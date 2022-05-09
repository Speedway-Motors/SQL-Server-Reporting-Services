-- Case 22065 - Analyze purchasers that do not get pulled in the revised CST 375 campaign

select * from [SMITemp].dbo.PJC_22065_CST_375_RevisedPull

select count(ixCustomer) from [SMITemp].dbo.PJC_22065_CST_375_RevisedPull
select count(distinct ixCustomer) from [SMITemp].dbo.PJC_22065_CST_375_RevisedPull


-- drop table [SMITemp].dbo.PJC_22065_ExcludedBuyers
-- truncate table [SMITemp].dbo.PJC_22065_ExcludedBuyers
insert into [SMITemp].dbo.PJC_22065_ExcludedBuyers
select distinct ixCustomer 
    ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
from vwCSTStartingPool 
where ixCustomer NOT IN --(Select ixCustomer from [SMITemp].dbo.PJC_temp)
                        (select ixCustomer 
                         from [SMITemp].dbo.PJC_22065_CST_375_RevisedPull)
                         
select COUNT(SP.ixCustomer) 
from vwCSTStartingPool SP
    join [SMITemp].dbo.PJC_22065_CST_375_RevisedPull RP on SP.ixCustomer = RP.ixCustomer



select COUNT(*) from [SMITemp].dbo.PJC_22065_CST_375_RevisedPull    --  443,151 (INCLUDES members fro the Starting Pool AND the Requestor Starting Pool)
select COUNT(*) from [SMITemp].dbo.PJC_22065_ExcludedBuyers         -- +190,440 (Buyers in Starting Pool but NOT in Cat 375 PULL)
                                                                    --  ======
                                                                    --  633,591 
                                                                    -- - 85,327 requestors
                                                                        =======
                                                                    --  548,264
                                                                    
select COUNT(*) from vwCSTStartingPool                              --  542,010
/****** 72 Mo Sales ******/
    update EB
    set Sales72Mo = B.Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, sum(isnull(O.mMerchandise,0)) Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -6, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer
    GO
    update EB
    set Orders72Mo = B.OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, COUNT(O.ixOrder) OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -6, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.ixOrder NOT LIKE '%-%'
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer



/******  36 Mo Sales ******/ 
    update EB
    set Sales36Mo = B.Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, sum(isnull(O.mMerchandise,0)) Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -3, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer
GO
    update EB
    set Orders36Mo = B.OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, COUNT(O.ixOrder) OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -3, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.ixOrder NOT LIKE '%-%'
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer



-- update [SMITemp].dbo.PJC_22065_ExcludedBuyers set Sales24Mo = NULL
/******  24 Mo Sales ******/ 
    update EB
    set Sales24Mo = B.Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, sum(isnull(O.mMerchandise,0)) Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -2, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer
GO
    update EB
    set Orders24Mo = B.OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, COUNT(O.ixOrder) OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -2, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.ixOrder NOT LIKE '%-%'
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer
    
    
/******  12 Mo Sales ******/ 
    update EB
    set Sales12Mo = B.Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, sum(isnull(O.mMerchandise,0)) Sales
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -1, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer
GO
    update EB
    set Orders12Mo = B.OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join (
    select EB.ixCustomer, COUNT(O.ixOrder) OrdCount
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
    left join tblOrder O on EB.ixCustomer = O.ixCustomer
        where O.dtShippedDate >= DATEADD(yy, -1, getdate()) --and '12/31/2012'
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.ixOrder NOT LIKE '%-%'
    group by EB.ixCustomer) B on EB.ixCustomer = B.ixCustomer
    
/***** Populate OptIn Data *********/
update EB
    set OptIn_2B = OI.sOptInStatus
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join tblMailingOptIn OI ON EB.ixCustomer = OI.ixCustomer and OI.ixMarket = '2B'
update EB
    set OptIn_AD = OI.sOptInStatus
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join tblMailingOptIn OI ON EB.ixCustomer = OI.ixCustomer and OI.ixMarket = 'AD'
update EB
    set OptIn_R = OI.sOptInStatus
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join tblMailingOptIn OI ON EB.ixCustomer = OI.ixCustomer and OI.ixMarket = 'R'
update EB
    set OptIn_SM = OI.sOptInStatus
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join tblMailingOptIn OI ON EB.ixCustomer = OI.ixCustomer and OI.ixMarket = 'SM'
update EB
    set OptIn_SR = OI.sOptInStatus
    from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
        join tblMailingOptIn OI ON EB.ixCustomer = OI.ixCustomer and OI.ixMarket = 'SR'
        



                                
