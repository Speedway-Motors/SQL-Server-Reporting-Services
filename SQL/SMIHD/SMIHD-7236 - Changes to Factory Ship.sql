/* SMIHD-7236 - Changes to Factory Ship


example DS only SKUs that were changed to stocked SKUs from Jesse

27847ST2  - 4/12/17
83514010440B – 4/06/17

Last full list I sent to Kevin is attached just in case you want it. Looks like those all converted on 4/5 or 4/6/2017.

*/



-- Most recent date converted to Stocked SKU
select ST.ixSKU, MAX(D.dtDate) 'Last Changed to Stocked SKU' -- 78,117 ST changing SKU to Stocked           70,212 unique SKUs
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where ST.sLocation = 99
and ST.sBin = '999'
and (ST.sToBin is NULL
    OR ST.sToBin <> '999')
GROUP BY ST.ixSKU    
HAVING MAX(D.dtDate) between '04/12/2017' and '04/13/2017'
order by  MAX(D.dtDate) desc

--and ixDate between 17993 and 17994 

select ST.ixSKU, MAX(D.dtDate) 'Last Changed to DSOnly SKU' -- 78,117 ST changing SKU to Stocked           143 unique SKUs
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where ST.sLocation = 99
and  ST.sToBin = '999'
GROUP BY ST.ixSKU    
order by  MAX(D.dtDate) desc

select ST.ixSKU, MAX(D.dtDate) 'Last Changed to DSOnly SKU' -- 78,117 ST changing SKU to Stocked           70,212 unique SKUs
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where ST.sLocation = 99
and  ST.sToBin = '999'
GROUP BY ST.ixSKU    
order by  MAX(D.dtDate) desc

select distinct ixSKU from tblBinSku  -- 104,610
where ixBin = '999'
and ixLocation = 99


select * -- ST.ixSKU, MAX(D.dtDate) 'Last Changed to DSOnly SKU' -- 78,117 ST changing SKU to Stocked           70,212 unique SKUs
from tblSKUTransaction ST
    --join tblDate D on ST.ixDate = D.ixDate
where ST.sLocation = 99
and  ST.sToBin = '999'


SELECT * FROM tblSKUTransaction
where ixSKU = '27847ST2'
order by ixDate desc

select * from tblDate 
where dtDate = '04/12/17' -- 18000





SELECT * FROM tblSKUTransaction
where ixSKU = '83514010440B'
order by ixDate desc

select * from tblDate 
where dtDate = '04/06/17' -- 17994


select ixSKU,  MAX(D.dtDate) 'Last Changed to DSOnly SKU' -- 144 in Jesse's list   -- 23 not in Jesse's list
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where sLocation = 99
and sBin = '999'
and (sToBin is NULL
    OR sToBin <> '999')
and ST.ixDate between 17993 and 17994   
and ixSKU IN /*Jesse's list */('10610791','1061651','1061661','106201762S','10623B-650','10624991','106290905','106291005','10680072','10680138-S-SS-Y','106QM225','106QM301','106QM301L','106QM30410','1821809','1821899','1827821','282K312182','282SK322213','282CL126004','282280','282RP141216','2824934','282304147','2821591','2824790','28285816','2828188','2824732','2824726','282G3912','28250316','28230168','3257364','3257577','3252912','32588103','3259629','3259680','3258157','425773406ERL','425080812BKX','4251985MRG','425197400','42561329293','425014ERL','425251006ERL','425AT985011ERL','425280021ERL','425781605ERL','425781606ERL','425AT981410ERL','425992912ERL','425962404ERL','425AT922166ERL','425304606ERL','4259892086ERL','4651758','47511911','47523756','47545754','47523702','47545300','491ATS64L80AN','491ATS64L80AL','491ATS6400GM','491COS6700DM','491XTL1910','491EC8004HT','491EC8001U120','491TR1200HT','5478597','5478579','54787451','6301515-GRY-XL','63088800A','63088801A','83514010440B','8351402118BD','8351401501BD','83526012389','83526011097','8352209481','8351705244','8351206798P','83526011098','83527010044','83527012634','8352304572','83515010020K','83515Q10385K','46542555','4657740','4657780','4655729','4654902','4655466','4652955','4657496','4659751','46529603','465KT1211','465RU3060','465995000','46522354','46529498','4659781','46545583','4659771','46524283','4655965','4659704','4652268','465810261','4654480','4651268','4654602','465PS3002','465PF1300','4654936','465HP1017','465PS2002','4653363','91132633','91132737','91132615','91132684','721GS40110500B','72152307','721TS405','7215247','7215248','7211210505','721PCML1012T','721CR810','721XMR810','721CML810T','721SG141012','721SG12108','721JNL8A6PK','721MCFR6','92633290','92624318','92618622-DBLU')
GROUP BY ST.ixSKU    
order by  MAX(D.dtDate) desc

