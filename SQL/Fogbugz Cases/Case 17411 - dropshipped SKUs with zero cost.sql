-- Case 17411 - dropshipped SKUs with zero cost

-- Orders YTD with 1+ dropshipped SKUs with zero cost
select O.ixOrder,
    O.dtOrderDate,
    VS.ixVendor, V.sName, 
    OL.ixSKU, OL.mCost, VS.iOrdinality
from tblOrder O
LEFT JOIN tblOrderLine OL ON O.ixOrder = OL.ixOrder 
LEFT JOIN tblVendorSKU VS ON OL.ixSKU = VS.ixSKU
LEFT JOIN tblVendor V on V.ixVendor = VS.ixVendor 
        WHERE OL.dtOrderDate >= '01/01/13'
          AND O.sOrderStatus = 'Shipped' 
          AND OL.flgLineStatus = 'Dropshipped'	
          AND OL.mCost = 0	
          --AND VS.iOrdinality = 1
order by O.ixOrder, OL.ixSKU, VS.iOrdinality 

         

