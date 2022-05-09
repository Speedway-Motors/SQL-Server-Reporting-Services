-- Case 25606 - CST Output File Checks for Catalog 503 Street 
  -- previous CST case = 25295
  
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '503'
-- Catalog 503 = '15 LS STREET

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '503%'  

SELECT ixSourceCode
     , sDescription 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '503%'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '503%'
  AND ixCatalog = '503'
  AND LEN(ixSourceCode) <> 5

  
  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '503%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '503'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- 0

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_25606_CST_OutputFile_503
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 502 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "108-503.txt" for Catalog 503 has passed the following QC checks.

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
-- DROP TABLE [SMITemp].dbo.PJC_25606_CST_OutputFile_503

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  
from [SMITemp].dbo.PJC_25606_CST_OutputFile_503 
where LEN(ixSourceCode) <>5
order by LEN(ixSourceCode) desc

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503       
                       
/*
All     Distinct            CST
Count	Count	    Delta   Count
======= ========    =====   =======
446,293	446,293    0	    446,293 v
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        -- easier to resize and line up codes if you paste this output in Excel
        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode
        
/**************
SCode	Qty 59
50302	29344
50303	15271
50304	11996
50305	8408
50306	2605
50307	6983
50308	7791
50309	4684
50310	2525
50311	847
50312	3232
50313	6402
50314	2429
50315	3466
50316	3632
50317	583
50318	2274
50319	7686
50320	3870
50321	7931
50322	14089
50323	519
50324	825
50325	6157
50326	9234
50327	1182
50328	8663
50329	9259
50330	9888
50331	8362
50332	2238
50333	2449
50334	2905
50335	2632
50336	4280
50337	1672
50338	2371
50339	2460
50340	1930
50341	5634
50342	3095
50343	6131
50344	11411
50345	1117
50346	2700
50347	4874
50348	2197
50349	5562
50350	4602
50351	5784
50352	5496
50353	1541
50354	1839
50355	2102
50356	1913
50357	3389
50358	1496
50359	2143
50360	2171
50361	1603
50362	4891
50363	2812
50364	5767
50365	10774
50366	975
50367	1870
50368	3628
50369	7963
50370	2244
50371	3406
50372	3452
50373	960
50374	1192
50375	1334
50376	1377
50377	2429
50378	1096
50379	1704
50380	1730
50381	1293
50382	4084
50383	2431
50384	5241
50385	9627
50386	809
50387	1442
50388	3814
50390	9161
50391	11304
50392	23544
50393	7826
50395	6239

FROM CST SCREEN:
Count Time: 01:16  
Total Segments: 92
 
Total Source Codes: 92
    Included: 92
    Excluded:  0
 
Total Customers: 446,293
    Included:    446,293 v
    Excluded:          0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
	OR --- 
    ixCustomer	ixSourceCode	sMailingStatus


*/

    -- SOP will exclude above people (82 customers) 
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_25606_CST_OutputFile_503
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 36 (36 addt'l incl. the split segments that they appended 'A/C' to) 
    WHERE ixSourceCode LIKE '503%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog

    JUST THE SCs with 5 digits and the additional letter indicating which promo type they're getting

*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '503' 
   --   AND LEN(ixSourceCode) = 5 
/*
SCode	Description

*/
      
   /* MISMATCHES! 
	
        -- NONE
	
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.PJC_25606_CST_OutputFile_503
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '503'                              )
   group by  ixSourceCode                             
   /* MISSING!!!
   ixSourceCode	Qty

		many were "missing" because the original SC in CST got replaced with the same SC appended with A,C, or F	
		
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
AFTER   417         338
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    

/******************************************************************************
****** QC checks MODIFIED load list provided by Marketing               *******
****** DOING ALL OF THE SAME STEPS AGAIN BUT NOW FOR THE MODIFIED FILE  ******
******************************************************************************/
-- DROP table PJC_25606_CST_OutputFile_503_MOD2
-- Dupe check
select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.PJC_25606_CST_OutputFile_503_MOD2 
    /*
    AllCnt	DistinctCount	Delta	
    446293	446293	        0	
    */
    
    -- if dupes are found    
        select ixCustomer, COUNT(*) from  PJC_25606_CST_OutputFile_503_MOD2
        group by ixCustomer
        having COUNT(*) > 1
   
        select * from PJC_25606_CST_OutputFile_503_MOD2
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
        order by ixCustomer
   
        -- removing one of each dupe
        set rowcount 1
        Delete 
        from PJC_25606_CST_OutputFile_503_MOD2
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
            and ixCustomer in (select ixCustomer from  PJC_25606_CST_OutputFile_503_MOD2
                            group by ixCustomer
                            having COUNT(*) > 1)
        set rowcount 0                          
                            
-- verify counts by Source Code match 503 LOL.xls sheet provided by Marketing
Select ixSourceCode, COUNT(ixCustomer) QTY
from [SMITemp].dbo.PJC_25606_CST_OutputFile_503_MOD3
group by ixSourceCode
order by ixSourceCode
/* 
    NOTE(S): 503 LOL.xls had counts differing in 4 source codes
    -- After notifying Dylan he made the necessary changes and re-sent the new file. 
       I uploaded them to a new table (PJC_25606_CST_OutputFile_503_MOD2) and re-ran all checks.
       
all delta's were <3 except for...
SC	    Rec	                Delta
50392	Counter	            300
50399	Request in Package	5,000
BLANK	DHL Bulk Center	    5,500
BLANK	CA DHL 	            500
*/                     


select * 
from PJC_25606_CST_OutputFile_503_MOD3
where ixSourceCode in (', 50303',', 50328',',50372C','161521,50303','322','503')

-- all customers in tblCustomer?
select ixCustomer -- 100% 
from [SMITemp].dbo.PJC_25606_CST_OutputFile_503_MOD2 
where 
ixCustomer NOT like '2046946%'
and ixCustomer in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomer)
                     
