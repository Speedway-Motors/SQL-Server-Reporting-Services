--  SMIHD-8562 - QC & Load Catalog mailing lists for 414 RACE
  -- previous CST case = SMIHD-7101

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD8562_CustFile_414

/* GLOBALLY REPLACE THE FOLLOWING:
        8562 <-- SMIHD CASE
        414
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
    BEFORE  447         371
    AFTER   445         373
    */    



/***********  REVIEW LIST OF MARKETS    ***********/
    select * from tblMarket order by ixMarket
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
    -- #ofMarkets = 16?     YES



/******   VALIDATE CATALOG DATA   *******/
        SELECT ixCatalog 'Cat#',sMarket 'Mkt',sDescription 'Description',
            CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate ',
            CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate   ',
            CONVERT(VARCHAR(10), D.dtDate, 101) AS 'InHomeDate',
            iQuantityPrinted 'QtyPrinted'
        FROM [SMI Reporting].dbo.tblCatalogMaster CM
            left join tblDate D on CM.ixInHomeDate = D.ixDate
        WHERE ixCatalog like '414%'
        ORDER BY ixStartDate desc, ixCatalog
        /*
        Are Market and all date fields identical?  NO
                                                                        Qty
        Cat#	Mkt	Description 	StartDate 	EndDate   	InHomeDate	Printed
        =====   === =============== ==========  ==========  ==========  =======
        414	    R	'17 OCT RACE	10/16/2017	11/13/2018	10/30/2017	110,000
        414N	SR	NO MAIL W/ 414	10/16/2017	10/30/2018	10/30/2017	 10,000
        414P	R	MAILER W/ 414	10/16/2017	10/30/2018	10/30/2017	 10,000
        */



