-- SMIHD-17984 - Backorders Ready to release temp version with Bin flg

-- VERSION excluding some SKUs that have inventory in both valid and invalid bins
    
-- Backorders Ready to Release
/*   ver 20.21.1
 */
DECLARE @SingleSKU varchar(25)
SELECT @SingleSKU = ' '-- ' ' instead of NULL --'35519212593' 

SELECT DISTINCT  -- 556 rows @11-18-20 8:00am
    O.ixOrder 'Order_#', 
    O.dtOrderDate 'Order_Date',
    O.ixCustomer,
    O.ixAuthorizationStatus  'AuthStatus',
    OL.ixSKU 'SKU',
    OL.iOrdinality,
    OL.flgLineStatus,
    ISNULL(S.sWebDescription, S.sDescription) 'SKU_Description',
    OL.mUnitPrice 'Unit_Price',
    (CASE WHEN S.flgIsKit = 1 THEN 'Y'
     ELSE ''
     END) 'Kit',
    (CASE WHEN OL.flgKitComponent = 1 THEN 'Y'
     ELSE ''
     END) 'KitComponent',
    OL.iQuantity 'Qty_Ordered',
    ISNULL(TOTQAV.TotQAV,0) 'TotQAV',
    ISNULL(TOTQOS.TotQOS,0) 'TotQOS',
    (CASE WHEN S.flgMadeToOrder = 1 THEN 'Y'
     ELSE ''
     END) 'MadeToOrder',
     (SL.iQCB + SL.iQCBOM + SL.iQCXFER) 'LNKQtyBkr', -- SUM of the 3 below
        SL.iQCB, --Qty Committed to Backorder++
        SL.iQCBOM, -- Qty Committed to BOM 
        SL.iQCXFER --  Qty Committed to Transfer
FROM   (-- FILLABLE ORDERS
                     SELECT ixOrder
                    --INTO #FILLABLE
                     FROM (SELECT O.ixOrder, OL.ixSKU, flgMadeToOrder,-- 2,272 orders     12,948 orderlines
                            CASE WHEN S.flgIsKit = 1 or S.flgMadeToOrder = 1 THEN 0
                                 WHEN ALLQTY.TotQAV< OL.iQuantity THEN 1
                                 ELSE 0
                            END AS 'UNFILLABLE'
                            FROM tblOrder O 
                                left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                                left join tblSKU S on S.ixSKU = OL.ixSKU
                                left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation = 99 --NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
                                left join (-- Total QAV / QOS from all Locations
                                           select ixSKU, SUM(iQAV) 'TotQAV', SUM(iQOS) 'TotQOS'
                                           from tblSKULocation
                                           WHERE ixLocation = 99
                                           group by ixSKU) ALLQTY on ALLQTY.ixSKU = S.ixSKU
                            WHERE O.sOrderStatus = 'Backordered' -- 5,708
                               AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
                               AND S.ixSKU NOT LIKE 'TECHELP-%'
                            --   AND S.ixSKU in ('91048343-620-STD','91048343-683-STD','91048345-28-350','91048345-31-350','91048345-31-370','91049345-28-350','91049345-28-370','91049345-28-389','91049345-31-350','91049345-31-370','91049345-31-389','91049345-31-411','91049345-31-456')
                               ) FILLABLE
                     GROUP BY ixOrder
                     HAVING SUM(UNFILLABLE) = 0
        ) FBO
    left join tblOrder O on O.ixOrder = FBO.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBinSku BS on OL.ixSKU = BS.ixSKU and BS.ixLocation = 99
    left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation = 99
    left join tblBin B on BS.ixBin = B.ixBin
    left join tblSKU S on S.ixSKU = OL.ixSKU
    left join (select ixSKU, SUM(iQAV) 'TotQAV' 
               from tblSKULocation
               where iQAV > 0
                    and ixLocation NOT IN (47,96)
               group by ixSKU) TOTQAV on TOTQAV.ixSKU = S.ixSKU
    left join (select ixSKU, SUM(iQOS) 'TotQOS' 
               from tblSKULocation
               where iQOS > 0
                    and ixLocation = 99 --NOT IN (47,96)
               group by ixSKU) TOTQOS on TOTQOS.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Backordered' -- 5,708
   --AND S.flgIsKit = 0-- exclude Kits on this version
   --AND OL.flgKitComponent = 0 --  exclude Kit components on this version
   AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
   AND S.ixSKU NOT LIKE 'TECHELP-%'
   AND O.ixAuthorizationStatus <> 'OK'
   AND (@SingleSKU = ' ' 
           OR O.ixOrder in (select distinct ixOrder from tblOrderLine OL where OL.ixSKU = @SingleSKU and flgLineStatus = 'Backordered')
        )
ORDER BY O.dtOrderDate, O.ixOrder, OL.iOrdinality, OL.ixSKU--, SL.ixLocation desc