-- Case 25759 - CST Output File Checks for Catalog 404 Race 
  -- previous CST case = 25606
  
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '404'
-- Catalog 404 = '15 LT SPR RACE

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '404%' ORDER BY ixCatalog
-- 43 source codes assigned to ixCatalog 404

SELECT ixSourceCode
     , sDescription 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '404%'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan
/*
ixSourceCode	sDescription
40402	12M 5+ $1,000+ R
40403	12M 3+ $150+ R
40404	12M 3+ $1+ R
40405	12M 2+ $150+ R
40406	12M 2+ $1+ R
40407	12M 1+ $150+ R
40408	12M 1+ $1+ R
40409	12M 1+ $1+ SM
40410	12M 2+ $150+ B
40411	12M 2+ $1+ B
40412	12M 1+ $150+ B
40413	12M 1+ $1+ B
40414A	24M 3+ $150+ R Control
40414C	24M 3+ $150+ R FREE SHIP $99
40415A	24M 3+ $1+ R Control
40415C	24M 3+ $1+ R FREE SHIP $99
40416A	24M 2+ $150+ R Control
40416C	24M 2+ $150+ R FREE SHIP $99
40417A	24M 2+ $1+ R Control
40417C	24M 2+ $1+ R FREE SHIP $99
40418A	24M 1+ $150+ R Control
40418C	24M 1+ $150+ R FREE SHIP $99
40419A	24M 1+ $1+ R Control
40419C	24M 1+ $1+ R FREE SHIP $99
40420A	24M 1+ $1+ SM Control
40420C	24M 1+ $1+ SM FREE SHIP $99
40421A	24M 2+ $150+ B Control
40421C	24M 2+ $150+ B FREE SHIP $99
40422A	24M 2+ $1+ B Control
40422C	24M 2+ $1+ B FREE SHIP $99
40423A	24M 1+ $1+ B Control
40423C	24M 1+ $1+ B FREE SHIP $99
40424A	36M 3+ $1,000+ R Control
40424C	36M 3+ $1,000+ R FREE SHIP $99
40470A	3M Requestors R Control
40470C	3M Requestors R FREE SHIP $99
40470F	3M Requestors R FREE SHIP $50
40471A	6M Requestors R Control
40471C	6M Requestors R FREE SHIP $99
40471F	6M Requestors R FREE SHIP $50
40492	COUNTER
40498	DHL BULK CENTER
40499	REQUEST IN PACKAGE
*/

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '404%'
  AND ixCatalog = '404'
  AND LEN(ixSourceCode) <> 5

  
  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '404%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '404'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- 0

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_25759_CST_OutputFile_404
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 502 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "108-404.txt" for Catalog 404 has passed the following QC checks.

1 - customer count in original CST file = 262,155
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - SOP will filter out any customers recently flagged as competitor, deceased, or do not mail


complete remaining steps:

6. Update deceased/exempt counts

7. Load Customer Offers:
    in SOP under <20>Reporting Menu, run 
                    <2>CST Customer offer load 
    follow directions and make sure to enter the EXACT in-home date and file names

You will receive a notification email when SOP finishes the customer offer loads. Complete the following steps:

8. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually around 10-40 customers that end up "missing" 
            These should just be customers that have been merged since the CST finalization
            and a handful of customers who's files were locked at the time customer offers were loading.

9. send Dylan and CC Chris Chance a list of the final counts of offers loaded by sourcecode through the case.
******************************************************************************************************************/
-- DROP TABLE [SMITemp].dbo.PJC_25759_CST_OutputFile_404

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  
from [SMITemp].dbo.PJC_25759_CST_OutputFile_404 
where LEN(ixSourceCode) <>5
order by LEN(ixSourceCode) desc

404571	6 -- <-- LOOKS LIKE THIS SHOULD HAVE BEEN 40471 instead... checking with Dylan to verify

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404       
                       
