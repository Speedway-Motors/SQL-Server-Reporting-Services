-- SMIHD-14726 - Garage Sale SKUs without proper vendor

-- SELECT @@SPID as 'Current SPID' -- 108 

SELECT distinct ss.ixSOPSKU 'SOPSKU', 
    --ss.ixSkuBase 'SKUBase',
     SL.iQAV 'QAV', 
     ss.flgPublish, flgBackorderable, V.ixVendor 'PVNum', V.sName 'PrimaryVendor',
    --S.flgActive, S.flgIsKit,
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    S.dtDiscontinuedDate 'DiscontinuedDate' ,
    ISNULL(POQ.TotPOOpenQty,0) 'TotOpenPOQty',
    (CASE when SUBSTRING(S.ixPGC,2,1) <> UPPER(SUBSTRING(S.ixPGC,2,1)) then 'Y'
     else 'N'
     end
     ) 'GS_PGC'
    -- 
FROM (-- GarageSaleMarket
     select distinct ixSKUbase -- 61,495
     from tng.tblskubase_effectivemarket SBEM 
     where ixMarket = 222
     UNION
     select distinct ixSKUbase -- 64,474
     from tng.tblskubasemarket SBM
     where ixMarket = 222
     ) GSM  -- 64,476 combined unique SKUs
        inner join tng.tblskuvariant ss on ss.ixSkuBase = GSM.ixSkuBase -- 77,973
        LEFT JOIN tblSKU S on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = ss.ixSOPSKU
        LEFT JOIN tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
        LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
        LEFT JOIN tblSKULocation SL on SL.ixSKU = S.ixSKU and ixLocation = 99
        LEFT JOIN (-- Outstanding QTY on Open POs
                    SELECT POD.ixSKU,
                           sum(POD.iQuantity)		QTYOrdered,
                           sum(POD.iQuantityPosted)  QTYPosted,
                           sum(POD.iQuantity - POD.iQuantityPosted) TotPOOpenQty -- QTY on order but not yet received.  
                    FROM tblPODetail POD
	                    left join tblPOMaster POM on POM.ixPO = POD.ixPO
                    WHERE (POD.iQuantity) > (POD.iQuantityPosted)
                        and POM.flgIssued = '1' 
                        and POM.flgOpen = '1'
                    GROUP BY POD.ixSKU
                    ) POQ on S.ixSKU = POQ.ixSKU
WHERE ss.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN 
                        (-- SKUs with PV of 0009
                         SELECT s.ixSKU  -- 9,366
                         FROM tblSKU s
                            left join tblVendorSKU vs on s.ixSKU = vs.ixSKU
                                                       -- and vs.iOrdinality = 1
                         WHERE vs.ixVendor in ('0009','9999','9410','9106')
                        )  -- 7,609
and ss.flgPublish = 1      
    --and SL.iQAV <> 0     
 and ISNULL(POQ.TotPOOpenQty,0) > 0         
order by    V.ixVendor      
 --  and ss.ixSOPSKU = '5001029701'

-- check to see 

--order by V.ixVendor

--ixSOPSKU	    flgPublish	iTotalQAV	iQAV    flgBackOrderable    Primary Vendor
1356686	        1	        63	        57
91054235.BLK-L	1	        28	        23	    1	                2517	PERFORMANCE BODIES
61710160	    1	        20	        16	    0	                0999	DISCONTINUED/QOH
8352206419	    1	        99	        0	    1	                0836	WILWOOD ENGINEERING DROP.SHIP

select * from 

SELECT ixSOPSKU, iTotalQAV FROM tng.tblskuvariant WHERE ixSOPSKU in ('91054235.BLK-L','61710160','8352206419')
order by ixSOPSKU

select ixSKU, ixLocation, iQAV from tblSKULocation where ixSKU in ('91054235.BLK-L','61710160','8352206419')
order by ixSKU

select  ixSKU, iQtyAvailable
from tblSKUProfitabilityRollup where ixSKU in ('91054235.BLK-L','61710160','8352206419')




SELECT iTotalQAV, COUNT(ixSOPSKU) SKUCnt FROM tng.tblskuvariant-- WHERE iTotalQAV IN (97,98,99,47,68)
group by iTotalQAV
order by iTotalQAV

select  iQtyAvailable, COUNT(ixSKU) SKUCnt 
FROM tblSKUProfitabilityRollup
--WHERE iQtyAvailable IN (97,98,99,47,68)
group by iQtyAvailable
order by iQtyAvailable

select  RU.ixSKU, RU.iQtyAvailable, SKUM.QAV
from tblSKUProfitabilityRollup RU
    left join (select ixSKU, SUM(iQAV) QAV
               from tblSKULocation SL
               group by ixSKU) SKUM on RU.ixSKU = SKUM.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
where iQtyAvailable is NULL

SELECT * FROM tblSKUProfitabilityRollup
WHERE ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS in (SELECT ixSKU from tblSKU where flgDeletedFromSOP = 1)


select distinct ixSKU from tblSKULocation 
where ixSKU in (select ixSKU from tblSKU where flgDeletedFromSOP = 1)




