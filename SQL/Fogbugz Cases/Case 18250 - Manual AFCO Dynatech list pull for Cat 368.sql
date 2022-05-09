-- Case 18250 - Manual AFCO Dynatech list pull for Cat 368
--    based on code from Case 18250

-- REQUESTORS
select count(distinct ixCustomer) from tblCatalogRequest
where ixCatalogMarket = 'AD'
AND ixRequestDate >= 16075
and ixCustomer in (select ixCustomer from vwCSTStartingPoolRequestors) 
and ixCustomer in (select ixCustomer from tblCustomer where flgDeletedFromSOP = 0) -- 4030

-- REQUESTORS 
select distinct CR.ixCustomer -- 10,870
from tblCatalogRequest CR
    join vwCSTStartingPoolRequestors SPR on CR.ixCustomer = SPR.ixCustomer
   -- join tblMailingOptIn MO on MO.ixCustomer = C.ixCustomer
where CR.ixCatalogMarket = 'AD'
    and dtRequestDate >= '01/08/2006'
  --  and CR.ixCustomer NOT IN (select ixCustomer from [SMITemp].dbo.PJC_18250_AD_StartingPool)
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
    AVG(O.mMerchandise) as AOV -- 30,522 after joining to vwCSTStartingPool
-- DROP table [SMITemp].dbo.PJC_18250_AD_StartingPool
into [SMITemp].dbo.PJC_18250_AD_StartingPool  
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

/*
36802   12M, 5+, $1000+
36803   12M, 5+, $1+
36804   12M, 2+, $1+
36805   12M, 1+, $1+
36806   24M, 5+, $1+
36807   36M, 5+, $1+
36830   12M, 5+, $1000+ Race
36831   12M, 5+, $200+ Race
36840   12M, 5+, $1000+ Open Wheel
36841   12M, 5+, $200+ Open Wheel
*/

/************
PULLING AD BUYERS FIRST
*************/

-- batches based by Recency, Freq, Monetary in that order

/***** 36802 ******/
--insert into PJC_AD_ManualPull_Cat368 -- 13,216
select distinct SP.ixCustomer , 
    '36802' as ixSourceCode
into PJC_AD_ManualPull_Cat368 
-- DROP table PJC_AD_ManualPull_Cat368    
from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/          1000 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')  -- and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
GO
/***** 36803  ******/
insert into PJC_AD_ManualPull_Cat368 -- 2,117
select distinct SP.ixCustomer , 
    '36803' as ixSourceCode
from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
GO
/***** 36804  ******/
insert into PJC_AD_ManualPull_Cat368 
select distinct SP.ixCustomer , -- 3,039
    '36804' as ixSourceCode
--into PJC_AD_ManualPull_Cat368 
-- TRUNCATE table PJC_AD_ManualPull_Cat368    
from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         2 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
GO
/***** 36805  ******/
insert into PJC_AD_ManualPull_Cat368 
select distinct SP.ixCustomer , -- 1,123
    '36805' as ixSourceCode
from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -12 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
GO
/***** 36806 ******/
insert into PJC_AD_ManualPull_Cat368 
select distinct SP.ixCustomer , -- 3,070
    '36806' as ixSourceCode
from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/          1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -24 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
GO
/***** 36807  ******/
insert into PJC_AD_ManualPull_Cat368 
select distinct SP.ixCustomer ,  -- 1,212
    '36807' as ixSourceCode
from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where O.dtShippedDate >= DATEADD(MM,/**/              -36 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)

GO

/*
DELETE from PJC_AD_ManualPull_Cat368
where ixSourceCode = '36807'
*/

