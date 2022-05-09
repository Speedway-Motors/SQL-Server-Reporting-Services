-- SMIHD-15949 TESTING FOR SMALL PACK DASHBOARD

/* Orders verfied 5/20/20

Order
=======
9156136 Verifying Station #1 AZ-TEMP-10 172.29.0.13
9178138 Verifying Station #2 TUL-PC-08 172.29.0.67
9174134 Verifying Station #3 TOL-DEC-1 172.29.0.181
    
TOL - Verify 1     172.29.0.13 Order # 9548233
TOL - Verify 2     172.29.0.67 Order #9586134
   
TOL - Big Pack    172.29.0.181  Order # 9570235

*/ 

select * from tblPackage where ixOrder in ('9548233','9586134')  -- 1 package each

select O.ixOrder, O.sOrderStatus, P.ixVerifier, P.ixVerificationIP, P.sTrackingNumber, P.flgCanceled, P.flgReplaced
from tblOrder O
    left join tblPackage P on O.ixOrder = P.ixOrder
where O.ixOrder in ('9570235')  
    and P.flgReplaced = 0
    and P.flgCanceled = 0
/*      sOrder                                  sTracking
ixOrder	Status	ixVerifier	ixVerificationIP	Number	            flgCanceled	flgReplaced
9548233	Open	BMN	        172.29.0.13	        00737582	        0	        0
9586134	Open	BMN	        172.29.0.67	        00738536	        0	        0

9570235	Shipped	BMN	        172.29.0.181	    1Z62F9970300294539	0	        0
*/

select * from tblIPAddress
where ixLocation = 85
and ixIP in ('172.29.0.13','172.29.0.181','172.29.0.67')

SELECT * FROM tblOrderLine
where ixOrder in ('9548233','9586134')  





/*
select * from tblJob where ixJob = '87-2'

select * from tblJob 
where ixJob like '43%'
order by ixDepartment, sJobSort


select * from tblJob 
where ixJob like '87%'
order by ixDepartment, sJobSort


select * from tblJob 
where sDescription like '%Ship%'
order by ixDepartment, sJobSort




87-2	SP Verify	2	87

SELECT * FROM tblDepartment 


MAIN 43-2	Small Pack Verifying
SUB1 43-3	Small Pack Packing
SUB2 43-8	Shipping
SUB3 43-9	Truck Loading
SUB4 43-12	Returns
     43-13	Misc Non Production
     43-14	Cleaning/Restock
     43-15	Break


43-1	AZ Outbound

43-4	Big Pack Printing
43-5	Big Pack Picking
43-6	Big Pack Verifying
43-7	Big Pack Packing

43-10	Smalls V&P
43-11	Unknown


SELECT * FROM tblIPAddress
where sGroup = 'Small Pack'
and ixLocation = 85

SELECT * FROM tblIPAddress
where ixLocation = 85

sGroup = 'Small Pack'

select distinct sJob
from tblJobClock
where sJob like '43-%'
and dtDate >= '06/01/20'
order by sJob
*/


SELECT FORMAT(JC.dtDate,'yyyy.MM.dd') 'Date', JC.ixEmployee, JC.sJob, J.sDescription 'JobDescr', 
    T1.chTime 'StartTime', 
    T2.chTime 'EndTime',
    JC.iStartTime, JC.iStopTime,
    (JC.iStopTime-JC.iStartTime) 'TotSec',
    --(JC.iStopTime-JC.iStartTime)/60.00 'TotMins',
    (JC.iStopTime-JC.iStartTime)/3600.00 'TotHrs'
FROM tblJobClock JC
    left join tblJob J on JC.sJob = J.ixJob
    left join tblTime T1 on T1.ixTime = JC.iStartTime
    left join tblTime T2 on T2.ixTime = JC.iStopTime
where JC.ixDate >= 19156	-- 06/11/2020	THUR
    --and JC.ixEmployee in ('BMN','KDW1','SCN')
    and JC.sJob in ('43-4','43-5','43-6','43-7')
order by JC.ixEmployee, JC.iStartTime







select * from tblJobclock


SELECT sGroup, count(*)
FROM tblIPAddress
where ixLocation = 85
GROUP BY sGroup
