-- Case 19365 - CST output file checks for Cat 354 

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '354'
-- Catalog 354 = FALL '13 SPRINT

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_19365_CST_OutputFile_354
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 354 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in original file = 32,047
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP


-- PASTE BELOW (with needed alterations) INTO TICKET and assign to Al
CST output file "47-354.txt" for Catalog 354 has passed the following QC checks.

1 - customer count in original file = 330,983
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

Please load the customer offers into SOP.  Assign this case back to me once the offers start loading and I'll provide final counts to Marketing once it's completed.



verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from PJC_19365_CST_OutputFile_354 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_19365_CST_OutputFile_354       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
330983	330983      330983
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_19365_CST_OutputFile_354
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_19365_CST_OutputFile_354
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_19365_CST_OutputFile_354
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35402	24532
35403	10320
35404	3210
35405	2729
35406	7358
35407	9384
35408	4329
35409	9602
35410	6832
35411	2938
35412	13001
35413	26154
35414	6787
35415	4434
35416	1569
35417	1696
35418	5971
35419	12113
35420	5244
35421	1934
35422	9858
35424	1543
35424B	1543
35425	1128
35426	1127
35427	509
35428	509
35429	1962
35430	1962
35431	4410
35432	4411
35433	648
35434	649
35435	1735
35436	1340
35437	3707
35438	6868
35439	799
35440	3258
35441	24951
35442	10027
35443	7367
35444	21049
35470	59486



FROM CST SCREEN
Total Segments: 44 [count of segments in table = 44]
Total Customers: 330,983 v

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_19365_CST_OutputFile_354 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_19365_CST_OutputFile_354 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then manually exclude them in the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1840751','98839','1363521','1725857','1448401')
            
            ixCustomer	sMailingStatus
            98839	9
            1363521	9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for ebay buyers, afco purchasers, etc)REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_19365_CST_OutputFile_354
        where ixCustomer NOT in ('1840751','98839','1363521','1725857','1448401')
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '354%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '354' 
    and len(ixSourceCode) >= 5

