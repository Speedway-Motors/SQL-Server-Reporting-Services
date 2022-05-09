-- Case 23108 - CST Output File Checks for Catalog 387 
  -- previous CST case = 23080
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '387'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '387%'

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '387%'
  AND LEN(ixSourceCode) >= 5

-- Catalog 387 = '14 SUMMER TBUCKET

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_23108_CST_OutputFile_387
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 387 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "94-387.txt" for Catalog 387 has passed the following QC checks.

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

-- quick review to verify data formatted correctly
SELECT TOP 10 * FROM [SMITemp].dbo.ASC_23108_CST_OutputFile_387 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM ASC_23108_CST_OutputFile_387       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
61,163	61,163      61,163
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM ASC_23108_CST_OutputFile_387
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM ASC_23108_CST_OutputFile_387
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM ASC_23108_CST_OutputFile_387
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty
38702	1388
38702B	595
38703	1147
38703B	491
38704	1448
38704B	621
38705	2279
38705B	976
38706	965
38706B	413
38707	924
38707B	396
38708	3363
38708B	1442
38709	889
38709B	381
38710	1695
38710B	726
38711	2148
38711B	920
38712	1275
38712B	546
38713	3167
38713B	1358
38714	2553
38715	2087
38716	13381
38770	6053
38771	4149
38772	3387

FROM CST SCREEN:
Count Time: 02:51
Total Segments: 18
 
Total Source Codes: 30
    Included: 30
    Excluded:  0
 
Total Customers: 61,163
    Included:    61,163 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM ASC_23108_CST_OutputFile_387 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM ASC_23108_CST_OutputFile_387 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
/*
	-- NONE
    ixCustomer	ixSourceCode	sMailingStatus
    
*/

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_23108_CST_OutputFile_387
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 5 (12 addt'l incl. the split segments that they appended 'B' to) 
    WHERE ixSourceCode LIKE '387%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '387' 
      AND LEN(ixSourceCode) = 5 -- >= 5 since the split segments are 6 digits in length 
      
   /*MISMATCHES! 
	Source Code = 38716
	Datawarehouse: 12M, 7+, $2000 
	CST: 12M, 6+, $1000
	
	CST was loaded correctly Dylan just did not fix the SOP description as he should have. Once this was done I was able to move forward. 
   */

/***************
SCode	Description
38702	12M, 2+, $400+
38702B	12M, 2+, $400+ 30% Split
38703	12M, 2+, $100+
38703B	12M, 2+, $100+ 30% Split
38704	12M, 1+, $100+
38704B	12M, 1+, $100+ 30% Split
38705	12M, 1+, $1+
38705B	12M, 1+, $1+ 30% Split
38706	24M, 2+, $400+
38706B	24M, 2+, $400+ 30% Split
38707	24M, 2+, $100+
38707B	24M, 2+, $100+ 30% Split
38708	24M, 1+, $1+
38708B	24M, 1+, $1+ 30% Split
38709	36M, 3+, $100+
38709B	36M, 3+, $100+ 30% Split
38710	36M, 1+, $100+
38710B	36M, 1+, $100+ 30% Split
38711	36M, 1+, $1+
38711B	36M, 1+, $1+ 30% Split
38712	48M, 2+, $100+
38712B	48M, 1+, $100+ 30% Split
38713	48M, 1+, $1+
38713B	48M, 1+, $1+ 30% Split
38714	60M, 1+, $100+
38715	72M, 1+, $100+
38716	12M, 6+, $1000+ SR
38761	Mr. Roadster Dealers
38770	12 Month Requestors
38771	18 Month Requestors
38772	24 Month Requestors
38792	Counter
38798	DHL Bulk Center
38799	RIP - Bouncebacks
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
BEFORE  391         321      v
AFTER   391         321
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #387 = 07/28/14
    -- kicked off routine @10:03AM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 61163  -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '387'
AND CO.dtDateLastSOPUpdate = '06/24/2014' 
and CO.ixTimeLastSOPUpdate >= 36000
    GROUP BY T.ixTime, T.chTime
  
    /*  61,163 total offers to load
                latest ETA is 12:15 PM */
      
/*
As Of   	TotQty	Loaded	ToGo	Rec/Sec	            Rec/Hr  EstHrsToFinish	    
10:14:08	61163	5058	56105	7.09396914446002	25538	2.19692223353
10:38:08	61163	14209	46954	6.59962842545285	23759	1.97626162717
11:54:08	61163	41500	19663	6.18203485773871	22255	0.88353179060
*/  

/***************************************************************     
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
    388     377,093	 46,236		8.1	06-19-14	Thursday (ran during production hours) 
    387		 61,163	 10,368		5.9	06-24-14	Tuesday (ran during production hours) 

    
       /********** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   **********/
                   
**********************************************************************************/
                   

/*************   SPECIAL NOTES FOR CAT 388 ONLY  ******************************/
   
   -- See MISMATCH notes starting on line 177

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan & Philip AFTER the      **********
 **********     Customer Offers have finished loading into SOP  **********/

-- Customers in Offer table for Cat 387
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_23108_CST_OutputFile_387
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '387'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '387'                            
order by SC.ixSourceCode 

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
                    from ASC_23108_CST_OutputFile_387
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '387' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
431212	0    	1
1267734	0    	0
843034	0    	1
1724631	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_23108_CST_OutputFile_387 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '387%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
                843034,38714
				1267734,38716
				431212,38716
				1724631,38770
            */

