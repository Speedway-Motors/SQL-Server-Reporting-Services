-- SMIHD-7230 - Exempt Employees with No Door Swipes

-- SMIHD-7230 - Exempt Employees with No Door Swipes

SELECT distinct E.ixEmployee, E.sPayrollId, E.sFirstname, E.sLastname, E.ixDepartment, E.flgCurrentEmployee, E.flgExempt, E.flgPayroll
from tblEmployee E
where flgCurrentEmployee = 1
    and flgExempt =1
    AND ixDepartment NOT IN ('9','47','55','74','90')
    AND ixEmployee NOT IN ('AJB3','AJP','ANH','BJH1','BJS2','CAS','CCC','CFS','CJM1','CMR2','CWS','DKC','DSS1','DWS','EJG','HMD','IDA','JAS3','JCM1','JDS','jcm','jds','jmm','JCM1','JTMT','KDL','KRH', 'LJP','MAL1','MAL2','MJT', 'RLH2','RLT','RNK','SQC','THN','TTL','ZLW')
    --and sPayrollId is NULL -- make sure this is right    87 employees

and ixEmployee IN (    SELECT DISTINCT CU.ixEmployee as 'ixEmployee'--, --CU.ixEmployee,
                        FROM tblCardUser CU 
                            join tblCard C on C.ixCardUser = CU.ixCardUser
                            join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
                            left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)
                            -- CU.ixEmployee = E.ixEmployee
                        WHERE 
                              CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101) between DATEADD(dd,-14,DATEDIFF(dd,0,getdate())) AND DATEADD(dd,-1,DATEDIFF(dd,0,getdate()))  
                        )
 and ixEmployee NOT IN (    SELECT DISTINCT CU.sExtraInfo--, --CU.ixEmployee,
                        FROM tblCardUser CU 
                            join tblCard C on C.ixCardUser = CU.ixCardUser
                            join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
                            left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)
                            -- CU.ixEmployee = E.ixEmployee
                        WHERE 
                               CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101) between DATEADD(dd,-14,DATEDIFF(dd,0,getdate())) AND DATEADD(dd,-1,DATEDIFF(dd,0,getdate())) 
                        )         
          
SELECT          
SELECT DATEADD(dd,-4,DATEDIFF(dd,0,getdate()))    


Extension
Department
Customer      
HireDate
TermDate

select * from tblEmployee
where sFirstname = 'CUONG'

select * from tblDate


SELECT
    E.sFirstname,
    E.sLastname,
    E.ixEmployee, -- placeholder until Employee# is created
    E.sPayrollId,
    E.ixDepartment,
    CONVERT(VARCHAR(10), DE.dtEventTimeDate, 101) AS [MM/DD/YYYY],
   SUBSTRING(datename(dw,DE.dtEventTimeDate),1,3) 'Day',
    DE.sAction,
-- MODIFY THE CASE STATEMENT ACCORDING TO THE CHART AT THE TOP OF THE COMMENTS TO COMPENSATE FOR OUR JUNKY DOOR SYSTEM
    DE.dtEventTimeDate 'EventTimeDate'
FROM
    tblEmployee E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
WHERE   E.ixEmployee IN ('CDN')
        -- E.sPayrollId in (@Employee)
and DE.dtEventTimeDate between '01/01/2017' and '04/12/2017'
--and E.ixDepartment in (@Dept)
ORDER BY     E.sLastname,    DE.dtEventTimeDate


-- Employees current flagges as exempt -- USE FOR XLS FILE TO HAVE DEB VERIFY
SELECT ixEmployee 'Employee',
    sFirstname 'FirstName',
    sLastname 'LastName',
    ixDepartment 'Dept',
    sPayrollId 'PayrollID',
    flgPayroll
