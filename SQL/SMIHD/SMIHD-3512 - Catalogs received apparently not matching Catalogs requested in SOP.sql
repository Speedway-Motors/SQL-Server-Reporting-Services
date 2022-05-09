-- SMIHD-3512 - Catalogs received apparently not matching Catalogs requested in SOP
SELECT * from tblCustomer
WHERE ixCustomer in ('1119743','2918058')

/*
ixCustomer	sCustomerFirstName	sCustomerLastName	sCustomerType	ixSourceCode	dtAccountCreateDate	sMailToCity	sMailToState	sMailToZip
1119743	    RICHARD	            DURNELL	            Retail	        WCR4	        2011-09-11          CATLIN	    IL	            61817
2918058	    JACOB	            MAKINGS	            Retail	        WCR7	        2016-02-08          ODESSA	    MO	            64076
*/

SELECT * from vwCSTStartingPool
WHERE ixCustomer in ('1119743','2918058')
/*
ixCustomer	sMailToState	ixOrigCustSourceCode	CustGroup
1119743	    IL	            WCR4	                WEB
*/
 


SELECT * from vwCSTStartingPoolRequestors
WHERE ixCustomer in ('1119743','2918058')
/*
ixCustomer	sMailToState	ixCatalogMarket	LatestRequestDate
2918058	    MO	            SR	            2016-02-08 
*/
  
SELECT * from tblOrder
WHERE ixCustomer in ('1119743','2918058') 
--2918058

/*
ixCustomer	ixOrder	    sOrderStatus    mMerchandise	sOrderChannel	sSourceCodeGiven	dtShippedDate	sShipToCity	sShipToState	sOrderType
1119743	    6161409	    Shipped            0.00	        INTERNAL	    EC	                2015-02-17      CATLIN	    IL	            Retail
1119743	    6161409EC	Shipped            0.00	        INTERNAL	    EC	                2015-02-17      CATLIN	    IL	            Retail
1119743	    4096963	    Shipped          666.81	        WEB	            2190	            2012-03-16      CATLIN	    IL	            Retail
*/

SELECT S.sDescription, OL.*
from tblOrderLine OL
left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE ixCustomer in ('1119743','2918058') 
and ixOrder in ('6161409','6161409EC')
order by ixOrder

/*
sDescription	        dtShippedDate	ixOrder
SPRINT CATALOG COMBO	2015-02-17      6161409
2014 SPRINT MASTER #3	2015-02-17      6161409
2015 RACE CATALOG #1	2015-02-17      6161409
2014 EMI CATALOG	    2015-02-17      6161409
2014 PRO SHOCKS CATALOG	2015-02-17      6161409
STREET CATALOG COMBO	2015-02-17      6161409
2015 STREET CATALOG #1	2015-02-17      6161409

SPRINT CATALOG COMBO	2015-02-17      6161409EC
2014 SPRINT MASTER #3	2015-02-17      6161409EC
2015 RACE CATALOG #1	2015-02-17      6161409EC
2014 EMI CATALOG	    2015-02-17      6161409EC
2014 PRO SHOCKS CATALOG	2015-02-17      6161409EC
STREET CATALOG COMBO	2015-02-17      6161409EC
2015 STREET CATALOG #1	2015-02-17      6161409EC
*/

