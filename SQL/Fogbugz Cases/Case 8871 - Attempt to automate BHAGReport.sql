/*All Channels Combined*/
drop view vwBHAGData

create view vwBHAGData
as

/*****Hard coding benchmark and target data for the BHAG Progress Measurement report*****/
/***Overall data***/
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'62196135' as Sales,
	'199' as AvgOrder,
	'312569' as NumOrders,
	'134550' as NumCustomers,
	'.4027' as PctNewCustomers,
	'2.3231' as AvgOrdersPerYear,
	'462' as AvgYearlySpend
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'67822331' as Sales,
	'200' as AvgOrder,
	'339405' as NumOrders,
	'149059' as NumCustomers,
	'.4031' as PctNewCustomers,
	'2.2770' as AvgOrdersPerYear,
	'455' as AvgYearlySpend
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,
	'84609525' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'156975' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'539' as AvgYearlySpend
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,
	'115539060' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'181380' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'637' as AvgYearlySpend
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'145516770' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'203805' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'714' as AvgYearlySpend
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'178948721' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'226231' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'791' as AvgYearlySpend
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'215833408' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'248656' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'868' as AvgYearlySpend
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'248917500' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'269100' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'925' as AvgYearlySpend
/***Catalog & Web Data***/
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'51811406' as Sales,
	'182' as AvgOrder,
	'284545' as NumOrders,
	'130291' as NumCustomers,
	'.4071' as PctNewCustomers,
	'2.1839' as AvgOrdersPerYear,
	'398' as AvgYearlySpend
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'56844764' as Sales,
	'183' as AvgOrder,
	'310233' as NumOrders,
	'144753' as NumCustomers,
	'.4066' as PctNewCustomers,
	'2.1432' as AvgOrdersPerYear,
	'393' as AvgYearlySpend	
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,	
	'70014714' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'151547' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'462' as AvgYearlySpend
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,	
	'96130708' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'175421' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'548' as AvgYearlySpend
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'121041504' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'197136' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'614' as AvgYearlySpend
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'148819360' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'218852' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'680' as AvgYearlySpend
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'179463728' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'240568' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'746' as AvgYearlySpend
UNION
select
	'20' as SortOrder,
	'Catalog & Web' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'207162690' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'260582' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'795' as AvgYearlySpend
/***Catalog Only***/
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'37114388' as Sales,
	'194' as AvgOrder,
	'191416' as NumOrders,
	'88793' as NumCustomers,
	'.3089' as PctNewCustomers,
	'2.1558' as AvgOrdersPerYear,
	'418' as AvgYearlySpend
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'38779491' as Sales,
	'198' as AvgOrder,
	'195878' as NumOrders,
	'91605' as NumCustomers,
	'.2872' as PctNewCustomers,
	'2.1383' as AvgOrdersPerYear,
	'423' as AvgYearlySpend	
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,	
	'50552896' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'103592' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'488' as AvgYearlySpend
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,	
	'69555324' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'121388' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'573' as AvgYearlySpend
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'87568241' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'136187' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'643' as AvgYearlySpend
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'107653018' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'150986' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'713' as AvgYearlySpend
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'129643870' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'165785' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'782' as AvgYearlySpend
UNION
select
	'30' as SortOrder,
	'Catalog Only' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'148461896' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'177586' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'836' as AvgYearlySpend
/***Web Only***/
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'14697018' as Sales,
	'158' as AvgOrder,
	'93129' as NumOrders,
	'52516' as NumCustomers,
	'.4876' as PctNewCustomers,
	'1.7733' as AvgOrdersPerYear,
	'280' as AvgYearlySpend
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'18077773' as Sales,
	'158' as AvgOrder,
	'114366' as NumOrders,
	'64939' as NumCustomers,
	'.5012' as PctNewCustomers,
	'1.7611' as AvgOrdersPerYear,
	'278' as AvgYearlySpend	
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,	
	'20034963' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'61269' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'327' as AvgYearlySpend
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,	
	'26605040' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'69104' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'385' as AvgYearlySpend
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'33634224' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'77857' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'432' as AvgYearlySpend
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'41486190' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'86610' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'479' as AvgYearlySpend
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'50065575' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'95363' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'525' as AvgYearlySpend
UNION
select
	'40' as SortOrder,
	'Web Only' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'58817920' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'105032' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'560' as AvgYearlySpend