/*
SCode	Description
35402	12M, 5+, $1000+
35403	12M, 5+, $400+
35404	12M, 5+, $100+
35405	12M, 3+, $1000+
35406	12M, 3+, $400+
35407	12M, 3+, $100+
35408	12M, 2+, $400+
35409	12M, 2+, $100+
35410	12M, 2+, $1+
35411	12M, 1+, $400+
35412	12M, 1+, $100+
35413	12M, 1+, $1+
35414	24M, 5+, $1000+
35415	24M, 5+, $400+
35416	24M, 5+, $100+
35417	24M, 2+, $1000+
35418	24M, 2+, $400+
35419	24M, 2+, $100+
35420	24M, 2+, $1+
35421	24M, 1+, $400+
35422	24M, 1+, $100
35423	36M, 5+, $1000
35424	36M, 5+, $1000 $7.99 Flat Rate
35425	36M, 5+, $400
35426	36M, 5+, $400 $7.99 Flat Rate
35427	36M, 2+, $1000
35428	36M, 2+, $1000 $7.99 Flat Rate
35429	36M, 2+, $400
35430	36M, 2+, $400 $7.99 Flat Rate
35431	36M, 2+, $100
35432	36M, 2+, $100 $7.99 Flat Rate
35433	36M, 1+, $400+
35434	36M, 1+, $400+ $7.99 Flat Rate
35435	48M, 5+, $1000+ $7.99 Flat Rate
35436	48M, 5+, $400+ $7.99 Flat Rate
35437	48M, 2+, $400+ $7.99 Flat Rate
35438	48M, 2+, $100+ $7.99 Flat Rate
35439	60M, 5+, $1000+ $7.99 Flat Rate
35440	60M, 2+, $400+ $7.99 Flat Rate
35441	60M, 1+, $100+ $7.99 Flat Rate
35442	72M, 1+, $100+ $7.99 Flat Rate
35443	12M, 1+, $100+ Both $7.99 Flat Rate
35444	12M, 1+, $100+ Race $7.99 Flat Rate
35460	BILL'S FRIENDS
35461	Mr. Roadster Dealers
35470	12M REQ.
35480	Goodguy's List
35492	COUNTER
35498	DHL Bulk Center
35499	RIP - Bouncebacks
Dylan is still building


*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_19365_CST_OutputFile_354
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '354'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '354'                            
order by SC.ixSourceCode 
-- note!  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

/*

select ixSourceCode, count(*)
from PJC_19365_CST_OutputFile_354
group by ixSourceCode
order by ixSourceCode
/*
SOP Customer Offer Load Times

CAT#    RECORDS SECONDS Rec/Sec Date        Day
====    ======= ======= ======= ========    ===
353     118,353  36,971     3.2 06-04-13    Tuesday
366      48,114  17,563     2.7 06-18-13    Tuesday
364      32,040   1,139    28.1 06-26-13    Friday
354     330,968  18,118    18.3 07-22-13    Monday

 
*/  
35402	12M, 5+, $1000+	24532	24530	-2
35403	12M, 5+, $400+	10320	10320	0
35404	12M, 5+, $100+	3210	3210	0
35405	12M, 3+, $1000+	2729	2728	-1
35406	12M, 3+, $400+	7358	7357	-1
35407	12M, 3+, $100+	9384	9384	0
35408	12M, 2+, $400+	4329	4329	0
35409	12M, 2+, $100+	9602	9602	0
35410	12M, 2+, $1+	6832	6832	0
35411	12M, 1+, $400+	2938	2938	0
35412	12M, 1+, $100+	13001	13001	0
35413	12M, 1+, $1+	26154	26153	-1
35414	24M, 5+, $1000+	6787	6787	0
35415	24M, 5+, $400+	4434	4434	0
35416	24M, 5+, $100+	1569	1569	0
35417	24M, 2+, $1000+	1696	1695	-1
35418	24M, 2+, $400+	5971	5971	0
35419	24M, 2+, $100+	12113	12113	0
35420	24M, 2+, $1+	5244	5244	0
35421	24M, 1+, $400+	1934	1934	0
35422	24M, 1+, $100	9858	9857	-1
35423	36M, 5+, $1000	NULL	0	0
35424	36M, 5+, $1000 $7.99 Flat Rate	1543	1543	0
35424B	36M, 5+, $1000	1543	1543	0
35425	36M, 5+, $400	1128	1128	0
35426	36M, 5+, $400 $7.99 Flat Rate	1127	1127	0
35427	36M, 2+, $1000	509	509	0
35428	36M, 2+, $1000 $7.99 Flat Rate	509	509	0
35429	36M, 2+, $400	1962	1962	0
35430	36M, 2+, $400 $7.99 Flat Rate	1962	1962	0
35431	36M, 2+, $100	4410	4410	0
35432	36M, 2+, $100 $7.99 Flat Rate	4411	4411	0
35433	36M, 1+, $400+	648	648	0
35434	36M, 1+, $400+ $7.99 Flat Rate	649	649	0
35435	48M, 5+, $1000+ $7.99 Flat Rate	1735	1735	0
35436	48M, 5+, $400+ $7.99 Flat Rate	1340	1340	0
35437	48M, 2+, $400+ $7.99 Flat Rate	3707	3707	0
35438	48M, 2+, $100+ $7.99 Flat Rate	6868	6868	0
35439	60M, 5+, $1000+ $7.99 Flat Rate	799	798	-1
35440	60M, 2+, $400+ $7.99 Flat Rate	3258	3258	0
35441	60M, 1+, $100+ $7.99 Flat Rate	24951	24947	-4
35442	72M, 1+, $100+ $7.99 Flat Rate	10027	10027	0
35443	12M, 1+, $100+ Both $7.99 Flat Rate	7367	7366	-1
35444	12M, 1+, $100+ Race $7.99 Flat Rate	21049	21048	-1
35460	BILL'S FRIENDS	NULL	0	0
35461	Mr. Roadster Dealers	NULL	0	0
35470	12M REQ.	59486	59485	-1
35480	Goodguy's List	NULL	0	0
35492	COUNTER	NULL	0	0
35498	DHL Bulk Center	NULL	0	0
35499	RIP - Bouncebacks	NULL	0	0
6623	ROD & CUSTOM	NULL	0	0
*/

