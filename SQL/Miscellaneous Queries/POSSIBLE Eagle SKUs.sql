-- POSSIBLE Eagle SKUs
/*
as usual... 
Carol was told to import a bunch of SKU data for Eagle SKUs 
but didn't provide her with all the necessary data
such as SOME INDICATOR THAT SHOWS THEY ARE EAGLE SKUS!!!

maybe we can actually ENFORCE some requirements 
and stop letting people cram crap/incomplete/useless data into our DBs?... just a thought
*/

select ixCreator 'Creator', flgDeletedFromSOP 'Del', count(*) 'Qty  '
from tblSKU
where dtCreateDate >= '05/01/2014'
group by ixCreator, flgDeletedFromSOP
order by ixCreator, flgDeletedFromSOP
/*
Del	Creator	Qty
0	AJBIII	674
1	AJBIII	2
0	CAF	    100
0	CGN	    1398
1	CGN	    161
0	DAS	    141
0	DKS1	120
1	DKS1	1
0	DMW	    202
1	DMW	    3
0	GJL	    26
0	JAK	    450
1	JAK	    13
0	JDS	    17
0	JMC1	15648
1	JMC1	1
0	JMM	    6
1	JMM	    2
0	JSD1	26
0	JTM	    1009
1	JTM	    56
0	KDL	    1061
1	KDL	    12
0	MAL2	11
0	NJS	    6086
1	NJS	    14
0	PSG	    1
0	RDW	    43
0	SAL	    2914
0	TKS	    20
0	WAA1	538
*/

-- these brands were ones Mike Long said are sold by/because of EAGLE
-- potential identifier?
select * from tblSKU
where dtCreateDate >= '05/01/2014'
 and ixBrand in ('10494','10763','10922','11182')

select * from tblBrand where ixBrand in ('10494','10763','10922','11182')