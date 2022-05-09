-- Case 21628 - CST output file checks for Catalog 384

USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '384'

-- Catalog 384 = '14 SPRING SPRINT

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_21628_CST_OutputFile_384
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 384 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "79-384.txt" for Catalog 384 has passed the following QC checks.

1 - customer count in original CST file = 43,721
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
***********************************************************/

-- quick review to verify data formatted correctly
SELECT TOP 10 * FROM dbo.ASC_21628_CST_OutputFile_384 ORDER BY newid()

/****** 1.& 2. check for DUPE CUSTOMERS ******/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM ASC_21628_CST_OutputFile_384       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
43,721	43,721      43,721
*/

/****** 3. Invalid Customer Numbers ******/

SELECT * FROM ASC_21628_CST_OutputFile_384
WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
SELECT * FROM ASC_21628_CST_OutputFile_384
WHERE LEN(ixCustomer) < 5
   OR ISNUMERIC(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

SELECT ixSourceCode AS SCode
     , COUNT(*) AS Qty
FROM ASC_21628_CST_OutputFile_384
GROUP BY ixSourceCode
ORDER BY ixSourceCode

/*
SCode	Qty
38402	3235
38403	1137
38404	2271
38405	1172
38406	4169
38407	1554
38408	1615
38409	4509
38410	2084
38411	3960
38412	1028
38413	3878
38414	518
38415	8690
38470	2368
38471	1533



FROM CST SCREEN
Count Time: 02:28
Total Segments: 16 (0 split segments) = 16 SCodes

Total Source Codes: 16
          Included: 16
          Excluded:  0
          
Total Customers: 43,721 v
       Included: 43,721   
       Excluded:      0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
SELECT * FROM ASC_21628_CST_OutputFile_384 
WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                      ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                      ,'212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
SELECT * FROM ASC_21628_CST_OutputFile_384 
WHERE ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
-- ixCustomer	ixSourceCode
-- 353394		38411    

   /*if any customers are returned then show details...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('353394')
            
             ixCustomer	 sMailingStatus
             353394		 9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_21628_CST_OutputFile_384
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 9
WHERE ixSourceCode LIKE '384%' AND len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
SELECT ixSourceCode SCode, sDescription 'Description'
FROM [SMI Reporting].dbo.tblSourceCode
WHERE ixCatalog = '384' 
  AND LEN(ixSourceCode) = 5

/*
SCode	Description
38402	12M, 3+, $400+
38403	12M, 3+, $100+
38404	12M, 2+, $1+
38405	12M, 1+, $100+
38406	12M, 1+, $1+
38407	24M, 3+, $100+
38408	24M, 2+, $1+
38409	24M, 1+, $1+
38410	36M, 1+, $100+; $7.99 Flat Rate
38411	36M, 1+, $1+; $7.99 Flat Rate
38412	48M, 2+, $100+; $7.99 Flat Rate
38413	48M, 1+, $1+; $7.99 Flat Rate
38414	60M, 2+, $200; $7.99 Flat Rate
38415	12m, 4+, $1000 Race
38460	Bill's Friends
38461	PRS Dealers
38470	12M Requestors; $7.99 Flat Rate
38471	18M Requestors; $7.99 Flat Rate
38492	Counter
38498	DHL Bulk Center
38499	RIP - Bouncebacks

*/

/***** 6. Update deceased exempt list   *****/

    -- execute the following BEFORE and AFTER running the update 
SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer 
WHERE flgDeceasedMailingStatusExempt = 1
  AND flgDeletedFromSOP = 0  
    -- Count BEFORE = 301    
    -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    -- Count AFTER  = 301

    -- execute the following BEFORE and AFTER running the update     
SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer
WHERE sMailingStatus = '8' 
  AND flgDeletedFromSOP = 0     
    -- Count BEFORE = 350    
    -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    -- Count AFTER  = 350    
    
    
/***** 7. Load Customer Offers into SOP ******
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #384 = 03/24/14
    -- kicked off routine @12:55PM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    select count(CO.ixCustomer) CustCnt
        ,CONVERT(VARCHAR, getdate(), 20)  as 'RunTime'
        ,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as SecRun
        --  (count(CO.ixCustomer) / (T.ixTime - min(CO.ixTimeLastSOPUpdate)) )*60 as 'Rec/Min',
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer)))
           /(CONVERT(DECIMAL(10,2),T.ixTime) 
                - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 
                    *60.00 
                        as 'Rec/Min'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer)))
           /(CONVERT(DECIMAL(10,2),T.ixTime) 
                - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 
                    *3600.00 
                        as 'Rec/Hour'                        
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    where SC.ixCatalog = '384'
    group by T.ixTime, T.chTime
    /* 43,721 total offers to load

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
       /***** CLOAK 2.0 launched ******/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    378     219,574	 21,780	   10.0	01-30-14	Monday (ran during production hours) 
    374     165,820  16,323    10.2 02-13-14    Thursday (11:50AM - 4:20PM) 
    384		 43,703	  3,717	   11.8	02-19-14	Wednesday (ran during production hours)  
       /***** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   *****/
    */


/********   SPECIAL NOTES FOR CAT 384 ONLY  ***************
    no special issues 
*/

  

-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/*****  8. Compare CST file to Qty loaded into SOP   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_21628_CST_OutputFile_384
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '384'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '384'                            
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
                    from ASC_21628_CST_OutputFile_384
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '384' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1258324	0    	0
1055454	0    	1
1553472	0    	0
1714411	0    	0
1761074	0    	1
1668873	0    	1
179412	0    	1
1808365	0    	1
1908809	0    	0
1193665	0    	1
1607974	0    	1
1691372	0    	1
667952	0    	1
707043	0    	1
1058057	0    	1
1369307	0    	0
1665522	0    	0
1794475	0    	1
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_21628_CST_OutputFile_384 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '384%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            1808365,38404
			1193665,38405
			1691372,38405
			179412,38405
			1058057,38406
			1055454,38407
			1908809,38410
			1714411,38413
			1369307,38414
			1258324,38415
			667952,38415
			707043,38415
			1553472,38470
			1607974,38470
			1665522,38470
			1668873,38470
			1761074,38470
			1794475,38470
            */


-- Customers in Offer table for Cat 384
/***** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '384' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
38402	3235	12M, 3+, $400+
38403	1137	12M, 3+, $100+
38404	2270	12M, 2+, $1+
38405	1169	12M, 1+, $100+
38406	4168	12M, 1+, $1+
38407	1553	24M, 3+, $100+
38408	1615	24M, 2+, $1+
38409	4509	24M, 1+, $1+
38410	2083	36M, 1+, $100+; $7.99 Flat Rate
38411	3960	36M, 1+, $1+; $7.99 Flat Rate
38412	1028	48M, 2+, $100+; $7.99 Flat Rate
38413	3877	48M, 1+, $1+; $7.99 Flat Rate
38414	517		60M, 2+, $200; $7.99 Flat Rate
38415	8687	12m, 4+, $1000 Race
38460	0		Bill's Friends
38461	0		PRS Dealers
38470	2362	12M Requestors; $7.99 Flat Rate
38471	1533	18M Requestors; $7.99 Flat Rate
38492	0		Counter
38498	0		DHL Bulk Center
38499	0		RIP - Bouncebacks
*/
