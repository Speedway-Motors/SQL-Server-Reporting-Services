-- Case 26077 - CST Output File Checks for Catalog 700 T-Bucket 
  -- previous CST case = 25947

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_26077_CST_OutputFile_700

-- GLOBALLY REPLACE the following:
    /*
        PJC_26077_CST_OutputFile_700
        '700%'
        '700'  
        700
    */  
    
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '700'
-- Catalog 700 = 2015 T-BUCKET

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '700%' ORDER BY ixCatalog
-- 54 source codes assigned to ixCatalog 700

SELECT ixSourceCode
     , sDescription 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '700%'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan
/*
ixSourceCode	sDescription
7000	OL' SKOOL RODZ
70002A	12M 3+ $100+ 2B Control
70002C	12M 3+ $100+ 2B $7.99 Flat Rate
70002F	12M 3+ $100+ 2B Free Shipping
70003A	12M 3+ $1+ 2B Control
70003C	12M 3+ $1+ 2B $7.99 Flat Rate
70003F	12M 3+ $1+ 2B Free Shipping
70004A	12M 1+ $1+ 2B Control
70004C	12M 1+ $1+ 2B $7.99 Flat Rate
70004F	12M 1+ $1+ 2B Free Shipping
70005A	12M 5+ $1,000+ SR Control
70005C	12M 5+ $1,000+ SR $7.99 Flat Rate
70005F	12M 5+ $1,000+ SR Free Shipping
70006A	24M 3+ $100+ 2B Control
70006C	24M 3+ $100+ 2B $7.99 Flat Rate
70006F	24M 3+ $100+ 2B Free Shipping
70007A	24M 3+ $1+ 2B Control
70007C	24M 3+ $1+ 2B $7.99 Flat Rate
70007F	24M 3+ $1+ 2B Free Shipping
70008A	24M 1+ $1+ 2B Control
70008C	24M 1+ $1+ 2B $7.99 Flat Rate
70008F	24M 1+ $1+ 2B Free Shipping
70009A	36M 2+ $100+ 2B Control
70009C	36M 2+ $100+ 2B $7.99 Flat Rate
70009F	36M 2+ $100+ 2B Free Shipping
7001	CIRCLE TRACK
70010A	36M 2+ $1+ 2B Control
70010C	36M 2+ $1+ 2B $7.99 Flat Rate
70010F	36M 2+ $1+ 2B Free Shipping
70011A	36M 1+ $1+ 2B Control
70011C	36M 1+ $1+ 2B $7.99 Flat Rate
70011F	36M 1+ $1+ 2B Free Shipping
70012A	48M 2+ $100+ 2B Control
70012C	48M 2+ $100+ 2B $7.99 Flat Rate
70012F	48M 2+ $100+ 2B Free Shipping
70013A	48M 2+ $1+ 2B Control
70013C	48M 2+ $1+ 2B $7.99 Flat Rate
70013F	48M 2+ $1+ 2B Free Shipping
70014A	60M 2+ $1+ 2B Control
70014C	60M 2+ $1+ 2B $7.99 Flat Rate
70014F	60M 2+ $1+ 2B Free Shipping
7002	SPEEDWAY ILLUSTRATED
7003	CLASSIC TRUCKS
7004	DRIVE
7005	GOODGUYS GAZETTE
7006	CHEVY HIGH PERFORMANCE
7007	STREET SCENE
70070A	12M Requestors 2B Control
70070C	12M Requestors 2B $7.99 Flat Rate
70070F	12M Requestors 2B Free Shipping
7008	HEMMINGS MOTOR NEWS
70092	Counter
70098	DHL Bulk Center
70099	Request In Package
*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '700%'
  AND ixCatalog = '700'
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- NONE
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '700%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '700'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- NONE

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL





/********************** START of QC for CST output file  ********************************/

-- DROP TABLE [SMITemp].dbo.PJC_26077_CST_OutputFile_700

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  
from [SMITemp].dbo.PJC_26077_CST_OutputFile_700 
where LEN(ixSourceCode) <>5
order by LEN(ixSourceCode) desc

50407EB -- <--10 DIF segments with EB appended

