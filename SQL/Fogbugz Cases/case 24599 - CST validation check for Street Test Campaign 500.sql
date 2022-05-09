-- case 24599 - CST validation check for Street Test Campaign 500

/***** CST validation check
street campaign 500
******/

-- duplicating from Race table
select top 1 *
into PJC_CST_Street500
from PJC_CST_tempRace400

select * from PJC_CST_Street500
-- TRUNCATE table PJC_CST_Street500



select COUNT(*) from PJC_CST_Street500                    -- 304,335
select COUNT(distinct ixCustomer) from PJC_CST_Street500  -- 304,335


select ixSourceCode,
    COUNT(ixCustomer) CustQty,
    sDescription 
from PJC_CST_Street500
group by ixSourceCode, sDescription
order by ixSourceCode


-- add descriptions of SCs
update PJC_CST_Street500
set sDescription = '12mo 1+ $1+ R'
where ixSourceCode = 40002
GO
update PJC_CST_Street500
set sDescription = '12mo 1+ $1+ B'
where ixSourceCode = 40003
GO
update PJC_CST_Street500
set sDescription = '24mo 1+ $1+ R'
where ixSourceCode = 40004
GO
update PJC_CST_Street500
set sDescription = '24mo 1+ $1+ B'
where ixSourceCode = 40005
GO
update PJC_CST_Street500
set sDescription = '36mo 1+ $1+ R'
where ixSourceCode = 40006
GO
update PJC_CST_Street500
set sDescription = '48mo 1+ $1+ R'
where ixSourceCode = 40007
GO
update PJC_CST_Street500
set sDescription = '60mo 1+ $1+ R'
where ixSourceCode = 40008
GO
update PJC_CST_Street500
set sDescription = '12mo Requestors'
where ixSourceCode = 40070

GO
-- populate state 
    update CST
    set ixState = C.sMailToState
    from PJC_CST_Street500 CST
     join [SMI Reporting].dbo.tblCustomer C on C.ixCustomer = CST.ixCustomer

    select COUNT(*) Qty, ixState
    from PJC_CST_Street500
    where ixState NOT in (select ixState from [SMI Reporting].dbo.tblStates where (flgContiguous = 1 or flgNonContiguous = 1) and ixState <> 'DC')
    group by ixState
    order by Qty desc
    /*
    Qty	ixState
    17	GU
    1	HG
    1	KAARINA
    1	MP
    1	NDS
    1	NU
    1	RP
    1	SACHSEN
    1	SAXONY
    1	SEINE ET MARNE
    1	SORSASALO
    1	x
    1	001
    1	BERN
    1	DALARNA
    1	FRANCE
    */

-- copy table before removing users
-- drop table PJC_CST_Street500_original
select * into PJC_CST_Street500_original from PJC_CST_Street500

-- remove custs with invalid states
    -- DELETE
    from PJC_CST_Street500 
    where ixState not in (select ixState from [SMI Reporting].dbo.tblStates where (flgContiguous = 1 or flgNonContiguous = 1) and ixState <> 'DC')


select COUNT(*) Qty, ixState
from PJC_CST_Street500
group by ixState
order by Qty desc
/*
Qty	    ixState
27568	CA
17442	TX
12973	FL
11786	NE
11324	PA
11260	IL
10924	MO
10337	NY
10044	OH
9740	VA
9455	MI
8783	IA
8518	MN
8402	WA
8261	IN
7937	NC
7927	WI
7859	KS
7356	CO
7273	AZ
7165	TN
6677	GA
5769	KY
5708	OK
5332	OR
4569	AL
4080	AR
3996	SC
3798	NJ
3236	MD
3151	MA
3124	LA
2803	SD
2797	MS
2662	NM
2647	NV
2391	CT
2390	ID
2273	WV
2134	ND
2126	UT
1962	ME
1832	MT
1626	NH
1536	WY
781	    VT
760	    DE
703	    HI
612	    RI
447	    AK
47	    DC
*/

-- cacl 12 month sales for R and B markets past 12 months
-- DROP TABLE PJC_CST_Street500_SALES
select CST.ixCustomer, 
    SUM(isNULL(OL.mExtendedPrice,0)) m12MoSalesRandB -- $31,113,920
into PJC_CST_Street500_SALES    
from PJC_CST_Street500 CST
    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixCustomer = CST.ixCustomer
    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU S on S.ixSKU = OL.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on PGC.ixPGC = S.ixPGC 
where O.sOrderStatus = 'Shipped'  
    and O.mMerchandise > 0   
    and O.dtShippedDate between '11/17/2013' and '11/16/2014'
    and O.sOrderType <> 'Internal'   -- exlude per CCC
    and O.sOrderChannel <> 'INTERNAL'-- exlude per CCC
    and O.sOrderType = 'Retail'       
    and OL.flgLineStatus = 'Shipped'
    and OL.flgKitComponent = 0  
    and PGC.ixMarket in ('R') -- exclude 'B' per CCC
group by CST.ixCustomer
order by m12MoSalesRandB    

select SUM(m12MoSalesRandB) from  PJC_CST_Street500_SALES -- $23,990,652 12Mo Race Sales


