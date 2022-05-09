-- tblPackage checks
/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblPackage%'
--  ixErrorCode	sDescription
--  1149	    Failure to update tblPackage

-- ERROR COUNTS by Day
    SELECT --dtDate, 
        DB_NAME() AS 'DB          '
        ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1149'
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months '05/06/2014'
    GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc

/*
DB          	Date    	ErrorQty
SMI Reporting	07/02/2015	71
SMI Reporting	07/01/2015	5
SMI Reporting	06/02/2015	174     <-- issue when adding flgReplaced... resolved
SMI Reporting	06/24/2014	1
SMI Reporting	07/05/2013	332
SMI Reporting	06/28/2013	104

AFCOReporting   NONE as of 10-5-15
*/

/************************************************************************/
-- TABLE GROWTH
exec spGetTableGrowth tblPackage
/*
DB          	TABLE       	Rows   	Date
SMI Reporting	tblPackage	4,288,324	02-01-17
SMI Reporting	tblPackage	4,220,765	01-01-17    ^353k
SMI Reporting	tblPackage	3,867,154	07-01-16    ^465k
SMI Reporting	tblPackage	3,402,189	01-01-16    ^682k
SMI Reporting	tblPackage	2,719,446	01-01-15    ^730k
SMI Reporting	tblPackage	2,090,781	01-01-14    ^600k
SMI Reporting	tblPackage	1,490,393	01-01-13
SMI Reporting	tblPackage	1,006,459	03-01-12

AFCOReporting	tblPackage	223,894	    10-01-15
AFCOReporting	tblPackage	215,901	    07-01-15
AFCOReporting	tblPackage	196,773	    01-01-15
AFCOReporting	tblPackage	182,217	    07-01-14
AFCOReporting	tblPackage	165,241	    01-01-14
AFCOReporting	tblPackage	159,500	    10-01-13
*/


/**********************************
*****   REFEED FAILED PACKAGES   ******
***********************************/ 
-- REFED all failed PACKAGES from #### to #### @12/31/2013
                    
-- 1) COUNT ERRORS
    select * --count(*)  -- #### total errors          
    from tblErrorLogMaster
    where dtDate >=  '02/01/2017' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1149   
    -- and ixTime >= 43000
-- 2) EXTRACT SKUS from the sError field                                    
    -- 29 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_Packages_toRefeed  
    -- DROP TABLE [SMITemp].dbo.PJC_Packages_toRefeed 
    INSERT into [SMITemp].dbo.PJC_Packages_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*' then replace(substring(sError,27,200),'*%','')
              when sError like '%*' then replace(substring(sError,27,200),'*%','')
              else replace(substring(sError,27,200),' failed to update','')
              end
              )'sTrackingNumber'
    into [SMITemp].dbo.PJC_Packages_toRefeed                      
    from tblErrorLogMaster
    where ixErrorCode = 1149
        and dtDate >= '01/01/2017' -- dtDate >=  DATEADD(month, -1, getdate()) -- past X months
    order by 'sTrackingNumber' 

    select sTrackingNumber, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    from tblSKU where sTrackingNumber in ('1011001402','1825303','2752005','5478361','603CUSTOM','603WAIST','60528500','63012-A','63012-C','63025-BLK-7',
                                '6304000','820BC4812','820BC4912','820BC4941','820BCAC4872','820BCAC4912','820BCAC4931','820BZAC4871','820Z4872','820Z4912',
                                '820Z4971','820Z4981','820Z4981FH','820ZAC4912','820ZAC4931','820ZAC4981','820ZAC5041','820ZAC5091','9171015LSPH')

                                      
    -- HOW MANY EXIST IN tblSKU ?
    select * from tblPackage SKU -- 35 out of 35
    join [SMITemp].dbo.PJC_Packages_toRefeed RF on SKU.sTrackingNumber = RF.sTrackingNumber
    
    
-- 3) REFEED these Packages from SOP
    select distinct sTrackingNumber from [SMITemp].dbo.PJC_Packages_toRefeed    

    select ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
     SELECT RF.sTrackingNumber
    FROM [SMITemp].dbo.PJC_Packages_toRefeed RF
        left join tblBOMTemplateMaster TM on RF.sTrackingNumber = TM.ixFinishedSKU

/*******   DONE   **********************/

select count(*) from tblBOMTransferMaster -- 44,940 
where dtDateLastSOPUpdate < '01/31/2014'    -- 44,881

select min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate) from tblBOMTransferMaster
42777	44310

select chTime from 

select count(*) from tblBOMTransferDetail --179943 
where dtDateLastSOPUpdate < '01/31/2014'    -- 179748


select * from tblErrorCode where ixErrorCode = 1160

-- CHECKING NEW FIELD
select * from tblPackage where ixShipTNT is NULL
and ixVerificationDate >= 16803


select count(*) PkgCnt, ixShipTNT
from tblPackage
where ixVerificationDate >= 16803
group by ixShipTNT
order by ixShipTNT 

select count(sTrackingNumber) PkgCnt, ixShipTNT
from tblPackage
where ixVerificationDate >= 16803
group by ixShipTNT
order by ixShipTNT 

select O.iShipMethod, count(P.sTrackingNumber) 
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
where O.dtShippedDate >= '05/01/2014'
and P.ixShipTNT = 0
group by O.iShipMethod

    
/* AFCO 01/01/14 TO 05/15/14
Pkg
Count	ixShipTNT
7	    NULL
5506	0
1502	1
4361	2
839	    3
626	    4
9	    5
1	    6

SMI 01/01/14 TO 05/15/14
PkgCnt	ixShipTNT
240064	NULL
3488	0
2714	1
6299	2
3845	3
723	    4
26	    5
*/

--
ixShip
TNT	    PkgCount
NULL	2336153
0	    11239
70	    2
96	    482
97	    17
99	    1

select *
from tblPackage
where ixShipTNT > 10

select ixShipTNT, count(*)
from tblPackage
where ixVerificationDate >= 16933
group by ixShipTNT

select * from tblPackage
where ixShipTNT = 0
order by newid()

-- AFCO
SELECT sTrackingNumber
from tblPackage
where ixVerificationDate >= 16803



SELECT P.ixVerifier, COUNT(O.ixOrder)
FROM tblPackage P 
join [SMITemp].dbo.PJC_Packages_toRefeed RF on P.sTrackingNumber = RF.sTrackingNumber
join tblOrder O on P.ixOrder = O.ixOrder
where O.dtOrderDate > '01/16/2017'
group by P.ixVerifier
order by P.dBillingWeight

order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate

SELECT * from tblTime where ixTime = 49983


SELECT * FROM [SMITemp].dbo.PJC_Packages_toRefeed RF
JOIN tblPackage P on RF.sTrackingNumber = P.sTrackingNumber
order by dtDateLastSOPUpdate

select sTrackingNumber, dtDateLastSOPUpdate, flgCanceled, flgReplaced
from tblPackage 
where ixOrder in ('6539963','6622062')