-- Case 19013 - lag in SOP Customer Offer load time

select count(*) from tblCustomerOffer -- 17,115,584 @06/18/2013


select count(*) 
from tblCustomerOffer 
where CO.ixCreateDate < 13516




-- Customer Offers by Year
select (Case when CO.ixCreateDate between 13516 and 13880 then '2005'
             when CO.ixCreateDate between 13881 and 14245 then '2006'
             when CO.ixCreateDate between 14246 and 14610 then '2007'
             when CO.ixCreateDate between 14611 and 14976 then '2008'
             when CO.ixCreateDate between 14977 and 15341 then '2009'
             when CO.ixCreateDate between 15342 and 15706 then '2010'
             when CO.ixCreateDate between 15707 and 16071 then '2011'
             when CO.ixCreateDate between 16072 and 16437 then '2012'
             when CO.ixCreateDate > 16438 then '2013'
             else '<2005'
         End) Yr,
         -- CO.ixSourceCode, 
         count(*) OfferCount
from tblCustomerOffer CO
    left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
--where SC.ixSourceCode is NULL    
group by (Case when CO.ixCreateDate between 13516 and 13880 then '2005'
             when CO.ixCreateDate between 13881 and 14245 then '2006'
             when CO.ixCreateDate between 14246 and 14610 then '2007'
             when CO.ixCreateDate between 14611 and 14976 then '2008'
             when CO.ixCreateDate between 14977 and 15341 then '2009'
             when CO.ixCreateDate between 15342 and 15706 then '2010'
             when CO.ixCreateDate between 15707 and 16071 then '2011'
             when CO.ixCreateDate between 16072 and 16437 then '2012'
             when CO.ixCreateDate > 16438 then '2013'
             else '<2005'
         End)
           --   CO.ixSourceCode
order by Yr desc -- OfferCount desc --Yr
/*
Year	OfferCount
2013	1,924,033
2012	3,471,672
2011	2,150,171
2010	2,532,131
2009	2,749,233
2008	2,557,968
2007	1,155,665
2006	  406,962
2005	  167,501
<2005	      248
*/



-- Customer Offers by Year
-- where SC NOT in tblSourceCode
select (Case when CO.ixCreateDate between 14611 and 14976 then '2008'
             when CO.ixCreateDate between 14977 and 15341 then '2009'
             when CO.ixCreateDate between 15342 and 15706 then '2010'
             when CO.ixCreateDate between 15707 and 16071 then '2011'
             when CO.ixCreateDate between 16072 and 16437 then '2012'
             when CO.ixCreateDate > 16438 then '2013'
             else '<2008'
         End) Yr,
         CO.ixSourceCode, 
         count(*) OfferCount
from tblCustomerOffer CO
    left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.ixSourceCode is NULL    
group by (Case when CO.ixCreateDate between 14611 and 14976 then '2008'
             when CO.ixCreateDate between 14977 and 15341 then '2009'
             when CO.ixCreateDate between 15342 and 15706 then '2010'
             when CO.ixCreateDate between 15707 and 16071 then '2011'
             when CO.ixCreateDate between 16072 and 16437 then '2012'
             when CO.ixCreateDate > 16438 then '2013'
             else '<2008'
         End),
             CO.ixSourceCode
order by Yr desc -- OfferCount desc 
/*
2013	36571575273	1
2013	352850	8664
2012	33298	347
2012	4007	6250
2012	4012	1053
2012	4024	1066
2012	4025	2273
2012	4032	1719
2012	4037	1657
2012	4038	397
2012	4041	439
2012	32098	1787
2012	4013	1023
2012	4020	832
2012	4026	710
2012	4027	699
2012	4031	723
2012	4036	5714
2012	4010	1839
2012	4030	2887
2012	4035	2471
2012	4042	2017
2012	4009	11019
2012	4028	2795
2012	4029	6654
2012	4033	655
2012	4034	580
2012	4039	1111
2012	4040	486
2012	4043	4314
2012	LASER	1
2010	1963.5	1
2010	209i	3
2010	240Q	5
2010	BD01I	2
2010	BDO6	1
2010	ML88B	2
2010	NULL	4
2010	1963.4	1
2010	1963.9	3
2010	213 Q	1
2010	219Q	15
2010	230Q	4
2010	233Q	2
2010	242I	1
2010	243I	11
2010	BD03	4
2010	ML89I	4
2010	REPLACETHIS	73534
2010	TC01Q	1
2010	1963.2	2
2010	220Q	1
2010	231Q	3
2010	232Q	16
2010	241Q	4
2010	99RAC	1
2010	ML90B	6
2010	ML90I	1
2010	Q212	1
2010	RENTAL	5
2010	1533	3
2010	1963.6	2
2010	221Q	14
2010	242Q	5
2010	243Q	13
2010	246I	2
2010	24Q	1
2010	BD06Q	1
2010	TC01I	1
2009	REPLACETHIS	196153
2008	REPLACETHIS	96753
*/





select max(ixCustomer) from tblCustomerOffer
where ixSourceCode = 'REPLACETHIS'

select * from tblCustomerOffer
where ixCustomer = '1999917' 

SELECT

select * from tblCustomerOffer -- 7,560
where ixSourceCode = 'REPLACETHIS'
             
select * from tblDate where dtDate = '01/01/2005'

select count(*) from tblOrder where dtOrderDate < '01/01/2006'

select ixSourceCode, count(*)
from tblCustomerOffer
group by ixSourceCode
order by count(*) desc




select count(distinct ixSourceCode) from tblCustomerOffer -- 2,970