-- Customers in Offer table for Cat 354
/***** 7. PROVIDE THESE COUNTS TO Dylan/Klye once after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '354' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
35402	24530	12M, 5+, $1000+
35403	10320	12M, 5+, $400+
35404	3210	12M, 5+, $100+
35405	2728	12M, 3+, $1000+
35406	7357	12M, 3+, $400+
35407	9384	12M, 3+, $100+
35408	4329	12M, 2+, $400+
35409	9602	12M, 2+, $100+
35410	6832	12M, 2+, $1+
35411	2938	12M, 1+, $400+
35412	13001	12M, 1+, $100+
35413	26153	12M, 1+, $1+
35414	6787	24M, 5+, $1000+
35415	4434	24M, 5+, $400+
35416	1569	24M, 5+, $100+
35417	1695	24M, 2+, $1000+
35418	5971	24M, 2+, $400+
35419	12113	24M, 2+, $100+
35420	5244	24M, 2+, $1+
35421	1934	24M, 1+, $400+
35422	9857	24M, 1+, $100
35423	0	36M, 5+, $1000
35424	1543	36M, 5+, $1000 $7.99 Flat Rate
35424B	1543	36M, 5+, $1000
35425	1128	36M, 5+, $400
35426	1127	36M, 5+, $400 $7.99 Flat Rate
35427	509	36M, 2+, $1000
35428	509	36M, 2+, $1000 $7.99 Flat Rate
35429	1962	36M, 2+, $400
35430	1962	36M, 2+, $400 $7.99 Flat Rate
35431	4410	36M, 2+, $100
35432	4411	36M, 2+, $100 $7.99 Flat Rate
35433	648	36M, 1+, $400+
35434	649	36M, 1+, $400+ $7.99 Flat Rate
35435	1735	48M, 5+, $1000+ $7.99 Flat Rate
35436	1340	48M, 5+, $400+ $7.99 Flat Rate
35437	3707	48M, 2+, $400+ $7.99 Flat Rate
35438	6868	48M, 2+, $100+ $7.99 Flat Rate
35439	798	60M, 5+, $1000+ $7.99 Flat Rate
35440	3258	60M, 2+, $400+ $7.99 Flat Rate
35441	24947	60M, 1+, $100+ $7.99 Flat Rate
35442	10027	72M, 1+, $100+ $7.99 Flat Rate
35443	7366	12M, 1+, $100+ Both $7.99 Flat Rate
35444	21048	12M, 1+, $100+ Race $7.99 Flat Rate
35460	0	BILL'S FRIENDS
35461	0	Mr. Roadster Dealers
35470	59485	12M REQ.
35480	0	Goodguy's List
35492	0	COUNTER
35498	0	DHL Bulk Center
35499	0	RIP - Bouncebacks
6623	0	ROD & CUSTOM

*/ 


-- Customers in output file but NOT in tblCustomerOffer
select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
from PJC_19365_CST_OutputFile_354 CST
               -- Customers in tblCustomerOffer for current catalog
    left join (select CO.ixCustomer
                from [SMI Reporting].dbo.tblCustomerOffer CO 
                where CO.ixSourceCode like '354%'
                and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
where CO.ixCustomer is NULL 
order by  CST.ixSourceCode, CST.ixCustomer              
/*
1457120,35402
730775,35402
847379,35402
404716,35404
1239751,35405
1127727,35406
1467305,35409
1096578,35412
1484161,35413
1770867,35413
187799,35413
1181722,35417
1088052,35422
1099742,35422
1032401,35439
1108833,35441
1114027,35441
1124734,35441
1571123,35441
1583728,35441
1112158,35443
1761461,35444
611209,35444
977388,35444
1616758,35470
*/

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_19365_CST_OutputFile_354
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '354' )
                    )

/********************************************
Cust	sMailing
  #     Status	flgDeletedFromSOP
1770867	NULL	0
1032401	0	1
730775	0	0
1114027	0	1
404716	0	1
847379	0	0
1096578	0	0
1583728	0	1
1484161	0	0
1088052	0	1
1124734	0	1
1108833	0	0
1181722	0	0
1467305	0	0
1239751	0	1
1571123	0	1
187799	0	0
1099742	0	0
1457120	0	0
1761461	0	1
611209	0	0
977388	0	1
1112158	0	1
1127727	0	0
1616758	0	1

**********************************************/



