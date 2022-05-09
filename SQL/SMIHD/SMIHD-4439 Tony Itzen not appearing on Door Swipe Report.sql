-- SMIHD-4439 Tony Itzen not appearing on Door Swipe Report

select ixEmployee, sPayrollId, flgCurrentEmployee, sLastname, sFirstname, ixDepartment
from tblEmployee 
where  sPayrollId = '1079'
order by sLastname
    /*
    ixEmployee	sPayrollId	flgCurrentEmployee	sLastname	sFirstname	ixDepartment
    AAI	        1079	    1	                ITZEN	    TONY	    80
    */

select * from tblEmployee where sLastname = 'ITZEN' -- 1079 AAI

select cu.*, c.*
from tblCardUser cu 
left join tblCard c on cu.ixCardUser = c.ixCardUser
where sLastName = 'Itzen'-- and sFirstName = 'Anthony' 



Select distinct E.sPayrollId, E.flgCurrentEmployee
from tblEmployee  E                                             
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee    
    left join tblCard C on C.ixCardUser = CU.ixCardUser
where E.ixDepartment in (80)   
order by E.sPayrollId


select * from tblDepartment where ixDepartment = 80

-- HAS 145 ENTRIES IN tblCardUser
Select --C.*, CU.*, E.*  -- CU.ixCardUser, CU.ixEmployee, E.ixEmployee, E.sPayrollId
CU.ixCardUser, CU.ixEmployee, CU.sFirstName, CU.sLastName, CU.sExtraInfo,
E.ixEmployee, E.sLastname, E.sFirstname, E.ixDepartment, E.sPayrollId, E.flgCurrentEmployee, E.dtDateLastSOPUpdate, E.flgExempt, E.flgDeletedFromSOP, E.ixCustomer, E.sEmailAddress, E.dtHireDate, E.flgPartTime, E.flgPayroll, E.dtTerminationDate
from tblEmployee  E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    left join tblCard C on C.ixCardUser = CU.ixCardUser
where CU.ixEmployee = 'AAI'
order by CU.ixCardUser desc
    /*
    ixCardUser	ixEmployee
    85813	AAI
    85607	AAI
    84590	AAI
    84384	AAI
    83367	AAI

    +140 more entries
    */

-- 2 ENTRIES WITH THE ixCardUser values from above
select * from tblCard 
where ixCardUser in (select ixCardUser 
                     from tblCardUser
                     where ixEmployee  = 'AAI')
/*                 
ixCard	ixCardUser	ixCardScanNum	sPrintedCardNum	flgActive	iActivationDate	iDeactivationDate
84613	237	        247546	        3192033	        0	        1282255080	    0
84817	237	        406274825	    115803	        0	        1305726600	    0                  
*/                     
                     
                 
                
        

select * from tblCardUser cu 
left join tblCard c on cu.ixCardUser = c.ixCardUser
where sLastName = 'Itzen' -- sFirstName = 'William'

select * from tblCardUser cu 
left join tblCard c on cu.ixCardUser = c.ixCardUser
where cu.ixEmployee = 'AAI'




/***	Summary of Changes to Daylight Saving Time ***
	    Prior to 2007	        2007 and After	
Start	1st SUN in April	    2nd SUN in March	
End	    Last SUN in October	    1st SUN in November	
				
				
------------ Start ------ End ----- Year
Door System	04/06/14	10/26/14	2014
Actual US	03/09/14	11/02/14	2014
			
Door System	04/05/15	10/25/15	2015
Actual US	03/08/15	11/01/15	2015
			
Door System	04/03/16	10/30/16	2016
Actual US	03/13/16	11/06/16	2016
			
Door System	04/02/17	10/29/17	2017
Actual US	03/12/17	11/05/16	2017
*/	



SELECT C.ixCardScanNum, DE.*
/*
    E.sFirstname,
    E.sLastname,
    E.ixEmployee, -- placeholder until Employee# is created
    E.sPayrollId,
    E.ixDepartment,
    CONVERT(VARCHAR(10), DE.dtEventTimeDate, 101) AS [MM/DD/YYYY],
    DE.sAction,
-- MODIFY THE CASE STATEMENT BASED ON THE CHART AT THE TOP OF THE COMMENTS TO COMPENSATE FOR OUR JUNKY DOOR SYSTEM
    (Case when (DE.dtEventTimeDate > '11/02/10' and  DE.dtEventTimeDate < '11/07/10')
          then dateadd(HH,-1,DE.dtEventTimeDate) 
          else DE.dtEventTimeDate
     End) EventTimeDate
     */
FROM
    tblEmployee E
    left join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    left join tblCard C on C.ixCardUser = CU.ixCardUser
    left join vwDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
WHERE   E.ixEmployee = 'AAI'
     --   E.sPayrollId in ('1079')--(@Employee)
--and DE.dtEventTimeDate >= @StartDate
--and DE.dtEventTimeDate < (@EndDate+1)
--and E.ixDepartment in (@Dept)
ORDER BY     E.sLastname,    DE.dtEventTimeDate     


select * from tblCardUser where ixEmployee = 'AAI' -- 144 rows       

select * from tblCard WHERE ixCardUser in ('237','443','1420','1626','2604','2810','3788','3994','4973','5179','6159','6365','7345','7551','8531','8737','9717','9923','10903','11109','12089','12295','13275','13481','14462','14668','15649','15855','16836','17042','18023','18229','19213','19419','20404','20610','21595','21801','22787','22993','23979','24185','25171','25377','26363','26569','27555','27761','28748','28954','29941','30147','31135','31341','32330','32536','33525','33731','34720','34926','35915','36121','37110','37316','38307','38513','39504','39710','40702','40908','41900','42106','43098','43304','44301','44507','45504','45710','46708','46914','47912','48118','49116','49322','50324','50530','51532','51738','52740','52946','53949','54155','55159','55365','56371','56577','57585','57791','58799','59005','60013','60219','61227','61433','62441','62647','63656','63862','64873','65079','66090','66296','67307','67513','68525','68731','69743','69949','70961','71167','72179','72385','73398','73604','74617','74823','75836','76042','77055','77261','78274','78480','79494','79700','80715','80921','81938','82144','83161','83367','84384','84590','85607','85813')


select * from tblDoorEvent         

select * from tblCardUser where sExtraInfo = 'AAI' 

select * from tblCardUser CU
LEFT join tblEmployee E on CU.sExtraInfo = E.ixEmployee
where CU.ixEmployee = 'AAI' 
AND E.ixEmployee <> 'AAI'  

select * from tblCardUser CU
join tblEmployee E on CU.sExtraInfo = E.ixEmployee
where CU.ixEmployee = 'AAI' -- 72 ROWS

select * from tblCardUser 
where  sExtraInfo = 'AAI' order by  ixEmployee -- 153 ROWS


