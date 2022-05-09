-- Grant Employee Report Access Permissions

-- Employee Info
SELECT @@SPID as 'Current SPID' -- 136

SELECT ixEmployee, sFirstname, sLastname, sEmailAddress
FROM tblEmployee
where ixEmployee in ('VMF','CAM1','WAS') -- like 'W%S%'
  and flgCurrentEmployee = 1

/*      sFirst      sLast
ixEmp   name	    name	sEmailAddress
=====   ========    ======= ====================================
CAM1	CODY	    MUTH	CAMUTH@SPEEDWAYMOTORS.COM
VMF	    VICTORIA	FORD	VMFORD@SPEEDWAYMOTORS.COM
WAS	    WYATT	    SCHUTTE	WASCHUTTE@SPEEDWAYMOTORS.COM
*/



