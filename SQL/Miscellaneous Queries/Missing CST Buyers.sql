-- Missing CST Buyers

/*
    2-6-14 PJC
    End result: 
        CST is working as designed.
        The vast majority of the "missing" customers were not included in the four test campaigns
        because they were either opted out of the Markets or their purchases were attributed to
        Markets outside the four used.  (tons were attributed to Pedal Car and "Both" for example).
        
        The remaining amount of customers not accounted for is negligable and doesn't warrant further time investigating.
    
*/

-- "MISSING" customers (12 month buyers who did not end up in one of the four test campaigns)
select distinct ixCustomer  -- 15,810
into [SMITemp].dbo.PJC_ExcludedCSTBuyers
from vwCSTStartingPool sp 
where sp.ixCustomer in 
    (select o.ixCustomer 
     from tblOrder o 
     where o.dtOrderDate between '02/03/2013' and '02/02/2014' --dateadd(mm,-12,getdate()) and dateadd(dd,-2,getdate()) 
     and o.sOrderStatus = 'Shipped' 
     and o.sOrderType='Retail' 
     and o.sOrderChannel <> 'INTERNAL' 
     and o.mMerchandise > 0) 
     and sp.ixCustomer not in 
        (select t.ixCustomer 
         from [SMITemp].dbo.ASC_21437_CST4TestMarketPulls_Flat t)


-- Market Sales for customers opted out of 3 or less markets
select EB.ixCustomer, PGC.ixMarket, SUM(OL.mExtendedPrice) 'Sales'
from [SMITemp].dbo.PJC_ExcludedCSTBuyers EB
join tblOrder O on O.ixCustomer = EB.ixCustomer
join tblOrderLine OL on OL.ixOrder = O.ixOrder
join tblSKU S on S.ixSKU = OL.ixSKU
join tblPGC PGC on PGC.ixPGC = S.ixPGC
where O.dtOrderDate between '02/03/2013' and '02/02/2014' --dateadd(mm,-12,getdate()) and dateadd(dd,-2,getdate()) 
     and O.sOrderStatus = 'Shipped' 
     and O.sOrderType='Retail' 
     and O.sOrderChannel <> 'INTERNAL' 
     and O.mMerchandise > 0
     and OL.flgLineStatus = 'Shipped'
and EB.ixCustomer NOT in (-- Customers opted out of 4 or more markets
                            select EB.ixCustomer--, COUNT(MOI.ixCustomer) OptOutMarkets
                            from [SMITemp].dbo.PJC_ExcludedCSTBuyers EB 
                                join tblMailingOptIn MOI on EB.ixCustomer = MOI.ixCustomer
                            where sOptInStatus = 'N'    
                            group by EB.ixCustomer
                            HAVING COUNT(MOI.ixCustomer) >= 4     
                            )
group by     EB.ixCustomer, PGC.ixMarket
order by ixMarket



-- looking for common traits in tbl Customer
select 
    C.flgDeceasedMailingStatusExempt, count(C.ixCustomer)
from tblCustomer C
    join [SMITemp].dbo.PJC_ExcludedCSTBuyers EB on C.ixCustomer = EB.ixCustomer
group by flgDeceasedMailingStatusExempt
order by flgDeceasedMailingStatusExempt 
-- checked sCustomerType , sMailToCountry, ixSourceCode, sMailToZip, ixAccountManager, ixCustomerType, sMailingStatus, sCustomerMarket, 
-- flgDeletedFromSOP, ixOriginalMarket

 
    
    
select EB.ixCustomer--, COUNT(MOI.ixCustomer) OptOutMarkets 
from [SMITemp].dbo.PJC_ExcludedCSTBuyers EB 
    join tblMailingOptIn MOI on EB.ixCustomer = MOI.ixCustomer
where sOptInStatus = 'N'    
group by EB.ixCustomer
HAVING COUNT(MOI.ixCustomer) >= 4



    
