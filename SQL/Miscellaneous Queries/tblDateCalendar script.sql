SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET ARITHABORT OFF
SET ARITHIGNORE ON
SET TEXTSIZE 2147483647


DECLARE @Date_Start AS DATETIME
DECLARE @Date_End AS DATETIME


SET @Date_Start = '19781213'
SET @Date_End = '20301231'


----------------------------------------------------------------------------------------------------------------------
--	Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable
----------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID (N'dbo.tblDate_Calendar', N'U') IS NOT NULL
BEGIN

	DROP TABLE dbo.tblDate_Calendar

END


----------------------------------------------------------------------------------------------------------------------
--	Permanent Table: Create Date Xref Table
----------------------------------------------------------------------------------------------------------------------

CREATE TABLE dbo.tblDate_Calendar

	(   ixDate SMALLINT
		,calendar_date DATETIME NOT NULL CONSTRAINT PK_tblDate_Calendar_calendar_date PRIMARY KEY CLUSTERED
		,calendar_year SMALLINT
		,calendar_month TINYINT
		,calendar_day TINYINT
		,calendar_quarter TINYINT
		,first_day_in_week DATETIME
		,last_day_in_week DATETIME
		,is_week_in_same_month INT
		,first_day_in_month DATETIME
		,last_day_in_month DATETIME
		,is_last_day_in_month INT
		,first_day_in_quarter DATETIME
		,last_day_in_quarter DATETIME
		,is_last_day_in_quarter INT
		--,day_of_week TINYINT
		,week_of_month TINYINT
		,week_of_quarter TINYINT
		,week_of_year TINYINT
		,days_in_month TINYINT
		,month_days_remaining TINYINT
		,weekdays_in_month TINYINT
		,month_weekdays_remaining TINYINT
		,month_weekdays_completed TINYINT
		,days_in_quarter TINYINT
		,quarter_days_remaining TINYINT
		,quarter_days_completed TINYINT
		,weekdays_in_quarter TINYINT
		,quarter_weekdays_remaining TINYINT
		,quarter_weekdays_completed TINYINT
		,day_of_year SMALLINT
		,year_days_remaining SMALLINT
		,is_weekday INT
		,is_leap_year INT
		,day_name VARCHAR (10)
		,month_day_name_instance TINYINT
		,quarter_day_name_instance TINYINT
		,year_day_name_instance TINYINT
		,month_name VARCHAR (10)
		,year_week CHAR (6)
		,year_month CHAR (6)
		,year_quarter CHAR (6)
	);


----------------------------------------------------------------------------------------------------------------------
--	Table Insert: Populate Base Date Values Into Permanent Table Using Common Table Expression (CTE)
----------------------------------------------------------------------------------------------------------------------

WITH cte_date_base_table AS

	(
		SELECT
			@Date_Start AS calendar_date

		UNION ALL

		SELECT
			DATEADD (DAY, 1, CTE.calendar_date)
		FROM
			cte_date_base_table CTE
		WHERE
			DATEADD (DAY, 1, CTE.calendar_date) <= @Date_End
	)

INSERT INTO dbo.tblDate_Calendar

	(
		calendar_date
	)

SELECT
	CTE.calendar_date
FROM
	cte_date_base_table CTE
OPTION
	(MAXRECURSION 0)


----------------------------------------------------------------------------------------------------------------------
--	Table Update I: Populate Additional Date Xref Table Fields (Pass I)
----------------------------------------------------------------------------------------------------------------------

UPDATE
	dbo.tblDate_Calendar
