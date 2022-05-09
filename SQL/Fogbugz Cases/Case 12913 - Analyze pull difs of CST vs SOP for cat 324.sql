select COUNT(*) from PJC_324_CST_Pulls                   -- 49247
select COUNT(distinct ixCustomer) from PJC_324_CST_Pulls -- 49247

select top 10 * from PJC_324_CST_Pulls

select CST_SC, COUNT(*) QTY
from PJC_324_CST_Pulls
group by CST_SC
order by CST_SC
/*
CST_SC	QTY
32410	2314
32411	7132
32412	1565
32413	5696
32414	1045
32415	4963
32416	794
32417	1257
32418	1214
32419	23267
*/

select top 10 * from tblCustomerOffer

select ixCustomer, ixSourceCode
from tblCustomerOffer CO

select ixSourceCode
from tblSourceCode
where ixCatalog = '324'
/*
32410
32411
32412
32413
32414
32415
32416
32417
32418
32419
*32420
*32488
*32499
*/

select CO.ixSourceCode, SC.sDescription, COUNT(CO.ixCustomer)
from tblCustomerOffer CO
    join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '324'   
group by  CO.ixSourceCode, SC.sDescription
order by CO.ixSourceCode


select CO.ixSourceCode, SC.sDescription, CO.ixCustomer
into PJC_324_SOP_Pulls
from tblCustomerOffer CO
    join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '324'   
group by  CO.ixSourceCode, SC.sDescription
order by CO.ixSourceCode

select * from PJC_324_SOP_Pulls -- 49,312
select COUNT(distinct ixCustomer) from PJC_324_SOP_Pulls -- 49,311

select ixCustomer, COUNT(*)
from PJC_324_SOP_Pulls
group by ixCustomer
having COUNT(*) > 1

-- the BILLs Friends segments are not deduped in SOP
select * from tblCustomerOffer 
where ixCustomer = '777810'
and ixSourceCode like '324%'


-- customers pulled by CST but NOT SOP
select ixCustomer 
into PJC_InCST_NotInSOP
from PJC_324_CST_Pulls
where ixCustomer not in (select ixCustomer from PJC_324_SOP_Pulls) -- 12,405


-- customers pulled by SOP but NOT CST
select ixCustomer from PJC_324_SOP_Pulls
where ixCustomer not in (select ixCustomer from PJC_324_CST_Pulls) -- 12,470

-- customers pulled by SOP but not in the Starting Pool view  
select ixCustomer from PJC_324_SOP_Pulls
where ixCustomer not in (select ixCustomer from vwListPullStartingPool) -- 586


--
ixCustomer	ixMarket	Freq	Monetary	
80977	    SR	        9	    2099.74	
265408	    SR	        2	     224.93	
334584	    SR	        4	     802.75	
381996	    SR	        3	    2817.95
414411	    SR	        13	    1093.78	

select SP.ixCustomer,
    PGC.ixMarket, -- 10 mins returns 270k rows
    count(distinct O.ixOrder) 'Freq', 
    SUM(OL.mExtendedPrice) 'Monetary',
    sMailToState
from PJC_InCST_NotInSOP X 
    join vwListPullStartingPool SP on SP.ixCustomer = X.ixCustomer
    join tblOrder O on SP.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
where 
   --X.ixCustomer = '21427'
       O.dtShippedDate >= DATEADD(MM, -12, getdate()) -- RECENCY '01/01/2008'
   and OL.flgLineStatus = 'Shipped'
   and OL.flgKitComponent = 0 
   and O.sOrderType <> 'Internal'
   and O.sOrderChannel <> 'INTERNAL'
 --  and PGC.ixMarket = '2B'--  @Market -- MARKET 'SR'
group by SP.ixCustomer,PGC.ixMarket,sMailToState
order by SP.ixCustomer,PGC.ixMarket
--having count(distinct O.ixOrder) >= @Frequency -- FREQUENCY
  -- and SUM(OL.mExtendedPrice) >= @Monetary -- MONETARY
  
--  
ixCustomer	ixMarket	Freq	Monetary	
21427	    B	        2	     86.95	<-- Sales $ by Market based on OrderLine SKU
21427	    SR	        3	    202.89	   
                                ======
                                289.84
                                
--His Orders:
ixOrder Merch$
4864459 178.93
4548254  22.97
4069224  87.94
        ======
        289.84
                                




select * from tblCustomerOffer
where ixCustomer = '21427'
and ixSourceCode like '324%'


select OL.*,M.ixMarket 
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
    join tblMarket M on M.ixMarket = PGC.ixMarket
where O.dtOrderDate > '03/13/2011'
and O.ixCustomer = '21427'