/******   VALIDATE SOURCE CODE DATA   *******/
    SELECT SC.ixCatalog 'Cat ', SC.ixSourceCode 'SoureCode', SC.sCatalogMarket 'CatMkt', SC.sSourceCodeType 'SCType',
    CONVERT(VARCHAR(10), SC.dtStartDate, 101) AS 'SCStartDate',
                CONVERT(VARCHAR(10), SC.dtEndDate, 101) AS 'SCEndDate ',
                SC.sDescription 'SC Description'
    FROM [SMI Reporting].dbo.tblSourceCode SC
    WHERE ixCatalog like '414%' -- ixSourceCode LIKE '414%' -- 12 at 8 PM
    ORDER BY ixCatalog, ixSourceCode

    /*      Soure   Cat         SC          SC          
    Cat 	Code	Mkt	SCType	StartDate	EndDate 	SC Description
    ====    ======= === ======  =========   ==========  ========================================
    414	    41402	R	CAT-H	10/16/2017	10/30/2018	LOYALISTS REV42 NO OFFER
    414	    41402A	R	CAT-H	10/16/2017	10/30/2018	LOYALISTS REV42 + OFFER
    414	    41403	R	CAT-H	10/16/2017	10/30/2018	NURTURERS REV42 NO OFFER
    414	    41403A	R	CAT-H	10/16/2017	10/30/2018	NURTURERS REV42 + OFFER
    414	    41404	R	CAT-H	10/16/2017	10/30/2018	1&2XBUYERS REV42 NO OFFER
    414	    41404A	R	CAT-H	10/16/2017	10/30/2018	1&2XBUYERS REV42 + OFFER
    414	    41405	R	CAT-H	10/16/2017	10/30/2018	UNDERPERFORMERS REV42 NO OFFER
    414	    41405A	R	CAT-H	10/16/2017	10/30/2018	UNDERPERFORMERS REV42 + OFFER
    414	    41406	R	CAT-H	10/16/2017	10/30/2018	WINBACKS REV42 NO OFFER
    414	    41406A	R	CAT-H	10/16/2017	10/30/2018	WINBACKS REV42 + OFFER
    414	    41407	R	CAT-H	10/16/2017	10/30/2018	FADERS REV42 NO OFFER
    414	    41407A	R	CAT-H	10/16/2017	10/30/2018	FADERS REV42 + OFFER
    414	    41408	R	CAT-H	10/16/2017	10/30/2018	CST 12MO POOL NOT IN LB ACTIVES
    414	    41460	R	CAT-H	10/16/2017	10/30/2018	PRO RACER DEALERS
    414	    41492	R	CAT-H	10/16/2017	10/30/2018	COUNTER
    414	    41496	R	CAT-R	10/16/2017	10/30/2018	THE MAIL GROUP CANADA BULK CENTER
    414	    41498	R	CAT-R	10/16/2017	10/30/2018	THE MAIL GROUP BULK CENTER
    414	    41499	R	CAT-H	10/16/2017	10/30/2018	REQUEST IN PACKAGE
    414	    414E	R	CAT-E	10/16/2017	10/30/2018	SHOW AND EVENT
    414N	41402N	SR	CAT-H	10/16/2017	10/30/2018	LOYALISTS REV42 NO MAILING
    414N	41403N	SR	CAT-H	10/16/2017	10/30/2018	NURTURERS REV42 NO MAILING
    414N	41404N	SR	CAT-H	10/16/2017	10/30/2018	1&2XBUYERS REV42 NO MAILING
    414N	41405N	SR	CAT-H	10/16/2017	10/30/2018	UNDERPERFORMERS REV42 NO MAILING
    414N	41406N	SR	CAT-H	10/16/2017	10/30/2018	WINBACKS REV42 NO MAILING
    414N	41407N	SR	CAT-H	10/16/2017	10/30/2018	FADERS REV42 NO MAILING
    414P	41402P	R	CAT-H	10/16/2017	10/30/2018	LOYALISTS REV42 MAILER NO OFFER
    414P	41402PA	R	CAT-H	10/16/2017	10/30/2018	LOYALISTS REV42 MAILER + OFFER
    414P	41403P	R	CAT-H	10/16/2017	10/30/2018	NURTURERS REV42 MAILER NO OFFER
    414P	41403PA	R	CAT-H	10/16/2017	10/30/2018	NURTURERS REV42 MAILER + OFFER
    414P	41404P	R	CAT-H	10/16/2017	10/30/2018	1&2XBUYERS REV42 MAILER NO OFFER
    414P	41404PA	R	CAT-H	10/16/2017	10/30/2018	1&2XBUYERS REV42 MAILER + OFFER
    414P	41405P	R	CAT-H	10/16/2017	10/30/2018	UNDERPERFORMERS REV42 MAILER NO OFFER
    414P	41405PA	R	CAT-H	10/16/2017	10/30/2018	UNDERPERFORMERS REV42 MAILER + OFFER
    414P	41406P	R	CAT-H	10/16/2017	10/30/2018	WINBACKS REV42 MAILER NO OFFER
    414P	41406PA	R	CAT-H	10/16/2017	10/30/2018	WINBACKS REV42 MAILER + OFFER
    414P	41407P	R	CAT-H	10/16/2017	10/30/2018	FADERS REV42 MAILER NO OFFER
    414P	41407PA	R	CAT-H	10/16/2017	10/30/2018	FADERS REV42 MAILER + OFFER
    */


    -- SCS with similar prefix to current catalog
    SELECT ixSourceCode ,ixCatalog,sCatalogMarket,  CONVERT(VARCHAR(10), dtStartDate, 101) AS 'SCStartDate', CONVERT(VARCHAR(10), dtEndDate, 101) AS 'SCEndDate', sDescription 
    FROM [SMI Reporting].dbo.tblSourceCode 
    WHERE ixSourceCode LIKE '414%'
        and (dtStartDate <> '10/16/2017'
             OR
             dtEndDate <> '10/30/2018')
    ORDER BY CONVERT(VARCHAR(10), dtStartDate, 101), ixCatalog, ixSourceCode 
    /*
    Source      Cat Start       End
    Code	CAT Mkt Date	    Date        Description
    ======= === === ==========  ==========  =================
    4140	212	R	02/10/2003	02/17/2004	MIDWESTRACFEB03
    4141	209	UK	03/03/2003	01/20/2003	HEMMINGROD
    4142	212	R	03/03/2003	02/17/2004	HEMMINGSRACE
    4143	213	SR	03/03/2003	06/13/2004	HEMMINGSSTREET
    4146	213	SR	03/03/2003	06/13/2004	DEALSWHLSCAT
    4144	BD03PC	03/03/2003	09/02/2004	HEMMINGSBLUDIA
    4148	212	R	04/07/2003	02/17/2004	CIRTRK JUNE 03
    4147	213	SR	04/14/2003	06/13/2004	STRRODDERJUNE03
    */


    -- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
    SELECT ixSourceCode
         , sDescription
    FROM [SMI Reporting].dbo.tblSourceCode 
    WHERE ixSourceCode LIKE '414%'
      AND ixCatalog = '414' 
      AND (LEN(ixSourceCode) < 5
            OR LEN(ixSourceCode) > 6)
    -- 414E	SHOW AND EVENT   valid
  
    -- SC's with identical descriptions  
    SELECT sDescription, COUNT(*) 'SCs' 
    FROM [SMI Reporting].dbo.tblSourceCode 
    WHERE ixSourceCode LIKE '414%'
      AND LEN(ixSourceCode) >= 5
        AND ixCatalog like '414%'  
    GROUP BY   sDescription
    HAVING COUNT(*) > 1
    -- NONE

        --if results from above
          SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
          WHERE sDescription = '<DUPED DESCRIPTION>'
          -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL
      
      








