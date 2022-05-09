-- SMIHD-15763 - BOM Prioritization - Warehouse report missing SKUs

/*
Dave brought something to my attention on this report, although the top level item shows priority, 
we aren’t able to build any because one of the components isn’t available. 

91664721.A is needed but that SKU doesn’t show up on the report. Nothing that ends in a .LETTER is on the report.
 Could you look to see if anything may be preventing this?
*/


-- SMIHD-14464 - Warehouse BOM Prioritization
--   ver 19.46.1
select TM.ixFinishedSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    ISNULL(MPB.MaxPossibleBasedOnComponentQAV,0) 'CanBuild',
    [dbo].[GetOpenBOMTransfers] (TM.ixFinishedSKU) 'OpenBOMs',
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
    V.sName 'PrimaryVendorName',
    SL.sPickingBin
-- TEMP for testing
/*    
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
                                    --TD.iQuantity, SL.iQAV, 
                                    (SL.iQOS/TD.iQuantity) 'QtyPos' -- used to be (SL.iQAV/TD.iQuantity)
                                FROM tblBOMTemplateDetail TD
                                    left join tblSKU S on TD.ixSKU = S.ixSKU 
                                    left join tblSKULocation SL on SL.ixSKU = TD.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS and SL.ixLocation = 99
                                WHERE S.flgDeletedFromSOP = 0
                                    and S.flgIntangible = 0
                                ) QP on TM.ixFinishedSKU = QP.ixFinishedSKU
                --WHERE TM.ixFinishedSKU in ('91664721') --('350018','91015840-SS','91633010','92610569','94517802','97080100')
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
    and (S.sSEMACategory NOT IN ('Apparel, Gifts and Literature') -- 3,271
           OR S.sSEMACategory IS NULL
           )
    and (S.sSEMAPart NOT IN ('Complete Upholstery Kits','Shocks','Cross Members') -- 2,942
          OR S.sSEMAPart IS NULL
           )
 and SL.sPickingBin IS NULL
    --and SL.sPickingBin NOT IN ('SHOCK', 'SHOP-R', 'SHOP-F', 'SHOP-W')
                        --        OR SL.sPickingBin IS NULL) -- 2,809
    and V.ixVendor NOT IN ('0009','0012','0106','0900','0940','0950','0955','0999','1404','2014','2103','2254','2319','2515','2788','2947','3103','9111','9999') -- 3,983
-- and S.ixSKU = '91664721.A'
ORDER BY -- SL.sPickingBin
    -- BO.BOCustomerCount desc,
    'FirstTimeBuilt' desc,
    (CASE WHEN (ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0)) = 0 THEN (SL.iQAV/0.0001) --12MoUsage
          ELSE (SL.iQAV/(ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0))) --12MoUsage
     END)


select * from tblSKULocation WHERE sPickingBin is NULL
and ixLocation = 99



select * from tblSKU where ixSKU = '91664721.A'




-- LINE 111 on 
 SELECT TD.ixFinishedSKU, TD.ixSKU, 
                                    --TD.iQuantity, SL.iQAV, 
                                    (SL.iQOS/TD.iQuantity) 'QtyPos' -- used to be (SL.iQAV/TD.iQuantity)
                                FROM tblBOMTemplateDetail TD
                                    left join tblSKU S on TD.ixSKU = S.ixSKU 
                                    left join tblSKULocation SL on SL.ixSKU = TD.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS and SL.ixLocation = 99
                                WHERE S.flgDeletedFromSOP = 0
                                    and S.flgIntangible = 0
                                    and TD.ixFinishedSKU = '91664721.A'
/*
ixFinishedSKU	ixSKU	QtyPos
91664721.A	1750105	745
91664721.A	1750205	328
91664721.A	1750245	150
91664721.A	5464107.1	13
91664721.A	91035100.2.2	0
91664721.A	91035100.3	127
91664721.A	91664721.1-L	8
91664721.A	91664721.1-R	8
91664721.A	91664721.2-L	27
91664721.A	91664721.2-R	25
91664721.A	91664721.4.1	23
91664721.A	91664721.4.2	18
91664721.A	HB8SHCSC-.38-1.00	142
91664721.A	HB8SSF-.25-.25	11
91664721.A	HZ2SFW-SAE-.50	604
91664721.A	HZ5HCSF-.38-2.50	128
91664721.A	HZ5HCSF-.50-1.50	59
91664721.A	HZ5HCSF-.50-2.25	51
91664721.A	HZ8HLNF-.38	103
91664721.A	HZ8HLNF-.50	402
*/

select ixFinishedSKU, flgDeletedFromSOP from tblBOMTemplateMaster where ixFinishedSKU = '91664721.A'

select ixSKU, flgActive, flgDeletedFromSOP, sSEMACategory, sSEMAPart from tblSKU where ixSKU = '91664721.A'

select * from tblVendorSKU VS WHERE ixSKU = '91664721.A' and VS.iOrdinality = 1

select * from tblSKULocation where ixSKU = '91664721.A'  and ixLocation = 99
--     and SL.sPickingBin NOT IN ('SHOCK', 'SHOP-R', 'SHOP-F', 'SHOP-W') -- 2,809
                                   


