-- Case 22327 - CST output file checks for Catalog 380 
  -- previous CST case = 22055
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '380'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '380%'

-- Catalog 380 = '14 RACE LT SPR

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_22327_CST_OutputFile_380
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 379 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "80-380.txt" for Catalog 380 has passed the following QC checks.

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
SELECT TOP 10 * FROM dbo.PJC_22327_CST_OutputFile_380 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM PJC_22327_CST_OutputFile_380       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
237,171	237,171     237,171
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM PJC_22327_CST_OutputFile_380
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM PJC_22327_CST_OutputFile_380
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM PJC_22327_CST_OutputFile_380
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty
38002	8599
38003	6272
38004	693
38005	7390
38006	2039
38007	2784
38008	6501
38009	3846
38010	1903
38011	2943
38012	3373
38013	7145
38014	2905
38015	6111
38016	6240
38017	16041
38018	4387
38019	5321
38020	6161
38021	1086
38022	4476
38023	5492
38024	6725
38025	5095
38026	13724
38027	2176
38028	3313
38029	4413
38030	975
38031	3650
38032	4569
38033	822
38034	5545
38035	4478
38036	3708
38037	2968
38038	3757
38039	3518
38040	5566
38041	7623
38042	3739
38043	10905
38044	16160
38050	2727
38051	497
38070	8810



    FROM CST SCREEN
Count Time: 21:06
Total Segments: 46
 
Total Source Codes: 47
    Included: 46
    Excluded:  1
 
Total Customers: 248,075
    Included:    237,171 v
    Excluded:     10,904
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM PJC_22327_CST_OutputFile_380 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM PJC_22327_CST_OutputFile_380 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
/*
    ixCustomer	ixSourceCode	sMailingStatus
    279097	    38037	        9
    49596	    38003	        9
*/



    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_22327_CST_OutputFile_380
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 3
    WHERE ixSourceCode LIKE '380%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '380' 
      AND LEN(ixSourceCode) = 5

/***************
SCode	Description
38002	12M, 6+, $2000+
38003	12M, 6+, $1000+
38004	12M, 5+, $1000+
38005	12M, 5+, $400+
38006	12M, 3+, $700+
38007	12M, 3+, $400+
38008	12M, 3+, $200+
38009	12M, 3+, $100+
38010	12M, 2+, $400+
38011	12M, 2+, $200+
38012	12M, 2+, $100+
38013	12M, 2+, $1+
38014	12M, 1+, $250+
38015	12M, 1+, $100+
38016	12M, 1+, $50+
38017	12M, 1+, $1+
38018	24M, 3+, $1000+
38019	24M, 3+, $400+
38020	24M, 3+, $100+
38021	24M, 2+, $400+
38022	24M, 2+, $100+
38023	24M, 2+, $1+
38024	24M, 1+, $100+
38025	24M, 1+, $50+
38026	24M, 1+, $1+
38027	36M, 3+, $1000+
38028	36M, 3+, $400+
38029	36M, 3+, $100+
38030	36M, 2+, $400+
38031	36M, 2+, $100+
38032	36M, 2+, $1+
38033	36M, 1+, $400+
38034	36M, 1+, $100+
38035	36M, 1+, $50+
38036	48M, 3+, $400+
38037	48M, 3+, $100+
38038	48M, 2+, $100+
38039	48M, 2+, $1+
38040	48M, 1+, $100+
38041	60M, 2+, $100+
38042	72M, 2+, $100+
38043	12M, 1+, $1+ Street and Race
38044	12M, 3+, $100+ Street
38050	72M, 1+, $1+ CA Race
38051	24M, 1+, $1+ CA Race & Street
38060	PRS Dealers
38061	Bill's Friends
38070	12M Requestors
38080	Wissota List
38081	IMCA List
38082	Racewise List
38092	Counter
38096	Canadian DHL Bulk Center
38097	Canadian RIP-Bouncebacks
38098	DHL Bulk Center
38099	RIP - Bouncebacks


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
BEFORE  374         306
AFTER   374         306
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    

    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #380 = 04/28/14
    -- kicked off routine @7:15PM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 197046 -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '380'
AND CO.dtDateLastSOPUpdate = '04/16/2014'    
    GROUP BY T.ixTime, T.chTime
    /* 237,171 total offers to load
      latest ETA is 6:15 PM
      
/*
  As Of	            TargetQty	QtyLoaded	StillFeeding	Rec/Sec	Rec/Min	Rec/Hour
2014-03-27 18:01:29	443151	    371355	    71796	        9.7     583	    35006
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
                from PJC_22327_CST_OutputFile_380
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '380'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '380'                            
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
                    from PJC_22327_CST_OutputFile_380
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '380' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
189695	0    	1
1793603	0    	0
1363860	0    	1
1695679	0    	0
741914	0    	1
1316374	0    	1
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from PJC_22327_CST_OutputFile_380 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '380%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*

            */

49777



-- Customers in Offer table for Cat 380
/********** PROVIDE THESE COUNTS TO Dylan & Philip after SOP loads all of the customer offers **********/
select SC.ixSourceCode 'SCode', count(distinct CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '380' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
37902	8461	12M, 6+, $2000+
37903	6261	12M, 6+, $1000+
37904	674	12M, 5+, $1000+
37905	7412	12M, 5+, $400+
37906	2030	12M, 3+, $700+
37907	2755	12M, 3+, $400+
37908	6542	12M, 3+, $200+
37909	3868	12M, 3+, $100+
37910	1857	12M, 2+, $400+
37911	2868	12M, 2+, $200+
37912	3399	12M, 2+, $100+
37913	7197	12M, 2+, $1+
37914	1131	12M, 1+, $400+
37915	1715	12M, 1+, $250+
37916	6015	12M, 1+, $100+
37917	22376	12M, 1+, $1+
37918	4321	24M, 3+, $1000+
37919	1931	24M, 3+, $700+
37920	3362	24M, 3+, $400+
37921	1075	24M, 2+, $400+
37922	5740	12M, 6+, $2000+ SR
*/


