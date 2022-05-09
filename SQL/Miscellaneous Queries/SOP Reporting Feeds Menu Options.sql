-- SOP Reporting Feeds Menu Options

-- Tables needing feed options:

-- tblTimeClock... should trigger updates to tblTimeClockDetail as well
    select COUNT(*) from tblTimeClock -- 211,220
    
    select REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', ''), DaysOld  
    from vwDataFreshness where sTableName = 'tblTimeClock'
    /*
    Records	DaysOld

    */
    select ixEmployee, COUNT(*) -- usually less than 1000 records per employee... data goes back to 2002!?!
    from tblTimeClock
    group by ixEmployee
    order by COUNT(*) desc

    select ixDate, COUNT(*) -- averages about 200 records/weekday
    from tblTimeClock
    where ixDate >= 16803
    group by ixDate
    order by COUNT(*) desc


-- tblJobClock
    select COUNT(*) from tblJobClock -- 671,144
    
    select REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', ''), DaysOld  
    from vwDataFreshness where sTableName = 'tblJobClock'
    /*
    Records	DaysOld
      1,382	   <=1
      3,459	   2-7
     14,076	  8-30
    118,528	 31-180
     14,749	181 +
    518,950	UK
    */        
    
    select sJob, COUNT(*) -- too many records per sJob value... up to 57K!
    from tblJobClock
    group by sJob
    order by COUNT(*) desc

    select ixEmployee, COUNT(*) -- avgs 1K-10K records per employe... data goes back to 2002!?!
    from tblJobClock
    group by ixEmployee
    order by COUNT(*) desc

    select ixDate, COUNT(*) -- averages about 800 records/weekday
    from tblJobClock
    where ixDate >= 16803
    group by ixDate
    order by COUNT(*) desc
