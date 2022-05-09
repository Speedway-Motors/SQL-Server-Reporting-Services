-- SMIHD-1277 Will Arnett not appearing on Door Swipe Report

select * 
from tblEmployee 
--where  sPayrollId = '3388'
order by sLastname
    /*
    ixEmployee	sPayrollId	flgCurrentEmployee	sLastname	sFirstname	ixDepartment
    WTA	        3388	    1	                ARNETT	    WILLIAM	    21
    */

select * from tblEmployee -- 2888 JBJ
where sLastname = 'JONES'

select * from tblCardUser cu 
left join tblCard c on cu.ixCardUser = c.ixCardUser
where sFirstName = 'William' and sLastName = 'Arnett';
--that's the query I used to get those results


Select distinct E.sPayrollId, E.flgCurrentEmployee
from tblEmployee  E                                             --179
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee    --179
    left join tblCard C on C.ixCardUser = CU.ixCardUser
where E.ixDepartment in (20,21,22,23,24,25,26,27,28,29,45,50)   -- 311
--and C.ixCardUser is NULL
order by E.sPayrollId


select * from tblDepartment where ixDepartment = 21

-- HAS 147 ENTRIES IN tblCardUser
Select C.*, CU.*, E.*  -- CU.ixCardUser, CU.ixEmployee, E.ixEmployee, E.sPayrollId
CU.ixCardUser, CU.ixEmployee, CU.sFirstName, CU.sLastName, CU.sExtraInfo,
E.ixEmployee, E.sLastname, E.sFirstname, E.ixDepartment, E.sPayrollId, E.flgCurrentEmployee, E.dtDateLastSOPUpdate, E.flgExempt, E.flgDeletedFromSOP, E.ixCustomer, E.sEmailAddress, E.dtHireDate, E.flgPartTime, E.flgPayroll, E.dtTerminationDate
from tblEmployee  E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    left join tblCard C on C.ixCardUser = CU.ixCardUser
where CU.ixEmployee = 'WTA'
order by CU.ixCardUser desc
    /*
    ixCardUser	ixEmployee
    169835	    WTA
    168742	    WTA
    167649	    WTA
    166556	    WTA
    165465	    WTA
    164374	    WTA
    163284	    WTA
    .
    .
    +140 more entries
    */

'WTA	ARNETT	WILLIAM'

-- NO ENTRIES WITH THE ixCardUser values from above
select * from tblCard 
where ixCardUser in (select ixCardUser 
                     from tblCardUser
                     where ixEmployee  = 'WTA')
-- NO ROWS RETURNED                     
                     
                     
                     
                 
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
                                           


                                           
                                           
                                           
Select distinct E.sPayrollId
from tblEmployee  E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
   left join tblCard C on C.ixCardUser = CU.ixCardUser
where E.ixDepartment in (21)
order by E.sPayrollId





select * from tblCardUser cu 
left join tblCard c on cu.ixCardUser = c.ixCardUser
where sFirstName = 'William' and sLastName = 'Arnett';

select * from tblCardUser cu 
left join tblCard c on cu.ixCardUser = c.ixCardUser
where cu.ixEmployee = 'WTA'


select * from tblCardUser cu 
left join tblCard c on cu.ixCardUser = c.ixCardUser
where sFirstName = 'Patrick' and sLastName = 'Crews';


--that's the query I used to get those results



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
WHERE
        E.sPayrollId in ('1126','3388')--(@Employee)
--and DE.dtEventTimeDate >= @StartDate
--and DE.dtEventTimeDate < (@EndDate+1)
--and E.ixDepartment in (@Dept)
ORDER BY     E.sLastname,    DE.dtEventTimeDate     

select * from tblCard where ixCardUser in (
                                            SELECT ixCardUser FROM tblCardUser where ixEmployee = 'WTA'                                                                                                    
                                            )
                                            

select * from tblCardUser where ixEmployee = 'WTA'        

select * from tblCard WHERE ixCardUser in ('17569','18559','19549','20539','21529','22519','23509','24500','25493','26486','27479','28472','29465','30458','31452','32448','33447','34447','35447','36447','37447','38447','39447','40447','41455','42464','43473','44482',
'45492','46503','47515','48530','49548','50566','51584','52602','53621','54642','55663','56684','57706','58728','59751','60775','61800','62826','63852','64878','65904','66932','67965','68998','70031','71066','72101','73136',
'74172','75209','76246','77284','78322','79360','80398','81436','82474','83512','84551','85591','86631','87671','88712','89755','90799','91843','92889','93935','94981','96027','97073','98119','99166','100216','101266','102316',
'103366','104416','105466','106520','107577','108634','109691','110750','111810','112870','113931','114992','116053','117114','118176','119238','120301','121365','122429','123493','124557','125622','126688','127754','128820',
'129888','130956','132024','133094','134164','135234','136305','137378','138453','139528','140603','141678','142753','143828','144906','145984','147062','148140','149218','150296','151374','152452','153530','154608','155686',
'156768','157850','158932','160020','161108','162196','163284','164374','165465','166556','167649','168742','169835','170928')


select * from tblDoorEvent         
select * from tblCardUser where ixEmployee = 'WTA                             '                                           

select * from tblCardUser where sExtraInfo LIKE 'PJC%'   
select * from tblCardUser where sExtraInfo = 'WTA' and len(sExtraInfo) = 3

select * from tblCardUser CU
LEFT join tblEmployee E on CU.sExtraInfo = E.ixEmployee
where CU.ixEmployee = 'WTA' 
AND E.ixEmployee <> 'WTA'  

select * from tblCardUser CU
join tblEmployee E on CU.sExtraInfo = E.ixEmployee
where CU.ixEmployee = 'WTA' -- 148 ROWS

select * from tblCardUser 
where  sExtraInfo = 'WTA' order by  ixEmployee -- 153 ROWS


select * from tblCardUser where ixEmployee = 'WTA' order by sExtraInfo
select * from tblCardUser where  sExtraInfo = 'WTA' order by  ixEmployee

select * from tblCardUser where ixEmployee = 'PJC' order by sExtraInfo
select * from tblCardUser where  sExtraInfo = 'PJC' order by  ixEmployee