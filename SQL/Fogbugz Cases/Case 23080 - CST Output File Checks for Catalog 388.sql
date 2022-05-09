-- Case 23080 - CST Output File Checks for Catalog 388 
  -- previous CST case = 22931  
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '388'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '388%'

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '388%'
  AND LEN(ixSourceCode) >= 5

-- Catalog 388 = '14 MID SUMMER STREET 

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_23080_CST_OutputFile_388
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 388 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "92-388.txt" for Catalog 388 has passed the following QC checks.

1 - customer count in original CST file = 373,093
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
SELECT TOP 10 * FROM [SMITemp].dbo.ASC_23080_CST_OutputFile_388 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM ASC_23080_CST_OutputFile_388       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
373,093	373,093     373,093
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM ASC_23080_CST_OutputFile_388
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM ASC_23080_CST_OutputFile_388
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM ASC_23080_CST_OutputFile_388
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty
38802	13799
38803	9885
38804	1920
38805	10421
38806	3282
38807	2840
38808	7769
38809	8941
38810	926
38811	3580
38812	9535
38813	6666
38814	2999
38815	5382
38816	7688
38817	8999
38818	17121
38819	7922
38820	4810
38821	1743
38822	2032
38823	6891
38824	13103
38825	12611
38826	27744
38827	3596
38828	2549
38829	990
38830	5821
38831	9400
38832	4458
38833	1738
38834	8832
38835	6833
38836	13159
38837	1343
38838	39252
38839	1672
38840	5065
38841	6605
38842	7792
38843	820
38844	3578
38845	5072
38850	5410
38870	40499

FROM CST SCREEN:
Count Time: 33:37
Total Segments: 46
 
Total Source Codes: 46
    Included: 46
    Excluded:  0
 
Total Customers: 373,093
    Included:    373,093 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM ASC_23080_CST_OutputFile_388 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM ASC_23080_CST_OutputFile_388 CST
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
        from ASC_23080_CST_OutputFile_388
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 3
    WHERE ixSourceCode LIKE '388%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '388' 
      AND LEN(ixSourceCode) = 5
      
   /*MISMATCHES! 

   */

/***************
SCode	Description
38802	12M, 6+, $2000+
38803	12M, 6+, $1000+
38804	12M, 5+, $1000+
38805	12M, 5+, $400+
38806	12M, 5+, $100+
38807	12M, 3+, $1000+
38808	12M, 3+, $400+
38809	12M, 3+, $100+
38810	12M, 2+, $1000+
38811	12M, 2+, $400+
38812	12M, 2+, $100+
38813	12M, 2+, $1+
38814	12M, 1+, $400+
38815	12M, 1+, $200+
38816	12M, 1+, $100+
38817	12M, 1+, $50+
38818	12M, 1+, $1+
38819	24M, 5+, $1000+
38820	24M, 5+, $400+
38821	24M, 5+, $100+
38822	24M, 2+, $1000+
38823	24M, 2+, $400+
38824	24M, 2+, $100+
38825	24M, 1+, $100+
38826	24M, 1+, $1+
38827	36M, 5+, $1000+
38828	36M, 5+, $400+
38829	36M, 5+, $100+
38830	36M, 2+, $400+
38831	36M, 2+, $100+
38832	36M, 2+, $1+
38833	36M, 1+, $400+
38834	36M, 1+, $100+
38835	36M, 1+, $50+
38836	36M, 1+, $1+
38837	12M, 1+, $1+ T-Bucket
38838	24M, 1+, $1+ Both
38839	48M, 5+, $1000+
38840	48M, 2+, $400+
38841	48M, 2+, $100+
38842	48M, 1+, $100+
38843	60M, 5+, $1000+
38844	60M, 2+, $400+
38845	60M, 2+, $100+
38850	72M, 1+, $1+ Canada Street
38860	Mr. Roadster Dealers
38870	12M Requestors
38880	Muscle Car List
38892	Counter
38898	DHL Bulk Center
38899	RIP - Bouncebacks
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
BEFORE  393         319      v
AFTER   391         321
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #388 = 07/21/14
    -- kicked off routine @10:00AM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 377093  -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '388'
AND CO.dtDateLastSOPUpdate = '06/19/2014' 
and CO.ixTimeLastSOPUpdate >= 35854  
    GROUP BY T.ixTime, T.chTime
    /*  377,093 total offers to load
                latest ETA is 11:00 PM */
      
/*
As Of   	TotQty	Loaded	ToGo	Rec/Sec	            Rec/Hr  EstHrsToFinish	    
10:05:23	377093	3688	373405	7.86353944562899	28309	13.19032816418
10:22:35	377093	12535	364558	8.35109926715522	30064	12.12606439595
10:49:38	377093	24934	352159	7.98143405889884	28733	12.25625587303
11:43:10	377093	50849	326244	8.02541035353535	28891	11.29223633657
13:12:50	377093	96899	280194	8.27065551382724	29774	9.41069389400
14:25:53	377093	128391	248702	7.97509162059755	28710	8.66255660048
15:46:58	377093	167576	209517	7.99351268841824	28777	7.28071028946
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
    

    
       /********** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   **********/
                   
**********************************************************************************/
                   

/*************   SPECIAL NOTES FOR CAT 388 ONLY  ******************************/
   
   -- NONE 

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
                from ASC_23080_CST_OutputFile_388
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '388'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '388'                            
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
                    from ASC_23080_CST_OutputFile_388
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '388' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
775936	0    	0
134076	0    	1
753869	0    	0
561160	0    	0
1498065	0    	0
1488657	0    	1
1503031	0    	0
438168	0    	1
58941	0    	0
1464627	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_23080_CST_OutputFile_388 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '388%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
                134076,38802
				58941,38802
				1503031,38813
				561160,38813
				1488657,38815
				1498065,38823
				438168,38825
				753869,38826
				775936,38826
				1464627,38827
            */