-- the SKUs not in Jesse's list
select ixSKU,  MAX(D.dtDate) 'Last Changed to DSOnly SKU'  -- 23
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where sLocation = 99
    and sBin = '999'
    and (sToBin is NULL
        or sToBin <> '999')
and ST.ixDate between 17993 and 17994   
and ixSKU NOT IN /*Jesse's list */('10610791','1061651','1061661','106201762S','10623B-650','10624991','106290905','106291005','10680072','10680138-S-SS-Y','106QM225','106QM301','106QM301L','106QM30410','1821809','1821899','1827821','282K312182','282SK322213','282CL126004','282280','282RP141216','2824934','282304147','2821591','2824790','28285816','2828188','2824732','2824726','282G3912','28250316','28230168','3257364','3257577','3252912','32588103','3259629','3259680','3258157','425773406ERL','425080812BKX','4251985MRG','425197400','42561329293','425014ERL','425251006ERL','425AT985011ERL','425280021ERL','425781605ERL','425781606ERL','425AT981410ERL','425992912ERL','425962404ERL','425AT922166ERL','425304606ERL','4259892086ERL','4651758','47511911','47523756','47545754','47523702','47545300','491ATS64L80AN','491ATS64L80AL','491ATS6400GM','491COS6700DM','491XTL1910','491EC8004HT','491EC8001U120','491TR1200HT','5478597','5478579','54787451','6301515-GRY-XL','63088800A','63088801A','83514010440B','8351402118BD','8351401501BD','83526012389','83526011097','8352209481','8351705244','8351206798P','83526011098','83527010044','83527012634','8352304572','83515010020K','83515Q10385K','46542555','4657740','4657780','4655729','4654902','4655466','4652955','4657496','4659751','46529603','465KT1211','465RU3060','465995000','46522354','46529498','4659781','46545583','4659771','46524283','4655965','4659704','4652268','465810261','4654480','4651268','4654602','465PS3002','465PF1300','4654936','465HP1017','465PS2002','4653363','91132633','91132737','91132615','91132684','721GS40110500B','72152307','721TS405','7215247','7215248','7211210505','721PCML1012T','721CR810','721XMR810','721CML810T','721SG141012','721SG12108','721JNL8A6PK','721MCFR6','92633290','92624318','92618622-DBLU')
GROUP BY ST.ixSKU    
order by  MAX(D.dtDate) desc




SELECT * from tblBinSku
where ixSKU in ('1063870BGX','1243352-BK/RED-52','1243352-BK/RED-54','1822130','2101521-FBLK-L','270R6546522-POL','425AT700116ERL','4657781','491SP1507HT','7212076','72120767M','72120939M','72120974','7215268','7215573','72504808VUA','72515121VCB','725246780','725564174','92620087','92620175','92620228','92633541')
and ixLocation = 99
order by ixBin


SELECT * from tblSKUTransaction 
where ixSKU = '7215268'
    and sLocation = 99
