-- Case 20956 - CST output file checks for Cat 373 

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '373'

-- Catalog 373 = '14 Spring Street

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_20956_CST_OutputFile_373
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 373 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "64-373.txt" for Catalog 373 has passed the following QC checks.

1 - customer count in original CST file = 328,438
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
select top 10 * from ASC_20956_CST_OutputFile_373 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_20956_CST_OutputFile_373       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
328438	328438		328438
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_20956_CST_OutputFile_373
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_20956_CST_OutputFile_373
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_20956_CST_OutputFile_373
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
37302	25214
37303	10501
37304	3206
37305	2824
37306	7639
37307	9285
37308	911
37309	3520
37310	9712
37311	6725
37312	15995
37313	25588
37314	7417
37315	4675
37316	1657
37317	1816
37318	6342
37319	12818
37320	12363
37321	1624
37322	1624
37323	1184
37324	1184
37325	417
37326	417
37327	99
37328	2628
37329	2529
37330	298
37331	4242
37332	3944
37333	167
37334	738
37335	570
37336	878
37337	878
37338	672
37339	671
37340	1880
37341	1880
37342	20
37343	3530
37344	3511
37345	416
37346	416
37347	1766
37348	1767
37349	2484
37350	2484
37351	8332
37352	22452
37370	24972
37371	24973
37372	14249
37373	14249
37380	5010
37381	1075



FROM CST SCREEN
Count Time: 23:21
Total Segments: 38 (19 split segments) = 57 SCodes

Total Source Codes: 57
          Included: 57
          Excluded:  0
          
Total Customers: 328,438 v
       Included: 328,438   
       Excluded:       0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_20956_CST_OutputFile_373 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_20956_CST_OutputFile_373 
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
        from ASC_20956_CST_OutputFile_373
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 10
where ixSourceCode like '373%' and len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '373' 
    and len(ixSourceCode) = 5

/*
SCode	Description
37302	12M, 5+, $1000+
37303	12M, 5+, $400+
37304	12M, 5+, $100+
37305	12M, 3+, $1000+
37306	12M, 3+, $400+
37307	12M, 3+, $100+
37308	12M, 2+, $1000+
37309	12M, 2+, $400+
37310	12M, 2+, $100+
37311	12M, 2+, $1+
37312	12M, 1+, $100+
37313	12M, 1+, $1+
37314	24M, 5+, $1000+
37315	24M, 5+, $400+
37316	24M, 5+, $100+
37317	24M, 2+, $1000+
37318	24M, 2+, $400+
37319	24M, 2+, $100+
37320	24M, 1+, $100+
37321	36M, 5+, $1000+ 50% Gift Card
37322	36M, 5+, $1000+ $7.99 FR Shipping
37323	36M, 5+, $400+ 50% Gift Card
37324	36M, 5+, $400+ $7.99 FR Shipping
37325	36M, 5+, $100+ 50% Gift Card
37326	36M, 5+, $100+ $7.99 FR Shipping
37327	36M, 2+, $400+ Ebay Split
37328	36M, 2+, $400+ 50% Gift Card
37329	36M, 2+, $400+$7.99 FR Shipping
37330	36M, 2+, $100+Ebay
37331	36M, 2+, $100+50% Gift Card
37332	36M, 2+, $100+$7.99 FR Shipping
37333	36M, 1+, $400+Ebay
37334	36M, 1+, $400+50% Gift Card
37335	36M, 1+, $400+$7.99 FR Shipping
37336	48M, 5+, $1000+ 50% Gift Card
37337	48M, 5+, $1000+ $7.99 FR Shipping
37338	48M, 5+, $400+ 50% Gift Card
37339	48M, 5+, $400+ $7.99 FR Shipping
37340	48M, 2+, $400+ 50% Gift Card
37341	48M, 2+, $400+ $7.99 FR Shipping
37342	48M, 2+, $100+ Ebay
37343	48M, 2+, $100+ 50% Gift Card
37344	48M, 2+, $100+ $7.99 FR Shipping
37345	60M, 5+, $1000+ 50% Gift Card
37346	60M, 5+, $1000+ $7.99 Flat Rate
37347	60M, 2+, $400+ 50% Gift Card
37348	60M, 2+, $400+ $7.99 Flat Rate
37349	60M, 2+, $100+ 50% Gift Card
37350	60M, 2+, $100+ $7.99 Flat Rate
37351	12M, 1+, $100+ Race and Street
37352	12M, 1+, $100+ Race
37360	Mr. Roadster Dealers
37361	Bill's Friends
37370	12M Requestors 50% Gift Card
37371	12M Requestors $7.99 FR Shipping
37372	18M Requestors 50% Gift Card
37373	18M Requestors $7.99 FR Shipping
37380	72M, 1+, $1 Street Rod CA
37381	72M, 1+, $1 Race CA
37385	Good Guy's List
37392	Counter
37398	DHL Bulk Center
37399	RIP - Bouncebacks
*/

