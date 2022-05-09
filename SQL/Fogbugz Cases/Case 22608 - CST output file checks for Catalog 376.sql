-- Case 22608 - CST output file checks for Catalog 376 
  -- previous CST case = 22327
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '376'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '376%'

-- Catalog 376 = '14 Street Rod Early Summer

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_22608_CST_OutputFile_376
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 376 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "89-376.txt" for Catalog 376 has passed the following QC checks.

1 - customer count in original CST file = 169,732
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

9. send Dylan and Philip a list of the final counts of offers loaded by sourcecode through the case.
******************************************************************************************************************/

-- quick review to verify data formatted correctly
SELECT TOP 10 * FROM dbo.ASC_22608_CST_OutputFile_376 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM ASC_22608_CST_OutputFile_376       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
169,732	169,732     169,732
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM ASC_22608_CST_OutputFile_376
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM ASC_22608_CST_OutputFile_376
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM ASC_22608_CST_OutputFile_376
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty
37602	13747
37603	9894
37604	1902
37605	10476
37606	3244
37607	2856
37608	7686
37609	9118
37610	933
37611	3613
37612	9503
37613	6535
37614	3054
37615	13023
37616	25955
37617	7754
37618	4793
37619	1739
37620	1983
37621	6721
37622	12973
37623	6253
37624	3498
37625	2479



    FROM CST SCREEN
Count Time: 13:14
Total Segments: 24
 
Total Source Codes: 25
    Included: 24
    Excluded:  1
 
Total Customers: 175,985
    Included:    169,732 v
    Excluded:     6,253
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM ASC_22608_CST_OutputFile_376 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM ASC_22608_CST_OutputFile_376 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
/*
    ixCustomer	ixSourceCode	sMailingStatus
   -- NONE
*/



    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_22608_CST_OutputFile_376
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 3
    WHERE ixSourceCode LIKE '376%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '376' 
      AND LEN(ixSourceCode) = 5

/***************
SCode	Description
37602	12M, 6+, $2000+
37603	12M, 6+, $1000+
37604	12M, 5+, $1000+
37605	12M, 5+, $400+
37606	12M, 5+, $100+
37607	12M, 3+, $1000+
37608	12M, 3+, $400+
37609	12M, 3+, $100+
37610	12M, 2+, $1000+
37611	12M, 2+, $400+
37612	12M, 2+, $100+
37613	12M, 2+, $1+
37614	12M, 1+, $400+
37615	12M, 1+, $100+
37616	12M, 1+, $1+
37617	24M, 5+, $1000+
37618	24M, 5+, $400+
37619	24M, 5+, $100+
37620	24M, 2+, $1000+
37621	24M, 2+, $400+
37622	24M, 2+, $100+
37623	24M, 1+, $100+
37624	36M, 5+, $1000+
37625	36M, 5+, $400+
37660	Mr. Roadster Dealers


********************/

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
BEFORE  391         316
AFTER   390         315
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    

    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #376 = 06/09/14
    -- kicked off routine @8:05AM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 169732 -- <-- total amount of customer offers in the CST campaign that's loading
    SELECT 
         CONVERT(VARCHAR, getdate(), 20)  as 'As Of'
        ,@QtyToLoad 'TargetQty'
        ,count(CO.ixCustomer) 'QtyLoaded'
        , (@QtyToLoad-count(CO.ixCustomer)) 'StillFeeding'
        --,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as 'SecRun'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 'Rec/Sec'
        ,CONVERT(DECIMAL(10,0),(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *60.00) as 'Rec/Min'
        ,CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00)) as 'Rec/Hour'         
    FROM [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    WHERE SC.ixCatalog = '376'
AND CO.dtDateLastSOPUpdate = '05/07/2014'  -- this should be changed to the date you are running the catalog load  
    GROUP BY T.ixTime, T.chTime
 
    /* 169,732 total offers to load
      latest ETA is 1:35 PM (actual finish time 1:44 PM) 
      
/*
As Of	            TargetQty	QtyLoaded	StillFeeding	Rec/Sec	Rec/Min	Rec/Hour
2014-5-7 8:43		169732		22395		147337			9.08	545		32693
2014-5-7 9:23		169732		43584		126148			8.94	537		32205
2014-5-7 10:34		169732		80857		88875			8.86	533		31952
2014-5-7 11:27		169732		105966		63766			8.60	516		30989
2014-5-7 13:15		169732		162352		7380			8.64	519		31118
*/  

      
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
    376		169,732	 20,438		8.3	05-07-14	Wednesday (ran during production hours)
       /********** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   **********/
    */


/*************   SPECIAL NOTES FOR CAT 380 ONLY  ******************************
    no special issues 
*/

  

-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/**********  8. Compare CST file to Qty loaded into SOP   **********/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_22608_CST_OutputFile_376
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '376'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '376'                            
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
                    from ASC_22608_CST_OutputFile_376
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '376' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
979320	0    	0
1060244	0    	0
501698	0    	0
637969	0    	0
1082151	0    	0
1311763	0    	0
153730	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_22608_CST_OutputFile_376 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '376%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            501698,37602
			1082151,37608
			637969,37609
			1311763,37612
			979320,37613
			1060244,37616
			153730,37617
            */

-- Customers in Offer table for Cat 376
/********** PROVIDE THESE COUNTS TO Dylan & Philip after SOP loads all of the customer offers **********/
select SC.ixSourceCode 'SCode', count(distinct CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '376' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
37602	13746		12M, 6+, $2000+
37603	9894		12M, 6+, $1000+
37604	1902		12M, 5+, $1000+
37605	10476		12M, 5+, $400+
37606	3244		12M, 5+, $100+
37607	2856		12M, 3+, $1000+
37608	7685		12M, 3+, $400+
37609	9117		12M, 3+, $100+
37610	933			12M, 2+, $1000+
37611	3613		12M, 2+, $400+
37612	9502		12M, 2+, $100+
37613	6534		12M, 2+, $1+
37614	3054		12M, 1+, $400+
37615	13023		12M, 1+, $100+
37616	25954		12M, 1+, $1+
37617	7753		24M, 5+, $1000+
37618	4793		24M, 5+, $400+
37619	1739		24M, 5+, $100+
37620	1983		24M, 2+, $1000+
37621	6721		24M, 2+, $400+
37622	12973		24M, 2+, $100+
37623	6253		24M, 1+, $100+
37624	3498		36M, 5+, $1000+
37625	2479		36M, 5+, $400+
37660	0			Mr. Roadster Dealers
*/


