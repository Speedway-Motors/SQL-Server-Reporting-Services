-- Case 25444 - CST Output File Checks for Catalog 403 Race 
  -- previous CST case = 25295
  
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '403'
-- Catalog 403 = '15 SPRNG RACE

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '403%'  

SELECT ixSourceCode
     , sDescription 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '403%'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '403%'
  AND LEN(ixSourceCode) <> 5
  
  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '403%'
  AND LEN(ixSourceCode) >= 5  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- 0

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_25444_CST_OutputFile_403_MOD2
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 502 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "108-403.txt" for Catalog 403 has passed the following QC checks.

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
-- DROP TABLE [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  from [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2 
order by LEN(ixSourceCode) desc

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2       
                       
/*
All     Distinct            CST
Count	Count	    Delta   Count
======= ========    =====   =======
262,155	262,155	    0	    262,155 v
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode
        
UPDATE [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2
SET ixSourceCode = '40336A' 
WHERE ixSourceCode = '40236A'         

UPDATE [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2
SET ixSourceCode = '40336C' 
WHERE ixSourceCode = '40236C'    

/**************
SCode	Qty 59


FROM CST SCREEN:
Count Time: 00:46  
Total Segments: 41
 
Total Source Codes: 41
    Included: 41
    Excluded:  0
 
Total Customers: 262,155
    Included:    262,155 v
    Excluded:          0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
	OR --- 
    ixCustomer	ixSourceCode	sMailingStatus
	2900337		40309			9
	1880509		40325			9
	1661760		40303			9
	767509		40307			9
	383423		40311			9
	1796463		40317C			9
	1570075		40323C			9
	967308		40319A			9
	485953		40331			9
	1992216		40325			9
	1853468		40311			9
	1836454		40319C			9
	1716477		40330			9
	1647874		40312			9
	1497475		40314			9
	1494788		40305			9
	1486849		40317C			9
	1317233		40333C			9
	848965		40326			9
	1865161		40332			9
	1420723		40316C			9
	1279389		40303			9
	1266270		40318C			9
	2033840		40309			9
	1782918		40302			9
	1772473		40313			9
	1740684		40309			9
	1565373		40311			9
	1356182		40315C			9
	1092457		40319A			9
	1061191		40324			9
	925920		40302			9
	561067		40322A			9
	176951		40317A			9
	51123		40316A			9
	1000187		40317A			9
	1581688		40371A			9
	1245216		40306			9
	1932773		40313			9
	1913255		40334C			9
	1753576		40307			9
	1604275		40317C			9
	1501870		40320C			9
	1444067		40318C			9
	1304753		40302			9
	1280185		40317A			9
	1275287		40316A			9
	1271109		40324			9
	1232562		40304			9
	1067576		40323A			9
	258217		40303			9
	1904863		40321C			9
	1534683		40371A			9
	1397875		40323C			9
	1227766		40332			9
	890142		40333A			9
	1722389		40304			9
	1602284		40371A			9
	1584777		40321C			9
	1550065		40328			9
	1537124		40333C			9
	1251149		40310			9
	1250570		40323A			9
	1135081		40317A			9
	590453		40322A			9
	2133742		40305			9
	1984866		40317C			9
	1829835		40311			9
	1675970		40317C			9
	1461748		40307			9
	1460687		40309			9
	1422283		40306			9
	1418630		40325			9
	1199580		40314			9
	1151200		40324			9
	1040721		40302			9
	1017893		40311			9
	815823		40311			9
	1890769		40327			9
	1867905		40319C			9
	1114982		40317A			9
	2951432		40309			9    
*/

    -- SOP will exclude above people (82 customers) 
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_25444_CST_OutputFile_403_MOD2
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 36 (36 addt'l incl. the split segments that they appended 'A/C' to) 
    WHERE ixSourceCode LIKE '403%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog

    JUST THE SCs with 5 digits and the additional letter indicating which promo type they're getting

*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '403' 
   --   AND LEN(ixSourceCode) = 5 
/*
SCode	Description
40302	6M 2+ $150+ R Control
40303	6M 2+ $1+ R Control
40304	6M 1+ $150+ R Control
40305	6M 1+ $1+ R Control
40306	6M 2+ $150+ B Control
40307	6M 2+ $1+ B Control
40308	6M 1+ $150+ B Control
40309	6M 1+ $1+ B Control
40310	12M 5+ $1,000+ R Control
40311	12M 3+ $150+ R Control
40312	12M 3+ $1+ R Control
40313	12M 2+ $150+ R Control
40314	12M 2+ $1+ R Control
40315A	12M 1+ $150+ R Control
40315C	12M 1+ $150+ R Offer
40316A	12M 1+ $1+ R Control
40316C	12M 1+ $1+ R Offer
40317A	12M 1+ $1+ B Control
40317C	12M 1+ $1+ B Offer
40318A	18M 2+ $150+ R Control
40318C	18M 2+ $150+ R Offer
40319A	18M 2+ $1+ R Control
40319C	18M 2+ $1+ R Offer
40320A	18M 1+ $150+ R Control
40320C	18M 1+ $150+ R Offer
40321A	18M 1+ $1+ R Control
40321C	18M 1+ $1+ R Offer
40322A	18M 2+ $1+ B Control
40322C	18M 2+ $1+ B Offer
40323A	18M 1+ $1+ B Control
40323C	18M 1+ $1+ B Offer
40324	24M 3+ $150+ R Control
40325	24M 3+ $1+ R Control
40326	24M 2+ $150+ R Control
40327	24M 2+ $1+ R Control
40328	24M 1+ $150+ R Control
40329	24M 1+ $1+ R Control
40330	24M 1+ $1+ SM Control
40331	24M 2+ $1+ B Control
40332	24M 1+ $1+ B Control
40333A	36M 3+ $150+ R Control
40333C	36M 3+ $150+ R Offer
40334A	36M 2+ $150+ R Control
40334C	36M 2+ $150+ R Offer
40335A	36M 1+ $150+ R Control
40335C	36M 1+ $150+ R Offer
40336A	48M 3+ $150+ R Control
40336C	48M 3+ $150+ R Offer
40337A	48M 2+ $150+ R Control
40337C	48M 2+ $150+ R Offer
40350	72M 1+ $1+ R Control CA
40370A	3M Requestors R Control
40370C	3M Requestors R Offer
40371A	6M Requestors R Control
40371C	6M Requestors R Offer
40372A	9M Requestors R Control
40372C	9M Requestors R Offer
40373A	12M Requestors R Control
40373C	12M Requestors R Offer
40392	COUNTER
40398	DHL BULK CENTER
40399	REQUEST IN PACKAGE
6973	CIRCLE TRACK
6974	SPEEDWAY ILLUSTRATED
*/
      
   /* MISMATCHES! 
	
        -- NONE
	
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '403'                              )
   group by  ixSourceCode                             
   /* MISSING!!!
   ixSourceCode	Qty

		NONE	
		
    */

         
/*********** 6. Update deceased exempt list   **********/

-- execute the following 2 queries ON STAGING beofre and after running the update 
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
BEFORE  418         337      
AFTER   418         337
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    


/****** QC checks MODIFIED load list provided by Marketing *******/

-- Dupe check
select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2 
    /*
    AllCnt	DistinctCount	Delta	
    262,155	262,155	        0	    
    */

-- verify counts by Source Code match 403 LOL.xls sheet provided by Marketing
Select ixSourceCode, COUNT(ixCustomer) QTY
from [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2
group by ixSourceCode
order by ixSourceCode
/*

    NOTE(S): 403 LOL.xls has counts of 2,835 for 40336A (vs. 1,835 in file provided) 
                                   and 2,836 for 40336C (vs. 3,836 in file provided) 
    
    -- After notifying Dylan he made the necessary changes and re-sent the new file. 
       I uploaded them to a new table (ASC_25444_CST_OutputFile_403_MOD22) and re-ran all checks.                                   

			 403 LOL.xls has counts of 2,835 for 40336A (vs. 2,836 in file provided) 
                                   and 2,836 for 40336C (vs. 2,835 in file provided) 
ixSource
Code	QTY
40302	35888
40303	24231
40304	2434
40305	9092
40306	1859
40307	9661
40308	346
40309	5395
40310	5125
40311	12095
40312	10761
40313	2703
40314	3852
40315A	1328
40315C	1328
40316A	4311
40316C	4312
40317A	6055
40317C	6055
40318A	4335
40318C	4336
40319A	4498
40319C	4498
40320A	622
40320C	622
40321A	3002
40321C	3002
40322A	2458
40322C	2458
40323A	1877
40323C	1877
40324	8051
40325	6183
40326	1722
40327	2918
40328	1813
40329	7302
40330	3405
40331	4670
40332	4414
40333A	4599
40333C	4600
40334A	1239
40334C	1240
40335A	1427
40335C	1427
40336A	2836
40336C	2835
40337A	1054
40337C	1055
40350	3316
40370A	1213
40370C	1213
40371A	4604
40371C	4604
40372A	1125
40372C	1126
40373A	874
40373C	874
*/
-- all customers in tblCustomer?
select ixCustomer -- 100% 
from [SMITemp].dbo.ASC_25444_CST_OutputFile_403_MOD2 
where ixCustomer in (select ixCustomer 
                     from tblCustomer)
   
    
    
               
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #403 = 03/16/15
    -- kicked off routine 2/12/15 @13:30PM
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
    WHERE SC.ixCatalog = '403'
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
 FROM ASC_25444_CST_OutputFile_403_MOD2 CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '403%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into ASC_25444_CST_403_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '403%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM ASC_25444_CST_OutputFile_403_MOD2 CST
 JOIN ASC_25444_CST_403_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 403 ONLY  ******************************/
none

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan AFTER the               **********
 **********     Customer Offers have finished loading into SOP  **********
 **********     and Customer Offers have been refed to          **********
 **********     SMI Reporting.  Update LOL .xls file if Dylan   **********
 **********     provided one.                                   **********/
 
 
-- Customers in Offer table for Cat 403
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from ASC_25444_CST_OutputFile_403_MOD2
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '403'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '403' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
SCode	Description					Qty in CST File	Qty in SOP	Delta
40302	6M 2+ $150+ R Control		35888			35878		-10
40303	6M 2+ $1+ R Control			24231			24229		-2
40304	6M 1+ $150+ R Control		2434			2434		0
40305	6M 1+ $1+ R Control			9092			9088		-4
40306	6M 2+ $150+ B Control		1859			1858		-1
40307	6M 2+ $1+ B Control			9661			9658		-3
40308	6M 1+ $150+ B Control		346				346			0
40309	6M 1+ $1+ B Control			5395			5393		-2
40310	12M 5+ $1,000+ R Control	5125			5123		-2
40311	12M 3+ $150+ R Control		12095			12093		-2
40312	12M 3+ $1+ R Control		10761			10760		-1
40313	12M 2+ $150+ R Control		2703			2701		-2
40314	12M 2+ $1+ R Control		3852			3852		0
40315A	12M 1+ $150+ R Control		1328			1327		-1
40315C	12M 1+ $150+ R Offer		1328			1328		0
40316A	12M 1+ $1+ R Control		4311			4311		0
40316C	12M 1+ $1+ R Offer			4312			4312		0
40317A	12M 1+ $1+ B Control		6055			6055		0
40317C	12M 1+ $1+ B Offer			6055			6053		-2
40318A	18M 2+ $150+ R Control		4335			4334		-1
40318C	18M 2+ $150+ R Offer		4336			4333		-3
40319A	18M 2+ $1+ R Control		4498			4497		-1
40319C	18M 2+ $1+ R Offer			4498			4498		0
40320A	18M 1+ $150+ R Control		622				622			0
40320C	18M 1+ $150+ R Offer		622				622			0
40321A	18M 1+ $1+ R Control		3002			3002		0
40321C	18M 1+ $1+ R Offer			3002			3002		0
40322A	18M 2+ $1+ B Control		2458			2458		0
40322C	18M 2+ $1+ B Offer			2458			2458		0
40323A	18M 1+ $1+ B Control		1877			1877		0
40323C	18M 1+ $1+ B Offer			1877			1876		-1
40324	24M 3+ $150+ R Control		8051			8051		0
40325	24M 3+ $1+ R Control		6183			6181		-2
40326	24M 2+ $150+ R Control		1722			1722		0
40327	24M 2+ $1+ R Control		2918			2918		0
40328	24M 1+ $150+ R Control		1813			1813		0
40329	24M 1+ $1+ R Control		7302			7302		0
40330	24M 1+ $1+ SM Control		3405			3404		-1
40331	24M 2+ $1+ B Control		4670			4670		0
40332	24M 1+ $1+ B Control		4414			4414		0
40333A	36M 3+ $150+ R Control		4599			4599		0
40333C	36M 3+ $150+ R Offer		4600			4598		-2
40334A	36M 2+ $150+ R Control		1239			1239		0
40334C	36M 2+ $150+ R Offer		1240			1239		-1
40335A	36M 1+ $150+ R Control		1427			1426		-1
40335C	36M 1+ $150+ R Offer		1427			1426		-1
40336A	48M 3+ $150+ R Control		2836			2836		0
40336C	48M 3+ $150+ R Offer		2835			2834		-1
40337A	48M 2+ $150+ R Control		1054			1054		0
40337C	48M 2+ $150+ R Offer		1055			1055		0
40350	72M 1+ $1+ R Control CA		3316			3316		0
40360	PRS DEALERS					NULL			0			0
40370A	3M Requestors R Control		1213			1213		0
40370C	3M Requestors R Offer		1213			1213		0
40371A	6M Requestors R Control		4604			4603		-1
40371C	6M Requestors R Offer		4604			4604		0
40372A	9M Requestors R Control		1125			1125		0
40372C	9M Requestors R Offer		1126			1126		0
40373A	12M Requestors R Control	874				874			0
40373C	12M Requestors R Offer		874				874			0
40392	COUNTER						NULL			0			0
40398	DHL BULK CENTER				NULL			0			0
40399	REQUEST IN PACKAGE			NULL			0			0
403		DO-NOT-MAIL	LIST			NULL			0			0
6973	CIRCLE TRACK				NULL			0			0
6974	SPEEDWAY ILLUSTRATED		NULL			0			0
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
                    from ASC_25444_CST_OutputFile_403_MOD2
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '403' )
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
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_25444_CST_OutputFile_403_MOD2 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   tblCustomerOffer CO 
                            where CO.ixSourceCode like '403%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
                
   
