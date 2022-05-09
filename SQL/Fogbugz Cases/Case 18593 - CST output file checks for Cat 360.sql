-- Case 18593 - CST output file checks for Cat 360

-- Catalog 360 = '13 RACE SPRNG2

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_18593_CST_OutputFile_360
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 360 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 183663 --[modified file with DO NOT MAIL removed]
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers --[modified file]

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP

verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from ASC_18593_CST_OutputFile_360 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_18593_CST_OutputFile_360       
                       
/*
AllCnt	DistinctCount
183663	183663
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_18593_CST_OutputFile_360
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_18593_CST_OutputFile_360
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_18593_CST_OutputFile_360
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
36002	14195
36003	5632
36004	2386
36005	2011
36006	2684
36007	10296
36008	1684
36009	6086
36010	7237
36011	1049
36012	1652
36013	5700
36014	5992
36015	15597
36016	8773
36017	6053
36018	1098
36019	4300
36020	5570
36021	879
36022	6126
36023	4931
36024	13387
36025	4520
36026	4520
36027	2086
36028	2087
36029	1984
36030	1983
36031	2929
36032	2929
36033	1856
36034	1856
36035	3242
36036	3242
36037	5332
36038	5890
36039	5889

FROM CST SCREEN
Total Segments: 31 segments [7 50% Split Segments - total row count = 38]
Total Customers: 183,663

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_18593_CST_OutputFile_360 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_18593_CST_OutputFile_360 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then manually exclude them in the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in (INSERT CUSTOMERS HERE)

            ixCustomer	sMailingStatus
            
            			
    */

    -- REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    --select ixCustomer+','+ixSourceCode
    --from ASC_18593_CST_OutputFile_360
    --where ixCustomer NOT in (INSERT CUSTOMERS HERE)

select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '360%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '360' 

/*
36002	12M, 6+, $1000+
36003	12M, 6+, $400+
36004	12M, 5+, $400+
36005	12M, 3+, $700+
36006	12M, 3+, $400+
36007	12M, 3+, $100+
36008	12M, 2+, $400+
36009	12M, 2+, $100+
36010	12M, 2+, $1+
36011	12M, 1+, $400+
36012	12M, 1+, $250+
36013	12M, 1+, $100+
36014	12M, 1+, $50+
36015	12M, 1+, $1+
36016	24M, 3+, $400+
36017	24M, 3+, $100+
36018	24M, 2+, $400+
36019	24M, 2+, $100+
36020	24M, 2+, $1+
36021	24M, 1+, $400+
36022	24M, 1+, $100
36023	24M, 1+, $50
36024	24M, 1+, $1
36025	36M, 3+, $100
36026	36M, 3+, $100 $7.99 FR
36027	36M, 2+, $100
36028	36M, 2+, $100 $7.99 FR
36029	36M, 2+, $1+
36030	36M, 2+, $1+ $7.99 FR
36031	36M, 1+, $100+
36032	36M, 1+, $100+ $7.99 FR
36033	36M, 1+, $50+
36034	36M, 1+, $50+ $7.99 FR
36035	48M, 3+, $100+
36036	48M, 3+, $100+ $7.99 FR
36037	12M, 6+, $1000+ SR
36038	12 Month Requestors
36039	12 Month Requestors $7.99 FR
36086	Bill's Friends
36087	PRS Dealers
36092	Counter
36098	DHL Bulk Center
36099	RIP - Bouncebacks
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_18593_CST_OutputFile_360
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '360'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '360'                            
order by SC.ixSourceCode 

-- Customers in Offer table for Cat 360

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '360' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty		Description
36002	14192	12M, 6+, $1000+
36003	5631	12M, 6+, $400+
36004	2385	12M, 5+, $400+
36005	2010	12M, 3+, $700+
36006	2683	12M, 3+, $400+
36007	10295	12M, 3+, $100+
36008	1684	12M, 2+, $400+
36009	6085	12M, 2+, $100+
36010	7237	12M, 2+, $1+
36011	1049	12M, 1+, $400+
36012	1652	12M, 1+, $250+
36013	5700	12M, 1+, $100+
36014	5992	12M, 1+, $50+
36015	15596	12M, 1+, $1+
36016	8772	24M, 3+, $400+
36017	6053	24M, 3+, $100+
36018	1098	24M, 2+, $400+
36019	4299	24M, 2+, $100+
36020	5570	24M, 2+, $1+
36021	879		24M, 1+, $400+
36022	6126	24M, 1+, $100
36023	4931	24M, 1+, $50
36024	13386	24M, 1+, $1
36025	4520	36M, 3+, $100
36026	4518	36M, 3+, $100 $7.99 FR
36027	2086	36M, 2+, $100
36028	2086	36M, 2+, $100 $7.99 FR
36029	1984	36M, 2+, $1+
36030	1983	36M, 2+, $1+ $7.99 FR
36031	2929	36M, 1+, $100+
36032	2929	36M, 1+, $100+ $7.99 FR
36033	1856	36M, 1+, $50+
36034	1856	36M, 1+, $50+ $7.99 FR
36035	3242	48M, 3+, $100+
36036	3242	48M, 3+, $100+ $7.99 FR
36037	5332	12M, 6+, $1000+ SR
36038	5888	12 Month Requestors
36039	5889	12 Month Requestors $7.99 FR
36086	0		Bill's Friends
36087	0		PRS Dealers
36092	0		Counter
36098	0		DHL Bulk Center
36099	0		RIP - Bouncebacks
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from ASC_18593_CST_OutputFile_360
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '360' )
--1120022, 1257248, 1796601, 1159262, 1439053, 1798929, 553750, 508074, 1485669, 503279, 
--1845730, 641296, 716052, 1458337, 509186, 1341450, 1016262, 1526519, 1293604, 150999, 
--1571668, 1247335, 1711043

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from ASC_18593_CST_OutputFile_360
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '360' )
                    )

/********************************************
ixCustomer	sMailingStatus	flgDeletedFromSOP
1798929		0				1
508074		0				0
553750		0				0
503279		0				1
1485669		0				1
1845730		0				0
641296		0				0
716052		0				0
509186		0				0
1341450		0				0
1458337		0				1
1120022		0				1
1257248		0				1
1796601		0				1
1159262		0				1
1439053		0				1
1016262		0				0
1293604		0				0
1526519		0				1
150999		0				1
1247335		0				1
1571668		0				1
1711043		0				1
**********************************************/



