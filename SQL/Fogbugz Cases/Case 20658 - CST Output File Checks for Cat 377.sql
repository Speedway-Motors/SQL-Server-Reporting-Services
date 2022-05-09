-- Case 20334 - CST output file checks for Cat 377 

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '377'

-- Catalog 377 = '14 WINTER RACE

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_20658_CST_OutputFile_377
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 377 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "61-377_New.txt" for Catalog 377 has passed the following QC checks.

1 - customer count in original CST file = 266,016
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
select top 10 * from ASC_20658_CST_OutputFile_377 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_20658_CST_OutputFile_377       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
266016	266016		266016
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_20658_CST_OutputFile_377
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_20658_CST_OutputFile_377
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_20658_CST_OutputFile_377
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
37702	8300
37703	6071
37704	8008
37705	1867
37706	2700
37707	6507
37708	3916
37709	1700
37710	6200
37711	7227
37712	1041
37713	1618
37714	5838
37715	6118
37716	16223
37717	4318
37718	5193
37719	6244
37720	1112
37721	4412
37722	5685
37723	88
37724	691
37725	695
37726	5430
37727	723
37728	4328
37729	2006
37730	11669
37731	52
37732	4727
37733	4675
37734	123
37735	2214
37736	2090
37737	81
37738	2120
37739	2039
37740	584
37741	3103
37742	2519
37743	494
37744	2116
37745	1622
37746	3330
37747	3329
37748	18
37749	3573
37750	3555
37751	15
37752	319
37753	304
37754	77
37755	2264
37756	2186
37757	1489
37758	12280
37759	10792
37760	3600
37761	3600
37762	1624
37763	1624
37764	774
37765	775
37766	1304
37767	1304
37768	13680
37780	10355
37781	10284
37782	9074



FROM CST SCREEN
Count Time: 26:06
Total Segments: 43 

Total Source Codes: 70
          Included: 70
          Excluded:  0
          
Total Customers: 266,016 v
       Included: 266,016   
       Excluded:       0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_20658_CST_OutputFile_377 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_20658_CST_OutputFile_377 
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
        from ASC_20658_CST_OutputFile_377
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 10
where ixSourceCode like '377%' and len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '377' 
    and len(ixSourceCode) = 5

/*
SCode	Description
37702	12M, 6+, $2000+
37703	12M, 6+, $1000+
37704	12M, 5+, $400+
37705	12M, 3+, $700+
37706	12M, 3+, $400+
37707	12M, 3+, $200+
37708	12M, 3+, $100+
37709	12M, 2+, $400+
37710	12M, 2+, $100+
37711	12M, 2+, $1+
37712	12M, 1+, $400+
37713	12M, 1+, $250+
37714	12M, 1+, $100+
37715	12M, 1+, $50+
37716	12M, 1+, $1+
37717	24M, 3+, $1000+
37718	24M, 3+, $400+
37719	24M, 3+, $100+
37720	24M, 2+, $400+
37721	24M, 2+, $100+
37722	24M, 2+, $1+
37723	24M, 1+, $400+ Ebay Split
37724	24M, 1+, $400+
37725	24M, 1+, $100+ Ebay Split
37726	24M, 1+, $100+
37727	24M, 1+, $50+ Ebay Split
37728	24M, 1+, $50+
37729	24M, 1+, $1+ Ebay Split
37730	24M, 1+, $1+
37731	36M, 3+, $100+ Ebay Split
37732	36M, 3+, $100+ 50% Split
37733	36M, 3+, $100+ $7.99 Flat Rate
37734	36M, 2+, $100+ Ebay Split
37735	36M, 2+, $100+ 50% Split
37736	36M, 2+, $100+ $7.99 Flat Rate
37737	36M, 2+, $1+ Ebay Split
37738	36M, 2+, $1+ 50% Split
37739	36M, 2+, $1+ $7.99 Flat Rate
37740	36M, 1+, $100+ Ebay Split
37741	36M, 1+, $100+ 50% Split
37742	36M, 1+, $100+ $7.99 Flat Rate
37743	36M, 1+, $50+ Ebay Split
37744	36M, 1+, $50+ 50% Split
37745	36M, 1+, $50+ $7.99 Flat Rate
37746	48M, 3+, $100+ 50% Split
37747	48M, 3+, $100+ $7.99 Flat Rate
37748	48M, 2+, $1+ Ebay Split
37749	48M, 2+, $1+ 50% Split
37750	48M, 2+, $1+ $7.99 Flat Rate
37751	48M, 1+, $400+ Ebay Split
37752	48M, 1+, $400+ 50% Split
37753	48M, 1+, $400+ $7.99 Flat Rate
37754	48M, 1+, $100+ Ebay Split
37755	48M, 1+, $100+ 50% Split
37756	48M, 1+, $100+ $7.99 Flat Rate
37757	48M, 1+, $1+ Ebay Split
37758	48M, 1+, $1+ 50% Split
37759	48M, 1+, $1+ $7.99 Flat Rate
37760	60M, 2+, $100+ 50% Split
37761	60M, 2+, $100+ $7.99 Flat Rate
37762	60M, 2+, $1+ 50% Split
37763	60M, 2+, $1+ $7.99 Flat Rate
37764	72M, 2+, $400+ 50% Split
37765	72M, 2+, $400+ $7.99 Flat Rate
37766	72M, 2+, $100+ 50% Split
37767	72M, 2+, $100+ $7.99 Flat Rate
37768	12M, 3+ $400 Street
37780	12M Requestors
37781	24M Requestors
37782	36M Requestors
37790	IMCA List $7.99 FR
37791	Wissota List $7.99 FR
37792	Counter
37798	DHL Bulk Center
37799	RIP - Bouncebacks
*/