SET
	 calendar_year = DATEPART (YEAR, calendar_date)
	,calendar_month = DATEPART (MONTH, calendar_date)
	,calendar_day = DATEPART (DAY, calendar_date)
	,calendar_quarter = DATEPART (QUARTER, calendar_date)
	,first_day_in_week = DATEADD (DAY, -DATEPART (WEEKDAY, calendar_date) + 1, calendar_date)
	,first_day_in_month = CONVERT (VARCHAR (6), calendar_date, 112) + '01'
	--,day_of_week = DATEPART (WEEKDAY, calendar_date)
	,week_of_year = DATEPART (WEEK, calendar_date)
	,day_of_year = DATEPART (DAYOFYEAR, calendar_date)
	,is_weekday = ISNULL ((CASE
								WHEN ((@@DATEFIRST - 1) + (DATEPART (WEEKDAY, calendar_date) - 1)) % 7 NOT IN (5, 6) THEN 1
								END), 0)
	,day_name = DATENAME (WEEKDAY, calendar_date)
	,month_name = DATENAME (MONTH, calendar_date)


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN calendar_year INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN calendar_month INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN calendar_day INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN calendar_quarter INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN first_day_in_week DATETIME NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN first_day_in_month DATETIME NOT NULL


--ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN day_of_week INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN week_of_year INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN day_of_year INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN is_weekday INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN day_name VARCHAR (10) NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN month_name VARCHAR (10) NOT NULL


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_calendar_year ON dbo.tblDate_Calendar (calendar_year)


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_calendar_month ON dbo.tblDate_Calendar (calendar_month)


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_calendar_quarter ON dbo.tblDate_Calendar (calendar_quarter)


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_first_day_in_week ON dbo.tblDate_Calendar (first_day_in_week)


--CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_day_of_week ON dbo.tblDate_Calendar (day_of_week)


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_is_weekday ON dbo.tblDate_Calendar (is_weekday)


----------------------------------------------------------------------------------------------------------------------
--	Table Update II: Populate Additional Date Xref Table Fields (Pass II)
----------------------------------------------------------------------------------------------------------------------

UPDATE
	dbo.tblDate_Calendar
SET
	 last_day_in_week = first_day_in_week + 6
	,last_day_in_month = DATEADD (MONTH, 1, first_day_in_month) - 1
	,first_day_in_quarter = A.first_day_in_quarter
	,last_day_in_quarter = A.last_day_in_quarter
	,week_of_month = DATEDIFF (WEEK, first_day_in_month, calendar_date) + 1
	,week_of_quarter = (week_of_year - A.min_week_of_year_in_quarter) + 1
	,is_leap_year = ISNULL ((CASE
								WHEN calendar_year % 400 = 0 THEN 1
								WHEN calendar_year % 100 = 0 THEN 0
								WHEN calendar_year % 4 = 0 THEN 1
								END),0)
	,year_week = CONVERT (VARCHAR (4), calendar_year) + RIGHT ('0' + CONVERT (VARCHAR (2), week_of_year), 2)
	,year_month = CONVERT (VARCHAR (4), calendar_year) + RIGHT ('0' + CONVERT (VARCHAR (2), calendar_month), 2)
	,year_quarter = CONVERT (VARCHAR (4), calendar_year) + 'Q' + CONVERT (VARCHAR (1), calendar_quarter)
FROM

	(
		SELECT
			 X.calendar_year AS subquery_calendar_year
			,X.calendar_quarter AS subquery_calendar_quarter
			,MIN (X.calendar_date) AS first_day_in_quarter
			,MAX (X.calendar_date) AS last_day_in_quarter
			,MIN (X.week_of_year) AS min_week_of_year_in_quarter
		FROM
			dbo.tblDate_Calendar X
		GROUP BY
			 X.calendar_year
			,X.calendar_quarter
	) A

WHERE
	A.subquery_calendar_year = calendar_year
	AND A.subquery_calendar_quarter = calendar_quarter


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN last_day_in_week DATETIME NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN last_day_in_month DATETIME NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN first_day_in_quarter DATETIME NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN last_day_in_quarter DATETIME NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN week_of_month INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN week_of_quarter INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN is_leap_year INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN year_week VARCHAR (6) NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN year_month VARCHAR (6) NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN year_quarter VARCHAR (6) NOT NULL


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_last_day_in_week ON dbo.tblDate_Calendar (last_day_in_week)


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_year_month ON dbo.tblDate_Calendar (year_month)


