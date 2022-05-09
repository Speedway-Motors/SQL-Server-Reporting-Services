-- Case 16895 - CST output file checks for Cat 362

-- see FB case# 16647 for an example of the process flow between Kyle, us and Al.

-- Catalog 362 = 2013 Sprint Winter Catalog 

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_14493_CST_OutputFile_339
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 362 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 39,987
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found 1 customer (375940) flagged as '9' - DO NOT MAIL - in file. Manually removed from file, re-saved, and re-uploaded

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP

verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from ASC_16895_CST_OutputFile_362


/****** 1.& 2. check for DUPE CUSTOMERS ******/
select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_16895_CST_OutputFile_362                              
/*
AllCnt	DistinctCount
39987	39987
*/

/****** 3. Invalid Customer Numbers ******/
select * from ASC_16895_CST_OutputFile_362
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)

    -- Cust number too short or contains chars
    select * from ASC_16895_CST_OutputFile_362
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0


/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_16895_CST_OutputFile_362
group by  ixSourceCode
order by  ixSourceCode
/*
SCode	Qty
36202	6245
36203	992
36204	903
36205	1470
36206	2044
36207	1119
36208	1725
36209	3505
36210	1275
36211	1391
36212	1200
36213	2023
36214	2634
36215	825
36216	1709
36217	1021
36218	2248
36219	776
36220	1543
36270	2907
36271	2432

FROM CST SCREEN
Total Segments: 21
Total Customers: 39987
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
    select * from ASC_16895_CST_OutputFile_362 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_16895_CST_OutputFile_362 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))

--SELECT * FROM [SMI Reporting].dbo.tblCustomer WHERE ixCustomer = '375940' --sMailingStatus = '9' 



select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '362%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '362' 
/*
SCode	Description
36202	12M, 6+, $1000+
36203	12M, 6+, $400+
36204	12M, 5+, $1+
36205	12M, 2+, $400+
36206	12M, 2+, $1+
36207	12M, 1+, $100+
36208	12M, 1+, $1+
36209	24M, 6+, $1000+
36210	24M, 5+, $1+
36211	24M, 3+, $100+
36212	24M, 2+, $1+
36213	24M, 1+, $1+
36214	36M, 5+, $1000+
36215	36M, 5+, $1+
36216	36M, 2+, $1+
36217	36M, 1+, $1+
36218	48M, 5+, $1000+
36219	48M, 5+, $1+
36220	48M, 2+, $1+
362520	POWRI BULK
36260	BILLS FRIENDS
36261	PRS DEALERS
36270	12M Requestors
36271	24M Requestors
36292	COUNTER
36298	DHL BULK
36299	REQ IN PACKAGE
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_16895_CST_OutputFile_362
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '357'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '357'                            
order by SC.ixSourceCode





-- Customers in Offer table for Cat 343

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '357' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   
/*
SCode	Qty	Description
35702	27346	12M, 6+, $1000+
35703	3410	12M, 6+, $700+
35704	2562	12M, 6+, $400+
35705	1409	12M, 5+, $1000+
35706	2343	12M, 5+, $400+
35707	1676	12M, 5+, $100+
35708	1889	12M, 3+, $1000+
35709	1659	12M, 3+, $700+
35710	3629	12M, 3+, $400+
35711	5595	12M, 3+, $100+
35712	2555	12M, 2+, $400+
35713	5962	12M, 2+, $100+
35714	2710	12M, 2+, $1+
35715	1325	12M, 1+, $400+
35716	7384	12M, 1+, $100+
35717	12794	12M, 1+, $1+
35718	10196	12M, 3+, $1000+ R&S
35719	6626	12M, 3+, $400+ R&S
35720	7598	24M, 6+, $1000+
35721	1395	24M, 6+, $700+
35722	2985	24M, 5+, $400+
35723	936	    24M, 3+, $1000+
35724	899	    24M, 3+, $700+
35725	3806	24M, 2+, $400+
35726	9060	24M, 2+, $100+
35727	5920	36M, 6+, $1000+ OFR
35728	3690	36M, 5+, $400+ OFR
35760	0	    BILLS FRIENDS
35761	0	    PRS DEALER
35770	11829	12M REQUESTORS OFR
35792	0	    COUNTER
35798	0	    DHL
35799	0	    REQ IN PACKAGE
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from ASC_16895_CST_OutputFile_362
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '357' )

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from ASC_16895_CST_OutputFile_362
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '357' )
                    )





