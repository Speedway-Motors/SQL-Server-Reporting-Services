-- Case 17114 - Manual AFCO/Dynatech list pull for Catalog 367

select * from tblVendor 
where UPPER(sName) like '%AFCO%'
 OR  UPPER(sName) like '%DYNA%'
/*
-- Using 
0106	AFCO RACING
0311	DYNATECH

-- NOT Using
0108	AFCO-SPECIAL ORDER
0126	AFCO BUY BACK
0313	DYNATECH-FACTORY SHIP
9106	AFCO-GS
9311	DYNATECH-GS
*/
 

   
-- Pool for customers who've purchased AD SKUs in the last 72M    
Select O.ixCustomer,
    AVG(O.mMerchandise) as AOV -- 28,615 after joining to vwCSTStartingPool
-- DROP table PJC_17114_AD_StartingPool
into PJC_17114_AD_StartingPool  
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblVendorSKU VS on OL.ixSKU = VS.ixSKU
    and O.ixCustomer in (select ixCustomer from vwCSTStartingPool) -- VSP on O.ixCustomer = VSP.ixCustomer
where VS.ixVendor in ('0106','0311', '0108','0126','0313','9106','9311')         --) -- 
    and VS.iOrdinality = 1
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '01/08/2006' --between '01/01/2011' and '12/31/2011'
group by O.ixCustomer
order by O.ixCustomer


select top 10 * from vwCSTStartingPool


select ixCustomer from 

-- additional segments to add  
12m 5+ $1,000

-- as I hit segment that has less than 1,000, 
12m 5+ $1+
12m 2+ 1
 
    2+
    1+
24m
36m
48m
60m
72m








12m 5+ $1,000 R
12m 5+ $1,000 S

12m 5+ $100+  R
12m 5+ $100+  S

12m 2+ $1





select * from tblVendor 
where UPPER(sName) like '%AFCO%'
 OR  UPPER(sName) like '%DYNA%'
 
 
 select * from tblVendor WHERE ixVendor = '0311'
 
 
select distinct CR.ixCustomer -- 14,482
from tblCatalogRequest CR
    join vwCSTStartingPoolRequestors SPR on CR.ixCustomer = SPR.ixCustomer
   -- join tblMailingOptIn MO on MO.ixCustomer = C.ixCustomer
where CR.ixCatalogMarket = 'AD'
    and dtRequestDate >= '01/08/2006'
  --  and CR.ixCustomer NOT IN (select ixCustomer from PJC_17114_AD_StartingPool)
    and CR.ixCustomer NOT IN (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')
    
    

select sOptInStatus, COUNT(*)
from tblMailingOptIn
group by sOptInStatus

