-- Case 17114 - Manual AFCO/Dynatech list pull for Cat#

-- REQUESTORS
select count(distinct ixCustomer) from tblCatalogRequest
where ixCatalogMarket = 'AD'
AND ixRequestDate >= 16075
and ixCustomer in (select ixCustomer from vwCSTStartingPoolRequestors) -- 3955
and ixCustomer in (select ixCustomer from tblCustomer where flgDeletedFromSOP = 0) --

-- REQUESTORS 
select distinct CR.ixCustomer -- 14,482
from tblCatalogRequest CR
    join vwCSTStartingPoolRequestors SPR on CR.ixCustomer = SPR.ixCustomer
   -- join tblMailingOptIn MO on MO.ixCustomer = C.ixCustomer
where CR.ixCatalogMarket = 'AD'
    and dtRequestDate >= '01/08/2006'
  --  and CR.ixCustomer NOT IN (select ixCustomer from PJC_17114_AD_StartingPool)
    and CR.ixCustomer NOT IN (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')
    




select * from tblVendor 
where UPPER(sName) like '%AFCO%' OR  UPPER(sName) like '%DYNA%'
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






-- NO SKUs are assigned to a PGC that has AD as the Market!!!
select PGC.ixMarket, COUNT(SKU.ixSKU)
from tblSKU SKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where SKU.flgDeletedFromSOP = 0
  and SKU.flgActive = 1
group by PGC.ixMarket   
order by  COUNT(SKU.ixSKU) desc
/*
ixMarket	SKU Count
R	        48106
SR	        23704
B	        11703
SM	        6618
2B	        2057
PC	        1706
NULL	    425
TE	        126
SC	        97
*/

select * from tblMarket




/************
PULLING AD BUYERS FIRST
*************/

-- batches based by Recency, Freq, Monetary in that order

/***** 36702 ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36702' as ixSourceCode
--into PJC_AD_ManualPull 
-- TRUNCATE table PJC_AD_ManualPull    
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/          1000 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36703  ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36703' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36704  ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36704' as ixSourceCode
--into PJC_AD_ManualPull 
-- TRUNCATE table PJC_AD_ManualPull    
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         2 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36705  ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36705' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36706 ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36706' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/          1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -24 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36707  ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36707' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         2 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -24 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)

GO

/*
DELETE from PJC_AD_ManualPull
where ixSourceCode = '36707'
*/

/***** 36708 24m 5+ $1000        COUNT = #### ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36708' as ixSourceCode
--into PJC_AD_ManualPull 
-- TRUNCATE table PJC_AD_ManualPull    
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -24 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36709 ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36709' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -36 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36710  ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36710' as ixSourceCode
--into PJC_AD_ManualPull 
-- TRUNCATE table PJC_AD_ManualPull    
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         2 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -36 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36711  ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36711' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -36 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36712 ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36712' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -48 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36713 ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36713' as ixSourceCode
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         2 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -48 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36714  ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36714' as ixSourceCode
--into PJC_AD_ManualPull 
-- TRUNCATE table PJC_AD_ManualPull    
from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -48 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO

/*
DELETE from PJC_AD_ManualPull
where ixSourceCode = '36707'
*/

/*  PER PHILIP, DO NOT PULL THE FOLLOWING COMMENTED OUT SEGMENTS

                        /***** 36715 ******/
                        insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
                            '36715'as ixSourceCode
                        --into PJC_AD_ManualPull 
                        -- TRUNCATE table PJC_AD_ManualPull    
                        from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         5 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -60 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
                        GO
                        /***** 36716 ******/
                        insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
                            '36716'as ixSourceCode
                        From vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         2 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -60 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
                        GO
                        /***** 36717 ******/
                        insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
                            '36717'as ixSourceCode
                        from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         1 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -60 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
                        GO
                        /***** 36718 ******/
                        insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
                            '36718' as ixSourceCode
                        from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         5 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -72 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
                        GO

                        /***** 36719  ******/
                        insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
                            '36719' as ixSourceCode
                        from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         2 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -72 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
                        GO
                        /***** 36720  ******/
                        insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
                            '36720' as ixSourceCode
                        from vwCSTStartingPool SP join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         1 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -72 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
                        GO
                        /*
                        DELETE from PJC_AD_ManualPull
                        where ixSourceCode = '36707'
                        */

*/

/************
PULL 12M STREET AND RACE BUYER SEGMENTS UP TO 75k total customers in campaign
*************/

/***** 36730 ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36730' as ixSourceCode
from vwCSTStartingPool SP 
    join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder 
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU join tblPGC PGC on PGC.ixPGC = SKU.ixPGC 
    join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /*RECENCY*/, getdate()) 
            and O.sOrderType <> 'Internal' 
            and O.sOrderChannel <> 'INTERNAL' 
            and O.sOrderStatus = 'Shipped' 
            and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/          1000 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where  O.dtShippedDate >= DATEADD(MM,/**/             -12 /*RECENCY*/, getdate()) 
    and O.sOrderType <> 'Internal' 
    and O.sOrderChannel <> 'INTERNAL'
    and PGC.ixMarket =                /**/             'R'/*MARKET*/
    and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   
    and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)