select * from [SMITemp].dbo.PJC_22065_ExcludedBuyers


update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX


    
/******  replace NULLs with 0 ******/ 
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Sales72Mo = 0
    where Sales72Mo IS NULL
    GO
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Sales36Mo = 0
    where Sales36Mo IS NULL 
    GO
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Sales24Mo = 0
    where Sales24Mo IS NULL 
    GO
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Sales12Mo = 0
    where Sales12Mo IS NULL            
    GO    
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Orders72Mo = 0
    where Orders72Mo IS NULL
    GO
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Orders36Mo = 0
    where Orders36Mo IS NULL 
    GO
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Orders24Mo = 0
    where Orders24Mo IS NULL 
    GO
    update [SMITemp].dbo.PJC_22065_ExcludedBuyers
    set Orders12Mo = 0
    where Orders12Mo IS NULL            
    GO    



    
select * from [SMITemp].dbo.PJC_22065_ExcludedBuyers 
order by Sales12Mo desc


select COUNT(*) from [SMITemp].dbo.PJC_22065_ExcludedBuyers                     -- 190,440
select COUNT(distinct ixCustomer) from [SMITemp].dbo.PJC_22065_ExcludedBuyers   -- 190,440

select EB.*, dtAccountCreateDate, ixSourceCode, 
--ixCustomerType, sMailingStatus, flgDeletedFromSOP
sCustomerMarket, ixOriginalMarket 
from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
left join tblCustomer C on EB.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0
order by Sales12Mo
    -- Sales12Mo desc, Sales24Mo Desc
  --  dtAccountCreateDate desc


select sCustomerMarket, COUNT(*)
from (select EB.*, dtAccountCreateDate, ixSourceCode, 
--ixCustomerType, sMailingStatus, flgDeletedFromSOP
sCustomerMarket, ixOriginalMarket 
from [SMITemp].dbo.PJC_22065_ExcludedBuyers EB
left join tblCustomer C on EB.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0) B
group by sCustomerMarket
order by sCustomerMarket




/**** from CCC breakdown by SKU Market ******/
-- Original Code for CCC
select 
	c.ixCustomer,
	sum(case when pgc.ixMarket='SR' then ol.mExtendedPrice else 0 end) as 'Street',
	sum(case when pgc.ixMarket='R' then ol.mExtendedPrice else 0 end) as 'Race',
	sum(case when pgc.ixMarket='B' then ol.mExtendedPrice else 0 end) as 'B',
	sum(case when pgc.ixMarket='2B' then ol.mExtendedPrice else 0 end) as 'TBUCKET',
	sum(case when pgc.ixMarket='SM' then ol.mExtendedPrice else 0 end) as 'Sprint',
	sum(ol.mExtendedPrice) as 'Total'
from
	tblOrderLine ol
	left join tblOrder o on ol.ixOrder = o.ixOrder
	left join tblSKU s on ol.ixSKU = s.ixSKU
	left join tblPGC pgc on s.ixPGC=pgc.ixPGC
	left join tblCustomer c on ol.ixCustomer = c.ixCustomer
where
	o.sOrderChannel <> 'INTERNAL'
	and ol.flgKitComponent=0
	and ol.flgLineStatus='Shipped'
	and o.dtOrderDate >= dateadd(yy,-1,getdate())
	and o.sOrderType='Retail'
		--and o.ixCustomer NOT in (select co.ixCustomer from tblCustomerOffer co left join tblDate d on co.ixActiveStartDate = d.ixDate and d.dtDate >= '01/01/14' and co.sType = 'OFFER')
	and c.ixCustomerType in ('1', '2', '3','4','5','6','7','8','9','10')
	and o.ixCustomer NOT in (select co.ixCustomer from tblCustomerOffer co left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
							where sc.ixCatalog in ('375'))  
group by
	c.ixCustomer
	
-- my MODIFIED version
select 
	C.ixCustomer,
	sum(case when PGC.ixMarket='SR' then OL.mExtendedPrice else 0 end) as 'Street',
    OptIn_SR,
	sum(case when PGC.ixMarket='R' then OL.mExtendedPrice else 0 end) as 'Race',
