/***** Missing SKU Transaction Records ************/

-- SOP SMI  stores last  90 days of SKU Transactions
-- SMI Reprting ~40 mins to refeed 30 days (Aprx 1,030 rec/sec)

-- SOP AFCO stores last 120 days of SKU Transactions
-- AFCOReprting ~6 mins to refeed 30 days (Aprx 1,030 rec/sec)

    /***********    DB counts vs SOP counts   **************/
        SELECT substring(DB_NAME(),1,4) AS 'DB    '
            , FORMAT(count(ST.iSeq),'###,##0') 'SKUTransActualCount'   
        FROM tblSKUTransaction ST
            join tblDate D on ST.ixDate = D.ixDate
        WHERE D.dtDate between '09/23/21' and '##/##/21' --   958,377 SMI  good thru 9/22/21  
    --WHERE D.dtDate between '09/16/20' and '##/##/20'   --  125,319 AFCO  good thru 9/22/21
    

        -- IF TOTALS DO NOT MATCH
        /***********    Find Date(s) with missing SKU Transactions  **************/
        SELECT substring(DB_NAME(),1,4) AS 'DB    '
            , CONVERT(VARCHAR, D.dtDate, 102)  AS 'Date'
            , D.sDayOfWeek3Char 'Day'   
            , count(ST.iSeq) 'SKUTransActualCount'
            , (MAX(ST.iSeq)+1) 'SKUTransExpextedCount'
        FROM tblSKUTransaction ST
            join tblDate D on ST.ixDate = D.ixDate
        WHERE D.dtDate between '03/09/20' and '##/##/20'  -- 212,031
        GROUP BY D.dtDate, D.sDayOfWeek3Char-- 224,878 AFCO
        ORDER BY D.dtDate

/*********************************************************************************

 ***********   SKU Transaction Counts Last Verified Date Ranges    ***************
 ********************************************************************************
DB      Date Range              DW          SOP         DELTA87ui1yut7r675
==      ====================    ========    ========    ======
SMI     01/01/14 to 05/17/21    ?           ?           0      <-- 100% match    no CHECKS FOR 06/18/18 to 07/13/18
AFCO    01/01/14 to 05/17/21    ?           ?           0      <-- 100% match    no CHECKS FOR 06/18/18 to 07/13/18       

SMI  takes about 1.5 mins/day to refeed
AFCO takes about  6 mins to refeed 30 days          Aprx 1,030 rec/sec
********************************************************************************/

--      ONLY valid check when the feeds start back up after
--      interruption on the SAME DAY
select DB_NAME() AS 'DB          '
    ,D.ixDate--,D.dtDate
    , substring(D.sDayOfWeek,1,3) as 'Day'
    , CONVERT(VARCHAR, D.dtDate, 10) AS 'Date'	--	11/19/2013
    , count(ST.iSeq) TransCount
    , max(ST.iSeq)+1 MaxSeq -- Sequence starts with #0 each day!
    , ((max(ST.iSeq)+1) - count(ST.iSeq)) as 'Missing'
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where dtDate >= '04/13/2022' --DATEADD(dd,-7,DATEDIFF(dd,0,getdate())) -- X days ago
group by D.dtDate, D.ixDate, substring(D.sDayOfWeek,1,3)
having count(ST.iSeq) <> max(ST.iSeq)+1 
order by D.ixDate

select * from tblSKUTransaction where ixDate = 19407
order by iSeq



    /*** WHERE DID FEEDS GET INTERRUPTED **************/
    select RN.RowNumber, RN.iSeq, T.chTime, ABS(RN.RowNumber-RN.iSeq) as Delta
    FROM(
        SELECT ROW_NUMBER() OVER(ORDER BY iSeq) AS "RowNumber", iSeq, ixDate, ixTime
        from tblSKUTransaction
        where ixDate = 19827
        ) RN
        LEFT JOIN tblTime T ON RN.ixTime = T.ixTime
    WHERE ABS(RN.RowNumber-RN.iSeq) > 1  -- 9:15-11:58
    ORDER BY T.chTime
    /*
    RowNumber	iSeq	chTime	Delta
    7675	    7676	10:34:03  	1

select * from tblSKUTransaction where ixDate = 19827 order by iSeq

    
    7676	    7679	10:34:45  	3
    */  

    select * from tblSKUTransaction where ixDate = 18911 order by iSeq


select ixVerificationDate, COUNT(*) 
from tblPackage where ixVerificationDate between 17993 and 179934 -- 4031
group by ixVerificationDate
/*
ixVerification
Date	QTY
17993	3257
17994	775
*/

select DB_NAME() AS 'DB          '
    ,ST.ixDate
    , substring(D.sDayOfWeek,1,3) as 'Day'
    , CONVERT(VARCHAR, D.dtDate, 10) AS 'Date    '	--	11/19/2013
    , ST.iSeq, ST.ixTime, T.chTime
from tblSKUTransaction ST
    join tblTime T on ST.ixTime = T.ixTime
    join tblDate D on ST.ixDate = D.ixDate
where ST.ixDate = 17205
   -- AND ST.iSeq in (49746,50021) -- last record fed b4 feeds stopped & first rec to feed when feeds started again
order by ST.iSeq
/*
DB          	ixDate	Day	Date    	iSeq	ixTime	chTime
AFCOReporting	16857	MON	02-24-14	8371	53488	14:51:28  
AFCOReporting	16857	MON	02-24-14	8996	54887	15:14:47  
SMI Reporting	16858	TUE	02-25-14	49746	64883	18:01:23  
SMI Reporting	16858	TUE	02-25-14	50021	65274	18:07:54  

 
*/


-- CHECK by day based on max transaction ID vs Record count
SELECT ixDate, 
    FORMAT(count(1),'###,###') 'Records', 
    FORMAT(max(iSeq)+1,'###,###') 'MaxSeq+1', 'SMI' 'Where',
    (count(1)-(max(iSeq)+1)) 'MissingTrans'
from tblSKUTransaction
where ixDate >= 19572--	08/01/2021                   MON 03/08/2021 new change went live
group by ixDate
order by(count(1)-(max(iSeq)+1)) desc, ixDate -- most missing records, then ixDate
/*
ixDate	Records	MaxSeq+1	Where	MissingTrans
19469	18,417	18,417	    SMI	    0           --04/20/2021     AS OF 3:30PM 5/1/21
*/