delete from PJC_25606_CST_OutputFile_503_MOD2
where ixCustomer = '2046946%'

select * from [SMI Reporting].dbo.tblCustomer
where ixCustomer like '2046946%'    

select ixCustomer,',',ixSourceCode 
from PJC_25606_CST_OutputFile_503_MOD2
order by ixSourceCode
    
    
               
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #503 = 04/05/15
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
    WHERE SC.ixCatalog = '503'
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
 FROM PJC_25606_CST_OutputFile_503_MOD2 CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '503%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_25606_CST_503_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '503%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_25606_CST_OutputFile_503_MOD2 CST
 JOIN PJC_25606_CST_503_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 503 ONLY  ******************************/
none

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan AFTER the               **********
 **********     Customer Offers have finished loading into SOP  **********
 **********     and Customer Offers have been refed to          **********
 **********     SMI Reporting.  Update LOL .xls file if Dylan   **********
 **********     provided one.                                   **********/
 
 
-- Customers in Offer table for Cat 503
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_25606_CST_OutputFile_503_MOD2
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '503'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '503' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
SCode	Description					Qty in CST File	Qty in SOP	Delta
50302	12M 5+ $1,000+ SR No Offer	29344	29343	-1
50303	12M 5+ $400+ SR No Offer	15270	15207	-63
50304	12M 5+ $100+ SR No Offer	11996	11995	-1
50305	12M 5+ $1+ SR No Offer	8407	8405	-2
50306	12M 3+ $1,000+ SR No Offer	2605	2605	0
50307	12M 3+ $400+ SR No Offer	6983	6983	0
50308A	12M 3+ $150+ SR No Offer	2597	2596	-1
50308C	12M 3+ $150+ SR $7.99 FR	2596	2596	0
50308F	12M 3+ $150+ SR FREE SHIP	2597	2597	0
50309	12M 3+ $50+ SR No Offer	4684	4684	0
50310	12M 3+ $1+ SR No Offer	2525	2525	0
503100A	3M Requestors SR No Offer	3053	3053	0
503100C	3M Requestors SR $7.99 FR	3054	3054	0
503100F	3M Requestors SR FREE SHIP	3054	3052	-2
503101A	6M Requestors SR No Offer	3768	3767	-1
503101C	6M Requestors SR $7.99 FR	3768	3767	-1
503101F	6M Requestors SR FREE SHIP	3768	3768	0
503102A	9M Requestors SR No Offer	7848	7848	0
503102C	9M Requestors SR $7.99 FR	7848	7846	-2
503102F	9M Requestors SR FREE SHIP	7846	7845	-1
503103A	12M Requestors SR No Offer	2608	2608	0
503103C	12M Requestors SR $7.99 FR	2609	2609	0
503103F	12M Requestors SR FREE SHIP	2609	2609	0
503104	72M 1+ $1+ SR No Offer	6238	6237	-1
50311	12M 2+ $1,000+ SR No Offer	847	847	0
50312	12M 2+ $400+ SR No Offer	3232	3231	-1
50313	12M 2+ $150+ SR No Offer	6401	6400	-1
50314	12M 2+ $100+ SR No Offer	2429	2429	0
50315	12M 2+ $50+ SR No Offer	3466	3466	0
50316	12M 2+ $1+ SR No Offer	3632	3631	-1
50317	12M 1+ $1,000+ SR No Offer	583	583	0
50318	12M 1+ $400+ SR No Offer	2274	2274	0
50319	12M 1+ $150+ SR No Offer	7686	7684	-2
50320	12M 1+ $100+ SR No Offer	3869	3869	0
50321	12M 1+ $50+ SR No Offer	7931	7930	-1
50322	12M 1+ $1+ SR No Offer	14089	14047	-42
50323	12M 2+ $1+ 2B No Offer	519	519	0
50324	12M 1+ $1+ 2B No Offer	825	825	0
50325	12M 2+ $100+ B No Offer	6157	6157	0
50326	12M 2+ $1+ B No Offer	9234	9234	0
50327	12M 1+ $100+ B No Offer	1182	1182	0
50328	12M 1+ $1+ B No Offer	8662	8662	0
50329	24M 3+ $1,000+ SR No Offer	9259	9259	0
50330	24M 3+ $400+ SR No Offer	9888	9888	0
50331	24M 3+ $150+ SR No Offer	8362	8362	0
50332	24M 3+ $100+ SR No Offer	2238	2238	0
50333	24M 3+ $50+ SR No Offer	2449	2449	0
50334	24M 3+ $1+ SR No Offer	2905	2905	0
50335	24M 2+ $400+ SR No Offer	2632	2632	0
50336	24M 2+ $150+ SR No Offer	4280	4280	0
50337	24M 2+ $100+ SR No Offer	1671	1671	0
50338	24M 2+ $50+ SR No Offer	2371	2371	0
50339	24M 2+ $1+ SR No Offer	2460	2460	0
50340	24M 1+ $400+ SR No Offer	1930	1930	0
50341	24M 1+ $150+ SR No Offer	5633	5633	0
50342	24M 1+ $100+ SR No Offer	3095	3095	0
50343	24M 1+ $50+ SR No Offer	6131	6131	0
50344A	24M 1+ $1+ SR No Offer	3804	3804	0
50344C	24M 1+ $1+ SR $7.99 FR	3804	3804	0
50344F	24M 1+ $1+ SR FREE SHIP	3802	3802	0
50345A	24M 1+ $1+ 2B No Offer	372	372	0
50345C	24M 1+ $1+ 2B $7.99 FR	372	372	0
50345F	24M 1+ $1+ 2B FREE SHIP	373	373	0
50346	24M 2+ $100+ B No Offer	2700	2700	0
50347	24M 2+ $1+ B No Offer	4874	4874	0
50348	24M 1+ $50+ B No Offer	2197	2197	0
50349A	24M 1+ $1+ B No Offer	1854	1854	0
50349C	24M 1+ $1+ B $7.99 FR	1854	1854	0
50349F	24M 1+ $1+ B FREE SHIP	1852	1852	0
503500	CAMAROS & CLASSICS 2015	NULL	0	0
50350A	36M 3+ $1,000+ SR No Offer	1534	1534	0
50350C	36M 3+ $1,000+ SR $7.99 FR	1534	1534	0
50350F	36M 3+ $1,000+ SR FREE SHIP	1534	1534	0
50351A	36M 3+ $400+ SR No Offer	1928	1927	-1
50351C	36M 3+ $400+ SR $7.99 FR	1928	1928	0
50351F	36M 3+ $400+ SR FREE SHIP	1928	1928	0
50352A	36M 3+ $150+ SR No Offer	1832	1832	0
50352C	36M 3+ $150+ SR $7.99 FR	1832	1832	0
50352F	36M 3+ $150+ SR FREE SHIP	1832	1832	0
50353A	36M 3+ $100+ SR No Offer	513	513	0
50353C	36M 3+ $100+ SR $7.99 FR	512	512	0
50353F	36M 3+ $100+ SR FREE SHIP	516	516	0
50354A	36M 3+ $50+ SR No Offer	613	613	0
50354C	36M 3+ $50+ SR $7.99 FR	614	614	0
50354F	36M 3+ $50+ SR FREE SHIP	612	612	0
50355A	36M 3+ $1+ SR No Offer	700	700	0
50355C	36M 3+ $1+ SR $7.99 FR	701	701	0
50355F	36M 3+ $1+ SR FREE SHIP	701	701	0
50356A	36M 2+ $400+ SR No Offer	637	637	0
50356C	36M 2+ $400+ SR $7.99 FR	638	638	0
50356F	36M 2+ $400+ SR FREE SHIP	638	638	0
50357A	36M 2+ $150+ SR No Offer	1129	1129	0
50357C	36M 2+ $150+ SR $7.99 FR	1130	1130	0
50357F	36M 2+ $150+ SR FREE SHIP	1130	1130	0
50358A	36M 2+ $100+ SR No Offer	498	498	0
50358C	36M 2+ $100+ SR $7.99 FR	499	499	0
50358F	36M 2+ $100+ SR FREE SHIP	499	499	0
50359A	36M 2+ $50+ SR No Offer	714	714	0
50359C	36M 2+ $50+ SR $7.99 FR	715	715	0
50359F	36M 2+ $50+ SR FREE SHIP	714	714	0
50360A	36M 2+ $1+ SR No Offer	723	723	0
50360C	36M 2+ $1+ SR $7.99 FR	724	724	0
50360F	36M 2+ $1+ SR FREE SHIP	724	724	0
50361A	36M 1+ $400+ SR No Offer	535	535	0
50361C	36M 1+ $400+ SR $7.99 FR	534	534	0
50361F	36M 1+ $400+ SR FREE SHIP	534	534	0
50362A	36M 1+ $150+ SR No Offer	1631	1631	0
50362C	36M 1+ $150+ SR $7.99 FR	1630	1630	0
50362F	36M 1+ $150+ SR FREE SHIP	1630	1630	0
50363A	36M 1+ $100+ SR No Offer	938	933	-5
50363C	36M 1+ $100+ SR $7.99 FR	937	937	0
50363F	36M 1+ $100+ SR FREE SHIP	937	937	0
50364A	36M 1+ $50+ SR No Offer	1922	1922	0
50364C	36M 1+ $50+ SR $7.99 FR	1922	1922	0
50364F	36M 1+ $50+ SR FREE SHIP	1923	1923	0
50365A	36M 1+ $1+ SR No Offer	3592	3592	0
50365C	36M 1+ $1+ SR $7.99 FR	3591	3591	0
50365F	36M 1+ $1+ SR FREE SHIP	3591	3591	0
50366A	36M 1+ $1+ 2B No Offer	325	325	0
50366C	36M 1+ $1+ 2B $7.99 FR	325	325	0
50366F	36M 1+ $1+ 2B FREE SHIP	325	325	0
50367A	36M 2+ $100+ B No Offer	624	624	0
50367C	36M 2+ $100+ B $7.99 FR	623	623	0
50367F	36M 2+ $100+ B FREE SHIP	623	623	0
50368A	36M 2+ $1+ B No Offer	1210	1210	0
50368C	36M 2+ $1+ B $7.99 FR	1209	1209	0
50368F	36M 2+ $1+ B FREE SHIP	1209	1209	0
50369A	36M 1+ $1+ B No Offer	2655	2655	0
50369C	36M 1+ $1+ B $7.99 FR	2654	2654	0
50369F	36M 1+ $1+ B FREE SHIP	2654	2654	0
50370A	48M 3+ $1,000+ SR No Offer	748	748	0
50370C	48M 3+ $1,000+ SR $7.99 FR	748	748	0
50370F	48M 3+ $1,000+ SR FREE SHIP	748	748	0
50371A	48M 3+ $400+ SR No Offer	1136	1136	0
50371C	48M 3+ $400+ SR $7.99 FR	1135	1135	0
50371F	48M 3+ $400+ SR FREE SHIP	1135	1135	0
50372A	48M 3+ $150+ SR No Offer	1150	1150	0
50372C	48M 3+ $150+ SR $7.99 FR	1151	1150	-1
50372F	48M 3+ $150+ SR FREE SHIP	1151	1151	0
50373A	48M 3+ $100+ SR No Offer	320	320	0
50373C	48M 3+ $100+ SR $7.99 FR	320	320	0
50373F	48M 3+ $100+ SR FREE SHIP	320	320	0
50374A	48M 3+ $50+ SR No Offer	397	396	-1
50374C	48M 3+ $50+ SR $7.99 FR	397	397	0
50374F	48M 3+ $50+ SR FREE SHIP	398	398	0
50375A	48M 3+ $1+ SR No Offer	444	444	0
50375C	48M 3+ $1+ SR $7.99 FR	444	444	0
50375F	48M 3+ $1+ SR FREE SHIP	446	446	0
50376A	48M 2+ $400+ SR No Offer	459	459	0
50376C	48M 2+ $400+ SR $7.99 FR	459	459	0
50376F	48M 2+ $400+ SR FREE SHIP	459	459	0
50377A	48M 2+ $150+ SR No Offer	809	809	0
50377C	48M 2+ $150+ SR $7.99 FR	810	810	0
50377F	48M 2+ $150+ SR FREE SHIP	810	810	0
50378A	48M 2+ $100+ SR No Offer	365	365	0
50378C	48M 2+ $100+ SR $7.99 FR	365	365	0
50378F	48M 2+ $100+ SR FREE SHIP	366	366	0
50379A	48M 2+ $50+ SR No Offer	568	568	0
50379C	48M 2+ $50+ SR $7.99 FR	568	567	-1
50379F	48M 2+ $50+ SR FREE SHIP	568	568	0
503801A	Rod Run Requestors SR No Offer	NULL	0	0
503801C	Rod Run Requestors SR $7.99 FR	NULL	0	0
503801F	Rod Run Requestors SR FREE SHIP	NULL	0	0
50380A	48M 2+ $1+ SR No Offer	576	576	0
50380C	48M 2+ $1+ SR $7.99 FR	577	577	0
50380F	48M 2+ $1+ SR FREE SHIP	577	577	0
50381A	48M 1+ $400+ SR No Offer	431	431	0
50381C	48M 1+ $400+ SR $7.99 FR	431	431	0
50381F	48M 1+ $400+ SR FREE SHIP	431	431	0
50382A	48M 1+ $150+ SR No Offer	1361	1361	0
50382C	48M 1+ $150+ SR $7.99 FR	1361	1361	0
50382F	48M 1+ $150+ SR FREE SHIP	1362	1362	0
50383A	48M 1+ $100+ SR No Offer	810	810	0
50383C	48M 1+ $100+ SR $7.99 FR	810	810	0
50383F	48M 1+ $100+ SR FREE SHIP	811	810	-1
50384A	48M 1+ $50+ SR No Offer	1747	1747	0
50384C	48M 1+ $50+ SR $7.99 FR	1747	1747	0
50384F	48M 1+ $50+ SR FREE SHIP	1747	1747	0
50385A	48M 1+ $1+ SR No Offer	3209	3209	0
50385C	48M 1+ $1+ SR $7.99 FR	3209	3209	0
50385F	48M 1+ $1+ SR FREE SHIP	3209	3209	0
50386A	48M 1+ $1+ 2B No Offer	269	269	0
50386C	48M 1+ $1+ 2B $7.99 FR	270	270	0
50386F	48M 1+ $1+ 2B FREE SHIP	270	270	0
50387A	48M 2+ $100+ B No Offer	480	480	0
50387C	48M 2+ $100+ B $7.99 FR	481	481	0
50387F	48M 2+ $100+ B FREE SHIP	481	481	0
50388	12M 3+ $100+ R No Offer	3814	3795	-19
50390A	Goodguy's List SR No Offer	NULL	0	0
50390C	Goodguy's List SR $7.99 FR	NULL	0	0
50390F	Goodguy's List SR FREE SHIP	NULL	0	0
50392	COUNTER	NULL	0	0
50396	CA DHL No Offer	NULL	0	0
50398	DHL Bulk Center No Offer	NULL	0	0
50399	Request in Package No Offer	NULL	0	0
6971	OL SKOOL RODZ	NULL	0	0
6972	HOT ROD	NULL	0	0
6976	STREET SCENE	NULL	0	0
6977	CHEVY HIGH PERFORMANCE	NULL	0	0
6978	CLASSIC TRUCKS	NULL	0	0
6979	GOODGUYS GAZETTE	NULL	0	0
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
                    from PJC_25606_CST_OutputFile_503_MOD2
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '503' )
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
            from PJC_25606_CST_OutputFile_503_MOD3 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '503%'
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
      