/*******   IMPORT & VALIDATE DATA FROM "Customer File for PJC to Load for 414.xlsx" to [SMITemp].dbo.PJC_SMIHD8562_CustFile_414    **************/

    -- DROP TABLE [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
    Select ixSourceCode, COUNT(*) Qty
    from [SMITemp].dbo.PJC_SMIHD8562_CustFile_414   
    group by  ixSourceCode
    order by  ixSourceCode

    /*
    ixSource
    Code	Qty
    ======= =====       31 SCs
    41402	50610
    41402A	5620
    41402N	4075
    41402P	5690
    41402PA	5688
    41403	20077
    41403A	2251
    41403N	1625
    41403P	2209
    41403PA	2216
    41404	15285
    41404A	1722
    41404N	1233
    41404P	1625
    41404PA	1706
    41405	2792
    41405A	281
    41405N	208
    41405P	312
    41405PA	253
    41406	236
    41406A	21
    41406N	15
    41406P	39
    41406PA	32
    41407	1000
    41407A	105
    41407N	81
    41407P	125
    41407PA	105
    41408	5131
    */


    -- Invalid Customer Numbers 
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

    -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE




/*******   CLEAN DATA IN [SMITemp].dbo.PJC_SMIHD8562_CustFile_414    **************/

    -- Check for DUPE CUSTOMERS   
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414  
    /*      Distinct
    AllCnt	Count	Delta
    132368	132368	0
    */    
    
        -- IF DUPE Customers found
        select ixCustomer--, count(*) -- 3,266 duplicate customers 
        into [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#### -- temp table for deleting them
        from  [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
        group by ixCustomer
        having count(*) > 1   
        order by count(*) desc

        -- examples
        SELECT * FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
        WHERE ixCustomer in ('2665769','2547468','2561661','2681568','2675067','2503764','2566367','2611664','2514664','2587767')
        ORDER BY ixCustomer  

        BEGIN TRAN
            DELETE from [SMITemp].dbo.PJC_SMIHD8562_CustFile_414  -- 3,266
            where ixSourceCode = '51811'
                and ixCustomer in (select ixCustomer from [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#####)
        ROLLBACK TRAN                     

        -- Verify dupe remove worked
        select COUNT(*) AS 'AllCnt' 
             , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
             ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
        FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414  
        /*
        AllCnt	DistinctCount	Delta

        */    
        
    -- verify Customers only have US addresses        
    SELECT C.sMailToCountry, COUNT(*)        
    FROM tblCustomer C
    join [SMITemp].dbo.PJC_SMIHD8562_CustFile_414 CF on C.ixCustomer = CF.ixCustomer        
    GROUP BY C.sMailToCountry


-- REMOVE OPT-OUTS for Campaign Market 
    select top 10 * from [SMI Reporting].dbo.tblMailingOptIn
 
    select ixMarket, COUNT(*) 
    from  [SMI Reporting].dbo.tblMailingOptIn
    group by   ixMarket                            
    /*
    ixMarket	
    2B	1955955
    AD	1955954
    MC	1955955
    R	1955955
    SM	1955955
    SR	1955955
    */

    SELECT *
    -- DELETE -- 35 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'R' -- Street             <-- BE SURE TO CHANGE TO CURRENT CATALOG MARKET!!!!!
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
        -- DELETE -- 11 customer removed
        FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414 
        WHERE ixCustomer IN (SELECT ixCustomer
                             FROM [SMI Reporting].dbo.tblCustomer C
                             where C.sMailingStatus in ('9','8','7'))
                                           

         -- known competitors
        SELECT * 
        FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414 
        WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                              ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                              ,'212358','496845','824335','847314','761053','776728')
        -- NONE
                                    
        select COUNT(*) AS 'AllCnt' 
             , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
             ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
        FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414  
        /*      Distinct
        AllCnt	Count	    Delta
        132,322	132,322	        0
        */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
41402	50589
41402A	5614
41402N	4072
41402P	5688
41402PA	5684
41403	20069
41403A	2251
41403N	1625
41403P	2209
41403PA	2216
41404	15284
41404A	1722
41404N	1233
41404P	1625
41404PA	1706
41405	2791
41405A	281
41405N	208
41405P	312
41405PA	253
41406	236
41406A	21
41406N	15
41406P	39
41406PA	32
41407	1000
41407A	105
41407N	81
41407P	125
41407PA	105
41408	5131

*/






/**********  Load Customer Offers into SOP  ***********
    Customer offers may be loaded AFTER
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Delta of the counts to load vs. Alaina's expected counts file < 1%
*/             
    SELECT ixCustomer,',',ixSourceCode 
    FROM [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
    ORDER BY ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD8562_CustOffers_414.txt
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load
    
    approx load speed 225 rec/sec or  5 mins for 300K records to load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's not already in the ticket) 

    In-home date for Catalog 414 = 10/30/17
   
      
when they are done loading MANUALLY refeed all of todays offers to DW. (speeds range anywhere from 43 to 250 rec/sec) 

Compare Qty in SOP to the file.  If delta's are acceptable, update final counts by SC file.
Attach file to case with comments telling Alaiana that:
QC checks were passed, offers loaded, and that she can finish remaining manual steops.

**********/
 
-- Customers in Offer table for Cat 414
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description          ',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (   -- customers expected to load
                        select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD8562_CustFile_414
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (   -- customers actually loaded
                        select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog LIKE '414%'
                        group by SC.ixSourceCode, SC.sDescription 
                       -- order by SC.ixSourceCode
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog LIKE '414%' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
                                        Qty to      Qty
                                        load        LOADED
SCode	Description	                    into SOP	in SOP	Delta
41402	LOYALISTS REV42 NO OFFER	50589	50574	-15
41402A	LOYALISTS REV42 + OFFER	5614	5612	-2
41402N	LOYALISTS REV42 NO MAILING	4072	NULL	-4072
41402P	LOYALISTS REV42 MAILER NO OFFER	5688	NULL	-5688
41402PA	LOYALISTS REV42 MAILER + OFFER	5684	NULL	-5684
41403	NURTURERS REV42 NO OFFER	20069	20060	-9
41403A	NURTURERS REV42 + OFFER	2251	2251	0
41403N	NURTURERS REV42 NO MAILING	1625	NULL	-1625
41403P	NURTURERS REV42 MAILER NO OFFER	2209	NULL	-2209
41403PA	NURTURERS REV42 MAILER + OFFER	2216	NULL	-2216
41404	1&2XBUYERS REV42 NO OFFER	15284	15273	-11
41404A	1&2XBUYERS REV42 + OFFER	1722	1722	0
41404N	1&2XBUYERS REV42 NO MAILING	1233	NULL	-1233
41404P	1&2XBUYERS REV42 MAILER NO OFFER	1625	NULL	-1625
41404PA	1&2XBUYERS REV42 MAILER + OFFER	1706	NULL	-1706
41405	UNDERPERFORMERS REV42 NO OFFER	2791	2791	0
41405A	UNDERPERFORMERS REV42 + OFFER	281	281	0
41405N	UNDERPERFORMERS REV42 NO MAILING	208	NULL	-208
41405P	UNDERPERFORMERS REV42 MAILER NO OFFER	312	NULL	-312
41405PA	UNDERPERFORMERS REV42 MAILER + OFFER	253	NULL	-253
41406	WINBACKS REV42 NO OFFER	236	236	0
41406A	WINBACKS REV42 + OFFER	21	21	0
41406N	WINBACKS REV42 NO MAILING	15	NULL	-15
41406P	WINBACKS REV42 MAILER NO OFFER	39	NULL	-39
41406PA	WINBACKS REV42 MAILER + OFFER	32	NULL	-32
41407	FADERS REV42 NO OFFER	1000	1000	0
41407A	FADERS REV42 + OFFER	105	105	0
41407N	FADERS REV42 NO MAILING	81	NULL	-81
41407P	FADERS REV42 MAILER NO OFFER	125	NULL	-125
41407PA	FADERS REV42 MAILER + OFFER	105	NULL	-105
41408	CST 12MO POOL NOT IN LB ACTIVES	5131	5130	-1
41460	PRO RACER DEALERS	NULL	0	0
41492	COUNTER	NULL	0	0
41496	THE MAIL GROUP CANADA BULK CENTER	NULL	0	0
41498	THE MAIL GROUP BULK CENTER	NULL	0	0
41499	REQUEST IN PACKAGE	NULL	0	0
414E	SHOW AND EVENT	NULL	0	0
*/  

-- DETAILS on customers that did NOT get their customer offers loaded
        select CF.*, 
            C.ixCustomer, C.flgDeletedFromSOP, C.ixCustomerType, C.sCustomerType, C.sMailingStatus
        from [SMITemp].dbo.PJC_SMIHD8562_CustFile_414 CF
        left join tblCustomer C on CF.ixCustomer = C.ixCustomer
where CF.ixCustomer NOT IN ( select distinct CO.ixCustomer
                        from [SMI Reporting].dbo.tblSourceCode SC 
                             join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog LIKE '414%' )
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
    WHERE SC.ixCatalog = '414' 
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */                

                   