/***Counter***/
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'1582339' as Sales,
	'131' as AvgOrder,
	'12118' as NumOrders,
	'4830' as NumCustomers,
	'.2381' as PctNewCustomers,
	'2.5089' as AvgOrdersPerYear,
	'328' as AvgYearlySpend
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'1683095' as Sales,
	'132' as AvgOrder,
	'12785' as NumOrders,
	'4970' as NumCustomers,
	'.2481' as PctNewCustomers,
	'2.5724' as AvgOrdersPerYear,
	'339' as AvgYearlySpend	
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,	
	'2152570' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'5635' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'382' as AvgYearlySpend
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,	
	'2959488' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'6606' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'448' as AvgYearlySpend
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'3720322' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'7411' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'502' as AvgYearlySpend
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'4576312' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'8216' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'557' as AvgYearlySpend
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'5511831' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'9021' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'611' as AvgYearlySpend
UNION
select
	'50' as SortOrder,
	'Counter' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'6327300' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'9660' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'655' as AvgYearlySpend
/***Wholesale Overall***/
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'8892688' as Sales,
	'559' as AvgOrder,
	'15918' as NumOrders,
	'793' as NumCustomers,
	'.0404' as PctNewCustomers,
	'20.0731' as AvgOrdersPerYear,
	'11214' as AvgYearlySpend
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'9316571' as Sales,
	'569' as AvgOrder,
	'16374' as NumOrders,
	'800' as NumCustomers,
	'.0463' as PctNewCustomers,
	'20.4675' as AvgOrdersPerYear,
	'11646' as AvgYearlySpend	
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,	
	'12101775' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'925' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'13083' as AvgYearlySpend
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,	
	'16673679' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'1089' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'15311' as AvgYearlySpend
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'20976780' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'1221' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'17180' as AvgYearlySpend
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'25773297' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'1353' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'19049' as AvgYearlySpend
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'31063230' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'1485' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'20918' as AvgYearlySpend
UNION
select
	'60' as SortOrder,
	'Wholesale' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'35570808' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'1586' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'22428' as AvgYearlySpend
/***Wholesale MRR Only***/
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'3023276' as Sales,
	'461' as AvgOrder,
	'6559' as NumOrders,
	'457' as NumCustomers,
	'.0460' as PctNewCustomers,
	'14.3523' as AvgOrdersPerYear,
	'6615' as AvgYearlySpend
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'3046669' as Sales,
	'492' as AvgOrder,
	'6187' as NumOrders,
	'458' as NumCustomers,
	'.0284' as PctNewCustomers,
	'13.5087' as AvgOrdersPerYear,
	'6652' as AvgYearlySpend
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,	
	'4113694' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'533' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'7718' as AvgYearlySpend
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,	
	'5706636' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'628' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'9087' as AvgYearlySpend
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'7173760' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'704' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'10190' as AvgYearlySpend
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'8807760' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'780' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'11292' as AvgYearlySpend
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'10622515' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'857' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'12395' as AvgYearlySpend
UNION
select
	'70' as SortOrder,
	'Wholesale MRR Only' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'12093134' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'914' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'13231' as AvgYearlySpend
/***Wholesale PRS Only***/
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2009' as Year,
	'5869412' as Sales,
	'627' as AvgOrder,
	'9359' as NumOrders,
	'336' as NumCustomers,
	'.0327' as PctNewCustomers,
	'27.8542' as AvgOrdersPerYear,
	'17468' as AvgYearlySpend
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Benchmark' as Type,
	'2010' as Year,
	'6269902' as Sales,
	'615' as AvgOrder,
	'10187' as NumOrders,
	'342' as NumCustomers,
	'.0702' as PctNewCustomers,
	'29.7865' as AvgOrdersPerYear,
	'18333' as AvgYearlySpend
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Target' as Type,
	'2010' as Year,	
	'7988960' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'392' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'20380' as AvgYearlySpend
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Target' as Type,
	'2011' as Year,	
	'10973183' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'461' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'23803' as AvgYearlySpend
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Target' as Type,
	'2012' as Year,	
	'13811655' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'517' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'26715' as AvgYearlySpend
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Target' as Type,
	'2013' as Year,	
	'16975698' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'573' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'29626' as AvgYearlySpend
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Target' as Type,
	'2014' as Year,	
	'20466402' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'629' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'32538' as AvgYearlySpend
