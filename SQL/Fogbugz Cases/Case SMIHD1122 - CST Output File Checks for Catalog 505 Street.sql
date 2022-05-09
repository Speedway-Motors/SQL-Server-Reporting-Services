--  SMIHD1122 - CST Output File Checks for Catalog 505 Street
  -- previous CST case = 26077

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD1122_CST_OutputFile_505

-- GLOBALLY REPLACE the following:
    /*
        PJC_SMIHD1122_CST_OutputFile_505
        '505%'
        '505'  
        505
    */  
    
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '505'
/*
ixCatalog	sDescription	sMarket	dtStartDate	dtEndDate	iQuantityPrinted
505	        '15 MID SUM SR	SR	    2015-07-06 	2016-07-20 	350000
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixCatalog = '505' -- ixSourceCode LIKE '505%' 
ORDER BY ixCatalog
-- 79 source codes assigned to ixCatalog 505
--ixSourceCode	sDescription
50502A	12M 5+ $1,000+ SR No Offer
50502F	12M 5+ $1,000+ SR Offer
50503A	12M 3+ $150+ SR No Offer
50503F	12M 3+ $150+ SR Offer
50504A	12M 3+ $1+ SR No Offer
50504F	12M 3+ $1+ SR Offer
50505A	12M 2+ $150+ SR No Offer
50505F	12M 2+ $150+ SR Offer
50506A	12M 2+ $1+ SR No Offer
50506F	12M 2+ $1+ SR Offer
50507A	12M 1+ $150+ SR No Offer
50507F	12M 1+ $150+ SR Offer
50508A	12M 1+ $1+ SR No Offer
50508F	12M 1+ $1+ SR Offer
50509A	12M 1+ $1+ 2B No Offer
50509F	12M 1+ $1+ 2B Offer
50510A	12M 2+ $150+ B No Offer
50510F	12M 2+ $150+ B Offer
50511A	12M 2+ $1+ B No Offer
50511F	12M 2+ $1+ B Offer
50512A	12M 1+ $150+ B No Offer
50512F	12M 1+ $150+ B Offer
50513A	12M 1+ $1+ B No Offer
50513F	12M 1+ $1+ B Offer
50514A	12M 3+ $150+ R No Offer
50514F	12M 3+ $150+ R Offer
50515A	12M 3+ $1+ R No Offer
50515F	12M 3+ $1+ R Offer
50516A	12M 2+ $150+ R No Offer
50516F	12M 2+ $150+ R Offer
50517A	12M 2+ $1+ R No Offer
50517F	12M 2+ $1+ R Offer
50518A	12M 1+ $150+ R No Offer
50518F	12M 1+ $150+ R Offer
50519A	12M 1+ $1+ R No Offer
50519F	12M 1+ $1+ R Offer
50520A	12M 1+ $1+ SM No Offer
50520F	12M 1+ $1+ SM Offer
50521A	24M 3+ $150+ SR No Offer
50521F	24M 3+ $150+ SR Offer
50522A	24M 3+ $1+ SR No Offer
50522F	24M 3+ $1+ SR Offer
50523A	24M 2+ $150+ SR No Offer
50523F	24M 2+ $150+ SR Offer
50524A	24M 2+ $1+ SR No Offer
50524F	24M 2+ $1+ SR Offer
50525A	24M 1+ $150+ SR No Offer
50525F	24M 1+ $150+ SR Offer
50526A	24M 1+ $1+ SR No Offer
50526F	24M 1+ $1+ SR Offer
50527A	24M 1+ $1+ 2B No Offer
50527F	24M 1+ $1+ 2B Offer
50528A	24M 2+ $150+ B No Offer
50528F	24M 2+ $150+ B Offer
50529A	24M 2+ $1+ B No Offer
50529F	24M 2+ $1+ B Offer
50530A	24M 1+ $150+ B No Offer
50530F	24M 1+ $150+ B Offer
50531A	24M 1+ $1+ B No Offer
50531F	24M 1+ $1+ B Offer
50532A	24M 3+ $150+ R No Offer
50532F	24M 3+ $150+ R Offer
50533A	24M 3+ $1+ R No Offer
50533F	24M 3+ $1+ R Offer
50534A	24M 2+ $150+ R No Offer
50534F	24M 2+ $150+ R Offer
50535A	24M 2+ $1+ R No Offer
50535F	24M 2+ $1+ R Offer
50536A	24M 1+ $150+ R No Offer
50536F	24M 1+ $150+ R Offer
50537A	36M 5+ $400+ SR No Offer
50537F	36M 5+ $400+ SR Offer
50538A	36M 2+ $400+ SR No Offer
50538F	36M 2+ $400+ SR Offer
50539D	36M 1+ $1+ SR CA No Offer
50570A	3M Requestors SR No Offer
50570F	3M Requestors SR Offer
50592	COUNTER
50599	REQUEST IN PACKAGE

SELECT ixSourceCode
     , sDescription, * 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '505%'
and ixCatalog <> '505'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan
/*
ixSourceCode	sDescription

*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '505%'
  AND ixCatalog = '505'
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- NONE
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '505%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '505'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- NONE

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL





/********************** START of QC for CST output file  ********************************/

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  
from [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505 
where LEN(ixSourceCode) <>6
order by LEN(ixSourceCode) desc



/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
         'lookup' as CSTCount
    FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505       
    /*
    All     Distinct            CST
    Count	Count	    Delta   Count
    ======= ========    =====   =======
    350388	350388	    0	     350388   v
    */

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        -- easier to resize and line up codes if you paste this output in Excel
        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode
        
/**************
SCode	Qty 


FROM CST SCREEN:
Count Time: 00:36
Total Segments: 39
 
Total Source Codes: 77
    Included: 77
    Excluded:  0
 
Total Customers: 350,388
    Included:    350,388 v
    Excluded:         0
    */

/**********  check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505 CST
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
        from PJC_SMIHD1122_CST_OutputFile_505
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 28 (28 addt'l incl. the split segments that they appended 'A,C, or F' to) 
    WHERE ixSourceCode LIKE '505%' AND len(ixSourceCode) <> 6
    ORDER BY len(ixSourceCode), ixSourceCode
    /*
    ixSource
    Code	ixCatalog
     THE SCs with 5 digits and the additional letter indicating which promo type they're getting
     PLUS


*/
/*  -- THIS CHECK IS NOT CURRENTLY RELEVANT 
             most of the "final" source codes will be segments appended by various letters 
             depending on the type of offer they will be giving the customer.
             Keeping the code in case the process changes back to the old way
*/                                            
        -- VERIFY all source codes in the CST campaign exist in SOP
        SELECT ixSourceCode SCode, sDescription 'Description'
        FROM [SMI Reporting].dbo.tblSourceCode
        WHERE ixCatalog = '505' 
     --   AND LEN(ixSourceCode) = 5 
     SCode	Description

       -- SC in CST file but NOT in SOP
       SELECT ixSourceCode, count(*) 'Qty'
       from [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505
       where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                                  FROM [SMI Reporting].dbo.tblSourceCode
                                  WHERE ixCatalog = '505'                              )
       group by  ixSourceCode                             
       /* POTENTIALLY MISSING!!! */
 

         
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
BEFORE  480         349
AFTER   480         349 
*/    
    

-- create file to give to DYlan so he can reassign customers to their FINAL SCs
SELECT CST.*
FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505 CST

/*********************  END of QC for CST output file  ***********************/

-- SKIP TO LINE 367 since there is no modified output file this time


/******************************************************************************
****** START of QC for MODIFIED load list provided by Marketing         ******
****** DOING ALL OF THE SAME STEPS AGAIN BUT NOW FOR THE MODIFIED FILE  ******
******************************************************************************/
-- DROP table PJC_SMIHD1122_CST_OutputFile_505_MOD
-- Dupe check
select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
FROM [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505_MOD
    /*
    AllCnt	DistinctCount	Delta	
    60082	60082	        0	
    */
    
            -- if dupes are found    
                select ixCustomer, COUNT(*) from  PJC_SMIHD1122_CST_OutputFile_505_MOD
                group by ixCustomer
                having COUNT(*) > 1
           
                select * from PJC_SMIHD1122_CST_OutputFile_505_MOD
                where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
                order by ixCustomer
           
                -- removing one of each dupe
                set rowcount 1
                Delete 
                from PJC_SMIHD1122_CST_OutputFile_505_MOD
                where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
                    and ixCustomer in (select ixCustomer from  PJC_SMIHD1122_CST_OutputFile_505_MOD
                                    group by ixCustomer
                                    having COUNT(*) > 1)
                set rowcount 0                          
                            
-- verify counts by Source Code match 505 LOL.xls sheet provided by Marketing
Select ixSourceCode, COUNT(ixCustomer) QTY
from [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505_MOD
group by ixSourceCode
order by ixSourceCode
/*  1st Mod file PASSED
     
all delta's were <2 
*/                     


-- all customers in tblCustomer?
select ixCustomer -- 100% 
from [SMITemp].dbo.PJC_SMIHD1122_CST_OutputFile_505_MOD
where ixCustomer NOT in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomer)
-- and ixCustomer NOT like '2046946%'                     
                     
    -- delete from PJC_SMIHD1122_CST_OutputFile_505_MOD
    -- where ixCustomer = '2046946%'


/*********************  END of QC for MODIFIED output file  ***********************/

    
    
/**********  Load Customer Offers into SOP ***********/
    select ixCustomer,',',ixSourceCode 
    from PJC_SMIHD1122_CST_OutputFile_505_MOD
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD1122_CST_OutputFile_505_MOD q.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's in the ticket already) 

    In-home date for Catalog #505 = 07/20/15
    
When they are done loading DO NOT ENTER "OK" YET to "consolodate your lists"
open a new instance of SOP and MANUALLY refeed all of todays offers to DW. (ETA 43 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to load a customer file and give him an
ETA (# of records/2.1)/3600 hours) on when it should finish.

THEN 
    enter OK on you 1st SOP connection to begin the CUST record update
**********/
 
 
-- Customers in Offer table for Cat 505
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_SMIHD1122_CST_OutputFile_505
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '505'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '505' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 


/*
SCode	Description					Qty in CST File	Qty in SOP	Delta

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
    WHERE SC.ixCatalog = '505'
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
 FROM PJC_SMIHD1122_CST_OutputFile_505_MOD CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '505%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_SMIHD1122_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '505%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_SMIHD1122_CST_OutputFile_505_MOD CST
 JOIN PJC_SMIHD1122_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 505 ONLY  ******************************/
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
                    from PJC_SMIHD1122_CST_OutputFile_505_MOD
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '505' )
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
            from PJC_SMIHD1122_CST_OutputFile_505_MOD3 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '505%'
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
      