/***** 6. Load Customer Offers into SOP ******
SOP:
    <20> Reporting Menu
        <2> CST Customer offer load

Follow the onscreen instructions. Be sure to 
DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #377 = 01/06/14
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
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    where SC.ixCatalog = '377'
    group by T.ixTime, T.chTime
    /* 266,016 total offers to load
    CustCnt	SecRun	Rec/Min/Dec
    23897	3369	425.59
       
CustCnt	RunTime	                SecRun	Rec/Min
229285	2013-12-06 16:27:03.557	34464	399.1730501392752000
230560	2013-12-06 16:30:26.683	34667	399.0423169007988000
       

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
    */



-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/*****  8. Compare CST file to Qty loaded into SOP   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_20658_CST_OutputFile_377
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '377'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '377'                            
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
                    from ASC_20658_CST_OutputFile_377
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '377' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1150723	0    	0
1389325	0    	0
1631232	0    	0
1126932	0    	0
1278012	0    	0
1763946	0    	0
1785134	0    	0
993164	0    	0
1564105	0    	0
1236737	0    	0
1074725	0    	0
1596224	0    	0
739691	0    	0
1576670	0    	0
1666530	0    	0
1871826	0    	0
1031609	0    	0
1655660	0    	1
1615900	0    	0
1805237	0    	0
1076742	0    	0
1324635	0    	0
1417138	0    	0
1553933	0    	0
1651037	0    	0
1194710	0    	0
1637331	0    	0
276660	0    	1
771584	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_20658_CST_OutputFile_377 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '377%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            3
            */


-- Customers in Offer table for Cat 377
/***** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '377' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
37702	8300	12M, 6+, $2000+
37703	6071	12M, 6+, $1000+
37704	8008	12M, 5+, $400+
37705	1867	12M, 3+, $700+
37706	2700	12M, 3+, $400+
37707	6507	12M, 3+, $200+
37708	3916	12M, 3+, $100+
37709	1700	12M, 2+, $400+
37710	6200	12M, 2+, $100+
37711	7227	12M, 2+, $1+
37712	1041	12M, 1+, $400+
37713	1618	12M, 1+, $250+
37714	5838	12M, 1+, $100+
37715	6117	12M, 1+, $50+
37716	16222	12M, 1+, $1+
37717	4318	24M, 3+, $1000+
37718	5193	24M, 3+, $400+
37719	6244	24M, 3+, $100+
37720	1112	24M, 2+, $400+
37721	4412	24M, 2+, $100+
37722	5685	24M, 2+, $1+
37723	88	24M, 1+, $400+ Ebay Split
37724	691	24M, 1+, $400+
37725	695	24M, 1+, $100+ Ebay Split
37726	5430	24M, 1+, $100+
37727	723	24M, 1+, $50+ Ebay Split
37728	4328	24M, 1+, $50+
37729	2006	24M, 1+, $1+ Ebay Split
37730	11669	24M, 1+, $1+
37731	52	36M, 3+, $100+ Ebay Split
37732	4727	36M, 3+, $100+ 50% Split
37733	4675	36M, 3+, $100+ $7.99 Flat Rate
37734	123	36M, 2+, $100+ Ebay Split
37735	2214	36M, 2+, $100+ 50% Split
37736	2090	36M, 2+, $100+ $7.99 Flat Rate
37737	81	36M, 2+, $1+ Ebay Split
37738	2120	36M, 2+, $1+ 50% Split
37739	2039	36M, 2+, $1+ $7.99 Flat Rate
37740	584	36M, 1+, $100+ Ebay Split
37741	3102	36M, 1+, $100+ 50% Split
37742	2519	36M, 1+, $100+ $7.99 Flat Rate
37743	493	36M, 1+, $50+ Ebay Split
37744	2116	36M, 1+, $50+ 50% Split
37745	1622	36M, 1+, $50+ $7.99 Flat Rate
37746	3330	48M, 3+, $100+ 50% Split
37747	3328	48M, 3+, $100+ $7.99 Flat Rate
37748	18	48M, 2+, $1+ Ebay Split
37749	3573	48M, 2+, $1+ 50% Split
37750	3553	48M, 2+, $1+ $7.99 Flat Rate
37751	15	48M, 1+, $400+ Ebay Split
37752	319	48M, 1+, $400+ 50% Split
37753	304	48M, 1+, $400+ $7.99 Flat Rate
37754	77	48M, 1+, $100+ Ebay Split
37755	2264	48M, 1+, $100+ 50% Split
377550	0	TULSA SHOOTOUT
377551	0	CHILI BOWL
377552	0	RACERS OPEN HOUSE
37756	2185	48M, 1+, $100+ $7.99 Flat Rate
37757	1487	48M, 1+, $1+ Ebay Split
37758	12278	48M, 1+, $1+ 50% Split
37759	10789	48M, 1+, $1+ $7.99 Flat Rate
37760	3599	60M, 2+, $100+ 50% Split
37761	3599	60M, 2+, $100+ $7.99 Flat Rate
37762	1624	60M, 2+, $1+ 50% Split
37763	1623	60M, 2+, $1+ $7.99 Flat Rate
37764	774	72M, 2+, $400+ 50% Split
37765	775	72M, 2+, $400+ $7.99 Flat Rate
37766	1304	72M, 2+, $100+ 50% Split
37767	1304	72M, 2+, $100+ $7.99 Flat Rate
37768	13680	12M, 3+ $400 Street
37780	10353	12M Requestors
37781	10284	24M Requestors
37782	9072	36M Requestors
37790	0	IMCA List $7.99 FR
37791	0	Wissota List $7.99 FR
37792	0	Counter
37798	0	DHL Bulk Center
37799	0	RIP - Bouncebacks
*/
