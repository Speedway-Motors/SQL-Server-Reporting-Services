/* SMIHD-8993 - Overseas SKU Stock Analysis
    ver 17.44.1

DECLARE @PO varchar(10)
SELECT  @PO = '123309'  
 */   
 
SELECT 
     V.ixVendor 'VendorNum'
    ,V.sName 'VendorName'
    ,S.ixSKU 'SKU'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription'
    ,SKUM.iQAV 'QtyAv'
    ,ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo'
    ,ISNULL(BOMU.BOM12MoUsage,0) 'BOMUsage12Mo'
    ,(ISNULL(SALES.QtySold12Mo,0)+ISNULL(BOMU.BOM12MoUsage,0)) 'CombinedQtyConsumed12Mo'
    ,(ISNULL(SALES.QtySold12Mo,0)+ISNULL(BOMU.BOM12MoUsage,0))/12.0 'AvgMoConsumption'   
    , SKUM.iQAV/ NULLIF( ((ISNULL(SALES.QtySold12Mo,0)+ISNULL(BOMU.BOM12MoUsage,0))/12.0), 0) 'InvLeftMos' 
-- above   QAV / AvgMoConsumption
-- e.g.    30 /  ( (20+4)/12) )    = 15 Months Inv remaining
-- WORKAROUND FOR DIV/ZERO ISSUE:    Select dividend / NULLIF(divisor, 0) 
    ,S.iLeadTime/30.0 'LeadTimeMos'
    --,S.mPriceLevel1 'PriceLevel1'  ,S.mAverageCost 'AvgCost'
    ,S.mLatestCost 'LatestCost'
    --,S.flgActive
    , VOP.OpenPOs 'OpenPOsThisVendor'  
    , VOP.TotOpenQty 'TotQtyOnOpenPOsThisVendor'
    , OVOP.OpenPOs 'OpenPOsOtherVendors'  
    , OVOP.TotOpenQty 'TotQtyOnOpenPOsOtherVendors'    
    ,S.dtCreateDate
    ,(CASE WHEN TNG.ixSOPSKU IS NOT NULL then 'Y'
      ELSE 'N'
      END
      ) as 'AvailableOnTheWeb'
    , (CASE WHEN CABOM.ixSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END
       ) AS 'ComponentOfActiveBOM'
    , (CASE WHEN GS.ixSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END
       ) AS 'GarageSaleSKU'       
    ,S.sSEMACategory 'Category',S.sSEMASubCategory 'SubCategory' -- ,S.sSEMAPart 'Part'       
