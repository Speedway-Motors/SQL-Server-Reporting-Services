--  SMIHD-8675 - QC & Load Catalog mailing lists for 519 STREET
  -- previous CST case = SMIHD-8565

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD8675_CustFile_414

/* GLOBALLY REPLACE THE FOLLOWING:
        8675 <-- SMIHD CASE
        519
*/  
    
/***********  UPDATE DECEASED EXEMPT LIST  **********/
    -- execute & record results from the next 2 queries BEFORE & AFTER running <10> Update deceased exempt list in SOP's Reporting Menu  
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
    BEFORE  445         373
    AFTER   445         373
    */    



/***********  REVIEW LIST OF MARKETS    ***********/
    select * from tblMarket order by ixMarket    -- #ofMarkets = 16?     YES
    /*
    Mkt	sDescription             
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
  



/******   VALIDATE CATALOG DATA   *******/
        SELECT ixCatalog 'Cat#',sMarket 'Mkt',sDescription 'Description',
            CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate ',
            CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate   ',
            CONVERT(VARCHAR(10), D.dtDate, 101) AS 'InHomeDate',
            iQuantityPrinted 'QtyPrinted'
        FROM [SMI Reporting].dbo.tblCatalogMaster CM
            left join tblDate D on CM.ixInHomeDate = D.ixDate
        WHERE ixCatalog like '519%'
        ORDER BY ixStartDate desc, ixCatalog
        /*
        Are Market and all date fields identical?  NO
                                                                        Qty
        Cat#	Mkt	Description 	StartDate 	EndDate   	InHomeDate	Printed
        =====   === =============== ==========  ==========  ==========  =======
        519	    SR	'17 NOV STREET	10/30/2017	11/27/2018	11/13/2017	190,000
        519N	SR	NO MAIL W/ 519	10/30/2017	11/13/2017	11/13/2017	 20,000
        519P	SR	MAILER W/ 519	10/30/2017	11/13/2018	11/13/2017	 20,000     
        */



