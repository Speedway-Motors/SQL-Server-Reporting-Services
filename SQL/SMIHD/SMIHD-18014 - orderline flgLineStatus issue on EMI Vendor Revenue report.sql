-- SMIHD-18014 - orderline flgLineStatus issue on EMI Vendor Revenue report

/*
EMI Vendor Revenue.rdl
   ver 20.27.1

DECLARE @StartDate DATETIME, @EndDate DATETIME
SELECT @StartDate = '06/01/2020', @EndDate = '06/30/2020'
*/
SELECT-- OL.ixOrder, 
    S.ixSKU
    , S.sDescription
    , SUM(OL.iQuantity) 'QtySold'
    , SUM(OL.mExtendedPrice) 'Sales$'
    , SUM(OL.mExtendedCost) 'MerchCost'
    , (SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) 'GP$'
    --, TM.mEMITotalLaborCost
    , (ISNULL(TM.mEMITotalLaborCost,0)*SUM(OL.iQuantity)) 'ExtEMITotLaborCost'
    , S.ixBrand
    , B.sBrandDescription
    , S.sSEMACategory
    , S.sSEMASubCategory
    , S.sSEMAPart
--INTO #VendorRevOrders -- DROP TABLE #VendorRevOrders
FROM tblOrder O 
        LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
        LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder  
                                AND OL.flgKitComponent = '0'   
        LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
        LEFT JOIN tblBrand B on S.ixBrand = B.ixBrand
        LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU
        LEFT JOIN tblBOMTemplateMaster TM on TM.ixFinishedSKU = S.ixSKU
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate -- per Jerry Malcolm, use date shipped
  AND VS.iOrdinality = 1
  AND (VS.ixVendor = '1410'
       OR (VS.ixVendor = '0900'
             AND (S.ixSKU like '946%'
                OR S.ixSKU like '950%'
                OR S.ixSKU like '956%'
                OR S.ixSKU like '960%'
                OR S.ixSKU like '966%'
                OR S.ixSKU like '970%'
                OR (S.ixSKU like '976%' AND S.ixBrand = '11182') -- brand check is for 976% SKUs ONLY!
                )
            )
       )
  AND O.sSourceCodeGiven NOT IN ('EAGLE300','EAGLE340','EMI300','EMI340','PRS-EMI','EMP-EMI','CUST-SERV-EMI','MRR-EMI','EMI.DLR') -- ('EMI300','EMI340') -- DO NOT INCLUDE source codes EAGLE or INTERNAL-EMI 
  AND O.sMatchbackSourceCode NOT IN ('EAGLE300','EAGLE340','EMI300','EMI340','PRS-EMI','EMP-EMI','CUST-SERV-EMI','MRR-EMI','EMI.DLR') -- ('EMI300','EMI340') --
  AND O.sOrderTaker <> 'FWG'
  AND O.ixCustomerType <> '32'
  AND OL.flgLineStatus in ('Shipped','Dropshipped') -- added 6/30/20 because report was including line items with flgLineStatus 'Lost', 'Backordered', etc.
--  and OL.ixSKU in ('91073078', '91073080', '91073082', '94616002')
GROUP BY S.ixSKU
    , S.sDescription
    , S.ixBrand
    , B.sBrandDescription
    , (ISNULL(TM.mEMITotalLaborCost,0))
    , S.sSEMACategory
    , S.sSEMASubCategory
    , S.sSEMAPart
ORDER BY S.ixSKU --, VS.iOrdinality

/*
SELECT ixOrder, sOrderStatus, dtDateLastSOPUpdate, T.chTime 'LastFedTime'
from tblOrder O
    left join tblTime T on T.ixTime = O.ixTimeLastSOPUpdate
where ixOrder in ('9390043','9508131','9628732','9628732-1','9658033','9658033-1','9710539','97105390','9887832','9918734','9918734-1','9984337','9984337-1','Q1980154','Q1982391')
order by ixOrder

*/

select * from tblOrderLine
Where dtOrderDate between '06/01/20' and '06/30/20'
and ixSKU in ('91073078', '91073080', '91073082', '94616002')


select * from tblOrderLine where ixOrder = '9710539'

select distinct OL.flgLineStatus
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.dtShippedDate between '06/01/20' and '06/30/20'
  AND O.sSourceCodeGiven NOT IN ('EAGLE300','EAGLE340','EMI300','EMI340','PRS-EMI','EMP-EMI','CUST-SERV-EMI','MRR-EMI','EMI.DLR') -- ('EMI300','EMI340') -- DO NOT INCLUDE source codes EAGLE or INTERNAL-EMI 
  AND O.sMatchbackSourceCode NOT IN ('EAGLE300','EAGLE340','EMI300','EMI340','PRS-EMI','EMP-EMI','CUST-SERV-EMI','MRR-EMI','EMI.DLR') -- ('EMI300','EMI340') --
  AND O.sOrderTaker <> 'FWG'
  AND O.ixCustomerType <> '32'
/*
Shipped
Dropshipped

NULL
Backordered
Lost
Split Order
ZeroQty
*/


select dtShippedDate


Dropshipped
Shipped