SELECT CO.ixCustomer 'Cust', SC.ixCatalog 'Cat',SC.ixSourceCode 'SC    ',
sDescription 'SC Description          ',sCatalogMarket 'CatMkt',dtStartDate
FROM tblCustomerOffer CO
left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
WHERE ixCustomer in ('1119743','2918058') 
order by ixCustomer,
dtActiveStartDate
/*          Source                              Cat
Cust	Cat	Code	Description	                Mkt	dtStartDate
1119743	311	31198	SPRINT BULK	                SM	2010-11-01
1119743	332	33230	SPRT12M ReqNoBuys	        SM	2011-11-14
1119743	333	33330	SPRNT12M REQ	            SM	2012-01-30
1119743	339	33906	SR12M 1+ $400+	            SR	2012-04-09
1119743	334	33406	SM12M 1+ $100+	            SM	2012-04-23
1119743	337	33711	R12M 1+ $400+	            R	2012-05-07
1119743	341	34108	12M 1+ $400+	            SR	2012-06-11
1119743	342	34211	12M 1+ $400+	            SR	2012-08-13
1119743	346	34698	BULK DHL	                SM	2012-09-24
1119743	346	34607	12M 1+ $100+	            SM	2012-09-24
1119743	343	34313	12M, 1+, $400+	            SR	2012-10-01
1119743	347	34713	12M, 1+, $400+	            R	2012-10-22
1119743	344	34412	12M, 1+, $400+	            SR	2012-11-05
1119743	357	35715	12M, 1+, $400+	            R	2012-12-17
1119743	362	36207	12M, 1+, $100+	            SM	2013-01-07
1119743	362	36270	12M Requestors	            SM	2013-01-07
1119743	349	34912	12M, 1+, $400+	            SR	2013-01-14
1119743	358	35814	12M, 1+, $400+	            R	2013-02-11
1119743	350	35009	12M, 1+, $400+	            SR	2013-02-25
1119743	359	35911	12M, 1+, $400+	            R	2013-03-25
1119743	351	35111	12M, 1+, $400+	            SR	2013-04-01
1119743	363	36370	12M Requestors	            SM	2013-04-08
1119743	360	36022	24M, 1+, $100	            R	2013-05-20
1119743	353	35322	24M, 1+, $100	            SR	2013-06-17
1119743	364	36409	24M, 1+, $100+	            SM	2013-07-08
1119743	354	35422	24M, 1+, $100	            SR	2013-08-12
1119743	355	35520	24M, 1+, $100	            SR	2013-09-30
1119743	361	36123	24M, 1+, $100	            R	2013-10-21
1119743	356	35620	24M, 1+, $100	            SR	2013-11-04
1119743	377	37726	24M, 1+, $100+	            R	2013-12-23
1119743	383	38309	24M, 1+, $1+	            SM	2013-12-30
1119743	373	37320	24M, 1+, $100+	            SR	2014-01-20
1119743	378	37823	24M, 1+, $100+	            R	2014-02-10
1119743	384	38409	24M, 1+, $1+	            SM	2014-03-10
1119743	375	37531	36M, 1+, $100+	            SR	2014-04-14
1119743	380	38034	36M, 1+, $100+	            R	2014-05-05
1119743	385	38510	36M, 1+, $100+	            SM	2014-06-09
1119743	388	38834	36M, 1+, $100+	            SR	2014-07-07
1119743	389	38961	36M, 1+, $100+ Test Split	SR	2014-08-11
1119743	390	39034	36M, 1+, $100+	            SR	2014-09-22
1119743	382	382340	36M, 1+, $100+ Free Shipping	R	2014-10-20
1119743	391	39134	36M, 1+, $100+	            SR	2014-11-03
1119743	600	60013A	36M 1+ $1+ Control SM	    SM	2015-02-02
1119743	502	50237A	36M 1+ $150+ SR USA Email No Offer	SR	2015-02-09
1119743	403	40335A	36M 1+ $150+ R Control	    R	2015-02-23
1119743	503	50362A	36M 1+ $150+ SR No Offer	SR	2015-03-16
1119743	406	40616B	48M EV42 $4-8.99 TEST	    R	2015-10-26
1119743	407	40704	1&2XBUYERS REV42	        R	2016-02-01
*/

select * from tblMailingOptIn
WHERE ixCustomer in ('1119743','2918058') 
order by ixCustomer, ixMarket

/*          sOptIn
Cust	Mkt	Status	dtLastUpdate
1119743	2B	UK	    2012-09-29
1119743	AD	UK	    2012-09-29
1119743	R	Y	    2016-02-08
1119743	SM	Y	    2016-02-08
1119743	SR	UK	    2012-09-29

2918058	2B	UK	    2016-02-08
2918058	AD	UK	    2016-02-08
2918058	R	Y	    2016-02-08
2918058	SM	UK	    2016-02-08
2918058	SR	UK	    2016-02-08
*/