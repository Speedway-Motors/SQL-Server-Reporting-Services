-- Case 17809 - CST output file checks for Cat 349

-- see FB case# 16647 for an example of the process flow between Kyle, us and Al.

-- Catalog 349 = 2013 STREET EARLY SPRING Catalog 

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_17809_CST_OutputFile_365
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 362 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 435,622
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
select top 10 * from PJC_17809_CST_OutputFile_365 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_17809_CST_OutputFile_365       
                       
/*
AllCnt	DistinctCount
43810	43810
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_17809_CST_OutputFile_365
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_17809_CST_OutputFile_365
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_17809_CST_OutputFile_365
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
36502	4702
36503	915
36504	1579
36505	1347
36506	943
36507	1471
36509	4012
36510	935
36511	1252
36512	1155
36513	1774
36514	3380
36515	2031
36516	1152
36517	2636
36570	8788
36571	5738

FROM CST SCREEN
Total Segments: 17 
Total Customers: 43810

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_17809_CST_OutputFile_365 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    
    select * from PJC_17809_CST_OutputFile_365 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
-- 1833750	36507
    Select sMailingStatus from [SMI Reporting].dbo.tblCustomer 
    where ixCustomer = '1833750'


-- REGENERATE LIST EXCLUDING CUSTOMERS THAT FAILED CHECKS
    select * from PJC_17809_CST_OutputFile_365 
    where ixCustomer NOT in ('1833750')


-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '365' 

/*
SCode	Description
36502	12M, 5+, $1000+
36503	12M, 5+, $400+
36504	12M, 2+, $400+
36505	12M, 2+, $100+
36506	12M, 1+, $100+
36507	12M, 1+, $1+
36508	SOURCE CODE NOT BEING USED
36509	24M, 5+, $1000+
36510	24M, 5+, $400+
36511	24M, 2+, $400+
36512	24M, 2+, $100+
36513	24M, 1+, $1+
36514	36M, 5+, $1000+
36515	36M, 3+, $100+
36516	36M, 1+, $100+
36517	48M, 5+, $1000+
36560	BILLS FRIENDS
36561	MR ROADSTER DEALERS
36570	12 Month Requestors
36571	24 Month Requestors
36592	COUNTER
36598	DHL BULK
36599	REQUEST IN PACKAGE
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(distinct ixCustomer) Qty
                from PJC_17809_CST_OutputFile_365
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '365'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '365'                            
order by SC.ixSourceCode

-- Customers in Offer table for Cat 365

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(distinct CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '365' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty	Description
36502	9401	12M, 5+, $1000+
36503	1830	12M, 5+, $400+
36504	3156	12M, 2+, $400+
36505	2694	12M, 2+, $100+
36506	1886	12M, 1+, $100+
36507	1633	12M, 1+, $1+
36508	0	SOURCE CODE NOT BEING USED
36509	4012	24M, 5+, $1000+
36510	935	24M, 5+, $400+
36511	1251	24M, 2+, $400+
36512	1155	24M, 2+, $100+
36513	1774	24M, 1+, $1+
36514	3380	36M, 5+, $1000+
36515	2031	36M, 3+, $100+
36516	1152	36M, 1+, $100+
36517	2636	48M, 5+, $1000+
36560	0	BILLS FRIENDS
36561	0	MR ROADSTER DEALERS
36570	8787	12 Month Requestors
36571	5737	24 Month Requestors
36592	0	COUNTER
36598	0	DHL BULK
36599	0	REQUEST IN PACKAGE
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer, ixSourceCode
from PJC_17809_CST_OutputFile_365
except (select CO.ixCustomer, CO.ixSourceCode
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '365' )

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_17809_CST_OutputFile_365
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '365' )
                    )





