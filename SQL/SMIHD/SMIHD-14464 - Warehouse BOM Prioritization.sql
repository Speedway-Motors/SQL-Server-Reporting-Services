-- SMIHD-14464 - Warehouse BOM Prioritization
select TM.ixFinishedSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    ISNULL(MPB.MaxPossibleBasedOnComponentQAV,0) 'CanBuild',
    [dbo].[GetOpenBOMTransfers] (TM.ixFinishedSKU) 'OpenBOMs',
    SL.iQCBOM,
    ISNULL(OBOMT.QtyOnOpenBOMTransfers, 0) 'QtyOnOpenBOMTransfers',
    BO.BackOrderCount,
    ISNULL(BOMU.BOM12MoUsage,0) 'BOM12MoUsage',
    ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
    ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0) 'Tot12MoUsage',
    SL.iQAV 'SMI_QAV',
    SL.iQOS 'SMI_QOH',
   (CASE WHEN S.flgMadeToOrder = 1 THEN 'Y'
        ELSE 'N'
         END) as 'MTO',
    (CASE WHEN TC.BOMTransferCount = 1 AND ISNULL(OBOMT.QtyOnOpenBOMTransfers, 0) > 0 THEN 'Y'
     ELSE 'N'
     END) AS 'FirstTimeBuilt',
    -- QAV% of Tot 12Mo Usage
    -- prioritizing fields
    BO.BOCustomerCount,
    S.sSEMACategory,
    S.sSEMASubCategory,
    S.sSEMAPart,
    S.mPriceLevel1,
    S.mLatestCost,
    S.mAverageCost,
    V.ixVendor 'PrimaryVendor',
    V.sName 'PrimaryVendorName'
-- TEMP for testing
/*    SL.sPickingBin ,
    S.flgActive,
    TM.mSMIShopLabor,
    TM.mSMIShockLabor,
    TM.mEMIShopLabor,
    TM.mEMIShockLabor,
    */
from tblBOMTemplateMaster TM
    LEFT JOIN tblSKU S on TM.ixFinishedSKU = S.ixSKU
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
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
    LEFT JOIN (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    left join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    left join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU
                ) BOMU on BOMU.ixSKU = S.ixSKU
	LEFT JOIN (-- 12 Mo Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
				FROM tblOrderLine OL 
					left join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
				GROUP BY OL.ixSKU
				) SALES on SALES.ixSKU = S.ixSKU
    LEFT JOIN (-- Backorder Counts
                SELECT OL.ixSKU, 
                    count(O.ixOrder) BackOrderCount,
                    count(distinct O.ixCustomer) BOCustomerCount            -- 97
                FROM tblOrder O
                    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
                    left join tblSKULocation SL on SL.ixSKU = SKU.ixSKU and SL.ixLocation = 99
                WHERE O.sOrderStatus = 'Backordered'
                     and OL.flgLineStatus = 'Backordered'
                     and SKU.flgIsKit = 0
                     and SL.iQAV < 0
                GROUP BY OL.ixSKU
                ) BO on BO.ixSKU = S.ixSKU
    LEFT JOIN (-- count of all BOM Transfers
                SELECT ixFinishedSKU, 
                    count(ixTransferNumber)  'BOMTransferCount'
                FROM tblBOMTransferMaster 
                WHERE dtCanceledDate is NULL
                group by ixFinishedSKU
                having count(ixTransferNumber) = 1 
               ) TC on S.ixSKU = TC.ixFinishedSKU
    LEFT JOIN ( -- Max Possible Based On Component QAV
                SELECT TM.ixFinishedSKU, MIN(QP.QtyPos) 'MaxPossibleBasedOnComponentQAV'
                FROM tblBOMTemplateMaster TM
                    LEFT JOIN (-- QtyPos for ALL component SKUs
                                SELECT TD.ixFinishedSKU, TD.ixSKU, 
                                    TD.iQuantity, SL.iQAV, SL.iQCBOM, SL.iQOS,
                                    (SL.iQAV/TD.iQuantity) 'QtyPos'
                                FROM tblBOMTemplateDetail TD
                                    left join tblSKU S on TD.ixSKU = S.ixSKU 
                                    left join tblSKULocation SL on SL.ixSKU = TD.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS and SL.ixLocation = 99
                                WHERE S.flgDeletedFromSOP = 0
                                    and S.flgIntangible = 0
                                   and ixFinishedSKU in ('91140367')--,'91004003-1','350403','50525237')
                                  -- and SL.iQCBOM >  (ABS(SL.iQAV))
                                ) QP on TM.ixFinishedSKU = QP.ixFinishedSKU
                WHERE TM.ixFinishedSKU in ('91140367')--,'91004003-1','350403','50525237')  --('350018','91015840-SS','91633010','92610569','94517802','97080100')
                GROUP BY TM.ixFinishedSKU
                ) MPB on MPB.ixFinishedSKU = S.ixSKU
where TM.flgDeletedFromSOP = 0 -- 13,438
    and S.flgDeletedFromSOP = 0 -- 13,436
    and S.flgActive = 1 -- 12,035
