-- Case 22055 - CST output file checks for Catalog 375 
  -- previous CST case = 21859
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '375'

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '375%'

-- Catalog 375 = 2014 Late Spring Street

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_22055_CST_OutputFile_375
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 379 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "80-375.txt" for Catalog 375 has passed the following QC checks.

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
SELECT TOP 10 * FROM dbo.ASC_22055_CST_OutputFile_375 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM ASC_22055_CST_OutputFile_375       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
443,151	443,151     443,151
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM ASC_22055_CST_OutputFile_375
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM ASC_22055_CST_OutputFile_375
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM ASC_22055_CST_OutputFile_375
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty
37502	23642
37503	1882
37504	10429
37505	3244
37506	2807
37507	7629
37508	9065
37509	947
37510	3602
37511	9561
37512	6607
37513	3069
37514	12953
37515	25610
37516	7549
37517	4678
37518	1706
37519	1919
37520	6537
37521	12871
37522	12391
37523	27832
37524	3380
37525	2479
37526	883
37527	5567
37528	8981
37529	4257
37530	1631
37531	8472
37532	19441
37533	1459
37534	21624
37535	30627
37536	1640
37537	4855
37538	6471
37539	7082
37540	831
37541	3576
37542	5010
37543	6136
37544	2695
37545	7943
37570	45342
37571	39985
37580	5135
37581	1119



    FROM CST SCREEN
    Count Time: 26:38
    Total Segments: 48 (1 split segment) = 49 SCodes

    Total Source Codes: 49
              Included: 48
              Excluded:  1
              
    Total Customers: 453,147 v
           Included: 443,151  
           Excluded:   9,996
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM ASC_22055_CST_OutputFile_375 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT * FROM ASC_22055_CST_OutputFile_375 
    WHERE ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    -- ixCustomer	ixSourceCode
    -- NONE   

       /*if any customers are returned then show details...
       
                 SELECT ixCustomer, sMailingStatus
                 FROM [SMI Reporting].dbo.tblCustomer
                 WHERE ixCustomer in ('1424773')
                
                 ixCustomer	 sMailingStatus
                 1424773	    9
                			
        */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_22055_CST_OutputFile_375
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 3
    WHERE ixSourceCode LIKE '375%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '375' 
      AND LEN(ixSourceCode) = 5

/***************
SCode	Description
37502	12M, 6+, $1000+
37503	12M, 5+, $1000+
37504	12M, 5+, $400+
37505	12M, 5+, $100+
37506	12M, 3+, $1000+
37507	12M, 3+, $400+
37508	12M, 3+, $100+
37509	12M, 2+, $1000+
37510	12M, 2+, $400+
37511	12M, 2+, $100+
37512	12M, 2+, $1+
37513	12M, 1+, $400+
37514	12M, 1+, $100+
37515	12M, 1+, $1+
37516	24M, 5+, $1000+
37517	24M, 5+, $400+
37518	24M, 5+, $100+
37519	24M, 2+, $1000+
37520	24M, 2+, $400+
37521	24M, 2+, $100+
37522	24M, 1+, $100+
37523	24M, 1+, $1+
37524	36M, 5+, $1000+ $7.99 FR Shipping
37525	36M, 5+, $400+ $7.99 FR Shipping
37526	36M, 5+, $100+ $7.99 FR Shipping
37527	36M, 2+, $400+ $7.99 FR Shipping
37528	36M, 2+, $100+ $7.99 FR Shipping
37529	36M, 2+, $1+$7.99 FR Shipping
37530	36M, 1+, $400+$7.99 FR Shipping
37531	36M, 1+, $100+$7.99 FR Shipping
37532	36M, 1+, $1+$7.99 FR Shipping
37533	12M, 1+, $1+ T-Bucket
37534	12M, 1+, $1+ Both
37535	12M, 1+, $1+ Race
37536	48M, 5+, $1000+ $7.99 FR Shipping
37537	48M, 2+, $400+ $7.99 FR Shipping
37538	48M, 2+, $100+ $7.99 FR Shipping
37539	48M, 1+, $100+ $7.99 FR Shipping
37540	60M, 5+, $1000+ $7.99 Flat Rate
37541	60M, 2+, $400+ $7.99 Flat Rate
37542	60M, 2+, $100+ $7.99 Flat Rate
37543	60M, 1+, $100+ $7.99 Flat Rate
37544	72M, 1+, $400+ $7.99 Flat Rate
37545	72M, 1+, $100+ $7.99 Flat Rate
37560	Mr. Roadster Dealers
37561	Bill's Friends
37570	12M Requestors $7.99 FR Shipping
37571	24M Requestors $7.99 FR Shipping
37580	72M, 1+, $1 Street Rod CA
37581	72M, 1+, $1 Race CA
37585	Good Guy's List
37592	Counter
37596	Canadian DHL Bulk Center
37597	Canadian RIP- Bouncebacks
37598	DHL Bulk Center
37599	RIP-BOUNCEBACKS

********************/

/*********** 6. Update deceased exempt list   **********/

    -- execute the following BEFORE and AFTER running the update 
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer 
    WHERE flgDeceasedMailingStatusExempt = 1
      AND flgDeletedFromSOP = 0  
    -- Count BEFORE = 304
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer
    WHERE sMailingStatus = '8' AND flgDeletedFromSOP = 0  
    -- Count BEFORE = 366
           
    -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer
    WHERE sMailingStatus = '8' AND flgDeletedFromSOP = 0     
    -- Count AFTER  = 366   
    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #375 = 04/28/14
    -- kicked off routine @7:15PM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 443151 -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '375'
    GROUP BY T.ixTime, T.chTime
    /* 443,151 total offers to load
    
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
       /********** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   **********/
    */


/*************   SPECIAL NOTES FOR CAT 375 ONLY  ******************************
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
                from ASC_22055_CST_OutputFile_375
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '375'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '375'                            
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
                    from ASC_22055_CST_OutputFile_375
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '375' )
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
            from ASC_22055_CST_OutputFile_375 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '375%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*

            */

49777



-- Customers in Offer table for Cat 375
/********** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers **********/
select SC.ixSourceCode 'SCode', count(distinct CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '375' 
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


