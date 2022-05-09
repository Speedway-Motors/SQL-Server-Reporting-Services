-- Case 20334 - CST output file checks for Cat 383 

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '383'

-- Catalog 383 = WIN. '14 SPRINT

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_20334_CST_OutputFile_383
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 383 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "61-383.txt" for Catalog 383 has passed the following QC checks.

1 - customer count in original CST file = 40,649
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers


complete remaining steps:

6. Load Customer Offers:
    in SOP under <20>Reporting Menu, run 
                    <2>CST Customer offer load 
    follow directions and make sure to enter the EXACT in-home date and file names

You will receive a notification email when SOP finishes the customer offer loads. Complete the following steps:

7. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually around 10-40 customers that end up "missing" 
            These should just be customers that have been merged since the CST finalization
            and a handful of customers who's files were locked at the time customer offers were loading.

8. send Dylan and Kyle a list of the final counts of offers loaded by sourcecode through the case.
***********************************************************/

-- quick review to verify data formatted correctly
select top 10 * from PJC_20334_CST_OutputFile_383 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_20334_CST_OutputFile_383       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
40649	40649       40649
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_20334_CST_OutputFile_383
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_20334_CST_OutputFile_383
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_20334_CST_OutputFile_383
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
38302	3168
38303	1154
38304	2239
38305	1138
38306	4203
38307	1536
38308	1618
38309	4355
38310	2027
38311	3796
38312	945
38313	543
38314	8868
38370	2709
38371	1321
38372	1029



FROM CST SCREEN
Count Time: 2:20
Total Segments: 16 [count of segments in table = 16]

Total Source Codes: 16
          Included: 16
          Excluded:  0
          
Total Customers: 40,649 v
       Included: 40,649   
       Excluded:       0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_20334_CST_OutputFile_383 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_20334_CST_OutputFile_383 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then show details...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1315266')
            
            ixCustomer	sMailingStatus
            1315266	    9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_20334_CST_OutputFile_383
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '383%' and len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '383' 
    and len(ixSourceCode) >= 5

/*
SCode	Description
38302	12M, 3+, $400+
38303	12M, 3+, $100+
38304	12M, 2+, $1+
38305	12M, 1+, $100+
38306	12M, 1+, $1+
38307	24M, 3+, $100+
38308	24M, 2+, $1+
38309	24M, 1+, $1+
38310	36M, 1+, $100+
38311	36M, 1+, $1+
38312	48M, 2+, $100+
38313	48M, 1+, $100+
38314	12m, 4+, $1000 Race
38330	PRS Dealers
38360	Bill's Friends
38370	12M Requestors
38371	18M Requestors
38372	24M Requestors
38392	Counter
38398	DHL Bulk Center
38399	RIP - Bouncebacks


*/

/***** 6. Load Customer Offers into SOP ******
SOP:
    <20> Reporting Menu
        <2> CST Customer offer load

Follow the onscreen instructions. Be sure to 
DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the case if its not already there.)

    In home date for Cat#383 = 11/4/13
*/


    --SOP Customer Offer Load Times 
    -- this query a few times througout the loading process to make sure records are updating at a reasonable pace
    select count(CO.ixCustomer) CustCnt,
        (T.ixTime - min(CO.ixTimeLastSOPUpdate)) as SecRun,
        --  (count(CO.ixCustomer) / (T.ixTime - min(CO.ixTimeLastSOPUpdate)) )*60 as 'Rec/Min',
        (CONVERT(DECIMAL(10,2),count(CO.ixCustomer)))
           /(CONVERT(DECIMAL(10,2),T.ixTime) 
                - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 
                    *60.00 
                        as 'Rec/Min'
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    where SC.ixCatalog = '383'
    group by T.ixTime, T.chTime
    /* 180,025 total offers to load
    CustCnt	SecRun	Rec/Min/Dec
    23897	3369	425.59
       

    CAT#    RECORDS SECONDS Rec/Sec Date        Day Loaded
    ====    ======= ======= ======= ========    ==========
    353     118,353  36,971     3.2 06-04-13    Tuesday
    366      48,114  17,563     2.7 06-18-13    Tuesday
    364      32,040   1,139    28.1 06-26-13    Friday
    354     330,968  18,118    18.3 07-22-13    Monday
    355     239,006  33,388     7.2 09-11-13    Tuesday
    361     179,997  25,772     7.0 10-02-13    Wednesday
    383      40,649   5,750     7.1 11-05-13    Tuesday
    */



-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/*****  8. Compare CST file to Qty loaded into SOP   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_20334_CST_OutputFile_383
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '383'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '383'                            
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
                    from PJC_20334_CST_OutputFile_383
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '383' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
84601	0    	0
697649	0    	1
1466473	0    	1
1664803	0    	1
1079246	0    	1
1390666	0    	1
1384132	0    	1
1004490	0    	1
1840921	0    	1
1966658	0    	1
1901044	0    	1
1233661	0    	1
1019273	0    	1
1460549	0    	1
13185	0    	1
1107652	NULL	1
1137015	0    	1
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from PJC_20334_CST_OutputFile_383 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '383%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            3
            */


-- Customers in Offer table for Cat 383
/***** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '383' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
38302	3166	12M, 3+, $400+
38303	1154	12M, 3+, $100+
38304	2235	12M, 2+, $1+
38305	1138	12M, 1+, $100+
38306	4202	12M, 1+, $1+
38307	1536	24M, 3+, $100+
38308	1618	24M, 2+, $1+
38309	4352	24M, 1+, $1+
38310	2026	36M, 1+, $100+
38311	3795	36M, 1+, $1+
38312	945	48M, 2+, $100+
38313	543	48M, 1+, $100+
38314	8865	12m, 4+, $1000 Race
38330	0	PRS Dealers
383547	0	PRI RACE SHOW
383550	0	TULSA SHOOTOUT
383551	0	CHILI BOWL
38360	0	Bill's Friends
38370	2707	12M Requestors
38371	1321	18M Requestors
38372	1029	24M Requestors
38392	0	Counter
38398	0	DHL Bulk Center
38399	0	RIP - Bouncebacks
*/
