-- Case 23726 - Analysis Orders potentially generated from Eagle but not credited to Eagle Source Codes
select O.ixOrder,
       O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, O.ixCustomerType 'CustFlag',
       O.dtOrderDate,
       O.dtShippedDate,
       O.sSourceCodeGiven, O.sMatchbackSourceCode,
       O.sOrderChannel,
       O.sOrderTaker,
       SKU.ixBrand,
       B.sBrandDescription,
       OL.ixSKU,
       SKU.sDescription,
       OL.iQuantity,
       OL.mExtendedPrice
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on SKU.ixSKU = OL.ixSKU  
    left join tblBrand B on B.ixBrand = SKU.ixBrand
    left join vwEagleOrder E on E.ixOrder = O.ixOrder
    left join tblCustomer C on C.ixCustomer = O.ixCustomer
where O.dtOrderDate between '09/01/2014' and '09/30/2014' -->= '05/12/2014'
    and O.sOrderStatus = 'Shipped'
    and E.ixOrder is NULL -- Not credited to Eagle Source Code
    and SKU.ixBrand in ('10494', '11182', '10922', '10763') -- Eagle Brands
    and O.ixCustomer <> '1073350' -- Eagle Account
order by O.ixCustomerType,O.ixOrder, OL.iOrdinality      


/* If Mike doesn't have any changes the current "Eagle Motorsports Revenue via SMI SOP " report can probably be
   copied and used as the template for the new report.
    - Use tblOrder instead of vwEagleOrder
    - add the following conditions:
            and E.ixOrder is NULL -- Not in vwEagleOrder
            and SKU.ixBrand in ('10494', '11182', '10922', '10763') -- Eagle Brands
            and O.ixCustomer <> '1073350' -- Eagle Account

    
    
*/    


select SUM(mMerchandise)
from vwEagleOrder
where dtShippedDate >= '5/12/2014'
and sOrderStatus in ('Shipped','Dropshipped') -- 89,400



