-- Case 24164 - provide new account info to CLC to resolve Duplicate Accounts issue

select count (distinct C.ixCustomer )         -- 3,466    3,457 not deleted   1,835 have shipped/open orders            
    --C.ixSourceCode, SCT.sDescription, count(*) Qty
from tblCustomer C
    join tblOrder O on O.ixCustomer = C.ixCustomer
    left join tblSourceCode SC on SC.ixSourceCode = C.ixSourceCode
    left join tblSourceCodeType SCT on SCT.ixSourceCodeType = SC.sSourceCodeType
where dtAccountCreateDate between '09/29/2014' and '10/08/2014'
and flgDeletedFromSOP = 0
and O.sOrderStatus in ('Open','Shipped')
group by C.ixSourceCode, SCT.sDescription
order by count(*) desc


/*
newly created accounts that came in through
the website over the last 10 days
*/
select count(*) Qty, C.ixSourceCode, SCT.sDescription SCodeType, SC.sDescription
from tblCustomer C
    join tblOrder O on O.ixCustomer = C.ixCustomer
    left join tblSourceCode SC on SC.ixSourceCode = C.ixSourceCode
    left join tblSourceCodeType SCT on SCT.ixSourceCodeType = SC.sSourceCodeType
where dtAccountCreateDate between '09/29/2014' and '10/08/2014'
and flgDeletedFromSOP = 0
and O.sOrderStatus in ('Open','Shipped')
group by C.ixSourceCode, SC.sDescription, SCT.sDescription
order by count(*) desc
/*

WHICH OF THESE "came in through the website"?
I'm guessing all of them that are time "Web House", plus some of the SC's marked "Other" such as EBAY and GOOGLE SEARCH

Qty	ixSourceCode	SCodeType	sDescription
984	2190	Web House	INTERNET-DIRECT
412	EBAY	Other	EBAY
217	BUDY	Other	BUDY'S CATALOG
213	NET	Web House	DirectInternet
32	EC	Other	EXISTING CUST
18	EBAYGS	Catalog House	GARAGE SALE EBAY ORDERS
13	CTR	Other	COUNTER SALES
12	WCR3	Web House	WebCatReqstSTRT
5	GGL	Other	GOOGLE SEARCH
3	37585	Catalog House	Good Guy's List
3	WCR2	Web House	WebCatReqstRACE
2	WCR22	Web House	WebCatReqTBKT
2	31747	Catalog Prospect	DtaLgx2 OfrA
2	37616	Catalog House	12M, 1+, $1+
2	38898	Catalog House	DHL Bulk Center
2	37385	Catalog House	Good Guy's List
2	32310	Catalog House	TBKT12MM 1
2	30325	Catalog Prospect	Hemmings Poly
1	353532	Catalog @ Event	GOODGUYS PPG NATIONALS
1	375022	Catalog @ Event	2014 NSRA ROCKY MOUNTAIN SHOW PUEBLO, CO
1	32614	Catalog House	STRT12MM1
1	37516	Catalog House	24M, 5+, $1000+
1	37539	Catalog House	48M, 1+, $100+
1	39016	Catalog House	12M, 1+, $100+
1	38098	Catalog House	DHL Bulk Center
1	35470	Catalog House	12M REQ.
1	388035	Catalog @ Event	2014 NSRA NORTHEAST BURLINGTON
1	339532	Catalog @ Event	NSRA MID AMERICA 2012 SR
1	37504	Catalog House	12M, 5+, $400+
1	6852	Print Ad	CIRCLE TRACK
1	6783	Print Ad	HOT ROD JULY 2014
1	37882	Catalog Prospect	SCCA List
1	35605	Catalog House	12M, 3+, $1000+
1	6861	Print Ad	CHEVY HIGH PERFROMANCE
1	25955	Catalog @ Event	PARTSPEDLER 08
1	386037	Catalog @ Event	GOODGUYS 2014 LONE STAR NATS FORT WORTH
1	38971	Catalog House	18M Requestors
1	36099	Catalog House	RIP - Bouncebacks
1	37313	Catalog House	12M, 1+, $1+
1	MAIL	Catalog House	MAIL ORDERS
1	38113	Catalog House	12M, 2+, $1+
1	37520	Catalog House	24M, 2+, $400+
1	353549	Catalog @ Event	CRUISIN THE COAST
1	388037	Catalog @ Event	2014 GOODGUYS LONE STAR NATS FORT WORTH
*/