-- update 12mo sales
/*-- CLEAR SALES
        update PJC_CST_Street500
        set m12MoSalesRandB = 0
*/
update CST
set m12MoSalesRandB = TEMP.m12MoSalesRandB
from PJC_CST_Street500 CST
  join PJC_CST_Street500_SALES TEMP on TEMP.ixCustomer = CST.ixCustomer

 
SELECT SUM(m12MoSalesRandB) FROM PJC_CST_Street500 -- $23,747,537 v

select COUNT(*) from PJC_CST_Street500
where m12MoSalesRandB > 0 -- 86,942  vs   87,222 from CST - slight variance in dates used plus any newly merged customers  should account for the delta




select ixSourceCode SCode, sDescription, count(ixCustomer) CustQty, SUM(m12MoSalesRandB) Sales
from PJC_CST_Street500
group by ixSourceCode, sDescription
order by ixSourceCode
/*
sDescription	CustQty	    Sales
12mo 1+ $1+ R	87,222	$23,981,611         $24,858,912
12mo 1+ $1+ B	30,292	        665
24mo 1+ $1+ R	49,162	      8,374
24mo 1+ $1+ B	22,376	          1
36mo 1+ $1+ R	39,209	          0
48mo 1+ $1+ R	33,141	          0
60mo 1+ $1+ R	27,327	          0
12mo Requestors	15,527	          0
*/


select ixState, ixSourceCode, sDescription, SUM(m12MoSalesRandB) Sales
from PJC_CST_Street500
group by ixState, ixSourceCode, sDescription
order by sDescription desc, Sales desc

-- ALL 12Mo US Retail Race Sales regardless of CST customers
select SUM(isNULL(OL.mExtendedPrice,0)) m12MoSalesRandB -- $24,280,329
from [SMI Reporting].dbo.tblCustomer C
    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU S on S.ixSKU = OL.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on PGC.ixPGC = S.ixPGC 
where C.flgDeletedFromSOP = 0
    and (C.sMailToCountry is NULL OR C.sMailToCountry = 'USA')
    and O.sOrderStatus = 'Shipped'  
    and O.mMerchandise > 0   
    and O.dtShippedDate between '11/17/2013' and '11/16/2014'
    and O.sOrderType = 'Retail'   
    and O.sOrderChannel <> 'INTERNAL'-- exlude per CCC
    and OL.flgLineStatus = 'Shipped'
    and OL.flgKitComponent = 0 
    and PGC.ixMarket in ('R') -- exclude 'B' per CCC




-- details of the customer sales NOT in the CST pull
-- ALL 12 Mo Retail Race Sales regardless of CST customers
select --C.ixCustomer, C.sMailToZip, C.sMailToCountry, C.sMailToZip, C.sMailingStatus,
   -- C.sCustomerType, MOI.sOptInStatus,
    SUM(isNULL(OL.mExtendedPrice,0)) m12MoSalesRandB -- 
from [SMI Reporting].dbo.tblCustomer C
    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU S on S.ixSKU = OL.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on PGC.ixPGC = S.ixPGC 
    left join PJC_CST_Street500 CST on CST.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblMailingOptIn MOI on C.ixCustomer = MOI.ixCustomer AND MOI.ixMarket = 'R'
where C.flgDeletedFromSOP = 0
    and (C.sMailToCountry is NULL OR C.sMailToCountry = 'USA')
    and (C.sMailingStatus is NULL OR C.sMailingStatus = 0)
    and O.sOrderStatus = 'Shipped'  
    and O.mMerchandise > 0   
    and O.dtShippedDate between '11/17/2013' and '11/16/2014'
    and O.sOrderType = 'Retail'   
    and O.sOrderChannel <> 'INTERNAL'-- exclude per CCC
    and OL.flgLineStatus = 'Shipped'
    and OL.flgKitComponent = 0 
    and PGC.ixMarket in ('R') -- exclude 'B' per CCC
    AND CST.ixCustomer is NULL
    and C.sCustomerType = 'Retail' 
    and MOI.sOptInStatus = 'N'
GROUP BY C.ixCustomer, C.sMailToZip, C.sMailToCountry, C.sMailToZip, C.sMailingStatus,
    C.sCustomerType, MOI.sOptInStatus
ORDER BY MOI.sOptInStatus
    ,m12MoSalesRandB DESC     
    
    
    

/**************************************/ 
/********    24 month sales  **********/
/**************************************/
-- cacl 12 month sales for R and B markets past 12 months
-- DROP TABLE PJC_CST_Street500_SALES
select CST.ixCustomer, 
    SUM(isNULL(OL.mExtendedPrice,0)) m24MoSalesRandB -- $31,113,920
into PJC_CST_Street500_SALES24Mo    
from PJC_CST_Street500 CST
    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixCustomer = CST.ixCustomer
    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU S on S.ixSKU = OL.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on PGC.ixPGC = S.ixPGC 
