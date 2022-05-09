-- SMIHD-2903 - Noah Topil not receiving PO emails
select * from tblEmployee where ixEmployee like 'N%T'
/*
ixEmployee	sLastname	sFirstname
NFT	        TOPIL	    NOAH
*/


-- PO count by SHOP Employees
select POM.ixIssuer, 
    E.sFirstname, E.sLastname,
    count(POM.ixPO) POsIssuedYTD
from tblPOMaster POM
    left join tblEmployee E on POM.ixIssuer = E.ixEmployee
where ixDepartment = 7
    and flgCurrentEmployee = 1
    and POM.ixPODate >= 17168 -- 1/1/15
group by POM.ixIssuer, E.sFirstname, E.sLastname                
/*                                  POsIssued
ixIssuer	sFirstname	sLastname	YTD
DGS	        DOUG	    SCHMIDT	    84
DWW     	DAVID	    WALLACE	    32
LDS	        LARRY	    SCHACHER	76
NFT	        NOAH	    TOPIL	    6
*/

SPEEDWAYMOTORS\dgschmidt
SPEEDWAYMOTORS\nftopil

-- Noah's POs
select ixPO,	
ixPODate,	
-- ixIssueDate,	 --  issue date was the same as the PODate for all 6
ixIssuer,	ixBuyer,	ixVendor,
flgBlanket,	
flgIssued,	flgOpen,	sEmailAddress 
from tblPOMaster
where ixIssuer = 'NFT'
or ixBuyer = 'NFT'

/*                                           flg     flg     flg
ixPO	ixPODate	Issuer	Buyer	Vendor	Blanket	Issued	Open	sEmailAddress
106341	17392	    NFT	    CRD	    2891	0	    1	    0	    AHHANKS@speedwaymotors.com
107494	17442	   	NFT	    VLJ	    2891	0	    1	    0	    AHHANKS@speedwaymotors.com
107738	17455	    NFT	    NFT	    1423	0	    1	    0	    AHHANKS@speedwaymotors.com
108469	17494	    NFT	    NFT	    0916	0	    1	    0	    NFTOPIL@speedwaymotors.com
108545	17496	    NFT	    NFT	    0916	0	    1	    0	    NFTOPIL@speedwaymotors.com
108733	17504	    NFT	    NFT	    2891	0	    1	    1	    LDSCHACHER@speedwaymotors.com
*/

select * from tblPOMaster
where ixPO = '27894'


select ixDate, dtDate 
from tblDate where ixDate in (17392,17442,17455,17494,17496,17504)
order by ixDate
/*
ixDate	dtDate
17392	2015-08-13
17442	2015-10-02
17455	2015-10-15
17494	2015-11-23
17496	2015-11-25
17504	2015-12-03
*/

/* TRACE LOGS TO SEE IF THE CALL TO EXEC_PO IS BEING MADE */

-- DROP TABLE [SMITemp].dbo.PJC_Trace_DOMINO_01052016 
SELECT * FROM [SMITemp].dbo.PJC_Trace_DOMINO_01052016           -- 2 rows @ 1/4/16 6:20PM
-- where StartTime between '2016-01-05 14:52:37.710' and '2016-01-05 14:54:37.710'
where TextData like '%PO%'

-- DROP TABLE [SMITemp].dbo.PJC_Trace_DWStaging1_01052016 
SELECT * FROM [SMITemp].dbo.PJC_Trace_DWStaging1_01052016           -- 2 rows @ 1/4/16 6:20PM
where TextData like '%spExecPOReport%'

SELECT * FROM [SMITemp].dbo.PJC_Trace_DW1_01052016           -- 2 rows @ 1/4/16 6:20PM
where TextData like '%spExecPOReport%'

SELECT * FROM [SMITemp].dbo.PJC_Trace_NoahFTopil_DWStaging1_01042016    -- 2 rows @ 1/4/16 6:20PM
where TextData like '%spExecPOReport%'

SELECT * FROM [SMITemp].dbo.PJC_Trace_NoahFTopil_DW1_01042016    -- 2 rows @ 1/4/16 6:20PM
where TextData like '%spExecPOReport%'



-- DROP TABLE [SMITemp].dbo.PJC_Trace_NoahFTopil_DWStaging1_01082016 
SELECT * FROM [SMITemp].dbo.PJC_Trace_NoahFTopil_DWStaging1_01082016    -- 2 rows @ 1/4/16 6:20PM
where TextData like '%spExecPOReport%'




select ixPO,	
ixPODate,	
-- ixIssueDate,	 --  issue date was the same as the PODate for all 6
ixIssuer,	ixBuyer,	ixVendor,
flgBlanket,	
flgIssued,	flgOpen,	sEmailAddress 
from tblPOMaster
where ixIssuer in (select ixEmployee from tblEmployee 
                    where ixDepartment = 7
                        and flgCurrentEmployee = 1
                        )
and ixPODate >= 17168
                        
                        




-- YTD PO count by employee COMPANY WIDE
select POM.ixIssuer, 
    E.sFirstname, E.sLastname,
    count(POM.ixPO) POsIssuedYTD
from tblPOMaster POM
    left join tblEmployee E on POM.ixIssuer = E.ixEmployee
where -- ixDepartment = 7
   -- flgCurrentEmployee = 1
    POM.ixPODate >= 17168 -- 1/1/15
group by POM.ixIssuer, E.sFirstname, E.sLastname  
ORDER BY  count(POM.ixPO) DESC  




SELECT * from tblEmployee where ixEmployee like 'K%V'