/*
All     Distinct            CST
Count	Count	    Delta   Count
======= ========    =====   =======
229,504	229,504	    0	    229,504 v
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        -- easier to resize and line up codes if you paste this output in Excel
        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode
        
/**************
SCode	Qty 
SCode	Qty
40402	17976
40403	33097
40404	30830
40405	5448
40406	8502
40407	5241
40408	17743
40409	3186
40410	2716
40411	15059
40412	609
40413	9971
40414	15461
40415	12662
40416	3081
40417	5435
40418	3156
40419	13300
40420	1758
40421	1220
40422	7930
40423	7947
40424	2141
404571	2010
40470	3025

FROM CST SCREEN:
Count Time: 00:12
Total Segments: 25
 
Total Source Codes: 25
    Included: 25
    Excluded:  0
 
Total Customers: 229,504
    Included:    229,504 v
    Excluded:          0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
	OR --- 
    ixCustomer	ixSourceCode	sMailingStatus
    1940320	40422	9
    1801833	40404	9
    1787568	40423	9
    1749907	40414	9
    1315965	40423	9
    1079074	40416	9
    854101	40403	9
    1625660	40419	9
    1337921	40402	9
    1172069	40404	9
    2290447	40412	9
    1670077	40406	9
    1837678	40407	9
    1105072	40423	9
    183237	40414	9
    1968978	40408	9
    1923969	40423	9
    1494378	40404	9
    1444876	40421	9
    1011371	40423	9
    1937609	40416	9
    789010	40414	9
    2910235	40413	9
    2251245	40410	9
    1657771	40405	9
    2116441	40413	9
    2008845	40407	9
    1233185	40409	9
    1124889	40413	9
    955526	40424	9
    80794	40403	9
    1307069	40418	9
    937421	40404	9
    828932	40403	9
    558726	40408	9
    1955675	40405	9
    1929752	40420	9
    1675171	40423	9
    1218687	40407	9
    1646863	40419	9
    1373962	40423	9
    1053584	40408	9
    1529875	40419	9
    1507964	40418	9

*/

    -- SOP will exclude above people (44 customers) 
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_25759_CST_OutputFile_404
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 28 (28 addt'l incl. the split segments that they appended 'A,C, or F' to) 
    WHERE ixSourceCode LIKE '404%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog
    40414A	404
    40414C	404
    40415A	404
    40415C	404
    40416A	404
    40416C	404
    40417A	404
    40417C	404
    40418A	404
    40418C	404
    40419A	404
    40419C	404
    40420A	404
    40420C	404
    40421A	404
    40421C	404
    40422A	404
    40422C	404
    40423A	404
    40423C	404
    40424A	404
    40424C	404
    40470A	404
    40470C	404
    40470F	404
    40471A	404
    40471C	404
    40471F	404
    JUST THE SCs with 5 digits and the additional letter indicating which promo type they're getting

*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '404' 
 --   AND LEN(ixSourceCode) = 5 
 
   /* MISMATCHES! 
	
        -- NONE
	
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.PJC_25759_CST_OutputFile_404
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '404'                              )
   group by  ixSourceCode                             
   /* POTENTIALLY MISSING!!!
   ixSourceCode	Qty
    40414	15461
    40415	12662
    40416	3081
    40417	5435
    40418	3156
    40419	13300
    40420	1758
    40421	1220
    40422	7930
    40423	7947
    40424	2141
    404571	2010
    40470	3025
	 NOT truly "missing" because the original SC in CST got replaced with the same SC appended with A,C, or F	
		
    */

         
/*********** 6. Update deceased exempt list   **********/

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
BEFORE  444         342      
AFTER   444         342 
*/    
    


SELECT * FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404

/******************************************************************************
****** QC checks MODIFIED load list provided by Marketing               *******
****** DOING ALL OF THE SAME STEPS AGAIN BUT NOW FOR THE MODIFIED FILE  ******
******************************************************************************/
-- DROP table PJC_25759_CST_OutputFile_404_MOD2
-- Dupe check
select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.PJC_25759_CST_OutputFile_404_MOD2 
    /*
    AllCnt	DistinctCount	Delta	
    446293	446293	        0	
    */
    
    -- if dupes are found    
        select ixCustomer, COUNT(*) from  PJC_25759_CST_OutputFile_404_MOD2
        group by ixCustomer
        having COUNT(*) > 1
   
        select * from PJC_25759_CST_OutputFile_404_MOD2
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
        order by ixCustomer
   
        -- removing one of each dupe
        set rowcount 1
        Delete 
        from PJC_25759_CST_OutputFile_404_MOD2
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
            and ixCustomer in (select ixCustomer from  PJC_25759_CST_OutputFile_404_MOD2
                            group by ixCustomer
                            having COUNT(*) > 1)
        set rowcount 0                          
                            
-- verify counts by Source Code match 404 LOL.xls sheet provided by Marketing
Select ixSourceCode, COUNT(ixCustomer) QTY
from [SMITemp].dbo.PJC_25759_CST_OutputFile_404_MOD3
group by ixSourceCode
order by ixSourceCode
/* 
    NOTE(S): 404 LOL.xls had counts differing in 4 source codes
    -- After notifying Dylan he made the necessary changes and re-sent the new file. 
       I uploaded them to a new table (PJC_25759_CST_OutputFile_404_MOD2) and re-ran all checks.
       
all delta's were <3 except for...
SC	    Rec	                Delta
40492	Counter	            300
40499	Request in Package	5,000
BLANK	DHL Bulk Center	    5,500
BLANK	CA DHL 	            500
*/                     


select * 
from PJC_25759_CST_OutputFile_404_MOD3
where ixSourceCode in (', 50303',', 50328',',50372C','161521,50303','322','404')

-- all customers in tblCustomer?
select ixCustomer -- 100% 
from [SMITemp].dbo.PJC_25759_CST_OutputFile_404_MOD2 
where 
ixCustomer NOT like '2046946%'
and ixCustomer in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomer)
                     
delete from PJC_25759_CST_OutputFile_404_MOD2
where ixCustomer = '2046946%'

select * from [SMI Reporting].dbo.tblCustomer
where ixCustomer like '2046946%'    

select ixCustomer,',',ixSourceCode 
from PJC_25759_CST_OutputFile_404_MOD2
order by ixSourceCode
    
    
               
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #404 = 04/05/15
    -- kicked off routine 3/08/15 @22:45PM
*/

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
    WHERE SC.ixCatalog = '404'
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



/***********    CUSTOMER OFFER LOADING SPEEDS    ********************************* 
          
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
**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_25759_CST_OutputFile_404_MOD2 CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '404%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_25759_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '404%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_25759_CST_OutputFile_404_MOD2 CST
 JOIN PJC_25759_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 404 ONLY  ******************************/
none

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan AFTER the               **********
 **********     Customer Offers have finished loading into SOP  **********
 **********     and Customer Offers have been refed to          **********
 **********     SMI Reporting.  Update LOL .xls file if Dylan   **********
 **********     provided one.                                   **********/
 
 
-- Customers in Offer table for Cat 404
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_25759_CST_OutputFile_404_MOD2
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '404'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '404' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
SCode	Description					Qty in CST File	Qty in SOP	Delta

*/


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
                    from PJC_25759_CST_OutputFile_404_MOD2
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '404' )
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
            from PJC_25759_CST_OutputFile_404_MOD3 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '404%'
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
      