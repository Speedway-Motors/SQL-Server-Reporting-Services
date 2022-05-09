--  SMIHD-3897 - QC & Load Catalog mailing lists for 409 Race
  -- previous CST case = SMIHD-3819

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD3897_CustFile_409

-- GLOBALLY REPLACE the following:
    /*
        PJC_SMIHD3897_CustFile_409
        PJC_SMIHD3897_CustOffers_409    
        '409%'
        '409'  
        409
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
BEFORE  463         363
AFTER   463         363
*/    


SELECT ixCatalog 'Cat#',sDescription 'Description',sMarket 'Mkt',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate',
    iQuantityPrinted 'QtyPrinted'
FROM [SMI Reporting].dbo.tblCatalogMaster 
WHERE ixCatalog = '409'
/*
Cat#	Description	    Mkt	StartDate	EndDate	    QtyPrinted
409	    '16 ER SMR RACE	R	05/09/2016	05/23/2017	163000
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixCatalog = '409' -- ixSourceCode LIKE '409%' -- 12 at 8 PM
ORDER BY ixCatalog, ixSourceCode
-- 35 source codes assigned to ixCatalog 409
/*
Source
Code	sDescription
40900E	SHOW AND EVENT
40902	LOYALISTS REV42
40902C	LOYALISTS REV42 WITH OFFER
40902R	LOYALISTS REV42 1ST RACE '16
40903	NURTURERS REV42
40903C	NURTURERS REV42 WITH OFFER
40903R	NURTURERS REV42 1ST RACE '16
40904	1&2XBUYERS REV42
40904C	1&2XBUYERS REV42 WITH OFFER
40904R	1&2XBUYERS REV42 1ST RACE '16
40904U	1&2XBUYERS REV42 1ST MAIL '16
40905C	UNDERPERFORM REV42 WITH OFFER
40905R	UNDERPERFORM REV42 1ST RACE '16
40905U	UNDERPERFORM REV42 1ST MAIL '16
40906C	WINBACKS REV42 WITH OFFER
40906R	WINBACKS REV42 1ST RACE '16
40906U	WINBACKS REV42 1ST MAIL '16
40907C	FADERS REV42 WITH OFFER
40907R	FADERS REV42 1ST RACE '16
40908	CST 12M POOL
40908R	CST 12M POOL 1ST RACE '16
40908U	CST 12M POOL 1ST MAIL '16
40915	SPRINT TARGETED
40915C	SPRINT TARGETED WITH OFFER
40915R	SPRINT TARGETED 1ST RACE '16
40915U	SPRINT TARGETED 1ST MAIL '16
40950	VENDOR BUYERS
40960	PRO RACER DEALERS
40970C	12M RACE REQUESTORS WITH OFFER
40980C	12M SPRINT REQUESTORS WITH OFFER
40990C	IMCA RENTAL LIST WITH OFFER
40992	COUNTER
40996	CANADA RACE DHL
40998	DHL BULK CENTER
40999	REQUEST IN PACKAGE
*/
-- check for Source codes with similar prefix to current catalog
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '409%'
and ixCatalog <> '409' 
ORDER BY ixSourceCode  -- 
/*
ixSource
Code	sDescription
4090	SPEEDSCN FEB03
4091	CIRTRK MAY 03
4092	CIR TRK MAY03
4093	CLASTRU MAY03
4095	PERF RAC MAR03

select * from tblMarket

*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '409%'
  AND ixCatalog = '409' 
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- none
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '409%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '409'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- none

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
-- BEFORE CHANGES
Select ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	Qty
40902	32746
40902C	110
40902R	30293
40903	10174
40903C	6093
40903R	6781
40904	20370
40904C	10380
40904R	9991
40904U	82
40905C	5185
40905R	584
40905U	1
40906C	725
40906R	161
40906U	14
40907C	1078
40907R	43
40908	686
40908R	353
40908U	2819
40915	4653
40915C	945
40915R	572
40915U	250
40970C	687
40980C	262
*/
-- DROP TABLE PJC_SMIHD3897_CustFile_409

/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD3897_CustFile_409  
    /*      Distinct
    AllCnt	Count	Delta
   146038	146038	0
    */    
    

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn

-- 
    SELECT *
    -- DELETE -- 6 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD3897_CustFile_409 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'R' -- Race             <-- BE SURE TO CHANGE TO CURRENT CATALOG MARKET!!!!!
                         /* 2B	TBucket
                            AD	AFCO/Dynatech
                            R	Race
                            SM	SprintMidget
                            SR	StreetRod */
                               and MOI.sOptInStatus = 'N')

/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * 
    -- DELETE -- 29 customer removed
    FROM [SMITemp].dbo.PJC_SMIHD3897_CustFile_409 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD3897_CustFile_409 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                                
    select count(CF.ixCustomer) CustCount,
    count(distinct(CF.ixCustomer)) DistCustCnt
    from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409 CF
    /*
    CustCount	DistCustCnt
    146003	    146003
    */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