order by ixDate desc, ixTime desc

select * from tblOrderLine
where ixSKU in ('1063870BGX','1243352-BK/RED-52','1243352-BK/RED-54','1822130','2101521-FBLK-L','270R6546522-POL','425AT700116ERL','4657781','491SP1507HT','7212076','72120767M','72120939M','72120974','7215268','7215573','72504808VUA','72515121VCB','725246780','725564174','92620087','92620175','92620228','92633541')
and dtOrderDate between '04/01/2016' and '03/31/2017'
and flgLineStatus in ('Dropshipped','Shipped')





select distinct(ixSKU) -- 167
from tblSKUTransaction
where sLocation = 99
and (sBin <> '999' or sBin is NULL)
and (sToBin = '999')
and ixDate >= 17993




select ST.ixSKU, D.dtDate 'Date', T.chTime 'Time',
        'Changed to Stocked SKU'  as 'Action'-- 167   -- 23 not in Jesse's list
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
    join tblTime T on ST.ixTime = T.ixTime
where ST.sLocation = 99
and ST.sBin = '999'
and (ST.sToBin is NULL
    OR ST.sToBin <> '999')
and ST.ixDate between 17993 and 17994   
order by ixSKU


select ST.* -- ST.ixSKU , D.dtDate 'Date', T.chTime 'Time',
        --'Changed to Stocked SKU'  as 'Action'-- 167   -- 23 not in Jesse's list
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
    join tblTime T on ST.ixTime = T.ixTime
where ST.sLocation = 99
and ST.sBin = '999'
and (ST.sToBin is NULL
    OR ST.sToBin <> '999')
and ST.ixDate between 17993 and 17994   
order by ixSKU


/*
DECLARE    @StartDate datetime,    @EndDate datetime,
           @Vendor varchar(10),    @OrderType varchar(15),
           @MinUnitsSold int,       @SKUsFlaggedAsDropshipOnly varchar(1)

SELECT    @StartDate = '12/01/15',    @EndDate = '12/31/16',
          @Vendor = '1043',              @OrderType = 'Retail',
          @MinUnitsSold = 0,           @SKUsFlaggedAsDropshipOnly = 'N'
*/
SELECT SKU.ixSKU AS 'SKU'
	 , VSKU.sVendorSKU AS 'Vendor SKU'
	 , V.sName AS 'Vendor Name'
	 , VSKU.ixVendor AS 'Vendor Number'
	 , ISNULL(SKU.sWebDescription,SKU.sDescription) AS 'Description'
     , (CASE WHEN BinSku.ixSKU IS NOT NULL THEN 'Y' 
             ELSE NULL
        END) AS DropshipPart
	 , SKU.ixPGC AS 'PGC'
	 , PGC.sDescription AS 'PGC Description'
	 , SKU.dtCreateDate AS 'CreateDate'
	 , SKU.dDimWeight As 'DimWeight'
	 , SKU.dWeight AS 'Weight'
                , DSES.dBillingWeight
	,(CASE when SKU.dDimWeight > SKU.dWeight THEN SKU.dDimWeight
                     else SKU.dWeight
                 end) 'GreaterWeight'
	, DSES.mEstimatedShippingRate 'EstShippingRate'
	 , SKU.iLength AS 'Length'
	 , SKU.iWidth AS 'Width'
	 , SKU.iHeight AS 'Height'
     , SKU.sSEMACategory AS 'SEMACategory'	 
     , sSEMASubCategory AS 'SEMASubCategory'
     , sSEMAPart AS 'SEMAPart'
	 , SKU.mPriceLevel1 AS 'Retail'
	 , SKU.flgUnitOfMeasure
	 , MIN(OL.dtOrderDate) AS 'Date First Sold'
	 , COUNT(DISTINCT O.ixOrder) AS 'Number of Orders'
	 , SUM(OL.iQuantity) AS 'Actual Units Sold'
     , ISNULL(R.QtyReturned,0) 'QtyReturned'
	 , SUM(OL.mExtendedPrice) AS 'Sales'
	 , SUM(OL.mExtendedCost) AS 'Cost'
     , count(distinct CASE WHEN O.sOrderType = 'Retail' THEN O.ixCustomer else null end) AS 'RetailCustCnt' 
     , count(distinct CASE WHEN O.sOrderType IN ('MRR', 'PRS')  THEN O.ixCustomer else null end) AS 'WholesaleCustCnt'
     , COUNT(DISTINCT O.ixCustomer) AS DistinctCustCnt 	       
