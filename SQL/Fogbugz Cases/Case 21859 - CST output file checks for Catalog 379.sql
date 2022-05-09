-- Case 21859 - CST output file checks for Catalog 379 
  -- previous CST case = 21628
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '379'

select * from tblSourceCode where ixSourceCode like '379%'
-- Catalog 379 = NOT BUILT YET!?!

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_21859_CST_OutputFile_379
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 379 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "79-379.txt" for Catalog 379 has passed the following QC checks.

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
******************************************************************************************************************/

-- quick review to verify data formatted correctly
SELECT TOP 10 * FROM dbo.PJC_21859_CST_OutputFile_379 ORDER BY newid()

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM PJC_21859_CST_OutputFile_379       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
100,993	100,993     100,993
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM PJC_21859_CST_OutputFile_379
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM PJC_21859_CST_OutputFile_379
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM PJC_21859_CST_OutputFile_379
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

    /*
    SCode	Qty
    37902	8461
    37903	6261
    37904	674
    37905	7412
    37906	2030
    37907	2755
    37908	6542
    37909	3868
    37910	1857
    37911	2868
    37912	3399
    37913	7197
    37914	1131
    37915	1715
    37916	6015
    37917	22378
    37918	4321
    37919	1931
    37920	3362
    37921	1075
    37922	5741



    FROM CST SCREEN
    Count Time: 09:45
    Total Segments: 21 (0 split segments) = 21 SCodes

    Total Source Codes: 21
              Included: 21
              Excluded:  0
              
    Total Customers: 100,993 v
           Included: 100,993  
           Excluded:       0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM PJC_21859_CST_OutputFile_379 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    --NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT * FROM PJC_21859_CST_OutputFile_379 
    WHERE ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    -- ixCustomer	ixSourceCode
    --    

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
        from PJC_21859_CST_OutputFile_379
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 9
    WHERE ixSourceCode LIKE '379%' AND len(ixSourceCode) <> 5

    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '379' 
      AND LEN(ixSourceCode) = 5

    /*
    SCode	Description
    37902	12M, 6+, $2000+
    37903	12M, 6+, $1000+
    37904	12M, 5+, $1000+
    37905	12M, 5+, $400+
    37906	12M, 3+, $700+
    37907	12M, 3+, $400+
    37908	12M, 3+, $200+
    37909	12M, 3+, $100+
    37910	12M, 2+, $400+
    37911	12M, 2+, $200+
    37912	12M, 2+, $100+
    37913	12M, 2+, $1+
    37914	12M, 1+, $400+
    37915	12M, 1+, $250+
    37916	12M, 1+, $100+
    37917	12M, 1+, $1+
    37918	24M, 3+, $1000+
    37919	24M, 3+, $700+
    37920	24M, 3+, $400+
    37921	24M, 2+, $400+
    37922	12M, 6+, $2000+ SR

    */

/*********** 6. Update deceased exempt list   **********/

    -- execute the following BEFORE and AFTER running the update 
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer 
    WHERE flgDeceasedMailingStatusExempt = 1
      AND flgDeletedFromSOP = 0  
    -- Count BEFORE = 301
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer
    WHERE sMailingStatus = '8' AND flgDeletedFromSOP = 0  
    -- Count BEFORE = 350 
           
    -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCustomer
    WHERE sMailingStatus = '8' AND flgDeletedFromSOP = 0     
    -- Count AFTER  = 349    
    
    
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #379 = 03/24/14
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
    where SC.ixCatalog = '379'
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
       /********** CLOAK 2.0 launched ***********/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    378     219,574	 21,780	   10.0	01-30-14	Monday (ran during production hours) 
    374     165,820  16,323    10.2 02-13-14    Thursday (11:50AM - 4:20PM) 
    384		 43,703	  3,717	   11.8	02-19-14	Wednesday (ran during production hours)  
    379     100,993            10.3 03-07-14    Thur night & Fri morning (ran in two parts)
       /********** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   **********/
    */


/*************   SPECIAL NOTES FOR CAT 379 ONLY  ******************************
    no special issues 
*/

  

-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/**********  8. Compare CST file to Qty loaded into SOP   **********/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_21859_CST_OutputFile_379
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '379'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '379'                            
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
                    from PJC_21859_CST_OutputFile_379
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '379' )
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
            from PJC_21859_CST_OutputFile_379 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '379%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*

            */

49777



-- Customers in Offer table for Cat 379
/********** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers **********/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '379' 
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