where O.sOrderStatus = 'Shipped'  
    and O.mMerchandise > 0   
    and O.dtShippedDate between '11/17/2012' and '11/16/2014'
    and O.sOrderType <> 'Internal'   -- exlude per CCC
    and O.sOrderChannel <> 'INTERNAL'-- exlude per CCC
    and O.sOrderType = 'Retail'       
    and OL.flgLineStatus = 'Shipped'
    and OL.flgKitComponent = 0  
    and PGC.ixMarket in ('R') -- exclude 'B' per CCC
group by CST.ixCustomer
order by m24MoSalesRandB    

select SUM(m24MoSalesRandB) from  PJC_CST_Street500_SALES24Mo -- $45,670,683 24Mo Race Sales


-- update 24Mo sales
/*-- CLEAR SALES
        update PJC_CST_Street500
        set m24MoSalesRandB = 0
*/
update CST
set m24MoSalesRandB = TEMP.m24MoSalesRandB
from PJC_CST_Street500 CST
  join PJC_CST_Street500_SALES24Mo TEMP on TEMP.ixCustomer = CST.ixCustomer

  
SELECT SUM(m24MoSalesRandB) FROM PJC_CST_Street500 -- $45,670,683 v

select COUNT(*) from PJC_CST_Street500
where m24MoSalesRandB > 0 -- 140,327  vs   136,384 from CST 




select ixSourceCode SCode, sDescription, count(ixCustomer) CustQty, SUM(m12MoSalesRandB) '12MoSales', SUM(m24MoSalesRandB) '24MoSales'
from PJC_CST_Street500
group by ixSourceCode, sDescription
order by ixSourceCode
/*
sDescription	CustQty	 12Mo Sales     24Mo Sales
12mo 1+ $1+ R	87,222	$23,981,611    $37,057,100
12mo 1+ $1+ B	30,292	        665        636,451
24mo 1+ $1+ R	49,162	      8,374      7,975,041
24mo 1+ $1+ B	22,376	          1            144 
36mo 1+ $1+ R	39,209	          0          1,944
48mo 1+ $1+ R	33,141	          0              0
60mo 1+ $1+ R	27,327	          0              0
12mo Requestors	15,527	          0              0
*/


select ixState, ixSourceCode, sDescription, SUM(m12MoSalesRandB) Sales
from PJC_CST_Street500
group by ixState, ixSourceCode, sDescription
order by sDescription desc, Sales desc

-- ALL 24Mo US Retail Race Sales regardless of CST customers
select SUM(isNULL(OL.mExtendedPrice,0)) m24MoSalesRandB -- $24,280,329
from [SMI Reporting].dbo.tblCustomer C
    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU S on S.ixSKU = OL.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on PGC.ixPGC = S.ixPGC 
where C.flgDeletedFromSOP = 0
    and (C.sMailToCountry is NULL OR C.sMailToCountry = 'USA')
    and O.sOrderStatus = 'Shipped'  
    and O.mMerchandise > 0   
    and O.dtShippedDate between '11/17/2012' and '11/16/2014'
    and O.sOrderType = 'Retail'   
    and O.sOrderChannel <> 'INTERNAL'-- exlude per CCC
    and OL.flgLineStatus = 'Shipped'
    and OL.flgKitComponent = 0 
    and PGC.ixMarket in ('R') -- exclude 'B' per CCC




-- details of the customer sales NOT in the CST pull
-- ALL 24Mo Retail Race Sales regardless of CST customers
select --C.ixCustomer, C.sMailToZip, C.sMailToCountry, C.sMailToZip, C.sMailingStatus,
   -- C.sCustomerType, MOI.sOptInStatus,
    SUM(isNULL(OL.mExtendedPrice,0)) m12MoSalesRandB -- 
from [SMI Reporting].dbo.tblCustomer C
    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU S on S.ixSKU = OL.ixSKU
    left join [SMI Reporting].dbo.tblPGC PGC on PGC.ixPGC = S.ixPGC 
    left join PJC_CST_Street500 CST on CST.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblMailingOptIn MOI on C.ixCustomer = MOI.ixCustomer AND MOI.ixMarket = 'R'
where C.flgDeletedFromSOP = 0
    and (C.sMailToCountry is NULL OR C.sMailToCountry = 'USA')
    and (C.sMailingStatus is NULL OR C.sMailingStatus = 0)
    and O.sOrderStatus = 'Shipped'  
    and O.mMerchandise > 0   
    and O.dtShippedDate between '11/17/2012' and '11/16/2014'
    and O.sOrderType = 'Retail'   
    and O.sOrderChannel <> 'INTERNAL'-- exclude per CCC
    and OL.flgLineStatus = 'Shipped'
    and OL.flgKitComponent = 0 
    and PGC.ixMarket in ('R') -- exclude 'B' per CCC
    AND CST.ixCustomer is NULL
    and C.sCustomerType = 'Retail' 
    and MOI.sOptInStatus = 'N'
GROUP BY C.ixCustomer, C.sMailToZip, C.sMailToCountry, C.sMailToZip, C.sMailingStatus,
    C.sCustomerType, MOI.sOptInStatus
ORDER BY MOI.sOptInStatus
    ,m12MoSalesRandB DESC         