FROM vwSKULocalLocation SKU
LEFT JOIN tblDropshipEstimatedShippingRate DSES on (CASE when SKU.dDimWeight > SKU.dWeight THEN CAST(CEILING(SKU.dDimWeight) as Int)  
                                                else CAST(CEILING(SKU.dWeight) as Int) 
                                                end) = DSES.dBillingWeight
LEFT JOIN tblVendorSKU VSKU ON VSKU.ixSKU = SKU.ixSKU
	               AND VSKU.iOrdinality = '1'
LEFT JOIN tblVendor V ON V.ixVendor = VSKU.ixVendor 	             
LEFT JOIN tblOrderLine OL ON OL.ixSKU = SKU.ixSKU 
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder
LEFT JOIN tblPGC PGC ON PGC.ixPGC = SKU.ixPGC 
LEFT JOIN (SELECT DISTINCT ixSKU 
           FROM tblBinSku 
           WHERE ixLocation = '99' 
             AND ixBin = '999'
          ) BinSku ON BinSku.ixSKU = SKU.ixSKU 
LEFT JOIN (-- RETURNS for DS SKUs
            SELECT CMD.ixSKU, SUM(iQuantityReturned) 'QtyReturned'
            FROM tblCreditMemoMaster CMM
                join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
                join vwDropshipOnlySKU DS on CMD.ixSKU = DS.ixSKU
            where CMM.flgCanceled = 0
            and CMM.dtCreateDate between @StartDate and @EndDate
            GROUP BY  CMD.ixSKU
           ) R on R.ixSKU = SKU.ixSKU
WHERE VSKU.ixVendor IN (@Vendor)
  AND OL.flgLineStatus IN ('Dropshipped')
  AND OL.dtOrderDate between @StartDate  AND @EndDate
  AND OL.flgKitComponent = 0
  AND O.sOrderType IN (@OrderType)
  AND O.sOrderStatus = 'Shipped'
  AND ((@SKUsFlaggedAsDropshipOnly ='Y' AND BinSku.ixSKU IS NOT NULL)
       OR (@SKUsFlaggedAsDropshipOnly ='N')
       )
GROUP BY SKU.ixSKU
    , VSKU.sVendorSKU
    , V.sName
    , VSKU.ixVendor
    , ISNULL(SKU.sWebDescription,SKU.sDescription)
    , (CASE WHEN BinSku.ixSKU IS NOT NULL THEN 'Y' 
            ELSE NULL
	  END)
    , SKU.ixPGC
    , PGC.sDescription
    , SKU.sSEMACategory
    , sSEMASubCategory
    , sSEMAPart
    , SKU.mPriceLevel1
    , SKU.flgUnitOfMeasure
    , SKU.dtCreateDate
    , SKU.dDimWeight
    , SKU.dWeight
    , R.QtyReturned
    ,DSES.dBillingWeight
    ,(CASE when SKU.dDimWeight > SKU.dDimWeight THEN SKU.dDimWeight
           else SKU.dDimWeight
      end) 
    , DSES.mEstimatedShippingRate
    , SKU.iLength 
    , SKU.iWidth
    , SKU.iHeight
HAVING SUM(OL.iQuantity) >= @MinUnitsSold
ORDER BY  SKU.ixSKU
-- LEN(SKU.sSEMACategory) DESC