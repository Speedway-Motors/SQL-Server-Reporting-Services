-- M
-- We recently eliminated the 98 location and created an IO bin for EMi stuff in the 99 location. 
-- Can we adjust this report so I can get my data back. Along with the addition of the labor column requested for open BOMs.

-- EMI BOM Inventory report.rdl

SELECT QS.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    ISNULL(OBOMT.QtyOnOpenBOMTransfers, 0) 'QtyOnOpenBOMTransfers',
    ISNULL(BOMU.BOM12MoUsage,0) 'BOM12MoUsage',
    ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
    ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0) 'Tot12MoUsage',
    ISNULL(SKULL.iQAV,0) 'SMI_QAV',
    ISNULL(SKULL2.iQAV,0) 'IOEAGLE_QTY', -- EMI_QAV', -- now pulls inventory from IOEAGLE bin
    SKULL.iQOS 'SMI_QOH',
    -- not asked for
    S.dtCreateDate,
    (CASE WHEN S.flgMadeToOrder = 1 THEN 'Y'
     ELSE 'N'
    END) as 'MTO',
    PLC.sProductLifeCycleCode
FROM (-- QUALIFYING SKUS - EMI BOMs
      SELECT S.ixSKU
      FROM tblSKU S
        left join tblBOMTemplateMaster BTM on S.ixSKU = BTM.ixFinishedSKU 
        left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
      WHERE S.flgDeletedFromSOP = 0
        and BTM.ixFinishedSKU is NOT NULL -- SKU is a BOM  13,367
        and VS.ixVendor = '1410' -- 451
        and S.flgActive = 1
      ) QS
    LEFT JOIN tblSKU S on QS.ixSKU = S.ixSKU
    LEFT JOIN tblSKULocation SKULL on SKULL.ixSKU = S.ixSKU and SKULL.ixLocation = 99
    LEFT JOIN tblProductLifeCycle PLC on S.ixProductLifeCycleCode = PLC.ixProductLifeCycleCode
    LEFT JOIN (-- EMI Qty (now stored in bin IOEAGLE)
                select ixSKU, FORMAT(sum(iSKUQuantity),'###,###') iQAV
                from tblBinSku 
                where ixBin = 'IOEAGLE'
                group by ixSKU
                ) SKULL2 on SKULL2.ixSKU = S.ixSKU 
	LEFT JOIN (-- 12 Mo Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
				FROM tblOrderLine OL 
					join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
				GROUP BY OL.ixSKU
				) SALES on SALES.ixSKU = S.ixSKU
    LEFT JOIN (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU
                ) BOMU on BOMU.ixSKU = S.ixSKU
    LEFT JOIN (-- Qty on Open BOM Transfers
                SELECT ABTM.ixFinishedSKU, SUM(ABTM.QtyRemaining) 'QtyOnOpenBOMTransfers'
                FROM (-- ALL Open BOM Transfers
                        SELECT BTM.ixFinishedSKU,
                           (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining
                        from tblBOMTransferMaster BTM
                        where BTM.flgReverseBOM = 0
                           and BTM.dtCanceledDate is NULL
                           and isnull(BTM.iCompletedQuantity,0) < BTM.iQuantity
                        ) ABTM
                GROUP BY ABTM.ixFinishedSKU
                ) OBOMT ON OBOMT.ixFinishedSKU = S.ixSKU
ORDER BY ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0) desc





(-- EMI Qty (now stored in bin IOEAGLE)
select ixSKU, FORMAT(sum(iSKUQuantity),'###,###') iQAV
from tblBinSku 
where ixBin = 'IOEAGLE'
group by ixSKU
)

order by sum(iSKUQuantity) desc

select top 10 * from tblBinSku WHERE ixBin = 'IOEAGLE'

SELECT ixSKu

tblLocation



--BEGIN TRAN
Select FORMAT(count(*),'###,###') 
from tblSKULocation where ixLocation = 97
--ROLLBACK TRAN

select * from tblSKULocation 
where ixSKU in ('97052085')

