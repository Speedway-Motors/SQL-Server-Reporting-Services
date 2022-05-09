-- Case 21222 - CST output file checks for Cat 378

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '378'

-- Catalog 378 = '14 SPRING RACE

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_21222_CST_OutputFile_378
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 378 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "72-378.txt" for Catalog 378 has passed the following QC checks.

1 - customer count in original CST file = 219,621
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
select top 10 * from dbo.ASC_21222_CST_OutputFile_378 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_21222_CST_OutputFile_378       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
219621	219621		219621
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_21222_CST_OutputFile_378
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_21222_CST_OutputFile_378
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_21222_CST_OutputFile_378
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
37802	8346
37803	6141
37804	8071
37805	1913
37806	2712
37807	6506
37808	3868
37809	1731
37810	6180
37811	7202
37812	2676
37813	5854
37814	6195
37815	16085
37816	4301
37817	5282
37818	6237
37819	1130
37820	4455
37821	5694
37822	789
37823	6129
37824	5064
37825	2154
37826	3167
37827	4165
37828	920
37829	3510
37830	4293
37831	807
37832	5352
37833	4222
37834	3791
37835	2929
37836	3638
37837	3530
37838	5326
37839	3483
37840	7240
37841	4072
37842	7957
37850	2596
37851	3516
37870	10192
37871	10200



FROM CST SCREEN
Count Time: 20:30
Total Segments: 45 (0 split segments) = 45 SCodes

Total Source Codes: 45
          Included: 45
          Excluded:  0
          
Total Customers: 219,621 v
       Included: 219,621   
       Excluded:       0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_21222_CST_OutputFile_378 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_21222_CST_OutputFile_378 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then show details...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1253743', '461557', '866887')
            
            ixCustomer	sMailingStatus
            461557		9
			866887		9
			1253743		9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_21222_CST_OutputFile_378
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 6
where ixSourceCode like '378%' and len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '378' 
    and len(ixSourceCode) = 5

/*
SCode	Description
37802	12M, 6+, $2000+
37803	12M, 6+, $1000+
37804	12M, 5+, $400+
37805	12M, 3+, $700+
37806	12M, 3+, $400+
37807	12M, 3+, $200+
37808	12M, 3+, $100+
37809	12M, 2+, $400+
37810	12M, 2+, $100+
37811	12M, 2+, $1+
37812	12M, 1+, $250+
37813	12M, 1+, $100+
37814	12M, 1+, $50+
37815	12M, 1+, $1+
37816	24M, 3+, $1000+
37817	24M, 3+, $400+
37818	24M, 3+, $100+
37819	24M, 2+, $400+
37820	24M, 2+, $100+
37821	24M, 2+, $1+
37822	24M, 1+, $400+
37823	24M, 1+, $100+
37824	24M, 1+, $50+
37825	36M, 3+, $1000+
37826	36M, 3+, $400+
37827	36M, 3+, $100+
37828	36M, 2+, $400+
37829	36M, 2+, $100+
37830	36M, 2+, $1+
37831	36M, 1+, $400+
37832	36M, 1+, $100+
37833	36M, 1+, $50+
37834	48M, 3+, $400+
37835	48M, 3+, $100+
37836	48M, 2+, $100+
37837	48M, 2+, $1+
37838	48M, 1+, $100+
37839	48M, 1+, $50+
37840	60M, 2+, $100+
37841	72M, 2+, $100+
37842	12M, 3+, $1000+ Street
37850	72M, 1+, $1+ CA Race
37851	72M, 1+, $1+ CA Street
37860	PRS Dealers
37861	Bill's Friends
37870	12M Requestors
37871	24M Requestors
37880	Wissota List
37881	IMCA List
37882	SCCA List
37892	Counter
37897	CANADIAN REQUEST IN PACKAGE
37898	DHL Bulk Center
37899	RIP - Bouncebacks
*/

