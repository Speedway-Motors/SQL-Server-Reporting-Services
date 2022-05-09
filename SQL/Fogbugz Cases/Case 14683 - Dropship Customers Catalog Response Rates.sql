-- Case 14683 - Dropship Customers Catalog Response Rates

select count(distinct O.ixOrder /*C.ixCustomer*/) CustCount -- 1,144  -- 14
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    join tblVendorSKU VS on OL.ixSKU = VS.ixSKU
    join tblVendor V on VS.ixVendor = V.ixVendor
    join tblCustomer C on C.ixCustomer = O.ixCustomer
where flgLineStatus = 'Dropshipped'

    and VS.iOrdinality = 1
    and (upper(sName) like '%SIMPSON%' or upper(sName) like 'BELL%' OR upper(sName) like '%AFCO%' OR upper(sName) like '%DYNA%')
    
    
    
        and (O.sMatchbackSourceCode like '335%'
        or  O.sMatchbackSourceCode like '338%'
        OR  O.sMatchbackSourceCode like '339%')
        

select count(distinct O.ixOrder) OrderCnt, V.ixVendor, V.sName 
from tblOrderLine OL                                           
    join tblOrder O on OL.ixOrder = O.ixOrder                  
    join tblCustomer C on C.ixCustomer = O.ixCustomer          
    join tblVendorSKU VS on OL.ixSKU = VS.ixSKU
    join tblVendor V on VS.ixVendor = V.ixVendor        
where OL.flgLineStatus = 'Dropshipped' -- 13,816 
    and VS.iOrdinality = 1
    and O.dtOrderDate >= '01/01/2011'
    and O.sOrderStatus = 'Shipped'
    
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and VS.ixVendor not in ('3895','1729','2267','2920','2895')
group by V.ixVendor, V.sName
order by OrderCnt desc
/*
OrdCount	ixVendor	sName
11	        0210	    BELL RACING USA
102	        0212	    BELL SPECIAL ORDER
10	        0630	    SIMPSON SAFETY EQUIPMENT
232	        0632	    SIMPSON SPECIAL ORDER
*/
/*

Cat DS custs	DS custs
#   rec		who ordered
	from that cat
	
--	
        Cust    Cust	
Cat #   Rec     Ordered	
=====	===	    =======I
335     255     44
338     179      1 
339     213      0



select * from tblCatalogMaster where ixCatalog in ('335','338','339')
select * from tblVendor where upper(sName) like '%AFCO%' OR upper(sName) like '%DYNA%')
*/

select count(distinct C.ixCustomer) CustCount -- 280 customers have received a Bell or Simpson dropship order in the past 2 years
from tblOrderLine OL                                               -- 255 received     44 have place orders from Cat 335
    join tblOrder O on OL.ixOrder = O.ixOrder                      -- 179 received     1  have place orders from Cat 338
    join tblCustomer C on C.ixCustomer = O.ixCustomer              -- 213 received     0  have place orders from Cat 339
    
where OL.flgLineStatus = 'Dropshipped' -- 13,816 

    and O.dtOrderDate >= '08/22/2010'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and C.ixCustomer in -- Customers who received catalog 335, 338, or 339
                        (select distinct ixCustomer -- 589K Customers
                         from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                            join tblCatalogMaster CM on CM.ixCatalog = SC.ixCatalog
                         -- where CM.ixCatalog in ('335','338','339') --
                         where CM.ixCatalog = '339' -- 
                         )
    and O.sMatchbackSourceCode like '339%'


-- DropShip Customers


select distinct C.ixCustomer -- 11365  31
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblCustomer C on C.ixCustomer = O.ixCustomer
    join tblVendorSKU VS on OL.ixSKU = VS.ixSKU
    join tblVendor V on VS.ixVendor = V.ixVendor        
where OL.flgLineStatus = 'Shipped' -- 13,816 
    and VS.iOrdinality = 1
    and O.dtOrderDate >= '08/22/2009'
    and V.ixVendor in ('0210','0212','0630','0632')
    and C.ixCustomer in -- Customers who received catalog 335, 338, or 339
                        (select distinct ixCustomer -- 589K Customers
                         from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                            join tblCatalogMaster CM on CM.ixCatalog = SC.ixCatalog
                         where CM.ixCatalog in ('335','338','339')
                         )
   and O.sMatchbackSourceCode like '339%'
    

select * from tblVendor where ixVendor in ('0210','0212','0630','0632')