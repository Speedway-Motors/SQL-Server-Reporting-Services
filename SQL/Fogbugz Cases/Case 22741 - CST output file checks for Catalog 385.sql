-- Case 22741 - CST output file checks for Catalog 385 
  -- previous CST case = 22327 (NO 
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '385'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '385%'

-- Catalog 385 = SPRNT SUM. '14

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_22741_CST_OutputFile_385
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 379 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "80-385.txt" for Catalog 385 has passed the following QC checks.

1 - customer count in original CST file = 443,151
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

9. send Dylan and Kyle a list of the final counts of offers loaded by sourcecode through the case.
******************************************************************************************************************/

-- quick review to verify data formatted correctly
SELECT TOP 10 * FROM dbo.PJC_22741_CST_OutputFile_385 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM PJC_22741_CST_OutputFile_385       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
36,572	36,572      36,572
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM PJC_22741_CST_OutputFile_385
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM PJC_22741_CST_OutputFile_385
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM PJC_22741_CST_OutputFile_385
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode


/**************
SCode	Qty
38502	3371
38503	1180
38504	2334
38505	1202
38506	4253
38507	1545
38508	1653
38509	4578
38510	2165
38511	4198
38512	1059
38513	600
38514	1246
38515	1166
38516	3840
38570	2182



    FROM CST SCREEN
Count Time: 03:19
Total Segments: 16
 
Total Source Codes: 16
    Included: 16
    Excluded:  0
 
Total Customers: 36,572
    Included:    36,572 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM PJC_22741_CST_OutputFile_385 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM PJC_22741_CST_OutputFile_385 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
/*
    ixCustomer	ixSourceCode	sMailingStatus
    201752	    38516	        9
*/



    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_22741_CST_OutputFile_385
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 3
    WHERE ixSourceCode LIKE '385%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '385' 
      AND LEN(ixSourceCode) = 5
      
   /*MISMATCH! 
    38516 - SOP "12m, 6+, $1000 Race" 
    38516 - CST "12m, 6+, $2000 Race"
    
    select ixCustomer
    from PJC_22741_CustsQualifyingFor_12M_6plus_2K_Race         -- 8,042 
    where ixCustomer NOT IN 
        (select ixCustomer from PJC_22741_CST_OutputFile_385)   --    11
        
   select ixCustomer, dbo.GetCatalogsMailedToCust (ixCustomer) 'Catalogs Received'
    from tblOrder
    where dtShippedDate >= '05/18/2013'
    and ixCustomer in ('712979','1179453','1045217','1025022','1133122','865623','810123','207288','529176','1299463','297827')
    group by ixCustomer
    order by ixCustomer
    
    ixCustomer	Catalogs Received
    207288	209, 349, 358, 359, 360, 364, 354, 355, 361, 377, 383, 373, 378, 384, 379, 375, 380
    297827	349, 349, 367, 367, 358, 358, 350, 359, 351, 363, 368, 352, 360, 353, 364, 354, 361, 377, 383, 373, 378, 384, 379, 375, 380
    529176	349, 367, 358, 350, 359, 351, 363, 352, 360, 361, 377, 378, 379, 380
    712979	213, 349, 358, 351, 360, 366, 371, 354, 377, 378, 375, 380, 376
    810123	362, 349, 367, 358, 359, 363, 368, 360, 364, 354, 372, 355, 361, 377, 383, 373, 378, 384, 379, 375, 380
    865623	349, 367, 358, 359, 363, 368, 360, 364, 371, 354, 355, 361, 377, 383, 373, 386, 378, 384, 379, 375, 380
    1025022	349, 367, 358, 350, 359, 351, 363, 368, 352, 360, 364, 354, 355, 361, 377, 383, 373, 378, 384, 379, 375, 380
    1045217	358, 359, 360, 361, 377, 378, 380
    1133122	349, 358, 350, 359, 351, 368, 352, 360, 364, 354, 355, 361, 377, 383, 373, 378, 384, 379, 375, 380
    1179453	349, 367, 358, 350, 359, 351, 363, 368, 352, 360, 353, 364, 354, 355, 361, 356, 377, 383, 373, 378, 374, 384, 379, 375, 380, 376
    1299463	349, 367, 358, 350, 359, 351, 363, 368, 352, 360, 353, 364, 354, 361, 377, 383, 373, 378, 374, 384, 379, 375, 380
        
   */

/***************
SCode	Description
38502	12M, 3+, $400+
38503	12M, 3+, $100+
38504	12M, 2+, $1+
38505	12M, 1+, $100+
38506	12M, 1+, $1+
38507	24M, 3+, $100+
38508	24M, 2+, $1+
38509	24M, 1+, $1+
38510	36M, 1+, $100+
38511	36M, 1+, $1+
38512	48M, 2+, $100+
38513	48M, 1+, $100+
38514	60M, 1+, $100
38515	12m, 3+, $1000 Both
38516	12m, 6+, $1000 Race
38560	Bill's Friends
38561	PRS Dealers
38570	12M Requestors; $7.99 Flat Rate
38592	Counter
38598	DHL Bulk Center
38599	RIP - Bouncebacks
*/


/*********** 6. Update deceased exempt list   **********/

-- execute the following BEFORE and AFTER running the update 

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
BEFORE  390         315
AFTER   390         315
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    

    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #385 = 06/23/14
    -- kicked off routine @11:29PM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 36572  -- <-- total amount of customer offers in the CST campaign that's loading
    SELECT 
         CONVERT(VARCHAR, GETDATE(), 8)    AS 'As Of   '
        ,@QtyToLoad 'TotQty'
        ,count(CO.ixCustomer) 'Loaded'
        , (@QtyToLoad-count(CO.ixCustomer)) 'ToGo'
        --,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as 'SecRun'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 'Rec/Sec'
        --,CONVERT(DECIMAL(10,0),(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *60.00) as 'Rec/Min'
        ,CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00)) as 'Rec/Hour',
        (@QtyToLoad-count(CO.ixCustomer))/(CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00))) as 'EstHrsToFinish'
    FROM [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    WHERE SC.ixCatalog = '385'
AND CO.dtDateLastSOPUpdate = '05/20/2014'    
    GROUP BY T.ixTime, T.chTime
    /*  36,572  total offers to load
                latest ETA is 12:50 PM
      
/*
As Of   	TotQty	Loaded	ToGo	Rec/Sec	            Rec/Hour    EstHrsToFinish	    
12:01:44	36572	15554	21018	8.35787211176786	30088	    0.69855091730	
12:19:03	36572	24978	11594	8.61310344827586	31007	    0.37391556745
*/  


Cust
Count	RunTime			    	SecRun	Rec/Min Rec/Hour	Rec/Sec
2854	2014-02-19 12:58:30		252		679.52	40771.43	11.33
8140	2014-02-19 13:06:27		729		669.96	40197.53	11.17     
42417	2014-02-19 13:55:33		3675	692.52	41551.35	11.54
      
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
    375 
    380     237,171             8.2 04-14-14    Tue night & Wed (ran in two parts)
    385      36,572   4,569     8.0 05-20-14    Tue late morning
    
       /********** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   **********/
    */


/*************   SPECIAL NOTES FOR CAT 385 ONLY  ******************************
   see MISMATCH notes starting around line 160
   
*/

  

-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/**********  8. Compare CST file to Qty loaded into SOP   **********/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_22741_CST_OutputFile_385
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '385'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '385'                            
order by SC.ixSourceCode 
-- note!  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

-- details on Customers that "failed to load" into tblCustomerOffer
-- most should be recently changed mail status or merged customers that are now flagged as deleted
select ixCustomer 'Cust #'
    , sMailingStatus+'    ' as 'MailingStatus' 
    , flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_22741_CST_OutputFile_385
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '385' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1535532	0    	1
360753	0    	1
185137	0    	0
349902	0    	0
421464	0    	0
821730	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from PJC_22741_CST_OutputFile_385 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '385%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*

            */




-- Customers in Offer table for Cat 385
/********** PROVIDE THESE COUNTS TO Dylan & Philip after SOP loads all of the customer offers **********/
select SC.ixSourceCode 'SCode', count(distinct CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '385' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description

*/






select sum(mExtendedPrice) from tblOrderLine where
    

