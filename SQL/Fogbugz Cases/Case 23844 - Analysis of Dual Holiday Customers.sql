-- Case 23844 - Analysis of Dual Holiday Customers 
-- drop table PJC_23844_DualHolidayCustomers
select distinct ixCustomer  -- 3612  BLACK FRIDAY CUSTOMERS
into [SMITemp].dbo.PJC_23844_DualHolidayCustomers
from tblOrder O
where O.dtOrderDate between '11/27/13' and '12/01/13'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
and O.ixCustomer in (
                        select distinct ixCustomer  -- 2937 CYBER MONDAY CUSTOMERS
                        from tblOrder O
                        where O.dtOrderDate between '12/02/13' and '12/03/13'
                            and O.sOrderStatus = 'Shipped'
                            and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
                            and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
                            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                            )

select count(DHC.ixCustomer) Custs, C.sCustomerType
    --,C.*
from [SMITemp].dbo.PJC_23844_DualHolidayCustomers DHC
    join tblCustomer C on DHC.ixCustomer = C.ixCustomer
group by   C.sCustomerType  
order by CustQty desc
/*
CustQty	CustomerType
126	    Retail
9	    PRS
7	    MRR
3	    Other
*/
   




select count(DHC.ixCustomer) Custs, (Case when D.iYear <= 2010 then 2010 -- <-- add "or older" to the output 
                                     else D.iYear
                                     end) as 'Created'
from [SMITemp].dbo.PJC_23844_DualHolidayCustomers DHC
    join tblCustomer C on DHC.ixCustomer = C.ixCustomer
    join tblDate D on D.dtDate = C.dtAccountCreateDate
group by  (Case when D.iYear <= 2010 then 2010
                                     else D.iYear
                                     end) 
/*      Account
Custs	Created
101	    2010 or older
7	    2011
10	    2012
27	    2013
*/


select count(DHC.ixCustomer) Custs, C.ixSourceCode
    --,C.*
from [SMITemp].dbo.PJC_23844_DualHolidayCustomers DHC
    join tblCustomer C on DHC.ixCustomer = C.ixCustomer
group by   C.ixSourceCode  
order by Custs desc
/*
Custs SC
30	2190
16	BUDY
10	WCR3
8	CTR
7	NET
5	2191
5	2192
4	EC
4	PRS
4	UK
2	WCR2
2	WCR22
2	EBAY
2	MRR00
2	89
2	97C
1	BDH
1	BDNET
1	BILL
1	93C
1	95B
1	96C
1	MS
1	CWS
1	PRS204
1	PRS212
1	PRS96
1	RC
1	SR
1	243L
1	24853
1	2509
1	27875
1	29381
1	30225
1	3916
1	5077
1	86
1	88
1	1014
1	1119
1	1235
1	1246
1	1394
1	1501
1	201
1	203I
1	205
1	206
1	209M
1	209S
1	2104
1	2155
1	WCR5
1	WCR9
1	NSRA00
*/


-- general
select C.*
from [SMITemp].dbo.PJC_23844_DualHolidayCustomers DHC
    join tblCustomer C on DHC.ixCustomer = C.ixCustomer
    join tblDate D on D.dtDate = C.dtAccountCreateDate
    
    

select sOrderChannel, COUNT(ixOrder) OrdCnt  -- 2937 CYBER MONDAY CUSTOMERS
from tblOrder O
where O.dtOrderDate between '11/27/13' and '12/03/13'    
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders   
group by sOrderChannel     
/*

Web	
Ebay/ Auction	
Catalog	'aka PHONE'
Counter	
MRR	
PRS

*/ 

-- BLACK FRIDAY
select (case
            when O.sOrderChannel = 'WEB' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then 'WEB-Mobile'
                                                                                                                           else 'WEB'
                                                                                                                           end)   
            when O.sOrderChannel = 'COUNTER' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Counter'
            when O.sOrderChannel = 'AUCTION' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Ebay/Auction'
            when C.sCustomerType = 'MRR' then 'MRR'
            when C.sCustomerType = 'PRS' then 'PRS'
            else 'Catalog'
         end) OrdChan,
                 sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) DailyNumOrds,  -- WE COUNT BACKORDERS MERCH, but we DON'T COUNT BACKORDERS as a new order!!!!!!
          sum(O.mMerchandise) DailySales
from [SMITemp].dbo.PJC_23844_DualHolidayCustomers DHC
    join tblCustomer C on DHC.ixCustomer = C.ixCustomer   
    join tblOrder O on O.ixCustomer = DHC.ixCustomer
WHERE  O.dtOrderDate between '11/27/13' and '12/01/13'    
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders     
group by (case
            when O.sOrderChannel = 'WEB' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then 'WEB-Mobile'
                                                                                                                           else 'WEB'
                                                                                                                           end)   
            when O.sOrderChannel = 'COUNTER' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Counter'
            when O.sOrderChannel = 'AUCTION' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Ebay/Auction'
            when C.sCustomerType = 'MRR' then 'MRR'
            when C.sCustomerType = 'PRS' then 'PRS'
            else 'Catalog'
         end)    

-- CYBER MONDAY
select (case
            when O.sOrderChannel = 'WEB' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then 'WEB-Mobile'
                                                                                                                           else 'WEB'
                                                                                                                           end)   
            when O.sOrderChannel = 'COUNTER' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Counter'
            when O.sOrderChannel = 'AUCTION' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Ebay/Auction'
            when C.sCustomerType = 'MRR' then 'MRR'
            when C.sCustomerType = 'PRS' then 'PRS'
            else 'Catalog'
         end) OrdChan,
                 sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) DailyNumOrds,  -- WE COUNT BACKORDERS MERCH, but we DON'T COUNT BACKORDERS as a new order!!!!!!
          sum(O.mMerchandise) DailySales
from [SMITemp].dbo.PJC_23844_DualHolidayCustomers DHC
    join tblCustomer C on DHC.ixCustomer = C.ixCustomer   
    join tblOrder O on O.ixCustomer = DHC.ixCustomer
WHERE  O.dtOrderDate between '12/01/13' and '12/02/13'    
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders     
group by (case
            when O.sOrderChannel = 'WEB' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then 'WEB-Mobile'
                                                                                                                           else 'WEB'
                                                                                                                           end)   
            when O.sOrderChannel = 'COUNTER' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Counter'
            when O.sOrderChannel = 'AUCTION' and (C.sCustomerType not in ('MRR','PRS') or C.sCustomerType is null) then 'Ebay/Auction'
            when C.sCustomerType = 'MRR' then 'MRR'
            when C.sCustomerType = 'PRS' then 'PRS'
            else 'Catalog'
         end)    