SELECT ixSKU, count(ixLocation)
from tblSKULocation
group by ixSKU
order by count(ixLocation) desc

SELECT ixLocation , FORMAT(count(ixSKU),'###,###') SKUs
from tblSKULocation
where iQOS > 0
  or iQAV > 0
group by ixLocation
order by count(ixSKU) desc

/*
47	461,754
85	461,754
97	461,754
99	461,754
*/


select ixLocation, FORMAT(count(*),'###,###') SKUs
from tblSKULocation
GROUP by ixLocation
order by ixLocation desc
/*
ixLocation	SKUs
99	        462,511
97	            272
85	        462,511
47	        462,511
*/


set rowcount 50000

BEGIN TRAN

    DELETE  
    FROM tblSKULocation
    WHERE ixLocation = 97
        and iQOS = 0
        and iQAV = 0

ROLLBACK TRAN -- 9:54

select *  FROM tblSKULocation
    WHERE ixLocation = 97

select SL.ixSKU
from tblSKULocation SL
    left join tblSKU S on SL.ixSKU = S.ixSKU and SL.ixLocation = 47
where S.flgDeletedFromSOP = 1

BEGIN TRAN
--DELETE FROM tblSKU where ixSKU in ('63029112','63029112','63029112','91604025','91604025','91604025','91604025','94612821','94612821')
ROLLBACK TRAN

SELECT * FROM tblSKU
where ixSKU in ('63029112','63029112','63029112','91604025','91604025','91604025','91604025','94612821','94612821')

-- Kit SKUs that have benn deleted
SELECT *
FROM tblKit K
   left join tblSKU S on K.ixKitSKU = S.ixSKU 
where S.flgDeletedFromSOP = 1


-- Kits that have deleted SKUs as components
SELECT distinct ixKitSKU -- 419
into #TempKitsWithDeletedSKUs  -- DROP TABLE #TempKitsWithDeletedSKUs
FROM tblKit K
   left join tblSKU S on K.ixSKU = S.ixSKU 
where S.flgDeletedFromSOP = 1

SELECT * FROM #TempKitsWithDeletedSKUs

SELECT TK.ixKitSKU, K.ixSKU 'DeletedSKU', S.flgDeletedFromSOP, S.dtDateLastSOPUpdate 'SKU_LU', K.dtDateLastSOPUpdate 'KIT_LU' 
FROM #TempKitsWithDeletedSKUs TK
    LEFT join tblKit K on TK.ixKitSKU = K.ixKitSKU
    LEFT join tblSKU S on S.ixSKU = K.ixSKU
WHERE S.flgDeletedFromSOP = 1
ORDER BY K.dtDateLastSOPUpdate


SELECT TK.ixKitSKU
FROM #TempKitsWithDeletedSKUs TK
left join tblKit K on TK.ixKitSKU = K.ixKitSKU



/******* SKU clean-up  ***************/
-- DROP TABLE #PrepToDELETE
select ixSKU, flgDeletedFromSOP, dtDateLastSOPUpdate
into #PrepToDELETE
from tblSKU
where ixSKU in ('63029112','91604025','94612821')

select * from #PrepToDELETE

SELECT ixSKU, flgDeletedFromSOP, dtDateLastSOPUpdate from tblSKU where ixSKU in (SELECT ixSKU from #PrepToDELETE)
SELECT ixKitSKU, dtDateLastSOPUpdate from tblKit where ixKitSKU in (SELECT ixSKU from #PrepToDELETE)
SELECT* /* ixKitSKU, dtDateLastSOPUpdate*/ from tblKit where ixKitSKU in (SELECT ixSKU from #PrepToDELETE)

BEGIN TRAN

-- SELECT ixSKU, flgDeletedFromSOP, dtDateLastSOPUpdate from tblSKU where ixSKU in (SELECT ixSKU from #PrepToDELETE)
DELETE FROM tblKit where ixKitSKU in (SELECT ixSKU from #PrepToDELETE)
-- DELETE FROM tblKitList where ixKitSKU in (SELECT ixSKU from #PrepToDELETE)

ROLLBACK TRAN

