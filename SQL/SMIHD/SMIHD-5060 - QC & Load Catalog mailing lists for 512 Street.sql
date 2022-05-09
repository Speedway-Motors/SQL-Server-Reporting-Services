--  SMIHD-5060 - QC & Load Catalog mailing lists for 512 Street
  -- previous CST case = SMIHD-4641

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD5060_CustFile_512

-- GLOBALLY REPLACE the following:
    /*
        PJC_SMIHD5060_CustFile_512
        PJC_SMIHD5060_CustOffers_512    
        '512%'
        '512'  
        512
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
BEFORE  461         362
AFTER   461         362
*/    


SELECT ixCatalog 'Cat#',sDescription 'Description',sMarket 'Mkt',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate',
    iQuantityPrinted 'QtyPrinted'
FROM [SMI Reporting].dbo.tblCatalogMaster 
WHERE ixCatalog = '512'
/*
Cat#	Description	    Mkt	StartDate	EndDate	    QtyPrinted
512	    '16 FALL SR	    SR	09/12/2016	10/10/2017	215000
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixCatalog = '512' -- ixSourceCode LIKE '512%' -- 12 at 8 PM
ORDER BY ixCatalog, ixSourceCode
-- 35 source codes assigned to ixCatalog 512
/*
Source
Code	sDescription
51200E	SHOW AND EVENT
51202	LOYALISTS SREV42
51203	NURTURERS SREV42
51204	1&2XBUYERS SREV42
51205	UNDERPERFORM SREV42
51206	WINBACKS SREV42 +OFFER
51207	FADERS SREV42 +OFFER
51210	CST 12M CREATED AFTER REFRESH
51211	12M $100+ COVERAGE ROUNDOUT
51250	VENDOR BUYERS
51260	MR ROADSTER DEALERS
51270	3M REQUESTORS SR +OFFER
51292	COUNTER
51296	CANADA STREET DHL
51298	DHL BULK CENTER
51299	REQUEST IN PACKAGE
*/
-- check for Source codes with similar prefix to current catalog
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '512%'
and ixCatalog <> '512' 
ORDER BY ixSourceCode  -- 
/*
ixSource
Code	sDescription
5121	HAWKEYEMAY5
5122	OLDCARSGUIDE04
5123	OLDCPRICERACE
5124	OLDCARDPRGUI04
5127	STRSCNJUL04


select * from tblMarket

*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '512%'
  AND ixCatalog = '512' 
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- none
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '512%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '512'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- none

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
-- BEFORE CHANGES
Select ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512   
group by ixSourceCode
order by ixSourceCode

/*
ixSource
Code	Qty
51202	63766
51203	51019
51204	58116
51205	19600
51206	1089
51207	8410
51210	6114
51211	17942
51270	6123
*/
-- DROP TABLE PJC_SMIHD5060_CustFile_512

