-- Case 25342 - 2014 Lincoln Swap Meet results

1.      I would like a report of total retail sales made at the Counter
for March 1, 2014.

2.      I would like another report of the portion of the Counter sales
from March 1, 2014 that used the SWAP25 promo code.

3.      Is there a way to view how many of item number 91089536 OR
91089535 were pulled on March 1, 2014?

/***** 1. Retail Counter Sales   ***********/
select D.dtDate, 
    D.sDayOfWeek, 
    sum(mMerchandise) RetailSales
from tblOrder O
    join tblDate D on O.dtOrderDate = D.dtDate
where O.dtOrderDate between '02/01/2014' and '04/01/2014' -- run based on Shipped date too to see dif
    and O.sOrderStatus = 'Shipped' 
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderType = 'Retail' 
    and O.sOrderChannel = 'COUNTER' 
   -- and O.iShipMethod = 1
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders       -- Ordered 16,159.60   same $ when based off of shipped date
    and D.sDayOfWeek = 'SATURDAY'
group by D.dtDate, D.sDayOfWeek
order by D.dtDate

    -- PREVIOUS YEARS
    select D.dtDate, 
        D.sDayOfWeek, 
        sum(mMerchandise) RetailSales
    from tblOrder O
        join tblDate D on O.dtOrderDate = D.dtDate
    where O.dtOrderDate between '02/01/2013' and '04/01/2013' -- run based on Shipped date too to see dif
        and O.sOrderStatus = 'Shipped' 
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderType = 'Retail' 
        and O.sOrderChannel = 'COUNTER' 
       -- and O.iShipMethod = 1
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders       -- Ordered 16,159.60   same $ when based off of shipped date
        and D.sDayOfWeek = 'SATURDAY'
    group by D.dtDate, D.sDayOfWeek
    order by D.dtDate

    -- PREVIOUS YEARS
    select D.dtDate, 
        D.sDayOfWeek, 
        sum(mMerchandise) RetailSales
    from tblOrder O
        join tblDate D on O.dtOrderDate = D.dtDate
    where O.dtOrderDate between '02/01/2012' and '04/01/2012' -- run based on Shipped date too to see dif
        and O.sOrderStatus = 'Shipped' 
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderType = 'Retail' 
        and O.sOrderChannel = 'COUNTER' 
       -- and O.iShipMethod = 1
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders       -- Ordered 16,159.60   same $ when based off of shipped date
        and D.sDayOfWeek = 'SATURDAY'
    group by D.dtDate, D.sDayOfWeek
    order by D.dtDate


-- Key Dates near that time
02/03/14 Street Catalog #373 In-Home 
02/23/14 Daytona 
02/24/14 Race Catalog #378 In-Home 


/* 2.
select * from tblOrder where sSourceCodeGiven like '%SWAP%' -- none

select * from tblPromoCodeMaster where ixPromoId like '%SWAP%'   -- none
select * from tblPromoCodeMaster where ixPromoCode like '%SWAP%'
  
ixPromoId	ixPromoCode	sDescription
478	        SWAP25	    Lincoln Swap Meet $25 off $200+ Email
479	        SWAP25H	    HAGGLE Lincoln Swap Meet $25 off $200+ Email

*/

select D.dtDate, 
    O.sOrderChannel,
    PCM.ixPromoCode,
    PCM.sDescription,
    sum(mMerchandise) RetailSales,
    COUNT(O.ixOrder) Orders
from tblOrder O
    join tblDate D on O.dtOrderDate = D.dtDate
    join tblOrderPromoCodeXref PCX on O.ixOrder = PCX.ixOrder
    join tblPromoCodeMaster PCM on PCX.ixPromoId = PCM.ixPromoId
where O.dtOrderDate between '02/01/2014' and '04/01/2014' -- run based on Shipped date too to see dif
    and O.sOrderStatus = 'Shipped' 
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderType = 'Retail' 
   -- and O.sOrderChannel = 'COUNTER' 
   -- and O.iShipMethod = 1
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders       -- Ordered 16,159.60   same $ when based off of shipped date
    and PCX.ixPromoId in ('478','479')
  --  and D.sDayOfWeek = 'SATURDAY'
group by  D.dtDate, 
    O.sOrderChannel,
    PCM.ixPromoCode,
    PCM.sDescription
order by D.dtDate
   
   
select OL.dtOrderDate, OL.ixSKU, SUM(OL.iQuantity) 'QtySold' -- 196
from tblOrderLine OL
where OL.ixSKU in ('91089536','91089535')
    and OL.dtOrderDate between '02/01/2014' and '04/01/2014'
    and OL.ixOrder in (Select ixOrder
                        from tblOrder O
                        where O.sOrderStatus = 'Shipped' 
                        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
                        and O.sOrderType = 'Retail' 
                       -- and O.sOrderChannel = 'COUNTER' 
                       -- and O.iShipMethod = 1
                        and O.mMerchandise > 0
                        and O.dtOrderDate between '02/01/2014' and '04/01/2014')
group by OL.dtOrderDate, ixSKU
order by  OL.dtOrderDate  



select * from tblSKU where ixSKU  in ('91089536','91089535')   
   
    
select SUM(OL.iQuantity) 'QtySold' -- 196
from tblOrderLine OL
where OL.ixSKU in ('91089536','91089535')    
 and OL.dtOrderDate between '02/01/2014' and '04/01/2014'
 and OL.flgLineStatus = 'Shipped'   
 and OL.ixCustomer = '1299266'
 
 
     
select O.ixOrder, SUM(OL.iQuantity) 'QtySold' -- 196
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixSKU in ('91089536','91089535')    
 and OL.dtOrderDate between '02/01/2014' and '04/01/2014'
 and OL.flgLineStatus = 'Shipped'  
 and O.sOrderType = 'Internal'
 Group by O.ixOrder
 
 select * from tblOrderLine
 where ixOrder = '5224953'
 
 select * from tblOrderLine where sPriceDevianceReason LIKE '%SWAP MEET%'
 
  
 select * from tblOrder where ixOrder = '5224953'
 select * from tblCustomer where ixCustomer = '707952'
  
select O.ixOrder, O.sOrderType, O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName,
SUM(OL.iQuantity) 'QtySold'
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    join (select OL.ixOrder, OL.iQuantity
               from tblOrderLine OL
               where ixSKU = '91089535'
               and OL.dtShippedDate between '02/01/2014' and '03/02/2014'
               ) OL on OL.ixOrder = O.ixOrder
group by   O.ixOrder, O.sOrderType, O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName              

select * from tblOrderLine where ixOrder = '5963642'
               
    -- get average sales SATURDAY sales per day for Sat during 2014 for 6 weeks before and after that date
    
select * 
from tblOrderLine OL
where ixSKU = '91089535'
and OL.dtShippedDate between '02/01/2014' and '04/02/2014'   
and OL.ixCustomer in (707952 ,1299266)  
and OL.iQuantity > 1

select * from tblSKUTransaction 
where ixSKU = '91089535'
and ixDate = '16859'

 between 16858 and 16860 --'02/01/2014' and '03/02/2014' 

select * from tblDate where dtDate  between '02/01/2014' and '03/02/2014'   
select * from tblDate where ixDate = 16859

select * from tblOrderLine where ixOrder = '5963642'

