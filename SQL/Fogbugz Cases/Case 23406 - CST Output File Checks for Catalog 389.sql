-- Case 23406 - CST Output File Checks for Catalog 389 
  -- previous CST case = 23080
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '389'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '389%'

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '389%'
  AND LEN(ixSourceCode) >= 5

-- Catalog 389 = '14 SUMMER TBUCKET

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_23406_CST_OutputFile_389
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 389 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "94-389.txt" for Catalog 389 has passed the following QC checks.

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
SELECT TOP 10 * FROM [SMITemp].dbo.PJC_23406_CST_OutputFile_389 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM PJC_23406_CST_OutputFile_389       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
405,920	405,920     405,920
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM PJC_23406_CST_OutputFile_389
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM PJC_23406_CST_OutputFile_389
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM PJC_23406_CST_OutputFile_389
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty 47


FROM CST SCREEN:
Count Time: 33:04
Total Segments: 47
 
Total Source Codes: 47
    Included: 47
    Excluded:  0
 
Total Customers: 405,920
    Included:    405,920 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM PJC_23406_CST_OutputFile_389 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM PJC_23406_CST_OutputFile_389 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
/*
	-- NONE
    ixCustomer	ixSourceCode	sMailingStatus
    1349572	            38918	9
    1111864	            38926	9
    1247748	            38934	9
    1837244	            38936	9    
    
*/

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_23406_CST_OutputFile_389
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 5 (12 addt'l incl. the split segments that they appended 'B' to) 
    WHERE ixSourceCode LIKE '389%' AND len(ixSourceCode) <> 5
    /*
    ixSourceCode	ixCatalog
    3890	209
    3892	209
    3893	209
    3894	209
    3895	209
    3896	209
    3897	209
    3898	209
    3899	209
*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '389' 
      AND LEN(ixSourceCode) = 5 -- >= 5 since the split segments are 6 digits in length 
      
   /* MISMATCHES! 
	Source Code = 38938
	    SOP/DW: 12M, 1+, $1+ Both
	       CST: 24M, 1+, $1+ Both
	
	CST was loaded correctly Dylan just did not fix the SOP description as he should have. Once this was done I was able to move forward. 
	
   */

/***************
SCode	Description
38902	12M, 6+, $2000+
38903	12M, 6+, $1000+
38904	12M, 5+, $1000+
38905	12M, 5+, $400+
38906	12M, 5+, $100+
38907	12M, 3+, $1000+
38908	12M, 3+, $400+
38909	12M, 3+, $100+
38910	12M, 2+, $1000+
38911	12M, 2+, $400+
38912	12M, 2+, $100+
38913	12M, 2+, $1+
38914	12M, 1+, $400+
38915	12M, 1+, $200+
38916	12M, 1+, $100+
38917	12M, 1+, $50+
38918	12M, 1+, $1+
38919	24M, 5+, $1000+
38920	24M, 5+, $400+
38921	24M, 5+, $100+
38922	24M, 2+, $1000+
38923	24M, 2+, $400+
38924	24M, 2+, $100+
38925	24M, 1+, $100+
38926	24M, 1+, $1+
38927	36M, 5+, $1000+
38928	36M, 5+, $400+
38929	36M, 5+, $100+
38930	36M, 2+, $400+
38931	36M, 2+, $100+
38932	36M, 2+, $1+
38933	36M, 1+, $400+
38934	36M, 1+, $100+
38935	36M, 1+, $50+
38936	36M, 1+, $1+
38937	24M, 1+, $1+ T-Bucket
38938	24M, 1+, $1+ Both
38939	48M, 5+, $1000+
38940	48M, 2+, $400+
38941	48M, 2+, $100+
38942	48M, 1+, $100+
38943	60M, 5+, $1000+
38944	60M, 2+, $400+
38945	60M, 2+, $100+
38970	12M Requestors
38971	18M Requestors
38972	24M REQUESTORS
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
AFTER   388         324
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
 
 
 /********** Special Analysis & Manual Steps    *****************/
 /**********      LOYALTY BUILDER DATA          *****************/
 /**********       UNIQUE to Cat #389           *****************/
  
         select CST.ixCustomer, CST.ixSourceCode,
            (case when LB.MailTo = 'N' then 'N'
                  else 'Y'
                  end) 'LBMailTo'
         into [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull          
         from PJC_23406_CST_OutputFile_389 CST
          left join [SMITemp].dbo.PJC_LB_streetrod20140711 LB on CST.ixCustomer = LB.ixCustomer

        select ixSourceCode, LBMailTo, Count(*) QTY
        from  [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull 
        group by ixSourceCode, LBMailTo
        order by ixSourceCode, LBMailTo
        /*
        ix      LB
        Source  Mail
        Code	To	QTY
        38902	N	65
        38902	Y	13781
        38903	N	163
        38903	Y	9737
        38904	N	19
        38904	Y	1902
        38905	N	773
        38905	Y	9652
        38906	N	1323
        38906	Y	1927
        38907	N	33
        38907	Y	2802
        38908	N	280
        38908	Y	7462
        38909	N	2471
        38909	Y	6491
        38910	N	17
        38910	Y	888
        38911	N	128
        38911	Y	3443
        38912	N	1603
        38912	Y	7949
        38913	N	5021
        38913	Y	1612
        38914	N	36
        38914	Y	2968
        38915	N	72
        38915	Y	5312
        38916	N	331
        38916	Y	7401
        38917	N	3425
        38917	Y	5631
        38918	N	12807
        38918	Y	4357
        38919	N	494
        38919	Y	7503
        38920	N	1498
        38920	Y	3373
        38921	N	1497
        38921	Y	269
        38922	N	26
        38922	Y	2046
        38923	N	491
        38923	Y	6433
        38924	N	8449
        38924	Y	4664
        38925	N	2580
        38925	Y	10098
        38926	N	25046
        38926	Y	2903
        38927	N	595
        38927	Y	3066
        38928	N	1277
        38928	Y	1311
        38929	N	905
        38929	Y	109
        38930	N	1081
        38930	Y	4852
        38931	N	8136
        38931	Y	1502
        38932	N	4355
        38932	Y	174
        38933	N	37
        38933	Y	1707
        38934	N	5324
        38934	Y	3598
        38935	N	6479
        38935	Y	359
        38936	N	12586
        38936	Y	585
        38937	N	2160
        38937	Y	454
        38938	N	18214
        38938	Y	3297
        38939	N	88
        38939	Y	1641
        38940	N	516
        38940	Y	4769
        38941	N	1924
        38941	Y	4982
        38942	N	1277
        38942	Y	6875
        38943	N	15
        38943	Y	844
        38944	N	128
        38944	Y	3540
        38945	N	628
        38945	Y	4639
        38970	Y	39181
        38971	N	1
        38971	Y	26414
        38972	Y	27043
        */
        
        /* 
        PRG provided spreadsheet on which Source Codes to split, the new SCs will be the ones that LB flagged as don't mail.  
        NOTE: Only SOME of the source codes were split.  Some had insiginificant qty of "don't mail" customers.
        */
        
        -- Build modified table to reassign customers into the new split the SCs
        select ixCustomer, 
            ixSourceCode, 
            ixSourceCode as 'OrigSC', 
            LBMailTo 
        into [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull_MODIFIED
        from [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull 
        
        select * from [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull_MODIFIED         
        
        UPDATE [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull_MODIFIED
        set ixSourceCode = (CASE 
                                when LBMailTo = 'N' and ixSourceCode = '38906' then '38946'
                                when LBMailTo = 'N' and ixSourceCode = '38909' then '38947'
                                when LBMailTo = 'N' and ixSourceCode = '38912' then '38948'
                                when LBMailTo = 'N' and ixSourceCode = '38913' then '38949'
                                when LBMailTo = 'N' and ixSourceCode = '38917' then '38950'
                                
                                when LBMailTo = 'N' and ixSourceCode = '38918' then '38951'
                                when LBMailTo = 'N' and ixSourceCode = '38920' then '38952'
                                when LBMailTo = 'N' and ixSourceCode = '38921' then '38953'
                                when LBMailTo = 'N' and ixSourceCode = '38924' then '38954'
                                when LBMailTo = 'N' and ixSourceCode = '38925' then '38955'
                                
                                when LBMailTo = 'N' and ixSourceCode = '38926' then '38956'
                                when LBMailTo = 'N' and ixSourceCode = '38928' then '38957'
                                when LBMailTo = 'N' and ixSourceCode = '38930' then '38958'
                                when LBMailTo = 'N' and ixSourceCode = '38931' then '38959'
                                when LBMailTo = 'N' and ixSourceCode = '38932' then '38960'
                                
                                when LBMailTo = 'N' and ixSourceCode = '38934' then '38961'
                                when LBMailTo = 'N' and ixSourceCode = '38935' then '38962'
                                when LBMailTo = 'N' and ixSourceCode = '38936' then '38963'
                                when LBMailTo = 'N' and ixSourceCode = '38937' then '38964'
                                when LBMailTo = 'N' and ixSourceCode = '38938' then '38965'
                                
                                when LBMailTo = 'N' and ixSourceCode = '38941' then '38966'
                                when LBMailTo = 'N' and ixSourceCode = '38942' then '38967'
                             ELSE ixSourceCode
                             END
                             )

        select ixSourceCode, count(*) 'Qty'
        from [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull_MODIFIED
        group by ixSourceCode
        order by ixSourceCode  
        /*
        ixSourceCode	Qty
        38902	13846
        38903	9900
        38904	1921
        38905	10425
        38906	1927
        38907	2835
        38908	7742
        38909	6491
        38910	905
        38911	3571
        38912	7949
        38913	1612
        38914	3004
        38915	5384
        38916	7732
        38917	5631
        38918	4357
        38919	7997
        38920	3373
        38921	269
        38922	2072
        38923	6924
        38924	4664
        38925	10098
        38926	2903
        38927	3661
        38928	1311
        38929	1014
        38930	4852
        38931	1502
        38932	174
        38933	1744
        38934	3598
        38935	359
        38936	585
        38937	454
        38938	3297
        38939	1729
        38940	5285
        38941	4982
        38942	6875
        38943	859
        38944	3668
        38945	5267
        38946	1323
        38947	2471
        38948	1603
        38949	5021
        38950	3425
        38951	12807
        38952	1498
        38953	1497
        38954	8449
        38955	2580
        38956	25046
        38957	1277
        38958	1081
        38959	8136
        38960	4355
        38961	5324
        38962	6479
        38963	12586
        38964	2160
        38965	18214
        38966	1924
        38967	1277
        38970	39181
        38971	26415
        38972	27043
        */

select * from   [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull_MODIFIED   
where ixSourceCode <> OrigSC                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #389 = 07/28/14
    -- kicked off routine @10:03AM
*/

 
    -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 405920  -- <-- total amount of customer offers in the CST campaign that's loading
    SELECT 
 --        CONVERT(VARCHAR, GETDATE(), 8)    AS 'As Of   '
        @QtyToLoad 'TotQty'
        ,count(CO.ixCustomer) 'Loaded'
        --, (@QtyToLoad-count(CO.ixCustomer)) 'ToGo'
        --,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as 'SecRun'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 'Rec/Sec'
        --,CONVERT(DECIMAL(10,0),(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *60.00) as 'Rec/Min'
        --,CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00)) as 'Rec/Hr',
       ,(@QtyToLoad-count(CO.ixCustomer))/(CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00))) as 'EstHrsToFinish'
    FROM [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    WHERE SC.ixCatalog = '389'
        AND CO.dtDateLastSOPUpdate = '07/22/2014' 
        AND CO.ixTimeLastSOPUpdate >= 39600
    GROUP BY T.ixTime, T.chTime
  
    /*  405,920 total offers to load
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
    389     405,920  63,000     6.4 07-22-14    Tuesday (kicked off at 11:01 AM, ran straight thru until completed 4:29AM Wed) 
**********************************************************************************/
                   

/*************   SPECIAL NOTES FOR CAT 389 ONLY  ******************************/
   
   -- See MISMATCH notes starting on line 177

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan & Philip AFTER the      **********
 **********     Customer Offers have finished loading into SOP  **********/

-- Customers in Offer table for Cat 389
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_23406_CST_OutputFile_389
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '389'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '389'                            
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
                    from PJC_23406_CST_OutputFile_389
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '389' )
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
            from PJC_23406_CST_OutputFile_389 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '389%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
                843034,38714
				1267734,38716
				431212,38716
				1724631,38770
            */

select ixCustomer, ',',ixSourceCode
from [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull_MODIFIED   