/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512  
    /*      Distinct
    AllCnt	Count	Delta
   232,179	228,913	3266
    */    

    -- DUPE Customers found
    select ixCustomer--, count(*) -- 3,266 duplicate customers 
    into [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom51211 -- temp table for deleting them
    from  [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
    group by ixCustomer
    having count(*) > 1   
    order by count(*) desc

    -- examples
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
    WHERE ixCustomer in ('2665769','2547468','2561661','2681568','2675067','2503764','2566367','2611664','2514664','2587767')
    ORDER BY ixCustomer  

    BEGIN TRAN
        DELETE from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512  -- 3,266
        where ixSourceCode = '51211'
            and ixCustomer in (select ixCustomer from [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom51211)
    ROLLBACK TRAN                     

    -- Verify dupe remove worked
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512  
    /*
    AllCnt	DistinctCount	Delta
    228913	228913	        0
    */
    
    
/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn

-- 
    SELECT *
    -- DELETE -- 81 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'SR' -- Street             <-- BE SURE TO CHANGE TO CURRENT CATALOG MARKET!!!!!
                         /* 2B	TBucket
                            AD	AFCO/Dynatech
                            R	Race
                            SM	SprintMidget
                            SR	StreetRod */
                               and MOI.sOptInStatus = 'N')

/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * 
    -- DELETE -- 576 customer removed
    FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * 
    FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                                
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD5060_CustFile_512  
    /*
    AllCnt	DistinctCount	Delta
    228,256	228,256	        0
    */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
51202	63752
51203	51005
51204	58108
51205	19595
51206	1088
51207	8406
51210	6113
51211	14066
51270	6123
*/

/**********  Load Customer Offers into SOP  ***********
    Customer offers may be loaded AFTER
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Alaina provided expected counts already and the delta on her list vs the counts to load is < 1%
*/             
    select ixCustomer,',',ixSourceCode 
    from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD5060_CustOffers_512.txt
    
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load
    
    takes approx 5 mins for 300K records to load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's in the ticket already) 

    In-home date for Catalog #512 = 04/04/16
    
When they are done loading DO NOT ENTER "OK" YET to "consolodate your lists"
open a new instance of SOP and MANUALLY refeed all of todays offers to DW. (speeds range anywhere from 43 to 250 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to load a customer file and give him an
ETA (# of records/2.1)/3600 hours) on when it should finish.

THEN 
    enter OK on you 1st SOP connection to begin the CUST record update

kicked off at 8:05 finished at 8:28  
**********/
 
 
-- Customers in Offer table for Cat 512
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (   -- customers expected to load
                        select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (   -- customers actually loaded
                        select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '512' 
                        group by SC.ixSourceCode, SC.sDescription 
                       -- order by SC.ixSourceCode
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '512' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
                                    Qty to      Qty
                                    load        LOADED
SCode	Description	                into SOP	in SOP	Delta
51200E	SHOW AND EVENT	NULL	0	0
51202	LOYALISTS SREV42	63752	63729	-23
51203	NURTURERS SREV42	51005	50999	-6
51204	1&2XBUYERS SREV42	58108	58090	-18
51205	UNDERPERFORM SREV42	19595	19593	-2
51206	WINBACKS SREV42 +OFFER	1088	1088	0
51207	FADERS SREV42 +OFFER	8406	8405	-1
51210	CST 12M CREATED AFTER REFRESH	6113	6113	0
51211	12M $100+ COVERAGE ROUNDOUT	14066	14063	-3
51250	VENDOR BUYERS	NULL	0	0
51260	MR ROADSTER DEALERS	NULL	0	0
51270	3M REQUESTORS SR +OFFER	6123	6121	-2
51292	COUNTER	NULL	0	0
51296	CANADA STREET DHL	NULL	0	0
51298	DHL BULK CENTER	NULL	0	0
51299	REQUEST IN PACKAGE	NULL	0	0
*/

-- DETAILS on customers that did NOT get their customer offers loaded
        select CF.*, 
            C.ixCustomer, C.flgDeletedFromSOP, C.ixCustomerType, C.sCustomerType, C.sMailingStatus
        from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512 CF
        left join tblCustomer C on CF.ixCustomer = C.ixCustomer
where CF.ixCustomer NOT IN ( select distinct CO.ixCustomer
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '512' )
-- 100 customer flagged as deleted FROM SOP in the last 30 days

                 
                        
                                                

   
/* after verifying the Delta's from above check are acceptable
   enter OK in SOP to start the CUST update routine.
   It is currently VERY slow at about 3 rec/sec and 
   CAN TAKE UP TO 50 HOURS to complete depending on # of records.
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
    WHERE SC.ixCatalog = '512' 
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */                
      
/*
  
-- kicked off customer offer load routine 05/31/16 3:16PM     .... finished 
--  262,106 records in file
               
Current                                                         ETA @
Count     Time      Rec Fed Mins    Sec     Rec/Sec     Remaining   Current rate    ETA
======= =======     ======= ====    ======= =======     =========   ============    ===========
      0 13:03 Sat          
 28,600 16:26        28,600 203     12,180  2.3         230,779     27.9 hours      ~8:30PM SUN   
177,400 09:52 Sun   148,800         62,760  2.3          81,979     
259,324 21:18 Sun   259,324 1,935  116,100  2.2   

*/  



/***********    CUST LOADING SPEEDS    ********************************* 
          
    CAT#    RECORDS SECONDS Rec/Sec Date        Day Loaded
    ====    ======= ======= ======= ========    ==========
    364      32,040   1,139    28.1 06-26-13    Friday
    354     330,968  18,118    18.3 07-22-13    Monday
    355     239,006  33,388     7.2 09-11-13    Tuesday
    377     265,994  41,260     6.4 12-06-13    Friday (ran during production hours)
       /********** CLOAK 2.0 launched ***********/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    388     377,093	 46,236		8.1	06-19-14	Thursday (ran during production hours) 
    389     405,920  63,000     6.4 07-22-14    Tuesday (kicked off at 11:01 AM, ran straight thru until completed 4:29AM Wed) 
    390     242,902  39,438     6.2 09-04-14    Thursday (kicked off at 11:11 AM) 
    382     177,308  57,600     3.1 09-30-14    Tuesday (kicked off at 9:45 AM)
    402     259,379 116,100     2.2 01-11-15    Sat 1:03PM finished Sun 9:18 PM
    403		262,106  85,200     3.1 02-12-15	Thursday 1:23PM finished Fri 1:03PM
    504     297,877 103,608     2.9 04-16-15    Kicked off Thur 4/16/15 @11:19AM
    405     301,884 103,800     2.9 04-24-15
    700      60,077  25,656     2.3 05-12-15    
    505     350,364 123,676     2.8 05-31-15    
    506     280,870  98,930     2.8 07-21-15    kicked off routine TUE 7/21/15 @6:00PM (approx)  
    507     294,490 127,894     2.3 09-17-15    kicked off routine WED 9/17/15 @7:145PM  
    406     118,223  44,002     2.7 09-29-15
    508     288,264 101,585     2.8 12-13-15
    407     177,594 
    904      
**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_SMIHD5060_CustFile_512_FINAL CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '512%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_SMIHD1574_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '512%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_SMIHD5060_CustFile_512_FINAL CST
 JOIN PJC_SMIHD1574_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 507 ONLY  ******************************/
none

-- COMPLETE THE REMAINING STEPS 



-- NOTE --  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

-- details on Customers that "failed to load" into tblCustomerOffer
-- most should be recently changed mail status or merged customers that are now flagged as deleted
select ixCustomer 'Cust #'
    , sMailingStatus+'    ' as 'MailingStatus' 
    , flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '512' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1278330	0    	0
1908620	0    	0
156303	0    	0
778123	0    	0

-- 44 were deleted from SOP

*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer,CST.ixSourceCode --ixCustomer
            from [SMITemp].dbo.PJC_SMIHD5060_CustFile_512 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '512%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            
            SELECT COUNT(*) Qty, C.sMailingStatus 'Status', C.flgDeletedFromSOP
            from [SMI Reporting].dbo.tblCustomer C
            where ixCustomer in ('2479247','1171745','375007','1721188','1918731','1722407','1325038','397326','1483369','1669856','1406935','2466243','846897','2061843','2187345','1569083','1569984','1653083','1640621','2000649','2437040','1123686','2399942','2882732','2411147','1059338','1782119','1224338','1648121','190251')
            group by C.flgDeletedFromSOP, C.sMailingStatus
            /*
                Qty	Status	flgDeletedFromSOP
                3	NULL	1
                4	0	    0
                23	0	    1    
                */                
      
      
      select * from tblCustomerOffer 
      where ixSourceCode like '512%'
      and dtDateLastSOPUpdate = '05/31/2016'
      
      