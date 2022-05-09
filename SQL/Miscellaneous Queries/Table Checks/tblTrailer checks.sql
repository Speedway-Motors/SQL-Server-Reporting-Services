-- tblTrailer checks
/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblTrailer%'
--  ixErrorCode	sDescription
--      n/a Manually updated table

-- ERROR COUNTS by Day
    SELECT --dtDate, 
        DB_NAME() AS 'DB          '
        ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1149'
  --    and dtDate >=  DATEADD(month, -12, getdate())  -- past X months '05/06/2014'
    GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc

/*
DB          	Date    	ErrorQty

--      n/a Manually updated table

*/

/************************************************************************/
-- TABLE GROWTH
exec spGetTableGrowth tblTrailer
/*
DB          	TABLE       	Rows   	Date
SMI Reporting	tblTrailer	31	03-01-16

SMI Reporting	tblTrailer	30	01-01-16
SMI Reporting	tblTrailer	29	01-01-15
SMI Reporting	tblTrailer	27	01-01-14
SMI Reporting	tblTrailer	25	01-01-13
SMI Reporting	tblTrailer	24	03-01-12

AFCOReporting	should contain exact same data as SMI Reporting's tblTrailer
*/

-- tblTrailer DIF SMI Reporting vs AFCOReporting
select S.*,A.*
from [SMI Reporting].dbo.tblTrailer as S 
full outer join [AFCOReporting].dbo.tblTrailer as A
    on S.ixTrailer = A.ixTrailer
where S.sDescription <> A.sDescription
    or S.sOrigin <> A.sOrigin
    or S.ixCarrier <> A.ixCarrier
    or S.sTrailerStatus <> A.sTrailerStatus
    or S.ixTrailer is NULL
    or A.ixTrailer is NULL

-- update AFCOReporting with data from SMI Reporting
BEGIN TRAN
    -- update DW-STAGING1 ONLY!!!!
    INSERT INTO [AFCOReporting].dbo.tblTrailer
        Select ixTrailer,	sDescription,	sOrigin,	ixCarrier,	sTrailerStatus, NULL
        from tblTrailer
        where ixTrailer = 'ORL'
        --ixTrailer not in (select ixTrailer from [AFCOReporting].dbo.tblTrailer)
ROLLBACK TRAN

