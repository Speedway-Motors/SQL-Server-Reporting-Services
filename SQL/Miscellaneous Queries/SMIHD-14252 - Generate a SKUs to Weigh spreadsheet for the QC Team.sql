-- SMIHD-14252 - Generate a SKUs to Weigh spreadsheet for the QC Team

/*
SKUs that we physically have on hand  and are in the web.19 catalog.  												
												
    SKU	Description	
    QAV	
    QOS	
    Weight	
    Length	
    Width	
    Height	
    12 Month Sales (qty)	
Number of sales where it's the only SKU on an order	
    Number of packages shipped containing the SKU	
    Prime Vendor	
    Active -- don't exclude inactive SKUs…just show the flag
    Categorization levels	
    Pick Bin	
    PGC		

include UP & AUP SKUs?								
*/

SELECT S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    QS.QAV,
    QS.QOS,
    S.dWeight 'Weight',
    S.iLength 'Length',
    S.iWidth 'Width',
    S.iHeight 'Height',
    ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo(non-counter)',
    -- Orders where it's the sole Item
    -- # of packages in last 12 Mo
    ISNULL(PC.TotPackages,0) 'TotPackages',
    ISNULL(SOLO.SoloOrders,0) 'SoloOrders',
    VS.ixVendor 'PV#',
    V.sName 'PVName',
    (CASE WHEN S.flgActive = 1 then 'Y'
     ElSE 'N'
     END) as 'Active',
     SKULL.sPickingBin 'PickBin',
     S.ixPGC 'PGC',
     S.sSEMACategory 'Cateogry',
     S.sSEMASubCategory 'SubCategory',
     S.sSEMAPart 'Part'
