-- Case - 19297 update on status Canadian Customer Postal Codes


-- How many Custs still have F for their Postal Code?
select COUNT(ixCustomer)        -- 1,477 @7-17-2013
from tblCustomer
where sMailToCountry = 'CANADA'
and sMailToZip = 'F'
and flgDeletedFromSOP = 0


-- out of the above... 

--1) How many could qualify to be in a CST Buyer Segment?
SELECT ixCustomer, sMailToZip
    , dtAccountCreateDate  -- 1,305 @7-17-2013
FROM tblCustomer
WHERE (sMailingStatus is NULL OR sMailingStatus = '0')      
  and sCustomerType = 'Retail'
  and flgDeletedFromSOP = 0
  and ixCustomer in ( -- Customers who've ordered in last 72 months
                     select distinct ixCustomer 
                     from tblOrder 
                     where sOrderStatus = 'Shipped'
                         and dtShippedDate >= DATEADD(yy, -6, getdate()) 
                     )  
    /*** SPECIFICS FOR CANADA ****/
    and sMailToCountry = 'CANADA'
    and sMailToZip = 'F'
order by dtAccountCreateDate desc


--2) How many could qualify to be in a CST Requestor Segment?  -- 8 @7-17-2013
SELECT C.ixCustomer, C.sMailToState, CR.ixCatalogMarket, CR.LatestRequestDate, C.sMailToZip, C.dtAccountCreateDate
FROM tblCustomer C -- 88678 custs 98184 cust/Mkt combos
  JOIN (select ixCustomer, ixCatalogMarket, MAX(dtRequestDate) LatestRequestDate
        from tblCatalogRequest
        --where ixCustomer = '1954717'
        group by ixCustomer, ixCatalogMarket
        ) CR ON C.ixCustomer = CR.ixCustomer
  and C.sCustomerType = 'Retail'
  and C.flgDeletedFromSOP = 0
  -- and dtAccountCreateDate >= DATEADD(yy, -6, getdate()) -- ONLY CUSTOMERS CREATED IN THE LAST 6 years
  and C.ixCustomer NOT in (select distinct ixCustomer  -- checking to see if customer has placed an order
                     from tblOrder
                     where sOrderStatus = 'Shipped'
                     and dtShippedDate >= DATEADD(yy, -6, getdate()) 
                     )  
        /*** SPECIFICS FOR CANADA ****/
    and  sMailToCountry = 'CANADA'
    and sMailToZip = 'F'
    


-- Custs list to send to Al so he can generate address file 
-- we'll send to Philip to process through the company that can provide the Postal Codes.
select ixCustomer
    --,ixCustomerType
    , dtAccountCreateDate        -- 1,478 @7-18-2013
from tblCustomer
where sMailToCountry = 'CANADA'
    and sMailToZip = 'F'
    and flgDeletedFromSOP = 0
order by dtAccountCreateDate desc
    -- ixCustomerType desc



