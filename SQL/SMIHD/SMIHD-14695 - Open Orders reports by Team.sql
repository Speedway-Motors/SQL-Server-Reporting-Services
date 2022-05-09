-- SMIHD-14695 - Open Orders reports by Team


SELECT MAX(dtUpdateUtc) FROM tblCallCenterUser -- 2021-04-12 
SELECT MAX(dtUpdateUtc) FROM tblEmployeeDirectory -- 2021-03-29

select-- CCU.ixEmployeeDirectoryID 
     --, EMP.sPayrollId
     'CX '+ CAST(iTeam AS VARCHAR(6)) as 'CX Team'
     , CCU.sSkillTeam 'SKillTeam'
     , ED.sFirstName 'FirstName'
     , ED.sLastName 'LastName',
       ED.sShortName 'ixEmployee'
from tblEmployeeDirectory ED
    left join tblCallCenterUser CCU   ON ED.ixEmployeeDirectoryID = CCU.ixEmployeeDirectoryID 
    left join tblEmployee EMP on EMP.ixEmployee = ED.sShortName
   -- left join tblEmployee EMP on CAST(CCU.ixEmployeeDirectoryID AS VARCHAR(6)) = EMP.sPayrollId
-- where CCU.ixEmployeeDirectoryID in /*CX1*/ ('3037','3662','3828','3670','3470','3626','2882','3728','3165','2998','3938','3608','2723','3192','3943','3636','3468','3699','3745','3318','3713','2235')
-- where CCU.ixEmployeeDirectoryID in /*CX2*/ ('3578','3785','3107','3800','3239','3680','2164','2720','3809','3665','2305','3886','2285','3343','2698','3803','3608','3739','3685','3604','3840','3677','2498')
-- where CCU.ixEmployeeDirectoryID in /*CX3*/ ('2960','3822','3565','3452','3764','3700','3572','3698','3757','2607','3832','3943','3878','2726','3212','3624','2582','2740','3180','3488','2990','3233')
-- where CCU.ixEmployeeDirectoryID in /*Counter*/ ('3758','3703','2582','3798','3873','3310') -- shows 1 emp no iTeam values
-- where CCU.ixEmployeeDirectoryID in /*Operations*/ ('3489','2702','3688','3486','2731','2454','3248') -- shows 5 emps no iTeam values
-- where CCU.ixEmployeeDirectoryID in /*Wholesale*/ ('2728','3570','2842','3519','3694') -- shows 3 emps for Team 4
where CCU.iTeam between 1 and 6 -- 17 members
    and CCU.flgActive = 1 -- 15 members             exclude if you need historical members
order by iTeam, ED.sLastName


SELECT * FROM tblCallCenterUser
SELECT * FROM tblCallCenterSection
SELECT * FROM tblEmployeeDirectory

3037	ADB	    Andy Billesbach CX1
3343	ETS2	Emily Segieda   CX2
2582	PWO	    Pat Orth        CX3 & Counter
2731	KLJ	    Ken Jenkins     Operations & Returns
2842	JSD1	Jason Danely    Wholesale
2730	BKR	   qBrian Robinson  Surverys (not currently a group)


SELECT ixReportToEmployeeDirectoryID, sShortName, CCU.iTeam
FROM tblEmployeeDirectory E
    left join  tblCallCenterUser CCU on E.ixEmployeeDirectoryID = CCU.ixEmployeeDirectoryID 
WHERE ixReportToEmployeeDirectoryID in (3037, 3343, 2582, 2731, 2842)
    and E.flgActive = 1 -- just means they're active in the CX.  This could be 0 but they are still an employee outside of the CX now.
order by ixReportToEmployeeDirectoryID, sShortName

SELECT ixReportToEmployeeDirectoryID, COUNT(ixEmployeeDirectoryID)
FROM tblEmployeeDirectory E
WHERE ixReportToEmployeeDirectoryID in (3037, 3343, 2582, 2731, 2842)
GROUP BY ixReportToEmployeeDirectoryID


ixReportToEmployeeDirectoryID
NULL







    

select * from tblCallCenterUser
order by iTeam


select iTeam, count(sUserName) EmpCount
from tblCallCenterUser
group by iTeam
order by iTeam

/*
iTeam	EmpCount
NULL	18
1	    22
2	    24
3	    23
4	    4
*/

select sSkillTeam, count(sUserName) EmpCount
from tblCallCenterUser
group by sSkillTeam
order by sSkillTeam
/*
sSkillTeam	        EmpCount
NULL	            18
CX Agent	        43
CX Auto Tech Muscle	2
CX Auto Tech Race	3
CX Auto Tech Rod	9
CX Dealer	        4
CX Lead	            6
CX Support	        6
*/

select * from tblEmployee where ixEmployee = 'ADB'



select CCU.ixEmployeeDirectoryID 
     , EMP.sPayrollId
     , iTeam 
     , CCU.sSkillTeam
     , E.sFirstName
     , E.sLastName 
     , EMP.ixDepartment
     , EMP.flgCurrentEmployee
from tblCallCenterUser CCU 
    left join tblEmployeeDirectory E ON E.ixEmployeeDirectoryID = CCU.ixEmployeeDirectoryID 
    left join tblEmployee EMP on CAST(CCU.ixEmployeeDirectoryID AS VARCHAR(6)) = EMP.sPayrollId
-- where CCU.ixEmployeeDirectoryID in /*CX1*/ ('3037','3662','3828','3670','3470','3626','2882','3728','3165','2998','3938','3608','2723','3192','3943','3636','3468','3699','3745','3318','3713','2235')
-- where CCU.ixEmployeeDirectoryID in /*CX2*/ ('3578','3785','3107','3800','3239','3680','2164','2720','3809','3665','2305','3886','2285','3343','2698','3803','3608','3739','3685','3604','3840','3677','2498')
-- where CCU.ixEmployeeDirectoryID in /*CX3*/ ('2960','3822','3565','3452','3764','3700','3572','3698','3757','2607','3832','3943','3878','2726','3212','3624','2582','2740','3180','3488','2990','3233')
-- where CCU.ixEmployeeDirectoryID in /*Counter*/ ('3758','3703','2582','3798','3873','3310') -- shows 1 emp no iTeam values
-- where CCU.ixEmployeeDirectoryID in /*Operations*/ ('3489','2702','3688','3486','2731','2454','3248') -- shows 5 emps no iTeam values
where --CCU.ixEmployeeDirectoryID in /*Wholesale*/ ('2728','3570','2842','3519','3694') -- shows 3 emps for Team 4
    E.flgActive = 1

-- emps not join to tblEmployee
Chris	Kelley -- CAK2
Eric	Mcmillan -- EIM
Brian	Kelsay -- BLK
Kevin	Aquilina -- KCA

select * from tblEmployee
where ixEmployee like 'K%A%' -- BLK
order by sFirstname

select * from tblEmployee where ixEmployee in ('CAK2','EIM','BLK','KCA')
/*

                            SOP     Monet
        First   Last        Payroll Payroll
Emp     name	name	    Id      Id
====    ======  =======     ======  =======
BLK	    BRIAN   KELSAY	    4135    2724
CAK2	CHRIS	KELLEY	    <blank> 1197
EIM	    ERIC	MCMILLAN	<blank> 2882
KCA	    KEVIN	AQUILINA	4168    4172
*/