CREATE NONCLUSTERED INDEX IX_tblDate_Calendar_year_quarter ON dbo.tblDate_Calendar (year_quarter)


----------------------------------------------------------------------------------------------------------------------
--	Table Update III: Populate Additional Date Xref Table Fields (Pass III)
----------------------------------------------------------------------------------------------------------------------

UPDATE
	dbo.tblDate_Calendar
SET
	 is_last_day_in_month = (CASE
								WHEN last_day_in_month = calendar_date THEN 1
								ELSE 0
								END)
	,is_last_day_in_quarter = (CASE
									WHEN last_day_in_quarter = calendar_date THEN 1
									ELSE 0
									END)
	,days_in_month = DATEPART (DAY, last_day_in_month)
	,weekdays_in_month = A.weekdays_in_month
	,days_in_quarter = DATEDIFF (DAY, first_day_in_quarter, last_day_in_quarter) + 1
	,quarter_days_remaining = DATEDIFF (DAY, calendar_date, last_day_in_quarter)
	,weekdays_in_quarter = B.weekdays_in_quarter
	,year_days_remaining = (365 + is_leap_year) - day_of_year
FROM

	(
		SELECT
			 X.year_month AS subquery_year_month
			,SUM (X.is_weekday) AS weekdays_in_month
		FROM
			dbo.tblDate_Calendar X
		GROUP BY
			X.year_month
	) A

	,(
		SELECT
			 X.year_quarter AS subquery_year_quarter
			,SUM (X.is_weekday) AS weekdays_in_quarter
		FROM
			dbo.tblDate_Calendar X
		GROUP BY
			X.year_quarter
	 ) B

WHERE
	A.subquery_year_month = year_month
	AND B.subquery_year_quarter = year_quarter


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN is_last_day_in_month INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN is_last_day_in_quarter INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN days_in_month INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN weekdays_in_month INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN days_in_quarter INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN quarter_days_remaining INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN weekdays_in_quarter INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN year_days_remaining INT NOT NULL


----------------------------------------------------------------------------------------------------------------------
--	Table Update IV: Populate Additional Date Xref Table Fields (Pass IV)
----------------------------------------------------------------------------------------------------------------------

UPDATE
	dbo.tblDate_Calendar
SET
	 month_weekdays_remaining = weekdays_in_month - A.month_weekdays_remaining_subtraction
	,quarter_weekdays_remaining = weekdays_in_quarter - A.quarter_weekdays_remaining_subtraction
FROM

	(
		SELECT
			 X.calendar_date AS subquery_calendar_date
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										X.year_month
									ORDER BY
										X.calendar_date
								) AS month_weekdays_remaining_subtraction
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										X.year_quarter
									ORDER BY
										X.calendar_date
								) AS quarter_weekdays_remaining_subtraction
		FROM
			dbo.tblDate_Calendar X
		WHERE
			X.is_weekday = 1
	) A

WHERE
	A.subquery_calendar_date = calendar_date


----------------------------------------------------------------------------------------------------------------------
--	Table Update V: Populate Additional Date Xref Table Fields (Pass V)
----------------------------------------------------------------------------------------------------------------------

UPDATE
	dbo.tblDate_Calendar
SET
	 month_weekdays_remaining = A.month_weekdays_remaining
	,quarter_weekdays_remaining = A.quarter_weekdays_remaining