/* DO NOT PULL THE FOLLOWING COMMENTED OUT SEGMENTS

                /***** 36808 24m 5+ $1000        COUNT = #### ******/
                insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                    '36808' as ixSourceCode
                --into PJC_AD_ManualPull_Cat368 
                -- TRUNCATE table PJC_AD_ManualPull_Cat368    
                from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                            select O.ixCustomer from tblOrder O
                            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
                            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                where O.dtShippedDate >= DATEADD(MM,/**/              -24 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                GO
                /***** 36809 ******/
                insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                    '36809' as ixSourceCode
                from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                            select O.ixCustomer from tblOrder O
                            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
                            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                where O.dtShippedDate >= DATEADD(MM,/**/              -36 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                GO
                /***** 36810  ******/
                insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                    '36810' as ixSourceCode
                --into PJC_AD_ManualPull_Cat368 
                -- TRUNCATE table PJC_AD_ManualPull_Cat368    
                from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                            select O.ixCustomer from tblOrder O
                            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                            having count(distinct O.ixOrder) >=         2 /*FREQ*/         
                            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                where O.dtShippedDate >= DATEADD(MM,/**/              -36 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                GO
                /***** 36811  ******/
                insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                    '36811' as ixSourceCode
                from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                            select O.ixCustomer from tblOrder O
                            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
                            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                where O.dtShippedDate >= DATEADD(MM,/**/              -36 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                GO
                /***** 36812 ******/
                insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                    '36812' as ixSourceCode
                from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                            select O.ixCustomer from tblOrder O
                            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
                            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                where O.dtShippedDate >= DATEADD(MM,/**/              -48 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                GO
                /***** 36813 ******/
                insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                    '36813' as ixSourceCode
                from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                            select O.ixCustomer from tblOrder O
                            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                            having count(distinct O.ixOrder) >=         2 /*FREQ*/         
                            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                where O.dtShippedDate >= DATEADD(MM,/**/              -48 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                GO
                /***** 36814  ******/
                insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                    '36814' as ixSourceCode
                --into PJC_AD_ManualPull_Cat368 
                -- TRUNCATE table PJC_AD_ManualPull_Cat368    
                from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                            select O.ixCustomer from tblOrder O
                            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                            having count(distinct O.ixOrder) >=         1 /*FREQ*/         
                            and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                where O.dtShippedDate >= DATEADD(MM,/**/              -48 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                GO

/*
DELETE from PJC_AD_ManualPull_Cat368
where ixSourceCode = '36807'
*/



                        /***** 36815 ******/
                        insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                            '36815'as ixSourceCode
                        --into PJC_AD_ManualPull_Cat368 
                        -- TRUNCATE table PJC_AD_ManualPull_Cat368    
                        from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         5 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -60 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                        GO
                        /***** 36816 ******/
                        insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                            '36816'as ixSourceCode
                        From vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         2 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -60 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                        GO
                        /***** 36817 ******/
                        insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                            '36817'as ixSourceCode
                        from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         1 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -60 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                        GO
                        /***** 36818 ******/
                        insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                            '36818' as ixSourceCode
                        from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         5 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -72 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                        GO

                        /***** 36819  ******/
                        insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                            '36819' as ixSourceCode
                        from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         2 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -72 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                        GO
                        /***** 36820  ******/
                        insert into PJC_AD_ManualPull_Cat368 select distinct SP.ixCustomer , 
                            '36820' as ixSourceCode
                        from vwCSTStartingPool SP join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join (  -- RECENCY & MONETARY
                                    select O.ixCustomer from tblOrder O
                                    where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
                                    having count(distinct O.ixOrder) >=         1 /*FREQ*/         
                                    and SUM(O.mMerchandise) >= /**/             1 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
                        where O.dtShippedDate >= DATEADD(MM,/**/              -72 /*RECENCY*/, getdate()) and OL.flgLineStatus = 'Shipped'and OL.flgKitComponent = 0 and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'  and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
                        GO
                        /*
                        DELETE from PJC_AD_ManualPull_Cat368
                        where ixSourceCode = '36807'
                        */

*/
36830   12M, 5+, $1000+ Race
36831   12M, 5+, $200+ Race
36840   12M, 5+, $1000+ Open Wheel
36841   12M, 5+, $200+ Open Wheel

/************
PULL 12M STREET AND RACE BUYER SEGMENTS UP TO 75k total customers in campaign
*************/

/***** 36830 ******/
insert into PJC_AD_ManualPull_Cat368 
select distinct SP.ixCustomer , -- 18,801
    '36830' as ixSourceCode
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
    and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)
GO
/***** 36831  ******/
insert into PJC_AD_ManualPull_Cat368 
    select DISTINCT /*TOP 7465*/ -- SPECIFIC TARGET AMOUNT       -- 8,133 
    SP.ixCustomer , 
    '36831' as ixSourceCode
from vwCSTStartingPool SP 
    --join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer  NOW USING HARDCODED MARKET FOR MANUAL PULL
    join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join 
    tblPGC PGC on PGC.ixPGC = SKU.ixPGC join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/           200 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where  O.dtShippedDate >= DATEADD(MM,/**/             -12 /*RECENCY*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket =                /**/             'R'/*MARKET*/
   and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)

GO


/***** 36840 ******/
insert into PJC_AD_ManualPull_Cat368 
select distinct SP.ixCustomer , -- 12,544
    '36840' as ixSourceCode
from vwCSTStartingPool SP 
    --join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer  NOW USING HARDCODED MARKET FOR MANUAL PULL
    join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join 
    tblPGC PGC on PGC.ixPGC = SKU.ixPGC join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/          1000 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where  O.dtShippedDate >= DATEADD(MM,/**/             -12 /*RECENCY*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket =                /**/             'SR'/*MARKET*/
   and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)

GO

/***** 36841  ******/
insert into PJC_AD_ManualPull_Cat368 
    select DISTINCT /*TOP 3200*/ -- SPECIFIC TARGET AMOUNT      -- 7,445
    SP.ixCustomer , 
    '36841' as ixSourceCode
from vwCSTStartingPool SP 
    --join [SMITemp].dbo.PJC_18250_AD_StartingPool AD_SP on AD_SP.ixCustomer = SP.ixCustomer  NOW USING HARDCODED MARKET FOR MANUAL PULL
    join tblOrder O on SP.ixCustomer = O.ixCustomer join tblOrderLine OL on O.ixOrder = OL.ixOrder join tblSKU SKU on SKU.ixSKU = OL.ixSKU join 
    tblPGC PGC on PGC.ixPGC = SKU.ixPGC join (  -- RECENCY & MONETARY
            select O.ixCustomer from tblOrder O
            where  O.dtShippedDate >= DATEADD(MM,/**/ -72 /* ALWAYS 72m*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL' and O.sOrderStatus = 'Shipped' and O.mMerchandise > 1 group by O.ixCustomer
            having count(distinct O.ixOrder) >=         5 /*FREQ*/         
            and SUM(O.mMerchandise) >= /**/           200 /*MONETARY*/    ) FM on SP.ixCustomer = FM.ixCustomer
where  O.dtShippedDate >= DATEADD(MM,/**/             -12 /*RECENCY*/, getdate()) and O.sOrderType <> 'Internal' and O.sOrderChannel <> 'INTERNAL'
   and PGC.ixMarket =                /**/             'SR'/*MARKET*/
   and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = 'AD' and sOptInStatus = 'N')   and SP.ixCustomer NOT IN (select ixCustomer from PJC_AD_ManualPull_Cat368)

GO
/*
DELETE from PJC_AD_ManualPull_Cat368
where ixSourceCode between '36830' AND '36841'
*/



/******************
-- RESULTS
******************/
select ixSourceCode, COUNT(ixCustomer) CustCount 
from PJC_AD_ManualPull_Cat368 
group by ixSourceCode order by ixSourceCode
/*
36802	13216
36803	2117
36804	3039
36805	1123
36806	3070
36807	1212
36830	18801
36831	8133
36840	12544
36841	7445
*/

 EXEC spCSTSegmentPull    12,'5','1000','R','R'     -- 11,677 orig  

-- VERIFY NO DUPE CUSTOMERS
SELECT COUNT(*) from PJC_AD_ManualPull_Cat368                      -- 37474
SELECT COUNT(distinct ixCustomer) from PJC_AD_ManualPull_Cat368    -- 37474


select ixCustomer,',',ixSourceCode from PJC_AD_ManualPull_Cat368