/******   VALIDATE SOURCE CODE DATA   *******/
    SELECT SC.ixCatalog 'Cat ', SC.ixSourceCode 'SoureCode', SC.sCatalogMarket 'CatMkt', SC.sSourceCodeType 'SCType',
    CONVERT(VARCHAR(10), SC.dtStartDate, 101) AS 'SCStartDate',
                CONVERT(VARCHAR(10), SC.dtEndDate, 101) AS 'SCEndDate ',
                SC.sDescription 'SC Description'
    FROM [SMI Reporting].dbo.tblSourceCode SC
    WHERE ixCatalog like '519%' -- ixSourceCode LIKE '519%' -- 12 at 8 PM
    ORDER BY ixCatalog, ixSourceCode

    /*      Soure   Cat         SC          SC          
    Cat     Code	Mkt	SCType	StartDate	EndDate 	SC Description
    ===     ======= === ======  =========   ==========  ========================================
    519	    51902	SR	CAT-H	10/30/2017	11/13/2018	LOYALISTS SREV42 NO OFFER
    519	    51902A	SR	CAT-H	10/30/2017	11/13/2018	LOYALISTS SREV42 + OFFER
    519	    51903	SR	CAT-H	10/30/2017	11/13/2018	NURTURERS SREV42 NO OFFER
    519	    51903A	SR	CAT-H	10/30/2017	11/13/2018	NURTURERS SREV42 + OFFER
    519	    51904	SR	CAT-H	10/30/2017	11/13/2018	1&2XBUYERS SREV42 NO OFFER
    519	    51904A	SR	CAT-H	10/30/2017	11/13/2018	1&2XBUYERS SREV42 + OFFER
    519	    51905	SR	CAT-H	10/30/2017	11/13/2018	UNDERPERFORMERS SREV42 NO OFFER
    519	    51905A	SR	CAT-H	10/30/2017	11/13/2018	UNDERPERFORMERS SREV42 + OFFER
    519	    51906	SR	CAT-H	10/30/2017	11/13/2018	WINBACKS SREV42 NO OFFER
    519	    51906A	SR	CAT-H	10/30/2017	11/13/2018	WINBACKS SREV42 + OFFER
    519	    51907	SR	CAT-H	10/30/2017	11/13/2018	FADERS SREV42 NO OFFER
    519	    51907A	SR	CAT-H	10/30/2017	11/13/2018	FADERS SREV42 + OFFER
    519	    51908	SR	CAT-H	10/30/2017	11/13/2018	CST 12MO POOL NOT IN LB ACTIVES
    519	    51960	SR	CAT-H	10/30/2017	11/13/2018	MR ROADSTER DEALERS
    519	    51992	SR	CAT-H	10/30/2017	11/13/2018	COUNTER
    519	    51996	SR	CAT-R	10/30/2017	11/13/2018	CANADA THE MAIL GROUP BULK CENTER
    519	    51998	SR	CAT-R	10/30/2017	11/13/2018	THE MAIL GROUP BULK CENTER
    519	    51999	SR	CAT-H	10/30/2017	11/13/2018	REQUEST IN PACKAGE
    519	    519E	SR	CAT-E	10/30/2017	11/13/2018	SHOW AND EVENT
    519N	51902N	SR	CAT-H	10/30/2017	11/13/2018	LOYALISTS SREV42 NO MAILING
    519N	51903N	SR	CAT-H	10/30/2017	11/13/2018	NURTURERS SREV42 NO MAILING
    519N	51904N	SR	CAT-H	10/30/2017	11/13/2018	1&2XBUYERS SREV42 NO MAILING
    519N	51905N	SR	CAT-H	10/30/2017	11/13/2018	UNDERPERFORMERS SREV42 NO MAILING
    519N	51906N	SR	CAT-H	10/30/2017	11/13/2018	WINBACKS SREV42 NO MAILING
    519N	51907N	SR	CAT-H	10/30/2017	11/13/2018	FADERS SREV42 NO MAILING
    519P	51902P	SR	CAT-H	10/30/2017	11/13/2018	LOYALISTS STEV42 MAILER NO OFFER
    519P	51902PA	SR	CAT-H	10/30/2017	11/13/2018	LOYALISTS SREV42 MAILER + OFFER
    519P	51903P	SR	CAT-H	10/30/2017	11/13/2018	NURTURERS SREV42 MAILER NO OFFER
    519P	51903PA	SR	CAT-H	10/30/2017	11/13/2018	NURTURERS SREV42 MAILER + OFFER
    519P	51904P	SR	CAT-H	10/30/2017	11/13/2018	1&2XBUYERS SREV42 MAILER NO OFFER
    519P	51904PA	SR	CAT-H	10/30/2017	11/13/2018	1&2XBUYERS SREV42 MAILER + OFFER
    519P	51905P	SR	CAT-H	10/30/2017	11/13/2018	UNDERPERFORMERS SREV42 MAILER NO OFFER
    519P	51905PA	SR	CAT-H	10/30/2017	11/13/2018	UNDERPERFORMERS SREV42 MAILER + OFFER
    519P	51906P	SR	CAT-H	10/30/2017	11/13/2018	WINBACKS SREV42 MAILER NO OFFER
    519P	51906PA	SR	CAT-H	10/30/2017	11/13/2018	WINBACKS SREV42 MAILER + OFFER
    519P	51907P	SR	CAT-H	10/30/2017	11/13/2018	FADERS SREV42 MAILER NO OFFER
    519P	51907PA	SR	CAT-H	10/30/2017	11/13/2018	FADERS SREV42 MAILER + OFFER
    */


    -- SCS with similar prefix to current catalog
    SELECT ixSourceCode ,ixCatalog,sCatalogMarket,  CONVERT(VARCHAR(10), dtStartDate, 101) AS 'SCStartDate', CONVERT(VARCHAR(10), dtEndDate, 101) AS 'SCEndDate', sDescription 
    FROM [SMI Reporting].dbo.tblSourceCode 
    WHERE ixSourceCode LIKE '519%'
        and (dtStartDate <> '10/30/2017'
             OR
             dtEndDate <> '11/13/2018')
    ORDER BY CONVERT(VARCHAR(10), dtStartDate, 101), ixCatalog, ixSourceCode 
    /*
    Source      Cat Start       End
    Code	CAT Mkt Date	    Date        Description
    ======= === === ==========  ==========  =================
    5191	220	SM	07/19/2004	02/27/2005	SPRINT/MIDSPE04
    5190	221	SR	08/02/2004	04/21/2005	GOODGUYSSEPT04
    5199	219	R	09/13/2004	01/16/2005	CIRTRKCATNOV04
    5192	221	SR	09/13/2004	04/21/2005	STRSCENE
    */


    -- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
    SELECT ixSourceCode
         , sDescription
    FROM [SMI Reporting].dbo.tblSourceCode 
    WHERE ixSourceCode LIKE '519%'
      AND ixCatalog = '519' 
      AND (LEN(ixSourceCode) < 5
            OR LEN(ixSourceCode) > 6)
    -- 519E	SHOW AND EVENT   valid
  
    -- SC's with identical descriptions  
    SELECT sDescription, COUNT(*) 'SCs' 
    FROM [SMI Reporting].dbo.tblSourceCode 
    WHERE ixSourceCode LIKE '519%'
      AND LEN(ixSourceCode) >= 5
        AND ixCatalog like '519%'  
    GROUP BY   sDescription
    HAVING COUNT(*) > 1
    -- NONE

        --if results from above
          SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
          WHERE sDescription = '<DUPED DESCRIPTION>'
          -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL
      
      























