-- CHECKS for Backorder reports
/*
Emily K. Hockey - So today I have time to go through the old report and there still is some parts that do not come up, 
    To me it looks like if we do not have enough to fill all of the backorders, 
    they don't come through on the new list. A few examples are part numbers 
    136FK10256 1356686 1012002802

Also part 425350020ERL-3 did not come up but it looks like we got it


Pat, could you look into Emily's concern about having inventory, but not enough to fulfill all the B/Os, therefore not populating what we have in stock onto the Ready to Release report?
*/

select ixSKU, flgIsKit, flgMadeToOrder
from tblSKU
where ixSKU IN ('136FK10256','1356686','1012002802')

select * from tblSKULocation 
where ixSKU IN ('136FK10256','1356686','1012002802')



-- Details on Missing SKU
select O.ixOrder 'Order    ', O.ixCustomer 'Customer', 
    --O.sOrderStatus, 
    O.dtHoldUntilDate 'HoldUntil', O.ixAuthorizationStatus 'AuthStatus', OL.ixSKU, OL.iQuantity, OL.flgLineStatus, OL.flgKitComponent,
    S.flgIsKit, S.flgMadeToOrder
from tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
where OL.ixSKU = '136FK10256'
    and flgLineStatus = 'Backordered'
    and O.sOrderStatus = 'Backordered'
order by O.ixOrder
/*
ixOrder	ixCustomer	sOrderStatus	HoldUntil	AuthStatus	ixSKU	    iQuantity
9531317-1	3787036	Backordered 	NULL	    BKR	        136FK10256	1
9633111-1	3767339	Backordered	    NULL	    BKR	        136FK10256	1
9679513-1	3726530	Backordered 	NULL	    BKR	        136FK10256	1
9696513-1	542477	Backordered	    NULL	    BKR	        136FK10256	1
9777618-1	946290	Backordered	    NULL	    BKR	        136FK10256	1
*/



made to order 582ASB600 
kit 582601E & 582500C
kit 582500C 

-- Backorders Ready to Release
/*   ver 20.12.1

DECLARE @SingleSKU varchar(25)
SELECT @SingleSKU = ' '-- ' ' instead of NULL --'35519212593' 
    -- 35519212593 has 4 orders    9542107-1 9569405-1 9673208-1 9921006-1              9426102-1 is missing
    -- 2823022706KIT has 2 orders v
    -- 715BP15121 has 3 orders v
*/



-- Backorders Ready to Release
/*   ver 20.12.1
*/
DECLARE @SingleSKU varchar(25)
SELECT @SingleSKU = ' ' --'136FK10256'-- ' ' instead of NULL --'35519212593' 
    -- 35519212593 has 4 orders    9542107-1 9569405-1 9673208-1 9921006-1              9426102-1 is missing
    -- 2823022706KIT has 2 orders v
    -- 715BP15121 has 3 orders v

SELECT DISTINCT 
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
    ISNULL(TOTQOS.TotQOS,0) 'TotQOS'
