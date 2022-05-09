-- Case 17522 - CST output file checks for Cat 350

-- Catalog 350 = 2013 SPRNG RMAL (SR)

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_17522_CST_OutputFile_350
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 350 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 109985
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
select top 10 * from ASC_17522_CST_OutputFile_350


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_17522_CST_OutputFile_350       
                       
/*
AllCnt	DistinctCount
109985	109985
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_17522_CST_OutputFile_350
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_17522_CST_OutputFile_350
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_17522_CST_OutputFile_350
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35002	33603
35003	11240
35004	2575
35005	4022
35006	11610
35007	16258
35008	4512
35009	2878
35010	8152
35011	9248
3501111	1769
3502222	1806
3503333	2312

FROM CST SCREEN
Total Segments: 10 (13 rows, 3 split out segments) 
Total Customers: 109985

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_17522_CST_OutputFile_350 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    
    select * from ASC_17522_CST_OutputFile_350 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE

select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '362%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '350' 

/*
SCode	Description
35002	12M, 5+, $1000+
35003	12M, 5+, $400+
35004	12M, 5+, $100+
35005	12M, 2+, $1000+
35006	12M, 2+, $400+
35007	12M, 2+, $100+
35008	12M, 2+, $1+
35009	12M, 1+, $400+
35010	12M, 1+, $150+
35011	24M, 5+, $1000+
3501111	NON-MAIL OF 35002
3502222	NO-MAIL OF 35007
3503333	NO-MAIL OF 35011
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_17522_CST_OutputFile_350
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '350'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '350'                            
order by SC.ixSourceCode 

-- Customers in Offer table for Cat 350

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '350' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty	Description
35002	33602	12M, 5+, $1000+
35003	11240	12M, 5+, $400+
35004	2575	12M, 5+, $100+
35005	4022	12M, 2+, $1000+
35006	11610	12M, 2+, $400+
35007	16257	12M, 2+, $100+
35008	4512	12M, 2+, $1+
35009	2877	12M, 1+, $400+
35010	8152	12M, 1+, $150+
35011	9248	24M, 5+, $1000+
3501111	1769	NON-MAIL OF 35002
3502222	1806	NO-MAIL OF 35007
3503333	2312	NO-MAIL OF 35011
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from ASC_17522_CST_OutputFile_350
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '350' )
--337805, 1752649, 1399536, 775895

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from ASC_17522_CST_OutputFile_350
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '350' )
                    )

/********************************************
ixCustomer	sMailingStatus	flgDeletedFromSOP
337805			0					0
1752649			0					1
775895			0					0
1399536			0					1
**********************************************/