/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
         'lookup' as CSTCount
    FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700       
    /*
    All     Distinct            CST
    Count	Count	    Delta   Count
    ======= ========    =====   =======
    60082	60082	    0       60082 v
    */

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        -- easier to resize and line up codes if you paste this output in Excel
        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode
        
/**************
SCode	Qty 
70002	11044
70003	6689
70004	2484
70005	17396
70006	3349
70007	2184
70008	1869
70009	2224
70010	1802
70011	1067
70012	1418
70013	1196
70014	1640
70070	5720

FROM CST SCREEN:
Count Time: 00:03
Total Segments: 14
 
Total Source Codes: 14
    Included: 14
    Excluded:  0
 
Total Customers: 60,082
    Included:    60,082 v
    Excluded:         0
    */

/**********  check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
	OR --- 
    ixCustomer	ixSourceCode	sMailingStatus



*/

    -- SOP will exclude above people (44 customers) 
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_26077_CST_OutputFile_700
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 28 (28 addt'l incl. the split segments that they appended 'A,C, or F' to) 
    WHERE ixSourceCode LIKE '700%' AND len(ixSourceCode) <> 5
    ORDER BY len(ixSourceCode), ixSourceCode
    /*
    ixSource
    Code	ixCatalog
     THE SCs with 5 digits and the additional letter indicating which promo type they're getting
     PLUS
     7000	504
    7001	405
    7002	405
    7003	504
    7004	504
    7005	504
    7006	504
    7007	504
    7008	504

*/
/*  -- THIS CHECK IS NOT CURRENTLY RELEVANT 
             most of the "final" source codes will be segments appended by various letters 
             depending on the type of offer they will be giving the customer.
             Keeping the code in case the process changes back to the old way
                                            
                                            -- VERIFY all source codes in the CST campaign exist in SOP
                                            SELECT ixSourceCode SCode, sDescription 'Description'
                                            FROM [SMI Reporting].dbo.tblSourceCode
                                            WHERE ixCatalog = '700' 
                                         --   AND LEN(ixSourceCode) = 5 
                                         SCode	Description

                                           -- SC in CST file but NOT in SOP
                                           SELECT ixSourceCode, count(*) 'Qty'
                                           from [SMITemp].dbo.PJC_26077_CST_OutputFile_700
                                           where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                                                                      FROM [SMI Reporting].dbo.tblSourceCode
                                                                      WHERE ixCatalog = '700'                              )
                                           group by  ixSourceCode                             
                                           /* POTENTIALLY MISSING!!! */
 
*/
         
/***********  Update deceased exempt list   **********/

-- execute the following 2 queries BEFORE & AFTER running 
-- the <9> Update deceased exempt list in SOP's Reporting Menu 
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
BEFORE  483         346      
AFTER   480         349 
*/    
    

-- create file to give to DYlan so he can reassign customers to their FINAL SCs
SELECT CST.*
FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700 CST

/*********************  END of QC for CST output file  ***********************/



/******************************************************************************
****** START of QC for MODIFIED load list provided by Marketing         ******
****** DOING ALL OF THE SAME STEPS AGAIN BUT NOW FOR THE MODIFIED FILE  ******
******************************************************************************/
-- DROP table PJC_26077_CST_OutputFile_700_MOD
-- Dupe check
select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
FROM [SMITemp].dbo.PJC_26077_CST_OutputFile_700_MOD
    /*
    AllCnt	DistinctCount	Delta	
    60082	60082	        0	
    */
    
            -- if dupes are found    
                select ixCustomer, COUNT(*) from  PJC_26077_CST_OutputFile_700_MOD
                group by ixCustomer
                having COUNT(*) > 1
           
                select * from PJC_26077_CST_OutputFile_700_MOD
                where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
                order by ixCustomer
           
                -- removing one of each dupe
                set rowcount 1
                Delete 
                from PJC_26077_CST_OutputFile_700_MOD
                where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
                    and ixCustomer in (select ixCustomer from  PJC_26077_CST_OutputFile_700_MOD
                                    group by ixCustomer
                                    having COUNT(*) > 1)
                set rowcount 0                          
                            
-- verify counts by Source Code match 700 LOL.xls sheet provided by Marketing
Select ixSourceCode, COUNT(ixCustomer) QTY
from [SMITemp].dbo.PJC_26077_CST_OutputFile_700_MOD
group by ixSourceCode
order by ixSourceCode
/*  1st Mod file PASSED
     
all delta's were <2 
*/                     


-- all customers in tblCustomer?
select ixCustomer -- 100% 
from [SMITemp].dbo.PJC_26077_CST_OutputFile_700_MOD
where ixCustomer NOT in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomer)
-- and ixCustomer NOT like '2046946%'                     
                     
    -- delete from PJC_26077_CST_OutputFile_700_MOD
    -- where ixCustomer = '2046946%'