FROM

	(
		SELECT
			 X.calendar_date AS subquery_calendar_date
			,COALESCE (Y.month_weekdays_remaining, Z.month_weekdays_remaining, X.weekdays_in_month) AS month_weekdays_remaining
			,COALESCE (Y.quarter_weekdays_remaining, Z.quarter_weekdays_remaining, X.weekdays_in_quarter) AS quarter_weekdays_remaining
		FROM
			dbo.tblDate_Calendar X
			LEFT JOIN dbo.tblDate_Calendar Y ON DATEADD (DAY, 1, Y.calendar_date) = X.calendar_date
				AND Y.year_month = X.year_month
			LEFT JOIN dbo.tblDate_Calendar Z ON DATEADD (DAY, 2, Z.calendar_date) = X.calendar_date
				AND Z.year_month = X.year_month
		WHERE
			X.month_weekdays_remaining IS NULL
	) A

WHERE
	A.subquery_calendar_date = calendar_date


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN month_weekdays_remaining INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN quarter_weekdays_remaining INT NOT NULL


----------------------------------------------------------------------------------------------------------------------
--	Table Update VI: Populate Additional Date Xref Table Fields (Pass VI)
----------------------------------------------------------------------------------------------------------------------

UPDATE
	dbo.tblDate_Calendar
SET
	 is_week_in_same_month = A.is_week_in_same_month
	,month_days_remaining = days_in_month - calendar_day
	,month_weekdays_completed = weekdays_in_month - month_weekdays_remaining
	,quarter_days_completed = days_in_quarter - quarter_days_remaining
	,quarter_weekdays_completed = weekdays_in_quarter - quarter_weekdays_remaining
	,month_day_name_instance = A.month_day_name_instance
	,quarter_day_name_instance = A.quarter_day_name_instance
	,year_day_name_instance = A.year_day_name_instance
FROM

	(
		SELECT
			 X.calendar_date AS subquery_calendar_date
			,ISNULL ((CASE
						WHEN DATEDIFF (MONTH, X.first_day_in_week, X.last_day_in_week) = 0 THEN 1
						END), 0) AS is_week_in_same_month
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										 X.year_month
										,X.day_name
									ORDER BY
										X.calendar_date
								) AS month_day_name_instance
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										 X.year_quarter
										,X.day_name
									ORDER BY
										X.calendar_date
								) AS quarter_day_name_instance
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										 X.calendar_year
										,X.day_name
									ORDER BY
										X.calendar_date
								) AS year_day_name_instance
		FROM
			dbo.tblDate_Calendar X
	) A

WHERE
	A.subquery_calendar_date = calendar_date


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN is_week_in_same_month INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN month_days_remaining INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN month_weekdays_completed INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN quarter_days_completed INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN quarter_weekdays_completed INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN month_day_name_instance INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN quarter_day_name_instance INT NOT NULL


ALTER TABLE dbo.tblDate_Calendar ALTER COLUMN year_day_name_instance INT NOT NULL


----------------------------------------------------------------------------------------------------------------------
--	Main Query: Final Display / Output
----------------------------------------------------------------------------------------------------------------------

SELECT
	URD.*
FROM
	dbo.tblDate_Calendar URD
ORDER BY
	URD.calendar_date
	
	
	-- tblDateCalendar script

SELECT min(dtDate) OldestDate,
max(dtDate) NewestDate
 from tblDate



select * -- calendar_date, is_last_day_in_month, is_last_day_in_quarter
from tblDateCalendar
where is_last_day_in_month = 1
order by calendar_date


select min(calendar_date) from tblDateCalendar
where calendar_date NOT in (select dtDate from [SMI Reporting].dbo.tblDate)
order by 



/**** update and compare to tblDate

select * 
from tblDateCalendar DC
    join [SMI Reporting].dbo.tblDate D on DC.calendar_date = D.dtDate
    
    
where calendar_date NOT in (select dtDate from [SMI Reporting].dbo.tblDate) 



-- populate ixDate
UPDATE A 
SET A.ixDate = B.ixDate
FROM tblDateCalendar A
JOIN [SMI Reporting].dbo.tblDate B on A.calendar_date = B.dtDate



select DC.calendar_date, D.dtDate
from tblDateCalendar DC
    join [SMI Reporting].dbo.tblDate D on DC.ixDate = D.ixDate
    

*/    