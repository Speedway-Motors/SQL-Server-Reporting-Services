--  SMIHD-7603 - QC & Load Catalog mailing lists for 517 Street
  -- previous CST case = SMIHD-7101

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD7603_CustFile_517

-- GLOBALLY REPLACE the following:
    /*SMIHD-7603
        PJC_SMIHD7603_CustFile_517
        PJC_SMIHD7603_CustOffers_517    
        '517%'
        '517'  
        517
    */  
    
/***********  Update deceased exempt list   **********/
-- execute the following 2 queries BEFORE & AFTER running 
-- the <10> Update deceased exempt list in SOP's Reporting Menu 
    SELECT COUNT(*) 'Deceased'
    FROM [SMI Reporting].dbo.tblCustomer    
    WHERE sMailingStatus = '8' AND flgDeletedFromSOP = 0 
    
    SELECT COUNT(*) 'DeceasedExempt'
    FROM [SMI Reporting].dbo.tblCustomer 
    WHERE flgDeceasedMailingStatusExempt = 1
      AND flgDeletedFromSOP = 0  
/*                  Deceased
When    Deceased    Exempt      
======  =======     ======           
BEFORE  449         370
AFTER   449         370
*/    


SELECT ixCatalog 'Cat#',sDescription 'Description',sMarket 'Mkt',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate',
    iQuantityPrinted 'QtyPrinted'
FROM [SMI Reporting].dbo.tblCatalogMaster 
WHERE ixCatalog = '517'
/*
Cat#	Description	    Mkt	StartDate	EndDate	    QtyPrinted
unable to verify, catalog built same day
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixCatalog = '517' -- ixSourceCode LIKE '517%' -- 12 at 8 PM
ORDER BY ixCatalog, ixSourceCode
-- 11 source codes assigned to ixCatalog 517
/*
Source
Code	sDescription            #of SCs = 25
51702	LOYALISTS SREV42
51702U	LOYALISTS SREV42 NOT IN 511/516
51703	NURTURERS SREV42
51703U	NURTURERS SREV42 NOT IN 511/516
51704	1&2XBUYERS SREV42
51704U	1&2XBUYERS SREV42 NOT IN 511/516
51705	UNDERPERFORMERS SREV42
51705U	UNDERPERFORMERS SREV42 NOT IN 511/516
51706	WINBACKS SREV42
51706U	WINBACKS SREV42 NOT IN 511/516
51707	FADERS SREV42
51707U	FADERS SREV42 NOT IN 511/516
51708	CST 12M POOL
51709	CST 24M POOL
51710	CST 36M POOL
51711	CST 48M POOL
51760	MR ROADSTER DEALERS
51770	3M REQUESTORS
51771	6M REQUESTORS
51772	9M REQUESTORS
51792	COUNTER
51796	CANADA MAIL GROUP BULK CENTER
51798	MAIL GROUP BULK CENTER
51799	REQUEST IN PACKAGE
517E	SHOW AND EVENT
*/
-- check for Source codes with similar prefix to current catalog
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '517%'
and ixCatalog <> '517' 
ORDER BY ixSourceCode  -- 
/*
ixSource
Code	sDescription
5179	ELBOWSUP


select * from tblMarket
ixMarket	sDescription        #ofMarkets = 16
2B	TBucket
AD	AFCO/Dynatech
B	BothRaceStreet
CR	Canadian Race
CT	Canadian Street
G	Generic
MC	MuscleCar
Other	Other
PC	PedalCar
R	Race
SC	SportCompact
SE	Safety Equipment
SM	SprintMidget
SR	StreetRod
TE	Tools&Equip
UK	Unknown
*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '517%'
  AND ixCatalog = '517' 
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- 517E	SHOW AND EVENTS   valid
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '517%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '517'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- none

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '<DUPED DESCRIPTION>'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL


/*******   IMPORT FROM txt file to PJC_SMIHD7603_CustFile_517    **************/

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
Select ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD7603_CustFile_517   
group by ixSourceCode
order by ixSourceCode

/*
ixSource
Code	Qty
51702	70123
51702U	731
51703	54031
51703U	162
51704	71464
51704U	34370
51705	24663
51705U	318
51706	1894
51706U	870
51707	9831
51707U	339
51708	9356
51709	255
51710	257
51711	235
51770	1784
51771	156
51772	20
*/


