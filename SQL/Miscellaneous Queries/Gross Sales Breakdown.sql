-- Gross Sales Breakdown

/***** GROSS SALES BY YEAR ********/
select D.iYear, SUM(O.mMerchandise) Sales
from tblOrder O
    join tblDate D on O.ixOrderDate = D.ixDate
where sOrderStatus <> 'Cancelled'
group by D.iYear
--having SUM(O.mMerchandise) > 500000
order by D.iYear desc -- SUM(O.mMerchandise) desc

/*              %^ over
YEAR     $M     prev yr
====    =====   =======
2014	102.3    3.5    <-- YTD @12-18-14
2013	 98.5    9.5
2012	 89.9   16.0
2011	 77.5   11.8
2010	 69.3   10.4
2009	 62.8    4.5
2008	 60.1   12.5
2007	 53.4   19.7
2006	 44.6   
*/

select dtOrderDate, SUM(O.mMerchandise) Sales
from tblOrder O
where sOrderStatus <> 'Cancelled'
group by dtOrderDate
having SUM(O.mMerchandise) > 500000
order by dtOrderDate -- SUM(O.mMerchandise) desc

/*
top 10 days ever

2014-12-01 	    716,099
2014-04-28 	    606,565
2014-04-21 	    596,634
2014-04-14 	    596,301
2014-03-24 	    592,803
    2013-03-18 	584,826
2014-04-07 	    584,491
2014-05-27 	    581,584
    2013-04-01 	570,869
    2013-05-28 	569,451
*/

# of days $500K+
================
2014    22+
2013    17
2012    10

select distinct sOrderStatus from tblOrder