/***** 6. Load Customer Offers into SOP ******
SOP:
    <20> Reporting Menu
        <2> CST Customer offer load

Follow the onscreen instructions. Be sure to 
DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #378 = 02/24/14
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
    where SC.ixCatalog = '378'
    group by T.ixTime, T.chTime
    /* 219,621 total offers to load

CustCnt		RunTime						SecRun	Rec/Min	    Rec/Hour	Rec/Sec
380			2014-01-20 10:08:21.383		58		393.10		23586.21	6.635
20720		2014-01-20 10:41:42.793		2059	603.79		36227.29	10.06
39631		2014-01-20 11:12:44.913		3921	606.44		36386.53	10.10
86363		2014-01-20 12:31:55.567		8672	597.52		35851.80	 9.96  
111775		2014-01-20 13:14:04.277		11201	598.74		35924.47	 9.98
166897		2014-01-20 14:45:33.453		16690	599.99		35999.35	10.00
219574		2014-01-20 16:11:47.977		21864	602.56		36153.78	10.04

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
    378     219,574	 21,780	   10.0	01-30-14	Monday (ran during production hours) 
              
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
                from ASC_21222_CST_OutputFile_378
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '378'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '378'                            
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
                    from ASC_21222_CST_OutputFile_378
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '378' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1171047	0    	0
1064640	0    	1
1116030	0    	0
963898	0    	0
973172	0    	1
1424174	0    	1
1525772	NULL	1
1141853	0    	0
1228926	0    	1
1506770	NULL	0
1953507	0    	1
1070451	0    	1
1373574	0    	0
1095603	0    	1
1374435	0    	0
1537174	0    	0
1727337	0    	0
204395	0    	0
851819	0    	0
895039	0    	1
1103225	0    	0
1346702	0    	0
1960509	0    	0
500901	0    	0
891276	0    	0
1147328	0    	1
1379827	0    	0
1382540	0    	1
1425803	0    	0
1956841	0    	1
1223335	0    	1
928459	0    	0
1067039	0    	0
260480	0    	1
1537878	0    	1
1581533	0    	1
1887921	0    	1
99071	0    	0
985166	0    	0
1208827	0    	1
1230134	0    	0
1349230	0    	0
1477365	0    	1
1790305	0    	1
1806048	0    	1
485178	0    	0
1053017	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_21222_CST_OutputFile_378 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '378%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            47
            */


-- Customers in Offer table for Cat 378
/***** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '378' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
37802	8343	12M, 6+, $2000+
37803	6140	12M, 6+, $1000+
37804	8070	12M, 5+, $400+
37805	1913	12M, 3+, $700+
37806	2712	12M, 3+, $400+
37807	6505	12M, 3+, $200+
37808	3868	12M, 3+, $100+
37809	1729	12M, 2+, $400+
37810	6180	12M, 2+, $100+
37811	7202	12M, 2+, $1+
37812	2674	12M, 1+, $250+
37813	5852	12M, 1+, $100+
37814	6194	12M, 1+, $50+
37815	16082	12M, 1+, $1+
37816	4301	24M, 3+, $1000+
37817	5282	24M, 3+, $400+
37818	6237	24M, 3+, $100+
37819	1130	24M, 2+, $400+
37820	4455	24M, 2+, $100+
37821	5694	24M, 2+, $1+
37822	788	24M, 1+, $400+
37823	6128	24M, 1+, $100+
37824	5064	24M, 1+, $50+
37825	2154	36M, 3+, $1000+
37826	3165	36M, 3+, $400+
37827	4163	36M, 3+, $100+
37828	920	36M, 2+, $400+
37829	3507	36M, 2+, $100+
37830	4292	36M, 2+, $1+
37831	807	36M, 1+, $400+
37832	5351	36M, 1+, $100+
37833	4220	36M, 1+, $50+
37834	3789	48M, 3+, $400+
37835	2928	48M, 3+, $100+
37836	3637	48M, 2+, $100+
37837	3530	48M, 2+, $1+
37838	5321	48M, 1+, $100+
37839	3481	48M, 1+, $50+
37840	7237	60M, 2+, $100+
37841	4072	72M, 2+, $100+
37842	7955	12M, 3+, $1000+ Street
37850	2596	72M, 1+, $1+ CA Race
37851	3516	72M, 1+, $1+ CA Street
37860	0	PRS Dealers
37861	0	Bill's Friends
37870	10190	12M Requestors
37871	10200	24M Requestors
37880	0	Wissota List
37881	0	IMCA List
37882	0	SCCA List
37892	0	Counter
37897	0	CANADIAN REQUEST IN PACKAGE
37898	0	DHL Bulk Center
37899	0	RIP - Bouncebacks
*/