FROM   (-- FILLABLE ORDERS
                     SELECT ixOrder
                    --INTO #FILLABLE
                     FROM (SELECT O.ixOrder, OL.ixSKU, flgMadeToOrder,-- 2,272 orders     12,948 orderlines
                            CASE WHEN S.flgIsKit = 1 or S.flgMadeToOrder = 1 THEN 0
                                 WHEN (OL.iQuantity <= ALLQTY.TotQAV
                                       OR
                                       OL.iQuantity <= ALLQTY.TotQAV) THEN 0
                                 ELSE 1
                            END AS 'UNFILLABLE'
                            FROM tblOrder O 
                                left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                                left join tblSKU S on S.ixSKU = OL.ixSKU
                                left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
                                left join (-- Total QAV / QOS from all Locations
                                           select ixSKU, SUM(iQAV) 'TotQAV', SUM(iQOS) 'TotQOS'
                                           from tblSKULocation
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
    left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
    left join tblBin B on BS.ixBin = B.ixBin
    left join tblSKU S on S.ixSKU = OL.ixSKU
    --left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join (select ixSKU, SUM(iQAV) 'TotQAV' 
               from tblSKULocation
               where iQAV > 0
                    and ixLocation NOT IN (47,96)
               group by ixSKU) TOTQAV on TOTQAV.ixSKU = S.ixSKU
    left join (select ixSKU, SUM(iQOS) 'TotQOS' 
               from tblSKULocation
               where iQOS > 0
                    and ixLocation NOT IN (47,96)
               group by ixSKU) TOTQOS on TOTQOS.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Backordered' -- 5,708
   --AND S.flgIsKit = 0-- exclude Kits on this version
   --AND OL.flgKitComponent = 0 --  exclude Kit components on this version
--   AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
--   AND S.ixSKU NOT LIKE 'TECHELP-%'
--   AND O.ixAuthorizationStatus <> 'OK'
   AND (@SingleSKU = ' ' 
           OR O.ixOrder in (select distinct ixOrder from tblOrderLine OL where OL.ixSKU = @SingleSKU and flgLineStatus = 'Backordered')
        )
    
ORDER BY O.dtOrderDate, O.ixOrder, OL.iOrdinality, OL.ixSKU--, SL.ixLocation desc   






SELECT O.ixOrder, OL.ixSKU, flgMadeToOrder,-- 2,272 orders     12,948 orderlines
                            CASE WHEN S.flgIsKit = 1 or S.flgMadeToOrder = 1 THEN 0
                                 WHEN (OL.iQuantity <= ALLQTY.TotQAV
                                       OR
                                       OL.iQuantity <= ALLQTY.TotQOS) THEN 0
                                 ELSE 1
                            END AS 'UNFILLABLE'
                            FROM tblOrder O 
                                left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                                left join tblSKU S on S.ixSKU = OL.ixSKU
                                left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
                                left join (-- Total QAV / QOS from all Locations
                                           select ixSKU, SUM(iQAV) 'TotQAV', SUM(iQOS) 'TotQOS'
                                           from tblSKULocation
                                           group by ixSKU) ALLQTY on ALLQTY.ixSKU = S.ixSKU
                            WHERE O.sOrderStatus = 'Backordered' -- 5,708
                               AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
                               AND S.ixSKU NOT LIKE 'TECHELP-%'

ORDER BY O.ixOrder


=

SELECT O.ixOrder, OL.ixSKU, OL.iQuantity, flgMadeToOrder,-- 2,272 orders     12,948 orderlines
                            CASE WHEN S.flgIsKit = 1 or S.flgMadeToOrder = 1 THEN 0
                                 WHEN (OL.iQuantity <= ALLQTY.TotQAV
                                       OR
                                       OL.iQuantity <= ALLQTY.TotQAV) THEN 0
                                 ELSE 1
                            END AS 'UNFILLABLE'
                            FROM tblOrder O 
                                left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                                left join tblSKU S on S.ixSKU = OL.ixSKU
                                left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
                                left join (-- Total QAV / QOS from all Locations
                                           select ixSKU, SUM(iQAV) 'TotQAV', SUM(iQOS) 'TotQOS'
                                           from tblSKULocation
                                           group by ixSKU) ALLQTY on ALLQTY.ixSKU = S.ixSKU
                            WHERE O.sOrderStatus = 'Backordered' -- 5,708
                               AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
                               AND S.ixSKU NOT LIKE 'TECHELP-%'
                            --   AND S.ixSKU in ('91048343-620-STD','91048343-683-STD','91048345-28-350','91048345-31-350','91048345-31-370','91049345-28-350','91049345-28-370','91049345-28-389','91049345-31-350','91049345-31-370','91049345-31-389','91049345-31-411','91049345-31-456')
and O.ixOrder in ('9531317-1','9633111-1','9679513-1','9696513-1','9777618-1')
order by O.ixOrder
                               