GO
/***** 36731  ******/
insert into PJC_AD_ManualPull 
    select DISTINCT TOP 7465 -- SPECIFIC TARGET AMOUNT
    SP.ixCustomer , 
    '36731' as ixSourceCode
from vwCSTStartingPool SP 
    --join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer  NOW USING HARDCODED MARKET FOR MANUAL PULL
    join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join 
    tblPGC PGC on PGC.ixPGC = SKU.ixPGC join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/           200 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where  O.dtShippedDate >= DATEADD(MM,/**/             -12 /*RECENCY*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket =                /**/             'R'/*MARKET*/
   and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)

GO


/***** 36740 ******/
insert into PJC_AD_ManualPull select distinct SP.ixCustomer , 
    '36740' as ixSourceCode
from vwCSTStartingPool SP 
    --join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer  NOW USING HARDCODED MARKET FOR MANUAL PULL
    join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join 
    tblPGC PGC on PGC.ixPGC = SKU.ixPGC join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/          1000 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where  O.dtShippedDate >= DATEADD(MM,/**/             -12 /*RECENCY*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket =                /**/             'SR'/*MARKET*/
   and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)

GO

/***** 36741  ******/
insert into PJC_AD_ManualPull 
    select DISTINCT TOP 3200 -- SPECIFIC TARGET AMOUNT
    SP.ixCustomer , 
    '36741' as ixSourceCode
from vwCSTStartingPool SP 
    --join PJC_17114_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer  NOW USING HARDCODED MARKET FOR MANUAL PULL
    join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join 
    tblPGC PGC on PGC.ixPGC = SKU.ixPGC join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/           200 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where  O.dtShippedDate >= DATEADD(MM,/**/             -12 /*RECENCY*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket =                /**/             'SR'/*MARKET*/
   and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull)

GO
/*
DELETE from PJC_AD_ManualPull
where ixSourceCode between '36730' AND '36741'
*/



/******************
-- RESULTS
******************/
select ixSourceCode, COUNT(ixCustomer) CustCount 
from PJC_AD_ManualPull 
group by ixSourceCode order by ixSourceCode
/*
36702	12389
36703	1968
36704	3087
36705	1134
36706	2814
36707	1460
36708	775
36709	1027
36710	862
36711	433
36712	304
36713	341
36714	246
36730	19194
36731	7465
36740	11805
36741	3200


 EXEC spCSTSegmentPull    12,'5','1000','R','R'     -- 11,677 orig  

-- VERIFY NO DUPE CUSTOMERS
SELECT COUNT(*) from PJC_AD_ManualPull                      -- 37474
SELECT COUNT(distinct ixCustomer) from PJC_AD_ManualPull    -- 37474


select ixCustomer,',',ixSourceCode from PJC_AD_ManualPull


sel