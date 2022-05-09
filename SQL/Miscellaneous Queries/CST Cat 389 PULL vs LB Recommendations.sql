-- CST Cat 389 PULL vs LB Recommendations

select count(*) from PJC_LB_streetrod20140711 -- 388,490

select top 10 * from PJC_LB_streetrod20140711

select MailTo, count(*) QTY
from PJC_LB_streetrod20140711
group by MailTo
/*
Y	140633
N	247857
*/

select count(*) from [SMI Reporting].dbo.vwCSTStartingPool -- 550,957
select count(*) from [SMI Reporting].dbo.vwCSTStartingPoolCANADA

select count(distinct LB.ixCustomer )                                           -- 140,633 Yes  
from PJC_LB_streetrod20140711 LB
join [SMI Reporting].dbo.vwCSTStartingPool SP on LB.ixCustomer = SP.ixCustomer  -- 137,088 are in the CST Starting Pool
join (select distinct CO.ixCustomer
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '389'
      ) P on P.ixCustomer = LB.ixCustomer                                       -- 135,914 got pulled
where LB. MailTo = 'Y'


-- LB marked as Yes and custs are in the CST Starting Pool
select LB.*-- 140,633 Yes 
into PJC_LB_YesAndInCST_SP 
from PJC_LB_streetrod20140711 LB
join [SMI Reporting].dbo.vwCSTStartingPool SP on LB.ixCustomer = SP.ixCustomer  -- 137,088 are in the CST Starting Pool
                                                                                -- 135,914 got pulled
where LB. MailTo = 'Y'

-- LB marked as Yes and custs are in the CST Starting Pool
-- but DID NOT GET PULLED by CST for the mailing
select LB.* -- 1174
into PJC_LB_YesAndInCST_SP_butNotPulled
from PJC_LB_YesAndInCST_SP LB
left join (select distinct CO.ixCustomer
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '389'
      ) P on LB.ixCustomer = P.ixCustomer
where P.ixCustomer is NULL




select * from PJC_LB_YesAndInCST_SP_butNotPulled -- 1174

select top 10 * from [SMI Reporting].dbo.vwCSTStartingPool
PJC_LB_YesAndInCST_SP_butNotPulled

select * from PJC_LB_YesAndInCST_SP_butNotPulled NP
join (  -- FREQUENCY & MONETARY
            -- Count of Orders containg SKUs (WITHIN THE MARKET)
            -- and Total Sales of SKUs (WITHIN THE MARKET) for each customer for the last 72 Months
            select O.ixCustomer, 
                count(distinct O.ixOrder) 'Frequency',
                SUM(OL.mExtendedPrice)    'Monetary' 
            from [SMI Reporting].dbo.tblOrder O
                join [SMI Reporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder 
                join [SMI Reporting].dbo.tblSKU SKU on SKU.ixSKU = OL.ixSKU        
                join [SMI Reporting].dbo.tblPGC PGC on PGC.ixPGC = SKU.ixPGC       
            where  
                   O.dtShippedDate >= DATEADD(MM, -72, getdate())  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
               --and O.sOrderType = 'Retail' <-- per CCC, no need to add this requirent to CST views or Procs               
               and OL.flgKitComponent = 0 
               and SKU.flgIntangible <> 1
               and SKU.flgIntangible <> 2
               --and PGC.ixMarket = @Market           
            group by O.ixCustomer
           -- having count(distinct O.ixOrder) >= @Frequency
           --    and SUM(OL.mExtendedPrice) >= @Monetary
          ) FM on NP.ixCustomer = FM.ixCustomer
          
/* FINDINGS

550K - custs in CST StartingPool
388K - custs in LB dataset

409K - in Cat 389 pull from CST

    of those 409K
    93K are requestors (not buyers)

    of those 409K
    134K - were flagged Don't Mail by LB

        of those 134K
        127K - have been split out into separate source codes so that their performance can be tracked

    of those 409K



1174 Customers where flagged as "Mail" by LB that did NOT end up in the CST Pull.  I'm assuming that has to do mostly with the SKU/Market classification logic used by CST.
     I asked Philip if he thought we should put these customers in their own segment and mail them catalogs to evaluate their performance as well, but he said we couldn't 
     because we had to order exact quantities because this was a warp.
     
        
*/
