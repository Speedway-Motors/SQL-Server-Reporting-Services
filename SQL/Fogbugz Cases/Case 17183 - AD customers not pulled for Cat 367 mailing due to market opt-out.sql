-- Case 17183 - AD customers not pulled for Cat 367 mailing due to market opt-out
select distinct SP.ixCustomer
--into PJC_AD_ManualPull 
-- TRUNCATE table PJC_AD_ManualPull    
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -72 /*RECENCY*/, getdate()) 
and OL.flgLineStatus = 'Shipped'
and OL.flgKitComponent = 0 
and O.sOrderType <> 'Internal' 
and O.sOrderChannel <> 'INTERNAL'  
and SP.ixCustomer in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   
and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)