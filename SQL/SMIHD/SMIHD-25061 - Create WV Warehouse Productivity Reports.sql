-- SMIHD-25061 - Create WV Warehouse Productivity Reports
-- initial research looking at employee departments and jobclock activity


-- WV departments
select * from tblDepartment
where sDescription like '%WV%'
	or sDescription like '%West%'
	or ixDepartment in  (33,34,35,36,58)
/*
ix
Dept	sDescription
33		UNKNOWN		-- NEED TO UPDATE!
34		WV - Picking
35		WV - Small Pack
36		WV - Big Pack
58		West Virginia
*/

-- Full List of WV Job Clock Activities
SELECT ixDepartment 'Dept',
	ixJob 'Job ',
	sDescription 'Job Description',
	sJobSort
FROM tblJob
WHERE ixDepartment in (33,34,35,36,58)
	and sDescription <> 'Unknown'
ORDER BY ixDepartment, sJobSort



SELECT distinct sJob, count(*) RecCnt -- ixEmployee
FROM tblJobClock
where (sJob like '34-%'
		or sJob like '36-%'
		or sJob like '35-%')
		and ixEmployee NOT IN ('RNK','AJA','JFS','LJL1','RGK') -- LNK employees (did tests or were only briefly at WV)
GROUP BY sJob
ORDER BY sJob --dtDate desc
/*					

	-- no picking activity is being logged at all (dept 34) of 5-25-22
sJob	RecCnt
=====	======
35-1	4
35-2	44
35-8	801
36-1	6
36-5	1
36-6	254
36-7	12
36-8	61
36-9	2
*/

-- 29 employees currently at WV and they ALL are assigned to dept 58 as of 5-25-22
SELECT DISTINCT ixDepartment, ixEmployee, sFirstname, sLastname
from tblEmployee
WHERE ixEmployee in ('ADD1','AJA','AMT','BMW2','CAM2','CMG2','DAF','DJR3','DXP','EJH','JAH3','JFS','JLM4','JWO','KJW','KMP2','LCM','LJL1','LJS','MES2','MKC','MPO','MWP','NAG','NDP','PAP','PMD','RGK','RMM2','RWS1','SBF','TRW','TWH')
	and ixEmployee NOT IN ('RNK','AJA','JFS','LJL1','RGK') -- LNK employees (did tests or were only briefly at WV)
	--and ixDepartment <> 58 



-- RJ's list from People Ops
SELECT DISTINCT ixDepartment, ixEmployee, sFirstname, sLastname
from tblEmployee
WHERE ixEmployee in ('WFB','MKC','ADD1','JLE','RAE','ARF','LXF','RDF','SBF','CMG2','NAG','JXG1','EJH','RPL','LCM','SLM4','RMM2','CAM2','AMO1','JWO','KMP2','KRR','TCR','LJS','MES2','LSV','RXS','BMW2','TRW')
	--and ixEmployee NOT in ('ADD1','AJA','AMT','BMW2','CAM2','CMG2','DAF','DJR3','DXP','EJH','JAH3','JFS','JLM4','JWO','KJW','KMP2','LCM','LJL1','LJS','MES2','MKC','MPO','MWP','NAG','NDP','PAP','PMD','RGK','RMM2','RWS1','SBF','TRW','TWH')