FROM tblEmployee
where flgCurrentEmployee = 1
    and flgExempt = 1
    and sPayrollId is NOT NULL
    AND ixEmployee NOT IN ('AJB3','AJP','ANH','BJH1','BJS2','CAS','CCC','CFS','CJM1','CMR2','CWS','DKC','DSS1','DWS','EJG','HMD','IDA','JAS3','JCM1','JDS','jcm','jds','jmm','JCM1','JTMT','KDL','KRH', 'LJP','MAL1','MAL2','MJT', 'RLH2','RLT','RNK','SQC','THN','TTL','ZLW')
                                                                                                                                                                                                                                                                 
   -- and sEmailAddress is NULL
order by ixEmployee

-- list of Employees to not track (per Deb)
SELECT ixEmployee 'Employee',
sFirstname 'FirstName',
sLastname 'LastName',
ixDepartment 'Dept',
sPayrollId 'PayrollID',
flgPayroll
FROM tblEmployee
where flgCurrentEmployee = 1
    and flgExempt = 1
  --  and sPayrollId is NOT NULL
        AND ixEmployee NOT IN ('AJB3','AJP','ANH','BJH1','BJS2','CAS','CCC','CFS','CJM1','CMR2','CWS','DKC','DSS1','DWS','EJG','HMD','IDA','JAS3','JCM1','JDS','jcm','jds','jmm','JCM1','JTMT','KDL','KRH', 'LJP','MAL1','MAL2','MJT', 'RLH2','RLT','RNK','SQC','THN','TTL','ZLW')
   -- and sEmailAddress is NULL
order by ixEmployee


-- FIRST PASS AT REPORT LOGIC 7/20/2018
SELECT E.*, SWIPES.Swipes
FROM tblEmployee E
    LEFT JOIN (SELECT CU.ixEmployee -- BOTH OF THESE FIELDS NEED TO HAVE THE ixEmployee data or the report can not pick them up!!!
                       ,COUNT(DE.dtEventTimeDate) 'Swipes'
                       /*
			            CU.sExtraInfo 'tblCardUser.sExtraInfo', -- BOTH OF THESE FIELDS NEED TO HAVE THE ixEmployee data or the report can not pick them up!!!
			            CONVERT(VARCHAR(20), DE.dtEventTimeDate, 10) AS [MM/DD/YY],
			            SUBSTRING(D.sDayOfWeek,1,3) 'Day',    
			            SUBSTRING(CAST((CONVERT(VARCHAR(12), DE.dtEventTimeDate, 114)) as VARCHAR(12)),1,5) AS 'TIME',
			            DE.sAction
                        */
		            FROM tblCardUser CU 
			            join tblCard C on C.ixCardUser = CU.ixCardUser
			            join tblDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
			            left join tblDate D on D.dtDate = CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101)
		            WHERE CONVERT(VARCHAR(20), DE.dtEventTimeDate, 101) between DATEADD(dd,-14,DATEDIFF(dd,-1,getdate())) AND getdate() -- past 13 days (assuming you run it on Fridays)
                    GROUP BY CU.ixEmployee
		            --ORDER BY CU.ixEmployee -- CU.sExtraInfo, DE.dtEventTimeDate
                    ) SWIPES on E.ixEmployee = SWIPES.ixEmployee
where E.ixEmployee NOT IN ('AJB3','AJP','ANH','BJH1','BJS2','CAS','CCC','CFS','CJM1','CMR2','CWS','DKC','DSS1','DWS','EJG','HMD','IDA','JAS3','JCM1','JDS','jcm','jds','jmm','JCM1','JTMT','KDL','KRH', 'LJP','MAL1','MAL2','MJT', 'RLH2','RLT','RNK','SQC','THN','TTL','ZLW')
    and E.flgCurrentEmployee = 1
    and E.flgDeletedFromSOP = 0
    and E.flgPayroll = 1
    and E.flgExempt = 1
    AND E.ixDepartment NOT IN ('9','47','55','74','90')
    and SWIPES.Swipes is NULL
order by ixDepartment, ixEmployee




    SELECT * FROM tblDepartment where ixDepartment IN ('9','47','55','74','90')





