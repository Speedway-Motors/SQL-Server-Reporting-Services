-- Case 21046 - CST output file checks for Cat 386

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '386'

-- Catalog 386 = '14 SPRING TBUCKET

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_21046_CST_OutputFile_386
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 386 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "71-386.txt" for Catalog 386 has passed the following QC checks.

1 - customer count in original CST file = 45,884
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
select top 10 * from dbo.ASC_21046_CST_OutputFile_386 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_21046_CST_OutputFile_386       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
45884	45884		45884
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_21046_CST_OutputFile_386
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_21046_CST_OutputFile_386
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_21046_CST_OutputFile_386
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
38602	1450
38603	1191
38604	1513
38605	2335
38606	951
38607	909
38608	3278
38609	1230
38610	2535
38611	2035
38612	1628
38613	3035
38614	2214
38615	6648
38620	621
38621	511
38622	648
38623	1001
38624	407
38625	390
38626	1405
38627	872
38628	1301
38670	7776



FROM CST SCREEN
Count Time: 2:21
Total Segments: 15 (9 split segments) = 24 SCodes

Total Source Codes: 24
          Included: 24
          Excluded:  0
          
Total Customers: 45,884 v
       Included: 45,884   
       Excluded:      0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_21046_CST_OutputFile_386 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_21046_CST_OutputFile_386 
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
        from ASC_21046_CST_OutputFile_386
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 6
where ixSourceCode like '386%' and len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '386' 
    and len(ixSourceCode) = 5

/*
SCode	Description
38602	12M, 2+, $400+
38603	12M, 2+, $100+
38604	12M, 1+, $100+
38605	12M, 1+, $1+
38606	24M, 2+, $400+
38607	24M, 2+, $100+
38608	24M, 1+, $1+
38609	36M, 3+, $100+
38610	36M, 1+, $100+
38611	36M, 1+, $1+
38612	48M, 2+, $100+
38613	48M, 1+, $1+
38614	60M, 1+ $100+
38615	12M, 7+, $2000
38620	12M, 2+, $400+ 30% Split
38621	12M, 2+, $100+ 30% Split
38622	12M, 1+, $100+ 30% Split
38623	12M, 1+, $1+ 30% Split
38624	24M, 2+, $400+ 30% Split
38625	24M, 2+, $100+ 30% Split
38626	24M, 1+, $1+ 30% Split
38627	36M, 1+, $1+ 30% Split
38628	48M, 1+, $1+ 30% Split
38660	Bill's Friends
38661	Mr. Roadster Dealers
38670	12M REQUESTORS
38692	Counter
38698	DHL Bulk Center
38699	RIP - Bouncebacks
*/

/***** 6. Load Customer Offers into SOP ******
SOP:
    <20> Reporting Menu
        <2> CST Customer offer load

Follow the onscreen instructions. Be sure to 
DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #386 = 02/10/14
*/


    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    select count(CO.ixCustomer) CustCnt
        ,getdate() as 'RunTime'
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
    where SC.ixCatalog = '386'
    group by T.ixTime, T.chTime
    /* 45,884 total offers to load

CustCnt		RunTime						SecRun	Rec/Min	    Rec/Hour	Rec/Sec
10614		2014-01-09 11:57:04.430		943		675.33		40520.04	11.25
20476		2014-01-09 12:12:32.860		1871	656.63		39397.97	10.94
35486		2014-01-09 12:35:33.373		3252	654.72		39283.39	10.91


       

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
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
             
              
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
                from ASC_21046_CST_OutputFile_386
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '386'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '386'                            
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
                    from ASC_21046_CST_OutputFile_386
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '386' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1307033	0    	1
596036	0    	0
1042162	0    	1
803290	0    	0
1962736	0    	1
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_21046_CST_OutputFile_386 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '386%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            5
            */


-- Customers in Offer table for Cat 373
/***** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '386' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
38602	1450	12M, 2+, $400+
38603	1191	12M, 2+, $100+
38604	1513	12M, 1+, $100+
38605	2335	12M, 1+, $1+
38606	951	24M, 2+, $400+
38607	909	24M, 2+, $100+
38608	3278	24M, 1+, $1+
38609	1230	36M, 3+, $100+
38610	2535	36M, 1+, $100+
38611	2035	36M, 1+, $1+
38612	1628	48M, 2+, $100+
38613	3035	48M, 1+, $1+
38614	2214	60M, 1+ $100+
38615	6646	12M, 7+, $2000
38620	621	12M, 2+, $400+ 30% Split
38621	511	12M, 2+, $100+ 30% Split
38622	648	12M, 1+, $100+ 30% Split
38623	1001	12M, 1+, $1+ 30% Split
38624	407	24M, 2+, $400+ 30% Split
38625	390	24M, 2+, $100+ 30% Split
38626	1405	24M, 1+, $1+ 30% Split
38627	871	36M, 1+, $1+ 30% Split
38628	1301	48M, 1+, $1+ 30% Split
38660	0	Bill's Friends
38661	0	Mr. Roadster Dealers
38670	7774	12M REQUESTORS
38692	0	Counter
38698	34	DHL Bulk Center
38699	0	RIP - Bouncebacks
*/