UNION
select
	'80' as SortOrder,
	'Wholesale PRS Only' as OrderChannel,
	'Annual Target' as Type,
	'2015' as Year,	
	'23477664' as Sales,
	NULL as AvgOrder,
	NULL as NumOrders,
	'672' as NumCustomers,
	NULL as PctNewCustomers,
	NULL as AvgOrdersPerYear,
	'34937' as AvgYearlySpend



	

select * from vwBHAGData


select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Year-To-Date Progress' as Type,
	'Current YTD' as Year,
    sum(O.mMerchandise) as Sales,
	avg(O.mMerchandise) as AvgOrder,
    count(distinct(SUBSTRING(O.ixOrder, 1, 7))) as NumOrders,
    count(distinct(O.ixCustomer)) as NumCustomers,
	cast(count(distinct(vwNewCustOrder.ixOrder)) as decimal(6)) / cast(count(distinct(O.ixCustomer)) as decimal(6))  as PctNewCustomers,
	cast(count(distinct(SUBSTRING(O.ixOrder, 1, 7))) as decimal(6))/cast(count(distinct(O.ixCustomer)) as decimal(6)) as AvgOrdersPerYear,
	cast(round((cast(count(distinct(SUBSTRING(O.ixOrder, 1, 7)))as decimal(6))/cast(count(distinct(O.ixCustomer)) as decimal(6)))*cast(avg(O.mMerchandise) as decimal(6)),0) as int) as AvgYearlySpend
from
	tblOrder O
    left join vwNewCustOrder on O.ixOrder = vwNewCustOrder.ixOrder
where
   /*YTD Buyers*/
    (O.dtOrderDate >= '01/01/11' and O.dtOrderDate <= '06/30/11')
	and 
	O.sOrderStatus = 'Shipped'
    and
    O.sOrderChannel <> 'INTERNAL' and O.sOrderType <> 'Internal'
    and
    O.mMerchandise > 1
UNION
select
	'10' as SortOrder,
	'Overall' as OrderChannel,
	'Year-To-Date Progress' as Type,
	'Current Rolling 12 Months' as Year,
    sum(O.mMerchandise) as Sales,
	avg(O.mMerchandise) as AvgOrder,
    count(distinct(SUBSTRING(O.ixOrder, 1, 7))) as NumOrders,
    count(distinct(O.ixCustomer)) as NumCustomers,
	cast(count(distinct(vwNewCustOrder.ixOrder)) as decimal(6)) / cast(count(distinct(O.ixCustomer)) as decimal(6))  as PctNewCustomers,
	cast(count(distinct(SUBSTRING(O.ixOrder, 1, 7))) as decimal(6))/cast(count(distinct(O.ixCustomer)) as decimal(6)) as AvgOrdersPerYear,
	cast(round((cast(count(distinct(SUBSTRING(O.ixOrder, 1, 7)))as decimal(6))/cast(count(distinct(O.ixCustomer)) as decimal(6)))*cast(avg(O.mMerchandise) as decimal(6)),0) as int) as AvgYearlySpend
from
	tblOrder O
    left join vwNewCustOrder on O.ixOrder = vwNewCustOrder.ixOrder
where
    /*YTD 12mo Buyers*/
	(O.dtOrderDate >=(dateadd(month,-12,'06/30/11')) and O.dtOrderDate <= '06/30/11')
	and 
	O.sOrderStatus = 'Shipped'
    and
    O.sOrderChannel <> 'INTERNAL' and O.sOrderType <> 'Internal'
    and
    O.mMerchandise > 1