FROM tblSKU S
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN tblSKULocation SKULL on SKULL.ixSKU = S.ixSKU and SKULL.ixLocation = 99 -- just to get the local picking bin
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
            SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
            FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtShippedDate -- BASED ON SHIP DATE THIS TIME BECAUSE WE WANT TO USE THE SAME DATE RANGE FOR tblPackage
                left join tblOrder O on OL.ixOrder = O.ixOrder
            WHERE  OL.flgLineStatus IN ('Shipped')
                and O.iShipMethod <> 1 -- EXCLUDING COUNTER ORDERS
                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY   
            GROUP BY OL.ixSKU
            ) SALES on SALES.ixSKU = S.ixSKU  
    LEFT JOIN (-- Qualifying SKUs     (We have QAV or QAS and they're in WEB.19 catalog)
                SELECT S.ixSKU, STOCKED.QAV, STOCKED.QOS
                FROM tblSKU S
                    left join tblCatalogDetail CD on S.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.19'
                    LEFT JOIN (-- SKUs with QAV or QOS
                                SELECT SL.ixSKU, SUM(SL.iQAV) 'QAV', SUM(SL.iQOS) 'QOS'
                                    --, SUM(SL.iQOS)-SUM(SL.iQAV) 'DIF'
                                FROM tblSKULocation SL
                                    left join tblLocation L on L.ixLocation = SL.ixLocation
                                    left join tblSKU S on SL.ixSKU = S.ixSKU
                                WHERE SL.iQAV > 0
                                    and S.flgDeletedFromSOP = 0
                                    and S.flgIntangible = 0
                                    and SL.ixLocation <> '47'
                                GROUP BY SL.ixSKU
                                HAVING (SUM(SL.iQAV) > 0
                                        OR
                                        SUM(SL.iQOS) > 0
                                        )
                                ) STOCKED ON S.ixSKU = STOCKED.ixSKU
                WHERE S.flgDeletedFromSOP = 0
                    and S.flgIntangible = 0      -- 443,183
                    and CD.ixCatalog is NOT NULL -- 318,307 
                    and STOCKED.ixSKU is NOT NULL--  55,414
                    and S.flgIsKit = 0
                ) QS ON S.ixSKU = QS.ixSKU
    LEFT JOIN (-- Pkg count by SKU past 12 months
                SELECT OL.ixSKU, count(P.sTrackingNumber) 'TotPackages'
                FROM tblOrderLine OL
                    left join tblOrder O on OL.ixOrder = O.ixOrder
                    left join tblPackage P on OL.ixOrder = P.ixOrder and OL.sTrackingNumber = P.sTrackingNumber
                WHERE O.sOrderStatus = 'Shipped'
                    and O.iShipMethod <> 1 -- no counter
                    and OL.flgLineStatus = 'Shipped'
                    and O.dtShippedDate between DATEADD(yy, -1, getdate()) and getdate() 
                    and P.flgCanceled = 0
                    and P.flgReplaced = 0
                   -- and OL.ixSKU = '5644665T-RED'
                GROUP BY OL.ixSKU
                --order by count(P.sTrackingNumber) desc
                ) PC ON PC.ixSKU = S.ixSKU
    LEFT JOIN (-- SOLO Orders (how many orders where the SKU was the ONLY tangible item)
            SELECT OL.ixSKU, COUNT(distinct OL.ixOrder) 'SoloOrders'
            FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtShippedDate -- BASED ON SHIP DATE THIS TIME BECAUSE WE WANT TO USE THE SAME DATE RANGE FOR tblPackage
                left join tblOrder O on OL.ixOrder = O.ixOrder
            WHERE  OL.flgLineStatus IN ('Shipped')
                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY   
                and O.iTotalTangibleLines = 1
                and O.iShipMethod <> 1 -- EXCLUDING COUNTER ORDERS
            GROUP BY OL.ixSKU
            ) SOLO on SOLO.ixSKU = S.ixSKU 
WHERE QS.ixSKU is NOT NULL -- 55,414
  --  and S.ixSKU = '5644665T-RED'
  --AND PC.TotPackages > ISNULL(SALES.QtySold12Mo,0)
 -- and SOLO.SoloOrders > PC.TotPackages
ORDER BY S.flgIsKit DESC




    SELECT P.*,OL.ixSKU
                FROM tblOrderLine OL
                    left join tblOrder O on OL.ixOrder = O.ixOrder
                    left join tblPackage P on OL.ixOrder = P.ixOrder and OL.sTrackingNumber = P.sTrackingNumber
                WHERE O.sOrderStatus = 'Shipped'
                    and O.iShipMethod <> 1 -- no counter
                    and OL.flgLineStatus = 'Shipped'
                    and O.dtShippedDate > DATEADD(yy, -1, getdate())
                    and P.flgCanceled = 0
                    and P.flgReplaced = 0
                    and OL.ixSKU = '5644665T-RED'
                GROUP BY OL.ixSKU




SELECT DATEADD(yy, -1, getdate())

    
select * from tblCatalogDetail CD where CD.ixCatalog = 'WEB.19'

(-- SKUs with QAV or QOS
SELECT SL.ixSKU, SUM(SL.iQAV) 'QAV', SUM(SL.iQOS) 'QOS'
    --, SUM(SL.iQOS)-SUM(SL.iQAV) 'DIF'
FROM tblSKULocation SL
    left join tblLocation L on L.ixLocation = SL.ixLocation
    left join tblSKU S on SL.ixSKU = S.ixSKU
WHERE SL.iQAV > 0
    and S.flgDeletedFromSOP = 0
    and S.flgIntangible = 0
    and SL.ixLocation <> '47'
GROUP BY SL.ixSKU
HAVING (SUM(SL.iQAV) > 0
        OR
        SUM(SL.iQOS) > 0
        )
)
       -- AND SUM(SL.iQAV) <> SUM(SL.iQOS)
--order by SUM(SL.iQOS)-SUM(SL.iQAV) desc


-- Locations that have QAV when location 99 does not
select SL.ixLocation, L.sDescription, count(SL.ixSKU) 'SKUs with QAV '
from tblSKULocation SL
    left join tblLocation L on L.ixLocation = SL.ixLocation
    left join tblSKU S on SL.ixSKU = S.ixSKU
    left join tblCatalogDetail CD on S.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.19'
where SL.iQAV > 0
    and S.flgDeletedFromSOP = 0
    and S.flgIntangible = 0
    and S.ixSKU NOT IN (select ixSKU from tblSKULocation where ixLocation = 99 and iQAV > 0)
    and CD.ixSKU is NOT NULL
group by SL.ixLocation, L.sDescription
order by SL.ixLocation


SELECT * FROM tblOrderLine
where ixSKU = '124017-YEL-XL'
and dtShippedDate > DATEADD(yy, -1, getdate())
order by dtShippedDate desc


SELECT O.ixOrder, OL.ixSKU, OL.iQuantity, P.sTrackingNumber-- count(P.sTrackingNumber) 'TotPackages'
FROM tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblPackage P on OL.ixOrder = P.ixOrder and OL.sTrackingNumber = P.sTrackingNumber
WHERE O.sOrderStatus = 'Shipped'
    and O.iShipMethod <> 1 -- no counter
    and OL.flgLineStatus = 'Shipped'
    and O.dtShippedDate > DATEADD(yy, -1, getdate())
    and OL.ixSKU = '5644665T-RED'
    and P.flgCanceled = 0
    and P.flgReplaced = 0
                GROUP BY OL.ixSKU


select * from tblOrderLine where ixOrder = '8578641' and ixSKU = '124017-YEL-XL'


SELECT OL.*
            FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtOrderDate 
            WHERE  OL.flgLineStatus IN ('Shipped')
                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                and OL.ixSKU = '5644665T-RED'

              --  8131160

SELECT * FROM tblOrderLine where ixOrder = '7961682-1'
SELECT * FROM tblOrder where ixOrder = '7961682-1'