/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517  
    /*      Distinct
    AllCnt	Count	Delta
    280859	280859	0
    */    

    -- DUPE Customers found
    select ixCustomer--, count(*) -- 3,266 duplicate customers 
    into [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#### -- temp table for deleting them
    from  [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
    group by ixCustomer
    having count(*) > 1   
    order by count(*) desc

    -- examples
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
    WHERE ixCustomer in ('2665769','2547468','2561661','2681568','2675067','2503764','2566367','2611664','2514664','2587767')
    ORDER BY ixCustomer  

    BEGIN TRAN
        DELETE from [SMITemp].dbo.PJC_SMIHD7603_CustFile_517  -- 3,266
        where ixSourceCode = '51711'
            and ixCustomer in (select ixCustomer from [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#####)
    ROLLBACK TRAN                     

    -- Verify dupe remove worked
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517  
    /*
    AllCnt	DistinctCount	Delta

    */
    
    
/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn

-- 
    SELECT *
    -- DELETE -- 34 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'SR' -- Street             <-- BE SURE TO CHANGE TO CURRENT CATALOG MARKET!!!!!
                         /* 2B	TBucket
                            AD	AFCO/Dynatech
                            MC  Muscle Car
                            R	Race
                            SM	SprintMidget
                            SR	StreetRod */
                               and MOI.sOptInStatus = 'N')
                               
select ixMarket, COUNT(*) from  [SMI Reporting].dbo.tblMailingOptIn
group by   ixMarket                            
/*
ixMarket	
2B	1905403
AD	1905402
MC	1905403
R	1905403
SM	1905403
SR	1905403
*/

/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * 
    -- DELETE -- 109 customer removed
    FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * 
    FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                                
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517  
    /*      Distinct
    AllCnt	Count	    Delta
    280,716	280,716	    0
    */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
51702	70083
51702U	730
51703	53996
51703U	162
51704	71429
51704U	34366
51705	24646
51705U	318
51706	1893
51706U	870
51707	9822
51707U	339
51708	9356
51709	255
51710	257
51711	235
51770	1783
51771	156
51772	20
*/

/**********  Load Customer Offers into SOP  ***********
    Customer offers may be loaded AFTER
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Delta of the counts to load vs. Alaina's expected counts file < 1%
*/             
    SELECT ixCustomer,',',ixSourceCode 
    FROM [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
    ORDER BY ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD7603_CustOffers_517.txt
    
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load
    
    takes approx 5 mins for 300K records to load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's not already in the ticket) 

    In-home date for Catalog #517 = 05/30/17
    
When they are done loading MANUALLY refeed all of todays offers to DW. (speeds range anywhere from 43 to 250 rec/sec) 

Compare Qty in SOP to the file.  If delta's are acceptable, update final counts by SC file.
Attach file to case with comments telling Alaiana that:
QC checks were passed, offers loaded, and that she can finish remaining manual steops.

**********/
 
-- Customers in Offer table for Cat 517
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description          ',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (   -- customers expected to load
                        select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD7603_CustFile_517
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (   -- customers actually loaded
                        select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '517' 
                        group by SC.ixSourceCode, SC.sDescription 
                       -- order by SC.ixSourceCode
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '517' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
                                        Qty to      Qty
                                        load        LOADED
SCode	Description	                    into SOP	in SOP	Delta
51702	LOYALISTS SREV42	70083	69964	-119
51702U	LOYALISTS SREV42 NOT IN 511/516	730	730	0
51703	NURTURERS SREV42	53996	53960	-36
51703U	NURTURERS SREV42 NOT IN 511/516	162	162	0
51704	1&2XBUYERS SREV42	71429	71239	-190
51704U	1&2XBUYERS SREV42 NOT IN 511/516	34366	34352	-14
51705	UNDERPERFORMERS SREV42	24646	24629	-17
51705U	UNDERPERFORMERS SREV42 NOT IN 511/516	318	318	0
51706	WINBACKS SREV42	1893	1891	-2
51706U	WINBACKS SREV42 NOT IN 511/516	870	870	0
51707	FADERS SREV42	9822	9819	-3
51707U	FADERS SREV42 NOT IN 511/516	339	339	0
51708	CST 12M POOL	9356	9355	-1
51709	CST 24M POOL	255	255	0
51710	CST 36M POOL	257	257	0
51711	CST 48M POOL	235	235	0
51760	MR ROADSTER DEALERS	NULL	0	0
51770	3M REQUESTORS	1783	1783	0
51771	6M REQUESTORS	156	156	0
51772	9M REQUESTORS	20	20	0
51792	COUNTER	NULL	0	0
51796	CANADA MAIL GROUP BULK CENTER	NULL	0	0
51798	MAIL GROUP BULK CENTER	NULL	0	0
51799	REQUEST IN PACKAGE	NULL	0	0
517E	SHOW AND EVENT	NULL	0	0
*/  

-- DETAILS on customers that did NOT get their customer offers loaded
        select CF.*, 
            C.ixCustomer, C.flgDeletedFromSOP, C.ixCustomerType, C.sCustomerType, C.sMailingStatus
        from [SMITemp].dbo.PJC_SMIHD7603_CustFile_517 CF
        left join tblCustomer C on CF.ixCustomer = C.ixCustomer
where CF.ixCustomer NOT IN ( select distinct CO.ixCustomer
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '517' )
-- 100 customer flagged as deleted FROM SOP in the last 30 days

   
/* 
    run the CUST routine by selecting Customer <U>pdates

ETA (# of records/2.1)/3600 hours) on when it should finish.
kicked off at 8:05 finished at 8:28  

*/
    -- kicked off routine 9/16/15 @7:45PM (approx)      ETA 7:15 pm 7/22/15
     -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 294552  -- <-- total amount of customer offers in the CST campaign that's loading
    SELECT 
        CONVERT(VARCHAR, GETDATE(), 8)    AS 'As Of   '
        ,@QtyToLoad 'TotQty'
        ,count(CO.ixCustomer) 'Loaded'
        , (@QtyToLoad-count(CO.ixCustomer)) 'ToGo'
    --   ,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as 'SecRun'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 'Rec/Sec'
       --,CONVERT(DECIMAL(10,0),(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *60.00) as 'Rec/Min'
        ,CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00)) as 'Rec/Hr'
       ,(@QtyToLoad-count(CO.ixCustomer))/(CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00))) as 'EstHrsToFinish'
    FROM [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    WHERE SC.ixCatalog = '517' 
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */                

                   

/*************   SPECIAL NOTES FOR CAT 507 ONLY  ******************************/
none