/*******   IMPORT & VALIDATE DATA FROM "Customer File for PJC to Load for 519.xlsx" to [SMITemp].dbo.PJC_SMIHD8675_CustFile_519    **************/

    -- DROP TABLE [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
    Select ixSourceCode, COUNT(*) Qty
    from [SMITemp].dbo.PJC_SMIHD8675_CustFile_519   
    group by  ixSourceCode
    order by  ixSourceCode

    /*
    ixSource
    Code	Qty
    ======= =====       31 SCs
    51902	62763
    51902A	3809
    51902N	3765
    51902P	3826
    51902PA	3917
    51903	44652
    51903A	2652
    51903N	2718
    51903P	2707
    51903PA	2673
    51904	33756
    51904A	2099
    51904N	2080
    51904P	2018
    51904PA	1966
    51905	17428
    51905A	1040
    51905N	1083
    51905P	1053
    51905PA	1047
    51906	2405
    51906A	160
    51906N	136
    51906P	156
    51906PA	141
    51907	3996
    51907A	240
    51907N	218
    51907P	240
    51907PA	256
    51908	4226
    */


    -- Invalid Customer Numbers 
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

    -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE




/*******   CLEAN DATA IN [SMITemp].dbo.PJC_SMIHD8675_CustFile_519    **************/

    -- Check for DUPE CUSTOMERS   
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519  
    /*      Distinct
    AllCnt	Count	Delta
    209226	209226	0
    */    
    
        -- IF DUPE Customers found
        select ixCustomer--, count(*) -- 3,266 duplicate customers 
        into [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#### -- temp table for deleting them
        from  [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
        group by ixCustomer
        having count(*) > 1   
        order by count(*) desc

        -- examples
        SELECT * FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
        WHERE ixCustomer in ('2665769','2547468','2561661','2681568','2675067','2503764','2566367','2611664','2514664','2587767')
        ORDER BY ixCustomer  

        BEGIN TRAN
            DELETE from [SMITemp].dbo.PJC_SMIHD8675_CustFile_519  -- 3,266
            where ixSourceCode = '51811'
                and ixCustomer in (select ixCustomer from [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#####)
        ROLLBACK TRAN                     

        -- Verify dupe remove worked
        select COUNT(*) AS 'AllCnt' 
             , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
             ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
        FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519  
        /*
        AllCnt	DistinctCount	Delta

        */    
        
    -- verify Customers only have US addresses        
    SELECT COUNT(*), C.sMailToCountry
    FROM tblCustomer C
    join [SMITemp].dbo.PJC_SMIHD8675_CustFile_519 CF on C.ixCustomer = CF.ixCustomer        
    GROUP BY C.sMailToCountry
    /*
    1	    CANADA
    209225	NULL
    */

-- REMOVE OPT-OUTS for Campaign Market 
    select top 10 * from [SMI Reporting].dbo.tblMailingOptIn
 
    select ixMarket, COUNT(*) 
    from  [SMI Reporting].dbo.tblMailingOptIn
    group by   ixMarket                            
    /*
    ixMarket	
    2B	1961984
    AD	1961983
    MC	1961984
    R	1961984
    SM	1961984
    SR	1961984
    */

    SELECT *
    -- DELETE -- 17 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519 
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
                               


    --  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
     
        -- competitor,deceased, or "do not mail" status                            
        SELECT * 
        -- DELETE -- 51 customer removed
        FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519 
        WHERE ixCustomer IN (SELECT ixCustomer
                             FROM [SMI Reporting].dbo.tblCustomer C
                             where C.sMailingStatus in ('9','8','7'))
                                           

         -- known competitors
        SELECT * 
        FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519 
        WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                              ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                              ,'212358','496845','824335','847314','761053','776728')
        -- NONE
                                    
        select COUNT(*) AS 'AllCnt' 
             , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
             ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
        FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519  
        /*      Distinct
        AllCnt	Count	    Delta
        209,158	209,158	0
        */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
51902	62746
51902A	3809
51902N	3764
51902P	3826
51902PA	3915
51903	44640
51903A	2652
51903N	2717
51903P	2707
51903PA	2672
51904	33743
51904A	2098
51904N	2080
51904P	2017
51904PA	1963
51905	17419
51905A	1040
51905N	1083
51905P	1052
51905PA	1045
51906	2405
51906A	160
51906N	136
51906P	156
51906PA	141
51907	3992
51907A	240
51907N	218
51907P	240
51907PA	256
51908	4226
*/






/**********  Load Customer Offers into SOP  ***********
    Customer offers may be loaded AFTER
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Delta of the counts to load vs. Alaina's expected counts file < 1%
*/             
    SELECT ixCustomer,',',ixSourceCode 
    FROM [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
    ORDER BY ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD8675_CustOffers_519.txt
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load
    
    approx load speed 225 rec/sec or  5 mins for 300K records to load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's not already in the ticket) 

    In-home date for Catalog 519 = 10/30/17
   
      
when they are done loading MANUALLY refeed all of todays offers to DW. (speeds range anywhere from 43 to 250 rec/sec) 

Compare Qty in SOP to the file.  If delta's are acceptable, update final counts by SC file.
Attach file to case with comments telling Alaiana that:
QC checks were passed, offers loaded, and that she can finish remaining manual steops.

**********/
 
-- Customers in Offer table for Cat 519
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description          ',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (   -- customers expected to load
                        select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD8675_CustFile_519
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (   -- customers actually loaded
                        select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog LIKE '519%'
                        group by SC.ixSourceCode, SC.sDescription 
                       -- order by SC.ixSourceCode
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog LIKE '519%' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
                                        Qty to      Qty
                                        load        LOADED
SCode	Description	                    into SOP	in SOP	Delta

*/  

-- DETAILS on customers that did NOT get their customer offers loaded
        select CF.*, 
            C.ixCustomer, C.flgDeletedFromSOP, C.ixCustomerType, C.sCustomerType, C.sMailingStatus
        from [SMITemp].dbo.PJC_SMIHD8675_CustFile_519 CF
        left join tblCustomer C on CF.ixCustomer = C.ixCustomer
where CF.ixCustomer NOT IN ( select distinct CO.ixCustomer
                        from [SMI Reporting].dbo.tblSourceCode SC 
                             join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog LIKE '519%' )
-- 52 customer flagged as deleted FROM SOP in the last 30 days

   
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
    WHERE SC.ixCatalog = '519' 
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */                

                   