--	OptIn_R, OptIn_2B, OptIn_SM,
	sum(case when PGC.ixMarket='B' then OL.mExtendedPrice else 0 end) as 'B',
	sum(case when PGC.ixMarket='2B' then OL.mExtendedPrice else 0 end) as 'TBUCKET',
	sum(case when PGC.ixMarket='SM' then OL.mExtendedPrice else 0 end) as 'Sprint',
	sum(case when PGC.ixMarket NOT IN ('SR','R','B','2B','SM') then OL.mExtendedPrice else 0 end) as 'OTHER',
	sum(OL.mExtendedPrice) as 'Total'
from
	tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblCustomer C on OL.ixCustomer = C.ixCustomer
	join [SMITemp].dbo.PJC_22065_ExcludedBuyers EB on C.ixCustomer = EB.ixCustomer
	left join tblMailingOptIn MOI on C.ixCustomer = MOI.ixCustomer and MOI.ixMarket = 'SR' and MOI.sOptInStatus <> 'N'
		left join tblSKU S on OL.ixSKU = S.ixSKU
	left join tblPGC PGC on S.ixPGC=PGC.ixPGC
where
	O.sOrderChannel <> 'INTERNAL'
	and S.flgIntangible = 0
	and OL.flgKitComponent=0
	and OL.flgLineStatus='Shipped'
	and O.dtOrderDate >= dateadd(yy,-1,getdate())
	and O.sOrderType='Retail'
	and O.ixCustomer NOT in (select CO.ixCustomer from tblCustomerOffer CO left join tblSourceCode SC on CO.ixSourceCode=SC.ixSourceCode
							where SC.ixCatalog in ('375'))  
group by
	C.ixCustomer, OptIn_SR,	OptIn_R, OptIn_2B, OptIn_SM-- 4 mins	
order by sum(case when PGC.ixMarket='SR' then OL.mExtendedPrice else 0 end) desc	,
        sum(case when PGC.ixMarket='R' then OL.mExtendedPrice else 0 end) desc,
	    sum(case when PGC.ixMarket='B' then OL.mExtendedPrice else 0 end) desc,
	    sum(case when PGC.ixMarket='2B' then OL.mExtendedPrice else 0 end) desc,
	    sum(case when PGC.ixMarket='SM' then OL.mExtendedPrice else 0 end) desc,
	    sum(case when PGC.ixMarket NOT IN ('SR','R','B','2B','SM') then OL.mExtendedPrice else 0 end) desc

	
	
select COUNT(*) from [SMITemp].dbo.PJC_22065_ExcludedBuyers -- 453,000
select COUNT(*) from vwCSTStartingPool	                    -- 542,010




select PGC.ixMarket, M.sDescription, COUNT(PGC.ixPGC) PGCs
from tblPGC PGC
    join tblSKU SKU on PGC.ixPGC = SKU.ixPGC
    left join tblMarket M on PGC.ixMarket = M.ixMarket
group by PGC.ixMarket, M.sDescription



select COUNT(*) from tblSKU where flgDeletedFromSOP = 0 and flgIntangible = 0 -- 214,818

SELECT X.ixMarket, X.sDescription, sum(X.SKUCount) TotActiveSKUs
from (select SKU.ixPGC, M.ixMarket, M.sDescription, COUNT(SKU.ixSKU) SKUCount
                from tblSKU SKU
                    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
                    left join tblMarket M on M.ixMarket = PGC.ixMarket
                where SKU.flgDeletedFromSOP = 0 
                    and SKU.flgIntangible = 0
                    and SKU.flgActive = 1
                group by SKU.ixPGC, M.ixMarket, M.sDescription
                ) X
group by X.ixMarket, X.sDescription             
order by sum(X.SKUCount) desc


select M.ixMarket, M.sDescription, SUM(OL.mExtendedPrice) SalesYTD
from tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
    left join tblMarket M on M.ixMarket = PGC.ixMarket
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '01/01/2014'
    and O.sOrderType = 'Retail'
    and OL.flgLineStatus in ('Shipped','Dropshipped')
group by M.ixMarket, M.sDescription    
    
select SUM(O.mMerchandise)    
from tblOrder O 
    --left join tblOrderLine OL on OL.ixOrder = O.ixOrder
where  O.sOrderStatus in ('Shipped','Dropshipped')
and O.dtShippedDate >= '01/01/2014'  


select distinct flgLineStatus from tblOrderLine 

 