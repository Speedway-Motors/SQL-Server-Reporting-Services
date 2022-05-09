-- SMIHD-12782 - Backorders Ready to Release report 

/*
Backorders Ready to Release report 
selects all backorders with backordered items qtys available in picking, slapper or reserve bins, 
i.e. qtys available for the items to eventually be released. 
So it looks at the bin qtys and accumulates the bin qtys if the bin type is P, SL or R. 
If the accumulated qty for any sku > 0 then it appears on the report.
*/
SELECT DISTINCT 
    O.ixOrder 'Order_#', 
    O.dtOrderDate 'Order_Date',
    O.sMethodOfPayment 'Method_Of_Payment',
    O.sCreditCardLast4Digits 'Last4ofCC', -- ADD THE LAST 4 digits to tblOrder.   otherwise 100% SOP manual look-up
    O.ixCustomer,
    C.sCustomerType 'CustType',
    C.sCustomerFirstName 'First_Name',
    C.sCustomerLastName 'Last_Name',
    C.sDayPhone 'Day_Phone',
    C.sNightPhone 'Night_Phone',
    C.sCellPhone 'Cell_Phone',
    OL.ixSKU 'SKU',
    OL.iOrdinality,
    ISNULL(S.sWebDescription, S.sDescription) 'SKU_Description',
    (CASE WHEN S.flgIsKit = 1 THEN 'Y'
     ELSE ''
     END) 'Kit',
    (CASE WHEN OL.flgKitComponent = 1 THEN 'Y'
     ELSE ''
     END) 'KitComponent',
    OL.mUnitPrice 'Unit_Price',
    OL.iQuantity 'Qty_Ordered',
    ISNULL(TOTQAV.TotQAV,0) 'TotQAV',
    ISNULL(QAVLOC99.QAVLoc99,0) 'QAVLoc99',
    ISNULL(QAVLOC98.QAVLoc98,0) 'QAVLoc98',
    ISNULL(QAVLOC97.QAVLoc97,0) 'QAVLoc97'
   -- SL.ixLocation,
   -- SL.iQAV,
   --BS.iSKUQuantity, B.sBinType
FROM   (-- Fillable Backorders (potentially
        -- Backorders with 1 or more SKUs with sufficient QAV to fill */
        SELECT DISTINCT O.ixOrder -- 383 instead of 593
        FROM tblOrder O 
            left join tblOrderLine OL on O.ixOrder = OL.ixOrder
            left join tblSKU S on S.ixSKU = OL.ixSKU
            left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
            left join (-- Total QAV from all Locations
                       select ixSKU, SUM(iQAV) 'TotQAV' 
                       from tblSKULocation
                       where iQAV > 0
                            and ixLocation NOT IN (47,96)
                       group by ixSKU) TOTQAV on TOTQAV.ixSKU = S.ixSKU
        WHERE O.sOrderStatus = 'Backordered' -- 5,708
           AND S.flgIsKit = 0 -- exclude Kits on this version
           AND OL.flgKitComponent = 0 --  exclude Kit components on this version
           AND TOTQAV.TotQAV > OL.iQuantity
           AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
           AND S.ixSKU NOT LIKE 'TECHELP-%'
           AND S.ixSKU <> 'DLR' -- we want this SKU in the final report.  This is to avoid listing backorders that ONLY have DLR QAV
        ) FBO
    left join tblOrder O on O.ixOrder = FBO.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBinSku BS on OL.ixSKU = BS.ixSKU and BS.ixLocation = 99
    left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
    left join tblBin B on BS.ixBin = B.ixBin
    left join tblSKU S on S.ixSKU = OL.ixSKU
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join (select ixSKU, SUM(iQAV) 'TotQAV' 
               from tblSKULocation
               where iQAV > 0
                    and ixLocation NOT IN (47,96)
               group by ixSKU) TOTQAV on TOTQAV.ixSKU = S.ixSKU
    left join (-- Total QAV from Location 99
                select ixSKU, ISNULL(iQAV,0) 'QAVLoc99' 
                from tblSKULocation
                where ixLocation = 99
                and iQAV > 0
                ) QAVLOC99 on QAVLOC99.ixSKU = S.ixSKU
    left join (-- Total QAV from Location 98
                select ixSKU, ISNULL(iQAV,0) 'QAVLoc98' 
                from tblSKULocation
                where ixLocation = 98
                and iQAV > 0
                ) QAVLOC98 on QAVLOC98.ixSKU = S.ixSKU
    left join (-- Total QAV from Location 97
                select ixSKU, ISNULL(iQAV,0) 'QAVLoc97' 
                from tblSKULocation
                where ixLocation = 97
                and iQAV > 0
                ) QAVLOC97 on QAVLOC97.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Backordered' -- 5,708
   --AND S.flgIsKit = 0-- exclude Kits on this version
   --AND OL.flgKitComponent = 0 --  exclude Kit components on this version
   AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
   AND S.ixSKU NOT LIKE 'TECHELP-%'
  -- AND OL.ixSKU = '324104145' -- TESTING ONLY
  -- AND O.ixOrder = '6132362-1'
ORDER BY O.dtOrderDate, O.ixOrder, OL.iOrdinality, OL.ixSKU--, SL.ixLocation desc    -- 678 NON-KIT + 33 KIT + 244 Kit Components   960 Total


/*
ixSKU	    OLQtyBackOrdered	QAV
10610146A	10	                205
10623300CR	2	                50
106282501CR	2	                317

142100	47	3
142100	97	0
142100	98	0
142100	99	33

91076257	47	15
91076257	97	0
91076257	98	0
91076257	99	87

*/

select * from tblSKULocation 
where ixSKU = '91076257' --'142100'

select * from tblOrderLine where ixOrder = '6132362-1'

select * from tblSKULocation where ixSKU = '5602731'
select * from tblSKULocation where ixSKU = 'DLR'

select * from tblLocation 



-- sub-report QAV excluding Location 47
/*
DECLARE @SKU varchar(30)
SELECT  @SKU = '91089802'
*/
SELECT ixSKU, ixLocation 'Location', iQAV 'QAV'
FROM tblSKULocation
WHERE ixLocation <> 47 -- exclude AFCO
    and ixSKU = @SKU --('47552024','91089802','47522570','54785551','47552023','47553036')
ORDER BY ixSKU, ixLocation




SELECT ixSKU, ixLocation
FROM tblSKULocation 
where ixLocation = 99
and iQAV > 0
--and ixSKU in (select ixSKU from tblSKULocation where iQAV > 0 and ixLocation = 98)
and ixSKU in (select ixSKU from tblSKULocation where iQAV > 0 and ixLocation = 97)
and ixSKU in (select ixSKU from tblSKULocation where iQAV > 0 and ixLocation = 47)

SELECT ixSKU, ixLocation, iQAV
from tblSKULocation
where ixSKU in ('47552024','91089802','47522570','54785551','47552023','47553036')
order by ixSKU, ixLocation
/*
47522570	47	3
47522570	97	2
47522570	98	0
47522570	99	1048
                ====
                1053-3

47552023	47	3
47552023	97	2
47552023	98	0
47552023	99	29
                ====
                34-3

91089802	47	15
91089802	97	1
91089802	98	0
91089802	99	1212
                ====
                1228-15


91089802	1213v
47522570	1050v
47552024	 156
47553036	  51
47552023	  31v
54785551	  26


SELECT * FROM tblLocation
