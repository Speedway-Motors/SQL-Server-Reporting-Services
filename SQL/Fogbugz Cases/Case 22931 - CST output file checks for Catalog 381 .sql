-- Case 22931 - CST output file checks for Catalog 381 
  -- previous CST case = 22741 (NO 
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '381'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '381%'

-- Catalog 381 = '14 RACE SUMMER

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_22931_CST_OutputFile_381
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 379 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "80-381.txt" for Catalog 381 has passed the following QC checks.

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
SELECT TOP 10 * FROM [SMITemp].dbo.PJC_22931_CST_OutputFile_381 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM PJC_22931_CST_OutputFile_381       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
102,433	102,433     102,433
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM PJC_22931_CST_OutputFile_381
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM PJC_22931_CST_OutputFile_381
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM PJC_22931_CST_OutputFile_381
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty
38102	6265
38103	8777
38104	716
38105	7529
38106	2089
38107	2810
38108	6566
38109	3823
38110	1915
38111	2925
38112	3434
38113	7042
38114	2926
38115	6224
38116	6346
38117	16054
38118	4395
38119	5227
38120	6234
38121	1136

    FROM CST SCREEN
Count Time: 10:42
Total Segments: 20
 
Total Source Codes: 20
    Included: 20
    Excluded:  0
 
Total Customers: 102,433
    Included:    102,433 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM PJC_22931_CST_OutputFile_381 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM PJC_22931_CST_OutputFile_381 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
/*
    ixCustomer	ixSourceCode	sMailingStatus
    1505615	    38113	        9
*/

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_22931_CST_OutputFile_381
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 3
    WHERE ixSourceCode LIKE '381%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '381' 
      AND LEN(ixSourceCode) = 5
      
   /*MISMATCHES! 
    38102 - CST	12M, 6+, $1000+
    38102 - SOP	12M, 6+, $2000+
    
    38103 - CST	12M, 6+, $2000+
    38103 - SOP	12M, 6+, $1000+

   */

/***************
SCode	Description
38102	12M, 6+, $1000+
38103	12M, 6+, $2000+
38104	12M, 5+, $1000+
38105	12M, 5+, $400+
38106	12M, 3+, $700+
38107	12M, 3+, $400+
38108	12M, 3+, $200+
38109	12M, 3+, $100+
38110	12M, 2+, $400+
38111	12M, 2+, $200+
38112	12M, 2+, $100+
38113	12M, 2+, $1+
38114	12M, 1+, $250+
38115	12M, 1+, $100+
38116	12M, 1+, $50+
38117	12M, 1+, $1+
38118	24M, 3+, $1000+
38119	24M, 3+, $400+
38120	24M, 3+, $100+
38121	24M, 2+, $400+
38160	PRS Dealers
38161	Bill's Friends
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
BEFORE  393         319
AFTER   393         319
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #381 = 07/07/14
    -- kicked off routine @8:45AM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 102433  -- <-- total amount of customer offers in the CST campaign that's loading
    SELECT 
         CONVERT(VARCHAR, GETDATE(), 8)    AS 'As Of   '
        ,@QtyToLoad 'TotQty'
        ,count(CO.ixCustomer) 'Loaded'
        , (@QtyToLoad-count(CO.ixCustomer)) 'ToGo'
        --,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as 'SecRun'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 'Rec/Sec'
        --,CONVERT(DECIMAL(10,0),(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *60.00) as 'Rec/Min'
        ,CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00)) as 'Rec/Hr',
        (@QtyToLoad-count(CO.ixCustomer))/(CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00))) as 'EstHrsToFinish'
    FROM [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    WHERE SC.ixCatalog = '381'
AND CO.dtDateLastSOPUpdate = '06/04/2014'    
    GROUP BY T.ixTime, T.chTime
    /*  102,433 total offers to load
                latest ETA is 12:25 PM
      
/*
As Of   	TotQty	Loaded	ToGo	Rec/Sec	            Rec/Hr  EstHrsToFinish	    
11:49:32	102433	92796	9637	8.37811484290357	30161	0.31951858360

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
    381     102,433  12,548     8.2 06-04-14    Wed mid morning
       /********** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   **********/
    */


/*************   SPECIAL NOTES FOR CAT 381 ONLY  ******************************
   see MISMATCH notes starting around line 160
   
*/

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan & Philip AFTER the      **********
 **********     Customer Offers have finished loading into SOP  **********/

-- Customers in Offer table for Cat 381
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_22931_CST_OutputFile_381
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '381'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '381'                            
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
                    from PJC_22931_CST_OutputFile_381
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '381' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
872661	0    	0
594974	0    	1
1436622	0    	0
1016065	0    	0
342789	0    	0
1131164	0    	0
1897146	0    	1
1966870	0    	0
1073616	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from PJC_22931_CST_OutputFile_381 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '381%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
                1016065,38103
                1073616,38103
                1436622,38103
                342789,38103
                1897146,38108
                1966870,38111
                594974,38116
                1131164,38118
                872661,38120
            */

