select top 10 * from tblSKUTransaction

select * from tblBinSku


select D.iYear, D.iMonth
--,ST.ixDate
, COUNT(ST.ixDate|ST.iSeq) SKUTransCount
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where D.iYear >= 2012
group by D.iYear, D.iMonth
order by D.iYear desc, D.iMonth desc
/*
iYear	iMonth	SKUTransCount
2013	3	452135
2013	2	2568978
2013	1	2355209
2012	12	2126118
2012	11	2090278
2012	10	1989013
2012	9	1858587
2012	8	2089072
2012	7	2087557
2012	6	1872275
2012	5	2257650
2012	4	2282346
2012	3	2443497
2012	2	2173815
2012	1	1979667
*/

select D.iYear
--,ST.ixDate
, COUNT(ST.ixDate|ST.iSeq) SKUTransCount
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where D.iYear >= 2012
group by D.iYear
order by D.iYear desc


/* as of 3-21-2016
2016	3,423,431
2015	13,268,257
2014	12,310,204
2013	11,819,472
*/



select * from tblDate

16438	01/01/2013
16072	01/01/2012
15707	01/01/2011
15342	01/01/2010
14977	01/01/2009


select ST.ixDate|ST.iSeq
 from tblSKUTransaction
where ixDate between 16469 and 16496

 
select sMailingStatus, COUNT(*)
from tblCustomer
group by sMailingStatus

select D.dtDate, COUNT(ST.ixDate|ST.iSeq) STCount
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where D.iYear >= 2012
group by D.dtDate
order by D.dtDate desc

16499	34727
16498	348264
16497	69144
16496	74644
16495	80496
16494	76232
16493	77772
16492	34687
16491	30097
16490	62709
16489	55749
16488	98770
16487	78915
16486	74208
16485	30116
16484	32439
16483	60126
16482	67872
16481	77497
16480	79816
16479	73153
16478	26847
16477	27026
16476	54732
16475	62896
16474	66578
16473	70779
16472	61991
16471	25746
16470	926680
16469	80405
16468	52584
16467	61284
16466	68167
16465	60850
16464	24380
16463	24064
16462	47367
16461	52716
16460	54954
16459	58577
16458	55474
16457	20002
16456	21794
16455	44563
16454	51295
16453	56141
16452	62866
16451	53331
16450	19393
16449	20397
16448	40238
16447	50404
16446	58337
16445	74055
16444	68066
16443	24994
16442	24640
16441	49663
16440	64018
16439	934061
16438	56534
16437	33470
16436	20370
16435	23860
16434	45094
16433	53263
16432	44560
16431	9556
16430	21152
16429	14383
16428	19481
16427	37757
16426	47212
16425	55171
16424	64276
16423	60939
16422	22468
16421	23671
16420	46969
16419	54469
16418	60866
16417	68457
16416	53913
16415	23796
16414	25070
16413	50375
16412	53009
16411	56766
16410	62776
.
.
.
.
.
15201	1109
15200	280
15199	239
15198	944
15195	301
15194	301
15193	232
15192	436
15191	327
15189	82
15188	231
15187	539
15186	787
15185	333


select top 50 * from tblSKUTransaction 

-- last two years
select ST.sTransactionType, TT.sDescription, COUNT(*) TransCount
from tblSKUTransaction ST
    left join tblTransactionType TT on ST.sTransactionType = TT.ixTransactionType
where ixDate >= 15766 -- '03/01/2011'
group by sTransactionType, TT.sDescription
order by TransCount desc

select * from tblDate where dtDate = '03/01/2011'

-- EOM dates
select ST.sTransactionType, TT.sDescription, COUNT(*) TransCount
from tblSKUTransaction ST
    left join tblTransactionType TT on ST.sTransactionType = TT.ixTransactionType
where ixDate > 16317
and ixDate NOT in (16347,16378,16408,16439,16470)
group by sTransactionType, TT.sDescription
order by TransCount desc


select ixDate 
from tblDate 
where dtDate = '09/02/12'


