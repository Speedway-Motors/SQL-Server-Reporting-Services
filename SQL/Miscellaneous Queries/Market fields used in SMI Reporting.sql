select * from tblMarket
/*
Mkt	sDescription
--  ------------
2B	TBucket             *
B	BothRaceStreet      *
G	Generic             *
LM	Latemodel
LS	Leadsled
M	Modified
MD	MrRoadsterDealer
NA	NotApplicable
PC	PedalCar            *
PD	PedalcarDealer
R	Race                *
RD	PRS Dealer
SC	SportCompact        *
SE	SafetyEquip
SM	SprintMidget        *
SR	StreetRod           *
SS	StreetStock
TE	Tools&Equip         *
UK	Unknown             *
*/


SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) like '%MARKET%' )
ORDER BY name
-- tables with market fields
/*
tblCatalogMaster
tblCatalogRequest
tblCustomer
tblInsert       -- field, but table is empty
tblMarket
tblPGC
tblSourceCode
*/




select ixMarket, count(*) QTY
from tblPGC
group by ixMarket
/*
Mkt	QTY
NULL 5
2B	19
B	73
PC	21
R	79
SC	20
SM	21
SR	67
TE	 7
UK	 1
*/

select sMarket, count(*) QTY
from tblCatalogMaster
group by sMarket
/*
Mkt	QTY
--- ---
NULL 23
2B	5
G	27
PC	9
R	96
SC	1
SM	21
SR	95
*/

select sCustomerMarket, count(*) QTY
from tblCustomer
group by sCustomerMarket
order by sCustomerMarket
/*
Mkt	QTY
--- ---
NULL 265807
-14344	1
AD	7538
AR	2173
B	196759
C	10470
D	959
P	25640
R	266144
S	415936
T	25807
TB	16831
*/
select ixOriginalMarket, count(*) QTY
from tblCustomer
group by ixOriginalMarket
order by ixOriginalMarket
/*
Mkt	QTY
--- ---
NULL 307366
-1434	1
2B	16658
AD	7480
AR	2143
B	180076
C	9656
D	947
Other	10
P	24535
R	254811
SR	405407
T	24975
*/

select sCatalogMarket, count(*) QTY
from tblSourceCode
group by sCatalogMarket
order by sCatalogMarket
/*
sCatalogMarket	QTY
2B	148
G	234
PC	132
R	1645
SC	51
SM	551
SR	2307
unknown	1172
*/


select top 10 * from tblPGC            
select top 10 * from tblCatalogMaster   
select top 10 * from tblCustomer
select top 10 * from tblMarket
select top 10 * from tblSourceCode