40902	32733
40902C	110
40902R	30290
40903	10174
40903C	6091
40903R	6780
40904	20367
40904C	10374
40904R	9991
40904U	81
40905C	5182
40905R	584
40905U	1
40906C	724
40906R	161
40906U	14
40907C	1078
40907R	43
40908	686
40908R	353
40908U	2819
40915	4651
40915C	945
40915R	572
40915U	250
40970C	687
40980C	262
*/

/**********  Load Customer Offers into SOP AFTER ***********
    Customer offers may be loaded AFTER
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Alaina provided expected counts already and the delta on her list vs the counts to load is < 1%
*/             
    select ixCustomer,',',ixSourceCode 
    from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD3897_CustOffers_409.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load
    
    takes approx 5 mins for 300K records to load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's in the ticket already) 

    In-home date for Catalog #409 = 04/04/16
    
When they are done loading DO NOT ENTER "OK" YET to "consolodate your lists"
open a new instance of SOP and MANUALLY refeed all of todays offers to DW. (speeds range anywhere from 43 to 250 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to load a customer file and give him an
ETA (# of records/2.1)/3600 hours) on when it should finish.

THEN 
    enter OK on you 1st SOP connection to begin the CUST record update

kicked off at 8:05 finished at 8:28  
**********/
 
 
-- Customers in Offer table for Cat 409
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (   -- customers expected to load
                        select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (   -- customers actually loaded
                        select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '409' 
                        group by SC.ixSourceCode, SC.sDescription 
                       -- order by SC.ixSourceCode
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '409' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
                                    Qty to      Qty
                                    load        LOADED
SCode	Description	                into SOP	in SOP	Delta
40900E	SHOW AND EVENT	NULL	0	0
40902	LOYALISTS REV42	32733	32690	-43
40902C	LOYALISTS REV42 WITH OFFER	110	110	0
40902R	LOYALISTS REV42 1ST RACE '16	30290	30287	-3
40903	NURTURERS REV42	10174	10167	-7
40903C	NURTURERS REV42 WITH OFFER	6091	6089	-2
40903R	NURTURERS REV42 1ST RACE '16	6780	6777	-3
40904	1&2XBUYERS REV42	20367	20319	-48
40904C	1&2XBUYERS REV42 WITH OFFER	10374	10368	-6
40904R	1&2XBUYERS REV42 1ST RACE '16	9991	9987	-4
40904U	1&2XBUYERS REV42 1ST MAIL '16	81	79	-2
40905C	UNDERPERFORM REV42 WITH OFFER	5182	5181	-1
40905R	UNDERPERFORM REV42 1ST RACE '16	584	584	0
40905U	UNDERPERFORM REV42 1ST MAIL '16	1	1	0
40906C	WINBACKS REV42 WITH OFFER	724	724	0
40906R	WINBACKS REV42 1ST RACE '16	161	161	0
40906U	WINBACKS REV42 1ST MAIL '16	14	14	0
40907C	FADERS REV42 WITH OFFER	1078	1078	0
40907R	FADERS REV42 1ST RACE '16	43	43	0
40908	CST 12M POOL	686	686	0
40908R	CST 12M POOL 1ST RACE '16	353	353	0
40908U	CST 12M POOL 1ST MAIL '16	2819	2818	-1
40915	SPRINT TARGETED	4651	4645	-6
40915C	SPRINT TARGETED WITH OFFER	945	944	-1
40915R	SPRINT TARGETED 1ST RACE '16	572	572	0
40915U	SPRINT TARGETED 1ST MAIL '16	250	250	0
40950	VENDOR BUYERS	NULL	0	0
40960	PRO RACER DEALERS	NULL	0	0
40970C	12M RACE REQUESTORS WITH OFFER	687	687	0
40980C	12M SPRINT REQUESTORS WITH OFFER	262	262	0
40990C	IMCA RENTAL LIST WITH OFFER	NULL	0	0
40992	COUNTER	NULL	0	0
40996	CANADA RACE DHL	NULL	0	0
40998	DHL BULK CENTER	NULL	0	0
40999	REQUEST IN PACKAGE	NULL	0	0
*/

-- DETAILS on customers that did NOT get their customer offers loaded
        select CF.*, 
            C.ixCustomer, C.flgDeletedFromSOP, C.ixCustomerType, C.sCustomerType, C.sMailingStatus
        from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409 CF
        left join tblCustomer C on CF.ixCustomer = C.ixCustomer
where CF.ixCustomer NOT IN ( select distinct CO.ixCustomer
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '409' )
-- 100 customer flagged as deleted FROM SOP in the last 30 days
ixCustomer	ixSourceCode	ixCustomer	flgDeletedFromSOP	ixCustomerType	sCustomerType	sMailingStatus
                 
                        
                                                

   
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
    WHERE SC.ixCatalog = '409' 
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */
                
      
/*
  
-- kicked off customer offer load routine 02/12/15 1:23PM     .... finished 02/13/15 1:03 PM         
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
 FROM PJC_SMIHD3897_CustFile_409_FINAL CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '409%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_SMIHD1574_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '409%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_SMIHD3897_CustFile_409_FINAL CST
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
                    from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '409' )
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
            from [SMITemp].dbo.PJC_SMIHD3897_CustFile_409 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '409%'
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
      
      
      