FROM tblSKU S 
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU 
                                and VS.iOrdinality = 1 -- Primary Vendor only
    left join tblVendor V on VS.ixVendor = V.ixVendor 
    left join vwSKUMultiLocation SKUM on SKUM.ixSKU = S.ixSKU
    left join (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU) BOMU on BOMU.ixSKU = S.ixSKU
    left join (-- 12 Mo QTY SOLD
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU) SALES on SALES.ixSKU = S.ixSKU     
    left join (-- available on the Web
              SELECT TNG.ixSOPSKU
               FROM openquery([TNGREADREPLICA], '
                            select s.ixSOPSKU 
                            from tblskubase AS b
                                inner JOIN tblskuvariant s ON b.ixSKUBase = s.ixSKUBase
                                inner JOIN tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
                                inner JOIN tblproductpage AS pp ON ppsb.ixProductPage = pp.ixProductPage
                            WHERE b.flgWebPublish = 1
                                AND s.flgPublish = 1
                                AND pp.flgActive = 1
                                AND fn_isProductSaleable(s.flgFactoryShip, s.flgDiscontinued, s.flgBackorderable, s.iTotalQAV, s.flgMTO) = 1
                             '
                            ) TNG 
               ) TNG on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    left join (-- Count Open POs & Tot Open PO Qty for @Vendor
                SELECT POD.ixSKU, 
                SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0))
                    ELSE 0
                    END
                    ) 'TotOpenQty',
                SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN 1
                    ELSE 0
                    END
                    ) 'OpenPOs'
                    -- , SUM(Total Open QTY on all POs)
                FROM tblPOMaster POM
                    join tblPODetail POD on POM.ixPO = POD.ixPO
                WHERE POM.ixVendor = '1729' -- @Vendor
                    --AND POM.ixIssueDate >= 17500 -- FOR TESTING ONLY
                GROUP BY POD.ixSKU) VOP on VOP.ixSKU = S.ixSKU              
    left join (-- Count Open POs & Tot Open PO Qty for @Vendor
                SELECT POD.ixSKU, 
                SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0))
                    ELSE 0
                    END
                    ) 'TotOpenQty',
                SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN 1
                    ELSE 0
                    END
                    ) 'OpenPOs'
                    -- , SUM(Total Open QTY on all POs)
                FROM tblPOMaster POM
                    join tblPODetail POD on POM.ixPO = POD.ixPO
                WHERE POM.ixVendor <> '1729' -- @Vendor
                    --AND POM.ixIssueDate >= 17500 -- FOR TESTING ONLY
                GROUP BY POD.ixSKU) OVOP on OVOP.ixSKU = S.ixSKU              
    left join vwComponentSKUsOfActiveBOMs CABOM on CABOM.ixSKU = S.ixSKU                
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU
WHERE V.ixVendor = '1729' --'2895'             -- POM.ixPO = @PO -- '123309'
    and S.ixSKU NOT LIKE 'UP%'
    and S.flgDeletedFromSOP = 0 -- 5045
    and S.flgActive = 1 -- this excludes discontinued SKUs even if we still have QAV or QOS!!! -- 5,017
ORDER BY OVOP.TotOpenQty desc
    -- SKUM.iQAV/ NULLIF( ((ISNULL(SALES.QtySold12Mo,0)+ISNULL(BOMU.BOM12MoUsage,0))/12.0), 0) desc




-- SUB-QUERY FOR TOTAL PO count/totals for @Vendor
SELECT POD.ixSKU, 
SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0))
    ELSE 0
    END
    ) 'TotOpenQty',
SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN 1
    ELSE 0
    END
    ) 'OpenPOs'
    -- , SUM(Total Open QTY on all POs)
FROM tblPOMaster POM
    join tblPODetail POD on POM.ixPO = POD.ixPO
WHERE POM.ixVendor = @Vendor
    --AND POM.ixIssueDate >= 17500 -- FOR TESTING ONLY
GROUP BY POD.ixSKU
/*
ixSKU	        TotOpenQty	OpenPOs
91007128	    1276	    2
91032847-BLK	1000	    2
91038812	    400	        2
912100	        1715	    2
*/

SELECT POD.ixSKU, 
SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0))
    ELSE 0
    END
    ) 'TotOpenQty',
SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN 1
    ELSE 0
    END
    ) 'OpenPOs'
    -- , SUM(Total Open QTY on all POs)
FROM tblPOMaster POM
    join tblPODetail POD on POM.ixPO = POD.ixPO
WHERE POM.ixVendor = '1729'-- '2895' -- @Vendor
    AND POM.ixIssueDate >= 17500 -- FOR TESTING ONLY
  --  and POD.ixSKU = '9173423'    -- FOR TESTING ONLY
    -- AND   QTY IS STILL OPEN LOGIC