/*********************  END of QC for MODIFIED output file  ***********************/

    
    
/**********  Load Customer Offers into SOP ***********/
    select ixCustomer,',',ixSourceCode 
    from PJC_26077_CST_OutputFile_700_MOD
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_26077_CST_OutputFile_700_MOD.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's in the ticket already) 

    In-home date for Catalog #700 = 06/29/15
    
When they are done loading DO NOT ENTER "OK" YET to "consolodate your lists"
open a new instance of SOP and MANUALLY refeed all of todays offers to DW. (ETA 43 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to load a customer file and give him an
ETA (# of records/2.1)/3600 hours) on when it should finish.

THEN 
    enter OK on you 1st SOP connection to begin the CUST record update
**********/
 
 
-- Customers in Offer table for Cat 700
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_26077_CST_OutputFile_700_MOD
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '700'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '700' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 


/*
SCode	Description					Qty in CST File	Qty in SOP	Delta
70002A	2208	2208	0	12M 3+ $100+ 2B Control
70002C	4415	4417	-2	12M 3+ $100+ 2B $7.99 Flat Rate
70002F	4419	4419	0	12M 3+ $100+ 2B Free Shipping
70003A	1338	1338	0	12M 3+ $1+ 2B Control
70003C	2675	2675	0	12M 3+ $1+ 2B $7.99 Flat Rate
70003F	2676	2676	0	12M 3+ $1+ 2B Free Shipping
70004A	497	497	0	12M 1+ $1+ 2B Control
70004C	993	993	0	12M 1+ $1+ 2B $7.99 Flat Rate
70004F	994	994	0	12M 1+ $1+ 2B Free Shipping
70005A	3479	3479	0	12M 5+ $1,000+ SR Control
70005C	6958	6958	0	12M 5+ $1,000+ SR $7.99 Flat Rate
70005F	6958	6959	-1	12M 5+ $1,000+ SR Free Shipping
70006A	670	670	0	24M 3+ $100+ 2B Control
70006C	1338	1339	-1	24M 3+ $100+ 2B $7.99 Flat Rate
70006F	1339	1340	-1	24M 3+ $100+ 2B Free Shipping
70007A	437	437	0	24M 3+ $1+ 2B Control
70007C	873	873	0	24M 3+ $1+ 2B $7.99 Flat Rate
70007F	874	874	0	24M 3+ $1+ 2B Free Shipping
70008A	374	374	0	24M 1+ $1+ 2B Control
70008C	747	747	0	24M 1+ $1+ 2B $7.99 Flat Rate
70008F	748	748	0	24M 1+ $1+ 2B Free Shipping
70009A	444	444	0	36M 2+ $100+ 2B Control
70009C	890	890	0	36M 2+ $100+ 2B $7.99 Flat Rate
70009F	890	890	0	36M 2+ $100+ 2B Free Shipping
70010A	360	360	0	36M 2+ $1+ 2B Control
70010C	721	721	0	36M 2+ $1+ 2B $7.99 Flat Rate
70010F	721	721	0	36M 2+ $1+ 2B Free Shipping
70011A	213	213	0	36M 1+ $1+ 2B Control
70011C	427	427	0	36M 1+ $1+ 2B $7.99 Flat Rate
70011F	427	427	0	36M 1+ $1+ 2B Free Shipping
70012A	283	283	0	48M 2+ $100+ 2B Control
70012C	567	567	0	48M 2+ $100+ 2B $7.99 Flat Rate
70012F	568	568	0	48M 2+ $100+ 2B Free Shipping
70013A	239	239	0	48M 2+ $1+ 2B Control
70013C	478	478	0	48M 2+ $1+ 2B $7.99 Flat Rate
70013F	479	479	0	48M 2+ $1+ 2B Free Shipping
70014A	328	328	0	60M 2+ $1+ 2B Control
70014C	656	656	0	60M 2+ $1+ 2B $7.99 Flat Rate
70014F	656	656	0	60M 2+ $1+ 2B Free Shipping
70070A	1144	1144	0	12M Requestors 2B Control
70070C	2288	2288	0	12M Requestors 2B $7.99 Flat Rate
70070F	2288	2288	0	12M Requestors 2B Free Shipping
70092	0	NULL	0	Counter
70098	0	NULL	0	DHL Bulk Center
70099	0	NULL	0	Request In Package
*/


   
/* after verifying the Delta's from above check are acceptable
   enter OK in SOP to start the CUST update routine.
   It is currently VERY slow at about 3 rec/sec and 
   CAN TAKE UP TO 50 HOURS to complete depending on # of records.
*/
    -- kicked off routine 5/13/15 @11:17AM      ETA 7:15 pm 5/13/15
    
    
    
     -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 262107  -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '700'
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */
                
select * from [SMI Reporting].dbo.tblTime where chTime like '09:45%'                
      
      
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
    353     118,353  36,971     3.2 06-04-13    Tuesday
    366      48,114  17,563     2.7 06-18-13    Tuesday
    364      32,040   1,139    28.1 06-26-13    Friday
    354     330,968  18,118    18.3 07-22-13    Monday
    355     239,006  33,388     7.2 09-11-13    Tuesday
    361     179,997  25,772     7.0 10-02-13    Wednesday
    383      40,649   5,750     7.1 11-05-13    Tuesday
    377     265,994  41,260     6.4 12-06-13    Friday (ran during production hours)
    373     328,438             6.7 01-03-14    Friday - avg speed AFTER the feed issues (group locks) were resolved    
       /********** CLOAK 2.0 launched ***********/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    378     219,574	 21,780	   10.0	01-30-14	Monday (ran during production hours) 
    374     165,820  16,323    10.2 02-13-14    Thursday (11:50AM - 4:20PM) 
    384		 43,703	  3,717	   11.8	02-19-14	Wednesday (ran during production hours)  
    379     100,993            10.3 03-07-14    Thur night & Fri morning (ran in two parts)
    380     237,171             8.2 04-14-14    Tue night & Wed (ran in two parts)
    385      36,572   4,569     8.0 05-20-14    Tue late morning
    381     102,433  12,548     8.2 06-04-14    Wed mid morning
    388     377,093	 46,236		8.1	06-19-14	Thursday (ran during production hours) 
    387		 61,163	 10,368		5.9	06-24-14	Tuesday (ran during production hours) 
    389     405,920  63,000     6.4 07-22-14    Tuesday (kicked off at 11:01 AM, ran straight thru until completed 4:29AM Wed) 
    390     242,902  39,438     6.2 09-04-14    Thursday (kicked off at 11:11 AM) 
    382     177,308  57,600     3.1 09-30-14    Tuesday (kicked off at 9:45 AM)
    391     
    501     381,375 173,220     2.2 12-22-14    
    402     259,379 116,100     2.2 01-11-15    Sat 1:03PM finished Sun 9:18 PM
    600      49,515 
    502     411,369 
    403		262,106  85,200     3.1 02-12-15	Thursday 1:23PM finished Fri 1:03PM
    504     297,896                             Kicked off Thur 4/16/15 @11:19AM
    700      60,082             
**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_26077_CST_OutputFile_700_MOD CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '700%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_26077_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '700%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_26077_CST_OutputFile_700_MOD CST
 JOIN PJC_26077_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 700 ONLY  ******************************/
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
                    from PJC_26077_CST_OutputFile_700_MOD
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '700' )
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
            from PJC_26077_CST_OutputFile_700_MOD3 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '700%'
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
                5	0	    0
                22	0	    1
                */                
      