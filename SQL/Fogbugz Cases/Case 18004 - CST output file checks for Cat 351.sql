-- Case 18004 - CST output file checks for Cat 351

-- Catalog 351 = 2013 LT SPRING (SR)

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_18004_CST_OutputFile_351
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 351 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 295158 [modified file with DO NOT MAIL removed]
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers [modified file]

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP

verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from ASC_18004_CST_OutputFile_351 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_18004_CST_OutputFile_351       
                       
/*
AllCnt	DistinctCount
295166	295166
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_18004_CST_OutputFile_351
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_18004_CST_OutputFile_351
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_18004_CST_OutputFile_351
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35102	35007
35103	11044
35104	2581
35105	3059
35106	8017
35107	8457
35108	4578
35109	9297
35110	4487
35111	2863
35112	12590
35113	21665
35114	12649
35115	5841
35116	1445
35117	1889
35118	6702
35119	11527
35120	3209
35121	1821
35122	9035
35123	16895
35124	7099
35125	3493
35126	1251
35127	4604
35128	9242
35129	4603
35130	2507
35131	4963
35132	7857
35170	54889

FROM CST SCREEN
Total Segments: 32 segments
Total Customers: 295,166

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_18004_CST_OutputFile_351 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_18004_CST_OutputFile_351 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
   /*if any customers are returned then manually exclude them in the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1399515','81988','1165658','1169064','1159261','851794','1256250','988098')

            ixCustomer	sMailingStatus
            81988		9
            851794		9
            988098		9
            1159261		9
            1165658		9
            1169064		9
            1256250		9
            1399515		9
            			
    */

    -- REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    select ixCustomer+','+ixSourceCode
    from ASC_18004_CST_OutputFile_351
    where ixCustomer NOT in ('1399515','81988','1165658','1169064','1159261','851794','1256250','988098')

select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '351%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '351' 

/*
SCode	Description
35102	12M, 5+, $1000+
35103	12M, 5+, $400+
35104	12M, 5+, $100+
35105	12M, 3+, $1000+
35106	12M, 3+, $400+
35107	12M, 3+, $100+
35108	12M, 2+, $400+
35109	12M, 2+, $100+
35110	12M, 2+, $1+
35111	12M, 1+, $400+
35112	12M, 1+, $100+
35113	12M, 1+, $1+
35114	24M, 5+, $1000+
35115	24M, 5+, $400+
35116	24M, 5+, $100+
35117	24M, 2+, $1000+
35118	24M, 2+, $400+
35119	24M, 2+, $100+
35120	24M, 2+, $1+
35121	24M, 1+, $400+
35122	24M, 1+, $100+
35123	24M, 1+, $1+
35124	36M, 5+, $1000+, $7.99 FR
35125	36M, 5+, $400+, $7.99 FR
35126	36M, 2+, $1000+, $7.99 FR
35127	36M, 2+, $400+, $7.99 FR
35128	36M, 2+, $100+, $7.99 FR
35129	48M, 5+, $1000+, $7.99 FR
35130	48M, 5+, $400+, $7.99 FR
35131	48M, 2+, $400+, $7.99 FR
35132	48M, 2+, $100+, $7.99 FR
35160	BILLS FRIENDS
35161	MR ROADSTER DEALERS
35170	12 Mo Requestors, $7.99 FR
35192	COUNTER
35198	DHL Bulk Center
35199	RIP - Bouncebacks
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_18004_CST_OutputFile_351
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '351'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '351'                            
order by SC.ixSourceCode 

-- Customers in Offer table for Cat 351

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '351' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty		Description
35102	35003	12M, 5+, $1000+
35103	11041	12M, 5+, $400+
35104	2581	12M, 5+, $100+
35105	3059	12M, 3+, $1000+
35106	8017	12M, 3+, $400+
35107	8457	12M, 3+, $100+
35108	4578	12M, 2+, $400+
35109	9296	12M, 2+, $100+
35110	4486	12M, 2+, $1+
35111	2863	12M, 1+, $400+
35112	12588	12M, 1+, $100+
35113	21661	12M, 1+, $1+
35114	12649	24M, 5+, $1000+
35115	5841	24M, 5+, $400+
35116	1445	24M, 5+, $100+
35117	1889	24M, 2+, $1000+
35118	6701	24M, 2+, $400+
35119	11527	24M, 2+, $100+
35120	3209	24M, 2+, $1+
35121	1821	24M, 1+, $400+
35122	9035	24M, 1+, $100+
35123	16895	24M, 1+, $1+
35124	7099	36M, 5+, $1000+, $7.99 FR
35125	3493	36M, 5+, $400+, $7.99 FR
35126	1251	36M, 2+, $1000+, $7.99 FR
35127	4604	36M, 2+, $400+, $7.99 FR
35128	9242	36M, 2+, $100+, $7.99 FR
35129	4603	48M, 5+, $1000+, $7.99 FR
35130	2507	48M, 5+, $400+, $7.99 FR
35131	4963	48M, 2+, $400+, $7.99 FR
35132	7857	48M, 2+, $100+, $7.99 FR
35160	0		BILLS FRIENDS
35161	0		MR ROADSTER DEALERS
35170	54889	12 Mo Requestors, $7.99 FR
35192	0		COUNTER
35198	0		DHL Bulk Center
35199	0		RIP - Bouncebacks
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from ASC_18004_CST_OutputFile_351
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '351' )
--851794, 1159261, 1366138, 1169064, 1195738, 1087515, 81988, 1399515, 570028, 1165658, 1953149, 
--1458650, 322802, 988098, 1256250, 1299767, 1244066, 1715024, 1210122

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from ASC_18004_CST_OutputFile_351
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '351' )
                    )

/********************************************
ixCustomer	sMailingStatus	flgDeletedFromSOP

81988		9				0
1399515		9				0
1165658		9				0
988098		9				0
1256250		9				0
1244066		0				1
1458650		0				1
851794		9				0
1159261		9				0
1087515		0				1
1169064		9				0

	1953149		0				0
	570028		0				0
	1299767		0				0
	1210122		0				0
	1715024		0				0
	322802		0				0
	1366138		0				0
	1195738		0				0
**********************************************/