/***** 6. Load Customer Offers into SOP ******
SOP:
    <20> Reporting Menu
        <2> CST Customer offer load

Follow the onscreen instructions. Be sure to 
DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #373 = 02/03/14
*/


    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    select count(CO.ixCustomer) CustCnt
        ,getdate() as 'RunTime'
        ,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as SecRun
        --  (count(CO.ixCustomer) / (T.ixTime - min(CO.ixTimeLastSOPUpdate)) )*60 as 'Rec/Min',
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) / (CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *60.00 
            as 'Rec/Min'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) / (CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00 
            as 'Rec/Hour'                        
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    where SC.ixCatalog = '373'
    group by T.ixTime, T.chTime
    
    /* 328,438 total offers to load
CustCnt	RunTime	                SecRun	Rec/Min	    Rec/Hour
======= ======================= ======  =======     ========
7637	2014-01-02 14:02:31.743	1151	398	        23,886
14935	2014-01-02 14:21:41.153	2301	389     	23,366
82888	2014-01-02 18:02:15.197	15535   320         19,208
82888	2014-01-02 22:03:51.297	30031	165.6048749625384000	9936.2924977523040000
83034	2014-01-03 01:07:29.330	30
87066	2014-01-03 01:16:22.260	563
94197	2014-01-03 06:55:30.633	20911  <-- stuck again!  Looks like only about 30 mins after I started the 2nd file
110718	2014-01-03 07:46:59.050	24000

     

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
    
    */


/********   SPECIAL NOTES FOR CAT 373 ONLY  ***************
    Attempted to split the file into two parts. File 64-373A.txt contained 200,000 customers.  
    Started the file approx 1:50PM.  It looks like the SOP process got "stuck" after 82,888 customers loaded.  
    I will locate all of the 245,550 customers that have not yet loaded, place them in file 64-373B.txt 
    and attempt to kick the process off after 1AM.  Estimate at 6 rec/sec that it will take about 12 hours for the 
    remaining Customer Offers to load.
    */

   

-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/*****  8. Compare CST file to Qty loaded into SOP   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_20956_CST_OutputFile_373
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '373'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '373'                            
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
                    from ASC_20956_CST_OutputFile_373
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '373' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1543546	0    	1
287670	0    	0
1704250	0    	0
1610259	0    	1
1801102	0    	1
1032731	0    	1
1501878	0    	1
1825409	0    	1
1116832	0    	0
1960962	0    	1
1220821	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_20956_CST_OutputFile_373 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '373%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            3
            */


-- Customers in Offer table for Cat 373
/***** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '373' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
373000	0	CALGARY WORLD OF WHEEL S
373001	0	MEGA SPEED CUSTOM CAR & TRUCK SHOW
37302	25214	12M, 5+, $1000+
37303	10501	12M, 5+, $400+
37304	3206	12M, 5+, $100+
37305	2824	12M, 3+, $1000+
37306	7638	12M, 3+, $400+
37307	9285	12M, 3+, $100+
37308	911	12M, 2+, $1000+
37309	3520	12M, 2+, $400+
37310	9711	12M, 2+, $100+
37311	6725	12M, 2+, $1+
37312	15995	12M, 1+, $100+
37313	25588	12M, 1+, $1+
37314	7417	24M, 5+, $1000+
37315	4675	24M, 5+, $400+
37316	1657	24M, 5+, $100+
37317	1816	24M, 2+, $1000+
37318	6341	24M, 2+, $400+
37319	12817	24M, 2+, $100+
37320	12363	24M, 1+, $100+
37321	1624	36M, 5+, $1000+ 50% Gift Card
37322	1624	36M, 5+, $1000+ $7.99 FR Shipping
37323	1184	36M, 5+, $400+ 50% Gift Card
37324	1184	36M, 5+, $400+ $7.99 FR Shipping
37325	417	36M, 5+, $100+ 50% Gift Card
37326	417	36M, 5+, $100+ $7.99 FR Shipping
37327	99	36M, 2+, $400+ Ebay Split
37328	2628	36M, 2+, $400+ 50% Gift Card
37329	2529	36M, 2+, $400+$7.99 FR Shipping
37330	298	36M, 2+, $100+Ebay
37331	4242	36M, 2+, $100+50% Gift Card
37332	3943	36M, 2+, $100+$7.99 FR Shipping
37333	167	36M, 1+, $400+Ebay
37334	738	36M, 1+, $400+50% Gift Card
37335	570	36M, 1+, $400+$7.99 FR Shipping
37336	878	48M, 5+, $1000+ 50% Gift Card
37337	878	48M, 5+, $1000+ $7.99 FR Shipping
37338	672	48M, 5+, $400+ 50% Gift Card
37339	671	48M, 5+, $400+ $7.99 FR Shipping
37340	1880	48M, 2+, $400+ 50% Gift Card
37341	1880	48M, 2+, $400+ $7.99 FR Shipping
37342	20	48M, 2+, $100+ Ebay
37343	3530	48M, 2+, $100+ 50% Gift Card
37344	3511	48M, 2+, $100+ $7.99 FR Shipping
37345	416	60M, 5+, $1000+ 50% Gift Card
37346	416	60M, 5+, $1000+ $7.99 Flat Rate
37347	1766	60M, 2+, $400+ 50% Gift Card
37348	1767	60M, 2+, $400+ $7.99 Flat Rate
37349	2484	60M, 2+, $100+ 50% Gift Card
37350	2484	60M, 2+, $100+ $7.99 Flat Rate
37351	8332	12M, 1+, $100+ Race and Street
37352	22451	12M, 1+, $100+ Race
37360	0	Mr. Roadster Dealers
37361	0	Bill's Friends
37370	24972	12M Requestors 50% Gift Card
37371	24972	12M Requestors $7.99 FR Shipping
37372	14248	18M Requestors 50% Gift Card
37373	14249	18M Requestors $7.99 FR Shipping
37380	5010	72M, 1+, $1 Street Rod CA
37381	1075	72M, 1+, $1 Race CA
37385	0	Good Guy's List
37392	0	Counter
37398	0	DHL Bulk Center
37399	0	RIP - Bouncebacks
*/
