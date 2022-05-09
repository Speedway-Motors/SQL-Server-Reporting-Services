-- SMIHD-6414 - RealTime Dropship Activity


/*
ccc:
make the description an isnull(web description, sop description), 
    add a column for qty (i.e. the sum of the quantities from tblOrderLine), 
    drop the SEMA categorization, 
    add weight & length, width, height.
    
    
    
    
    From tng
SELECT b.sName, s.sSKUVariantName FROM tblskubase b INNER JOIN tblskuvariant s ON b.ixSKUBase = s.ixSKUBase WHERE b.ixSOPSKUBase = '300102009'


*/

-- DROPSHIP Order & Cust count data
select DSS.ixSKU, 
    S.sDescription,
    S.sWebDescription,
    ISNULL(TNG.sSKUVariantName,S.sDescription) 'SKUDescription',
    --S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart,
    S.mPriceLevel1, S.mAverageCost, S.mLatestCost,
    S.dWeight, S.dDimWeight, S.iLength, S.iWidth, S.iHeight,
    V.ixVendor,
    V.sName 'sPrimaryVendorName',
    SUM(OL.iQuantity) 'QtySold',
    COUNT(distinct O.ixOrder) 'Orders', 
    COUNT(distinct O.ixCustomer) 'UniqueCustomers',
    MIN(O.dtOrderDate) 'dtFirstDropship', 
  --  GETDATE() 'dtTableUpdate',    
    DATEDIFF(M, MIN(O.dtOrderDate), GETDATE()) 'MonthsSinceFirstDropship'
    --(COUNT(distinct O.ixOrder)/DATEDIFF(M, MIN(O.dtOrderDate), GETDATE())) 'OrdersPerMonthSinceFristSold'
from tblDropship DS
    join vwDropshipOnlySKU DSS on DS.ixSKU = DSS.ixSKU
    join tblOrder O on DS.ixOrder = O.ixOrder
    join tblOrderLine OL on OL.ixOrder = O.ixOrder
    join tblVendorSKU VS on DSS.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    join tblVendor V on VS.ixVendor = V.ixVendor and VS.iOrdinality = 1
    join tblSKU S on S.ixSKU = DSS.ixSKU
    left join (SELECT * FROM openquery([TNGREADREPLICA], '
            SELECT s.ixSOPSKU, s.sSKUVariantName
            FROM tblskuvariant s')
            ) TNG on TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = DSS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 
    and O.sOrderType <> 'Internal'  
    and OL.flgLineStatus = 'Dropshipped' 
    and S.flgActive = 1
    and S.flgDeletedFromSOP = 0 
group by DSS.ixSKU,
    S.sDescription,
    S.sWebDescription,    
    ISNULL(TNG.sSKUVariantName,S.sDescription),
   -- S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart,
    S.mPriceLevel1, S.mAverageCost, S.mLatestCost,    
    S.dWeight, S.dDimWeight, S.iLength, S.iWidth, S.iHeight,   
    V.ixVendor,
    V.sName
HAVING -- COUNT(distinct O.ixOrder) IN (1,3,5,10) -- 8,259
   -- or 
    COUNT(distinct O.ixOrder) > 10 -- 8,313
order by COUNT(distinct O.ixOrder) desc 

MIN(O.dtOrderDate) desc


DATEDIFF(M, MIN(O.dtOrderDate), GETDATE())

COUNT(distinct O.ixOrder) desc, COUNT(distinct O.ixCustomer) DESC,
    DSS.ixSKU
    
    


SELECT TNG.*, SKU.sDescription 'tblSKU', DSS.* 
FROM vwDropshipOnlySKU DSS 
left join (SELECT * FROM openquery([TNGREADREPLICA], '
            SELECT s.ixSOPSKU, s.sSKUVariantName
            FROM tblskuvariant s')
            ) TNG on TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = DSS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
JOIN tblSKU SKU on DSS.ixSKU = SKU.ixSKU
--WHERE SKU.ixSKU = '10611653T'
ORDER BY sSKUVariantName
-- WHERE b.ixSOPSKUBase = '300102009'

SELECT * FROM vwDropshipOnlySKU


SELECT S.sWebDescription, TNG.sSKUVariantName
from tblSKU S
left join (SELECT * FROM openquery([TNGREADREPLICA], '
            SELECT s.ixSOPSKU, s.sSKUVariantName
            FROM tblskuvariant s')
            ) TNG on TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.flgDeletedFromSOP = 0
and S.flgActive = 1

            