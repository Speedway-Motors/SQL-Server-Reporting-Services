-- Case 16647 - CST output file checks for Cat 357

-- see FB case# 16647 for an example of the process flow between Kyle, us and Al.

-- Catalog 357 = 2013 Race Catalog 

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_14493_CST_OutputFile_339
-- globally replace old table name with new table name



/******************* QC CHECKLIST  *************************

1 - customer count in file = 149,188
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - no customers flagged as competitor,deceased, or "do not mail"

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP

verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from PJC_16647_CST_OutputFile_357


/****** 1.& 2. check for DUPE CUSTOMERS ******/
select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_16647_CST_OutputFile_357                              
/*
AllCnt	DistinctCount
149188	149188
*/

/****** 3. Invalid Customer Numbers ******/
select * from PJC_16647_CST_OutputFile_357
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)

    -- Cust number too short or contains chars
    select * from PJC_16647_CST_OutputFile_357
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0


/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_16647_CST_OutputFile_357
group by  ixSourceCode
order by  ixSourceCode
/*
SCode	Qty
35702	27346
35703	3410
35704	2562
35705	1409
35706	2343
35707	1676
35708	1889
35709	1659
35710	3629
35711	5595
35712	2555
35713	5962
35714	2710
35715	1325
35716	7384
35717	12794
35718	10196
35719	6626
35720	7598
35721	1395
35722	2985
35723	936
35724	899
35725	3806
35726	9060
35727	5920
35728	3690
35770	11829

FROM CST SCREEN
Total Segments: 28
Total Customers: 149188
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
    select * from PJC_16647_CST_OutputFile_357 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_16647_CST_OutputFile_357 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))





select * from [SMI Reporting].dbo.tblSourceCode -- 33
where ixSourceCode like '357%' and len(ixSourceCode) > 4

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '357' 
/*
SCode	Description
35702	12M, 6+, $1000+
35703	12M, 6+, $700+
35704	12M, 6+, $400+
35705	12M, 5+, $1000+
35706	12M, 5+, $400+
35707	12M, 5+, $100+
35708	12M, 3+, $1000+
35709	12M, 3+, $700+
35710	12M, 3+, $400+
35711	12M, 3+, $100+
35712	12M, 2+, $400+
35713	12M, 2+, $100+
35714	12M, 2+, $1+
35715	12M, 1+, $400+
35716	12M, 1+, $100+
35717	12M, 1+, $1+
35718	12M, 3+, $1000+ R&S
35719	12M, 3+, $400+ R&S
35720	24M, 6+, $1000+
35721	24M, 6+, $700+
35722	24M, 5+, $400+
35723	24M, 3+, $1000+
35724	24M, 3+, $700+
35725	24M, 2+, $400+
35726	24M, 2+, $100+
35727	36M, 6+, $1000+ OFR
35728	36M, 5+, $400+ OFR
35760	BILLS FRIENDS
35761	PRS DEALER
35770	12M REQUESTORS OFR
35792	COUNTER
35798	DHL
35799	REQ IN PACKAGE
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_16647_CST_OutputFile_357
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
from PJC_16647_CST_OutputFile_357
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
                    from PJC_16647_CST_OutputFile_357
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '357' )
                    )





