-- Case 16140 add Factory Ship Division to Daily Orders Taken Report
-- SCRATCH WORK


-- LY corresponding date
select DATEADD(week, -52, '12/02/2012')     -- 12-4-2012



select top 10 * from vwDailyOrdersTakenDropship



select iPeriodYear,
    SUM(DropshipDailyNumOrds) DSOrdCount,
    SUM(DropshipDailySales)  DSSales
from vwDailyOrdersTakenDropship
where iPeriodYear >= 2010
group by iPeriodYear
/*
-- view results when it was INCLUDING AFCO SKUs
iPeriodYear	DSOrdCount	DSSales
2010	    2,541	    368,142
2011	    4,386	    643,483
2012	    6,522	    951,489

-- view results now that it is EXCLUDING AFCO SKUs
iPeriodYear	DSOrdCount	DSSales
2010	    765	        201,493
2011	    662	        195,546
2012	    510	        168,353

-- view EXCLUDING AFCO SKUs AND the AFCO parts that are discontinued now show one of the AFCO accounts as the vendor instead of 9999
iPeriodYear	DSOrdCount	DSSales
2010	    396	        105,819
2011	    325	         92,141
2012	    402	        151,621

*/

select iPeriod,
    SUM(DropshipDailyNumOrds) DSOrdCount,
    SUM(DropshipDailySales)  DSSales
from vwDailyOrdersTakenDropship
where iPeriodYear = 2011
group by iPeriod
order by iPeriod
    
select iPeriodYear,
    SUM(DropshipDailyNumOrds) DSOrdCount,
    SUM(DropshipDailySales)  DSSales
from vwDailyOrdersTakenDropship
where iPeriodYear = 2011
group by iPeriodYear
order by iPeriodYear
/*
DSOrdCount	DSSales
662	        195,546.15
*/
    
select iPeriodYear,
    SUM(DailyNumOrds) OrdCount,
    SUM(DailySales)  Sales
from vwDailyOrdersTaken
where iPeriodYear = 2011
  and dtDate <= '12/04/2011'
group by iPeriodYear
/*
iPeriodYear		Sales
to 12-2-11	    70,444,108
to 12-2-12      81,975,130
*/

select top 10 * from  vwDailyOrdersTaken         