GROUP BY POD.ixSKU
HAVING SUM(CASE WHEN (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0 THEN 1
    ELSE 0
    END
    ) > 1

SELECT

SELECT POD.*
FROM tblPOMaster POM
    join tblPODetail POD on POM.ixPO = POD.ixPO
WHERE POM.ixVendor = '1729' -- @Vendor
    AND POM.ixIssueDate >= 17500 -- FOR TESTING ONLY
    and POD.ixSKU IN ('91007128','91032847-BLK','91038812','912100')-- '9173423'    -- FOR TESTING ONLY
    -- AND   QTY IS STILL OPEN LOGIC
order by ixSKU
4 POs but only 1 with open Qty



-- SUB-QUERY FOR TOTAL PO count/totals for all other vendors




-- SELECT * FROM tblPOMaster where ixPO = '123309'

/*
-- OVERSEAS vendors
SELECT ixVendor, sName -- 26
FROM tblVendor 
where flgOverseas = 1
ORDER BY ixVendor

ixVendor	sName
0099	SPEEDWAY IMPORT ITEM
0345	FINISHLINE RACEWEAR USA, LLC
1024	ALLIED DIGITAL STRATEGIES
1089	APPLEGATE PERFORMANCE PRODUCT
1265	CHINA FIRST AUTOMOTIVE
1275	CHINA AUTO GROUP
1363	DALIAN QI MING METAL
1618	GOLDEN WHEEL DIE CAST LTD
1625	GRAND ARTISAN PRODUCTS INC
1729	RICHARD HUNG ENT CO LTD
1735	HIMET TECHNOLOGIES CO
1825	IUMBA INT'L LLC
1914	JPS RACEGEAR LLC
2115	LONGKOU TLC MACHINERY CO
2240	MOTOR PARTS S.A.
2423	ORPHIC INTERNATIONAL, INC
2558	PARTSALL INC
2838	PRORACE PRODUCTS INC
2895	SPEEDWAY MOTORS SHANGHAI
2920	SHANGHAI HONGDA METAL CO
2944	SHANGHAI SHENGBEI TRADING CO
3014	US PEDAL CAR INC
3238	XI'AN JOY-TOUCH TRADING CO
3415	ZHEJIANG ANHE ECONOMY & TRAD
3895	SPEEDWAY SHANGHAI-YUN ZHEN
3896	SPEEDWAY SHANGHAI FITTING
*/


SELECT VS.ixVendor, COUNT(S.ixSKU) 'SKUCnt'
from tblSKU S
    join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    join (SELECT ixVendor, sName
            FROM tblVendor 
            where flgOverseas = 1
          )OSV on VS.ixVendor = OSV.ixVendor
WHERE S.flgDeletedFromSOP = 0          
GROUP BY VS.ixVendor          
/*
ixVendor	SKUCnt
3896	629
3415	141
1275	1
1618	24
1024	22
1089	97
2920	174
3895	511
2115	4
2240	13
1825	22
1914	220
1729	5293
2423	81
0345	86
3238	284
1363	230
2944	238
2838	549
1735	77
0099	747
2558	39
1625	392
2895	5045
1265	25
*/

select S.ixSKU, S.dtDateLastSOPUpdate, S.flgDeletedFromSOP, S.flgActive
from tblSKU S
    join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
where VS.ixVendor = '1729' --'2895' 
    AND S.flgDeletedFromSOP = 0
    AND S.dtDateLastSOPUpdate < '10/30/2017' -- 620
ORDER BY S.dtDateLastSOPUpdate

SELECT S.dtDiscontinuedDate, SKUM.iQOS, SKUM.iQAV
from tblSKU S
    left join vwSKUMultiLocation SKUM on S.ixSKU = SKUM.ixSKU
where S.flgDeletedFromSOP = 0
    and S.flgActive = 0 -- 379,900
    and (SKUM.iQAV > 0 or SKUM.iQOS > 0)
    
    
    
    
    
    select POD.ixSKU, POD.ixPO,D.dtDate ExpectedDelivery, sum(POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) POQty -- outstanding PO Qty
         from tblPODetail POD
            join tblPOMaster POM on POM.ixPO = POD.ixPO
            left join tblDate D on D.ixDate = POD.ixExpectedDeliveryDate
where POD.ixSKU = @SKU
  and POM.flgIssued = 1
  and POM.flgOpen = 1
  and (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0
         group by POD.ixSKU, POD.ixPO, D.dtDate
 
order by D.dtDate

SELECT ixVendor, COUNT(POM.ixPO)
from tblPOMaster POM
where ixVendor in ( SELECT ixVendor
                    FROM tblVendor 
                    where flgOverseas = 1)
and POM.ixIssueDate >= 17500    
group by ixVendor                 
