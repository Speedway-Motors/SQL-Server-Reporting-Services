-- Case 25154 - CST Output File Checks for Catalog 402 
  -- previous CST case = 25067
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '600'
-- Catalog 600 = '15 WINT SPRINT

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '600%' 
-- UNABLE TO REVIEW.  SCs have not yet been created in SOP

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '600%'
  AND LEN(ixSourceCode) <> 5
-- UNABLE TO REVIEW.  SCs have not yet been created in SOP
  
  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '600%'
  AND LEN(ixSourceCode) >= 5  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- UNABLE TO REVIEW.  SCs have not yet been created in SOP

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_25154_CST_OutputFile_600
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 600 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "94-600.txt" for Catalog 600 has passed the following QC checks.

1 - customer count in original CST file = 61,163
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

9. send Dylan and CC Philip a list of the final counts of offers loaded by sourcecode through the case.
******************************************************************************************************************/
-- DROP TABLE [SMITemp].dbo.PJC_25154_CST_OutputFile_600

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_25154_CST_OutputFile_600 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  from [SMITemp].dbo.PJC_25154_CST_OutputFile_600 
order by LEN(ixSourceCode) desc

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.PJC_25154_CST_OutputFile_600       
                       
/*
All     Distinct            CST
Count	Count	    Delta   Count
======  ========    =====   =======
49,514	49,514	    0	    49,514 v
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_25154_CST_OutputFile_600
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_25154_CST_OutputFile_600
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_25154_CST_OutputFile_600
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty 45


FROM CST SCREEN:
Count Time: 00:19  <-- yeah that's right, SECONDS!
Total Segments:16
 
Total Source Codes: 23
    Included: 23
    Excluded:  0
 
Total Customers: 49,514
    Included:    49,514 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_25154_CST_OutputFile_600 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_25154_CST_OutputFile_600 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
    ixCustomer	ixSourceCode	sMailingStatus
   9
    
*/

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_25154_CST_OutputFile_600
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 5 (12 addt'l incl. the split segments that they appended 'B' to) 
    WHERE ixSourceCode LIKE '600%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog

    JUST THE SCs with 5 digits and the additional letter indicating which promo type they're getting

*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '600' 
   --   AND LEN(ixSourceCode) = 5 
/*
SCode	Description
60002	12M 3+ $1,000+ Control SM
60003	12M 3+ $150+ Control SM
60004	12M 3+ $1+ Control SM
60005	12M 2+ $1+ Control SM
60006	12M 1+ $1+ Control SM
60007	12M 5+ $1,000+ Control R
60008	24M 3+ $150+ Control SM
60009	24M 3+ $1+ Control SM
60010	24M 1+ $1+ Control SM
60011A	36M 3+ $150+ Control SM
60011C	36M 3+ $150+ Free Ship $100 SM
60012A	36M 3+ $1+ Control SM
60012C	36M 3+ $1+ Free Ship $100 SM
60013A	36M 1+ $1+ Control SM
60013C	36M 1+ $1+ Free Ship $100 SM
60014A	48M 3+ $1+ Control SM
60014C	48M 3+ $1+ Free Ship $100 SM
60015A	48M 1+ $1+ Control SM
60015C	48M 1+ $1+ Free Ship $100 SM
60016A	60M 3+ $1+ Control SM
60016C	60M 3+ $1+ Free Ship $100 SM
60070A	12M Requestors Control SM
60070C	12M Requestors Free Ship $100 SM
60092	COUNTER BULK
60098	DHL
60099	Request In Package
6941	CHILI BOWL PROGRAM 2014
6952	SPRINTCAR & MIDGET
*/
      
   /* MISMATCHES! 
	
        none
	
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.PJC_25154_CST_OutputFile_600
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '600'                              )
   group by  ixSourceCode                             
   /* MISSING!!!
   ixSourceCode	Qty

	Special case... all of the source codes will be built in SOP just PRIOR to loading the customer offers
	
    */

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_25154_CST_OutputFile_600 CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '600%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_25154_CST_600_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '600%' AND len(CO.ixSourceCode) = 5
 
 
 51399
 
 SELECT * FROM PJC_25154_CST_OutputFile_600 CST
 JOIN PJC_25154_CST_600_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
         
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
BEFORE  420         336      v
AFTER   419         337
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    



               
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #600 = 02/16/15
    -- kicked off routine 1/14/15 @19:30PM
*/

     -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 381375  -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '600'
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  405,920 total offers to load
                latest ETA is 09:50 PM */
                
select * from [SMI Reporting].dbo.tblTime where chTime like '09:45%'                
      
      
/*
  
-- kicked off customer offer load routine 01/10/15 1:03PM     .... finished 01/11/15 9:18 PM         
--  49,514 records in file
               
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
            
**********************************************************************************/
                   

/*************   SPECIAL NOTES FOR CAT 600 ONLY  ******************************/
none

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan AFTER the               **********
 **********     Customer Offers have finished loading into SOP  **********
 **********     and Customer Offers have been refed to          **********
 **********     SMI Reporting.  Update LOL .xls file if Dylan   **********
 **********     provided one.                                   **********/
 
 
-- Customers in Offer table for Cat 600
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_25154_CST_OutputFile_600
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '600'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '600' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
    SCode	Description	Qty in SOP
    60002	12M 3+ $1,000+ Control SM	2611
    60003	12M 3+ $150+ Control SM	4747
    60004	12M 3+ $1+ Control SM	12030
    60005	12M 2+ $1+ Control SM	1448
    60006	12M 1+ $1+ Control SM	1801
    60007	12M 5+ $1,000+ Control R	8470
    60008	24M 3+ $150+ Control SM	1673
    60009	24M 3+ $1+ Control SM	3564
    60010	24M 1+ $1+ Control SM	2106
    60011A	36M 3+ $150+ Control SM	480
    60011C	36M 3+ $150+ Free Ship $100 SM	479
    60012A	36M 3+ $1+ Control SM	997
    60012C	36M 3+ $1+ Free Ship $100 SM	995
    60013A	36M 1+ $1+ Control SM	938
    60013C	36M 1+ $1+ Free Ship $100 SM	937
    60014A	48M 3+ $1+ Control SM	908
    60014C	48M 3+ $1+ Free Ship $100 SM	907
    60015A	48M 1+ $1+ Control SM	710
    60015C	48M 1+ $1+ Free Ship $100 SM	711
    60016A	60M 3+ $1+ Control SM	500
    60016C	60M 3+ $1+ Free Ship $100 SM	500
    60070A	12M Requestors Control SM	984
    60070C	12M Requestors Free Ship $100 SM	984
    60092	COUNTER BULK	0
    60098	DHL	0
    60099	Request In Package	0
    6941	CHILI BOWL PROGRAM 2014	0
    6952	SPRINTCAR & MIDGET	0
    6954	ALLSTAR CIRCUIT OF CHAMPS RULEBOOK 2015	0
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
                    from PJC_25154_CST_OutputFile_600
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '600' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
ALL 34 were deleted from SOP

*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from PJC_25154_CST_OutputFile_600 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   tblCustomerOffer CO 
                            where CO.ixSourceCode like '600%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
                
            */
