-- Case 18831 - CST output file checks for Cat 353

-- Catalog 353 = '13 SR MID SUM.

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_18831_CST_OutputFile_353
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 353 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in original file = 334066 
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP

verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from PJC_18831_CST_OutputFile_353 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_18831_CST_OutputFile_353       
                       
/*
AllCnt	DistinctCount
334066	334066
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_18831_CST_OutputFile_353
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_18831_CST_OutputFile_353
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_18831_CST_OutputFile_353
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35302	24223
35303	10295
35304	3163
35305	2749
35306	7375
35307	9332
35308	4263
35309	9639
35310	6938
35311	2911
35312	12992
35313	25983
35314	6560
35315	4258
35316	1497
35317	1649
35318	5732
35319	11714
35320	5139
35321	1932
35322	9699
35323	21221
35324	3042
35325	2203
35326	974
35327	3805
35328	8665
35329	1206
35330	6978
35331	1600
35332	1271
35333	3630
35334	6632
35335	726
35336	3056
35340	4128
35341	688
35370	56474
35371	39724


FROM CST SCREEN
Total Segments: 39 segments [total row count = 39]
Total Customers: 334,066

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_18831_CST_OutputFile_353 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_18831_CST_OutputFile_353 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then manually exclude them in the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1840751','98839','1363521','1725857','1448401')
            
            ixCustomer	sMailingStatus
            98839	9
            1363521	9
            1448401	9
            1725857	9
            1840751	9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for ebay buyers, afco purchasers, etc)REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_18831_CST_OutputFile_353
        where ixCustomer NOT in ('1840751','98839','1363521','1725857','1448401')
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '353%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '353' 
    and len(ixSourceCode) >= 5

/*
SCode	Description
35302	12M, 5+, $1000+
35303	12M, 5+, $400+
35304	12M, 5+, $100+
35305	12M, 3+, $1000+
35306	12M, 3+, $400+
35307	12M, 3+, $100+
35308	12M, 2+, $400+
35309	12M, 2+, $100+
35310	12M, 2+, $1+
35311	12M, 1+, $400+
35312	12M, 1+, $100+
35313	12M, 1+, $1+
35314	24M, 5+, $1000+
35315	24M, 5+, $400+
35316	24M, 5+, $100+
35317	24M, 2+, $1000+
35318	24M, 2+, $400+
35319	24M, 2+, $100+
35320	24M, 2+, $1+
35321	24M, 1+, $400+
35322	24M, 1+, $100
35323	24M, 1+, $1
35324	36M, 5+, $1000
35325	36M, 5+, $400
35326	36M, 2+, $1000
35327	36M, 2+, $400
35328	36M, 2+, $100
35329	36M, 1+, $400+
35330	36M, 1+, $100+
35331	48M, 5+, $1000+
35332	48M, 5+, $400+
35333	48M, 2+, $400+
35334	48M, 2+, $100+
35335	60M, 5+, $1000+
35336	60M, 2+, $400+
35340	72M, 1+, $1+ SR (CA)
35341	72M, 1+, $1+ R (CA)
35360	BILL'S FRIENDS
35370	12M REQ.
35371	24M REQ.
35392	Counter
35398	DHL BULK CENTER
35399	RIP - Bouncebacks
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_18831_CST_OutputFile_353
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '353'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '353'                            
order by SC.ixSourceCode 

/*
Total SOP Customer Offer load time for Cat 353 was 28.25 hours w/avg of 3.3 rec/sec

  
  
*/  
-- Customers in Offer table for Cat 353

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '353' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Quanity	Description
35302	24223	12M, 5+, $1000+
35303	10295	12M, 5+, $400+
35304	3163	12M, 5+, $100+
35305	2749	12M, 3+, $1000+
35306	7374	12M, 3+, $400+
35307	9332	12M, 3+, $100+
35308	4263	12M, 2+, $400+
35309	9639	12M, 2+, $100+
35310	6938	12M, 2+, $1+
35311	2910	12M, 1+, $400+
35312	12991	12M, 1+, $100+
35313	25981	12M, 1+, $1+
35314	6560	24M, 5+, $1000+
35315	4258	24M, 5+, $400+
35316	1497	24M, 5+, $100+
35317	1649	24M, 2+, $1000+
35318	5732	24M, 2+, $400+
35319	11713	24M, 2+, $100+
35320	5139	24M, 2+, $1+
35321	1932	24M, 1+, $400+
35322	9699	24M, 1+, $100
35323	21221	24M, 1+, $1
35324	3042	36M, 5+, $1000
35325	2203	36M, 5+, $400
35326	974	36M, 2+, $1000
35327	3805	36M, 2+, $400
35328	8665	36M, 2+, $100
35329	1206	36M, 1+, $400+
35330	6978	36M, 1+, $100+
35331	1600	48M, 5+, $1000+
35332	1271	48M, 5+, $400+
35333	3630	48M, 2+, $400+
35334	6630	48M, 2+, $100+
35335	726	60M, 5+, $1000+
35336	3056	60M, 2+, $400+
35340	4127	72M, 1+, $1+ SR (CA)
35341	688	72M, 1+, $1+ R (CA)
35360	0	BILL'S FRIENDS
35370	56469	12M REQ.
35371	39721	24M REQ.
35392	0	Counter
35398	0	DHL BULK CENTER
35399	0	RIP - Bouncebacks

*/ 

/***** FOR CATALOG #353 ONLY
only 163,451 customers loaded from SOP.
     169,173 failed to load
     =======
     332,624
Will run query below to reload the remaining customers/SCs

select distinct SC.ixSourceCode
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '353' 
        
select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '353'         
        
        
select distinct CO.ixCustomer, count(SC.ixSourceCode)
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where SC.ixCatalog = '353'   
        and CO.ixCustomer is NOT NULL
              
        group by CO.ixCustomer
        having count(SC.ixSourceCode) >1
        
select distinct CO.ixCustomer, SC.ixSourceCode
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '353'         
        and CO.ixCustomer is NULL  
       
        

select * from [SMI Reporting].dbo.tblCustomerOffer 
where ixSourceCode like '353%'
--and len(ixSourceCode) = 5
order by ixSourceCode
*/

-- Customers in output file but NOT in tblCustomerOffer
select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
from PJC_18831_CST_OutputFile_353 CST
               -- Customers in tblCustomerOffer for current catalog
    left join (select CO.ixCustomer
                from [SMI Reporting].dbo.tblCustomerOffer CO 
                where CO.ixSourceCode like '353%'
                and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
where CO.ixCustomer is NULL 
order by  CST.ixSourceCode, CST.ixCustomer              
--1120022, 1257248, 1796601, 1159262, 1439053, 1798929, 553750, 508074, 1485669, 503279, 
--1845730, 641296, 716052, 1458337, 509186, 1341450, 1016262, 1526519, 1293534, 150999, 
--1571668, 1247335, 1711043

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_18831_CST_OutputFile_353
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '353' )
                    )

/********************************************
ixCustomer	sMailingStatus	flgDeletedFromSOP
1798929		0				1
508074		0				0
553750		0				0
503279		0				1

**********************************************/



