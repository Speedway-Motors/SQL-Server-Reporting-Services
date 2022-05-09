-- Case - 25975 Promo Reporting on Crate Engine Freight
Promo Reporting on Crate Engine Freight
select * from tblPromoCodeMaster where ixPromoId = '763'
/*
ixPromoId	ixPromoCode	    sDescription	                                dtStartDate	dtEndDate	flgSiteWide
763	        No Promo Code	Crate Engine Truck Freight Flat Rate Shipping	2015-04-16 	2020-12-31 	1
*/

SELECT O.ixOrder,O.ixCustomer,C.sCustomerType, 
--C.ixCustomerType, 
O.dtOrderDate,O.sOrderStatus, O.mMerchandise, O.iShipMethod, OX.ixPromoId, ixPromoCode--, OX.ixPromoCodeId
from tblOrder O
    left join tblOrderPromoCodeXref OX on O.ixOrder = OX.ixOrder
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.ixOrder in (-- orders containing on of the qualifitying SKUs    
                    select distinct ixOrder from tblOrderLine
                    where ixSKU in ('9153200','9153210','12130500','91532355','91532383',
                                    '91532496','91533347','91533383','91533427','91533454',
                                    '91533496','91534700','212119258602','412119318604','035512499120',
                                    '935512499529','235519201332','735519210007','835519210008','935519210009',
                                    '035519244450','235519258602','335519301293','435519301294','535519301295',
                                    '435519318604','291019258602','491019318604','291619258602','491619318604')
                    and dtOrderDate >= '04/16/2015'  
                    and ixOrder NOT like 'Q%'   
                    )           
order by dtOrderDate, O.ixOrder
-- Dealers & Counter orders do not get shipping promos


select * from tblOrderPromoCodeXref
where ixOrder like '%-%'
-- NONE !



select * from tblOrderLine where ixOrder = '6180314'

select * from tblOrder
where ixOrder = '6180314'