/*  and TM.ixFinishedSKU NOT IN (-- SKU with ANY Labor
                                SELECT distinct ixFinishedSKU
                                from tblBOMTemplateMaster
                                WHERE  flgDeletedFromSOP = 0
                                    and (mSMIShopLabor <>0
                                        or mSMIShockLabor <>0
                                        or mEMIShopLabor <>0
                                        or mEMIShockLabor <>0
                                       -- or mSMITotalLaborCost <> 0
                                       -- or mEMITotalLaborCost <> 0
                                        ) -- 8,003
                                ) -- 4,670
 */
  and TM.ixFinishedSKU NOT IN (-- specific Labor SKUs
                                SELECT distinct ixFinishedSKU
                                from tblBOMTemplateDetail
                                WHERE flgDeletedFromSOP = 0
                                    and ixSKU in ('94601', '91600001', '91645','54779082.1','12100001','94560') -- labor SKUs provided by MAL
                                ) -- 4,424
    and S.sSEMACategory NOT IN ('Apparel, Gifts and Literature') -- 3,271
    and S.sSEMAPart NOT IN ('Complete Upholstery Kits','Shocks','Cross Members') -- 2,942
    and SL.sPickingBin NOT IN ('SHOCK', 'SHOP-R', 'SHOP-F', 'SHOP-W') -- 2,809
    and V.ixVendor NOT IN ('0009','0012','0106','0900','0940','0950','0955','0999','1404','2014','2103','2254','2319','2515','2788','2947','3103','9111','9999') -- 3,983
/* TEMP for TESTING */
    and SL.iQCBOM <> 0
    and SL.iQOS > ISNULL(MPB.MaxPossibleBasedOnComponentQAV,0) 
    and ISNULL(MPB.MaxPossibleBasedOnComponentQAV,0) <= 0
    and SL.iQAV < 10
    and S.ixSKU in ('HC5HCSF-.44-1.50','91004003-1','350403','50525237') 
 ORDER BY BO.BOCustomerCount desc,
    'FirstTimeBuilt' desc,
    --SL.iQAV,
    (CASE WHEN (ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0)) = 0 THEN (SL.iQAV/0.0001) --12MoUsage
          ELSE (SL.iQAV/(ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0))) --12MoUsage
     END)



select * from tblSKULocation where ixSKU = '91004003-1'

/* example SKUS

HC5HCSF-.44-1.50
91004003-1
350403
50525237




SELECT distinct(sPickingBin) 
FROM tblSKULocation
where sPickingBin LIKE '%SHOP%'
and sPickingBin NOT IN ('SHOCK', 'SHOP-R', 'SHOP-F', 'SHOP-W')


select top 10 * from tblBOMTransferMaster
where ixCreateDate < 17000
order by ixCreateDate


-- Backorders by SKU 6553101
                select OL.ixSKU, 
                    count(O.ixOrder) BackOrderCount,
                    count(distinct O.ixCustomer) BOCustomerCount            -- 97
                from tblOrder O
                    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                where O.sOrderStatus = 'Backordered'
                     and OL.flgLineStatus = 'Backordered'
                     and OL.ixSKU = '910616005'
                    -- and SKU.flgIsKit = 0
                    -- and SL.iQAV < 0
                group by OL.ixSKU

select * from tblOrderLine where ixOrder = '8643763-1' and ixSKU = '6553101'


SELECT * FROM tblSKU where ixSKU like '%54779082.1%'
SELECT * FROM tblSKU where sSEMACategory like 'Apparel%'

select TM.* 
from tblBOMTemplateMaster TM
left join tblSKU S on TM.ixFinishedSKU = S.ixSKU
where TM.flgDeletedFromSOP = 0
and S.flgDeletedFromSOP = 1



-- SMIHD-14013 - EMI BOM Inventory report
SELECT QS.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    ISNULL(OBOMT.QtyOnOpenBOMTransfers, 0) 'QtyOnOpenBOMTransfers',
    ISNULL(BOMU.BOM12MoUsage,0) 'BOM12MoUsage',
    ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
    ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0) 'Tot12MoUsage',
    --(ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0))/12 as 'EstMonthlyUsage',
    SKULL.iQAV 'SMI_QAV',
    SKULL2.iQAV 'EMI_QAV',
    (SKULL.iQAV+SKULL2.iQAV) 'CombQAV',
    SKULL.iQOS 'SMI_QOH',
    SKULL2.iQOS 'EMI_QOH',
    (SKULL.iQOS+SKULL2.iQOS) 'CombQOS',
    -- not asked for
    S.dtCreateDate,
   -- S.dtDiscontinuedDate
    (CASE WHEN S.flgMadeToOrder = 1 THEN 'Y'
     ELSE 'N'
    END) as 'MTO'
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
    LEFT JOIN tblSKULocation SKULL2 on SKULL2.ixSKU = S.ixSKU and SKULL2.ixLocation = 98
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
ORDER BY ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0)


