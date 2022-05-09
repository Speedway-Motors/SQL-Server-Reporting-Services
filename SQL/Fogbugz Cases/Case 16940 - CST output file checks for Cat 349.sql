-- Case 16940 - CST output file checks for Cat 349

-- see FB case# 16647 for an example of the process flow between Kyle, us and Al.

-- Catalog 349 = 2013 STREET EARLY SPRING Catalog 

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_16940_CST_OutputFile_349
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
select top 10 * from ASC_16940_CST_OutputFile_349


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_16940_CST_OutputFile_349       
                       
/*
AllCnt	DistinctCount
435622	435622
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_16940_CST_OutputFile_349
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_16940_CST_OutputFile_349
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_16940_CST_OutputFile_349
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
34902	32919
34903	2044
34904	11144
34905	2519
34906	3021
34907	7897
34908	8628
34909	4511
34910	9422
34911	4480
34912	2864
34913	12669
34914	22042
34915	11594
34916	5349
34917	1301
34918	1709
34919	6301
34920	10921
34921	3036
34922	1668
34923	8634
34924	16229
34925	3544
34926	3543
34927	3547
34928	1274
34929	4612
34930	4626
34931	4627
34932	2368
34933	3512
34934	3512
34935	5686
34936	5685
34937	4570
34938	2525
34939	4828
34940	3862
34941	3863
34942	3014
34943	3013
34944	5776
34945	5777
34946	3176
34947	6048
34948	6049
34949	2646
34950	2646
34951	3329
34952	3329
34953	4115
34954	4115
34955	3569
34956	4323
34957	5110
34970	28698
34971	28697
34972	16477
34973	16477
34974	11076
34975	11076

FROM CST SCREEN
Total Segments: 48 (62 rows, 14 split out segments) 
Total Customers: 435622

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_16940_CST_OutputFile_349 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    
    select * from ASC_16940_CST_OutputFile_349 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE

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
362568	EAGLE CHASSIS COVER
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
                from ASC_16940_CST_OutputFile_349
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '349'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '349'                            
order by SC.ixSourceCode

-- Customers in Offer table for Cat 349

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '349' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty	Description
34902	32919	12M, 6+, $1000+
34903	2044	12M, 5+, $1000+
34904	11144	12M, 5+, $400+
34905	2519	12M, 5+, $100+
34906	3021	12M, 3+, $1000+
34907	7897	12M, 3+, $400+
34908	8628	12M, 3+, $100+
34909	4511	12M, 2+, $400+
34910	9422	12M, 2+, $100+
34911	4480	12M, 2+, $1+
34912	2864	12M, 1+, $400+
34913	12669	12M, 1+, $100+
34914	22042	12M, 1+, $1+
34915	11594	24M, 5+, $1000+
34916	5349	24M, 5+, $400+
34917	1301	24M, 5+, $100+
34918	1709	24M, 2+, $1000+
34919	6301	24M, 2+, $400+
34920	10921	24M, 2+, $100+
34921	3036	24M, 2+, $1+
34922	1668	24M, 1+, $400+
34923	8634	24M, 1+, $100+
34924	16229	24M, 1+, $1+
34925	3544	36M, 5+, $1000+ $7.99 FR
34926	3543	36M, 5+, $1000+ Tiered Ofr
34927	3547	36M, 5+, $400+ $7.99 FR
34928	1274	36M, 2+, $1000+ $7.99 FR
34929	4612	36M, 2+, $400+ $7.99 FR
34930	4626	36M, 2+, $100+ $7.99 FR
34931	4627	36M, 2+, $100+ Tiered Ofr
34932	2368	36M, 2+, $1+ $7.99 FR
34933	3512	36M, 1+, $100+ $7.99 FR
34934	3512	36M, 1+, $100+ Tiered Ofr
34935	5686	36M, 1+, $1+ $7.99 FR
34936	5685	36M, 1+, $1+ Tiered Ofr
34937	4570	48M, 5+, $1000+ $7.99 FR
34938	2525	48M, 5+, $400+ $7.99 FR
34939	4828	48M, 2+, $400+ $7.99 FR
34940	3862	48M, 2+, $100+ $7.99 FR
34941	3863	48M, 2+, $100+ Tiered Ofr
34942	3014	48M, 1+, $100+ $7.99 FR
34943	3013	48M, 1+, $100+ Tiered Ofr
34944	5776	48M, 1+, $1+ $7.99 FR
34945	5777	48M, 1+, $1+ Tiered Ofr
34946	3176	60M, 5+, $1000+ $7.99 FR
34947	6048	60M, 2+, $100+ $7.99 FR
34948	6049	60M, 2+, $100+ Tiered Ofr
34949	2646	60M, 1+, $100+ $7.99 FR
34950	2646	60M, 1+, $100+ Tiered Ofr
34951	3329	72M, 1+, $400+ $7.99 FR
34952	3329	72M, 1+, $400+ Tiered Ofr
34953	4115	72M, 1+, $100+ $7.99 FR
34954	4115	72M, 1+, $100+ Tiered Ofr
34955	3569	12M, 2+, $1000+, Race
34956	4323	12M, 2+, $400+, Race
34957	5110	12M, 2+, $100+, Race
34960	0	BILLS FRIENDS
34961	0	MR ROADSTER DEALERS
34970	28698	12M Requestors $7.99 FR
34971	28697	12M Requestors Tiered Ofr
34972	16477	24M Requestors $7.99 FR
34973	16476	24M Requestors Tiered Ofr
34974	11074	36M Requestors $7.99 FR
34975	11076	36M Requestors Tiered Ofr
34992	0	Counter
34998	0	DHL BULK
34999	0	RIP - Bouncebacks
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from ASC_16940_CST_OutputFile_349
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '349' )

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from ASC_16940_CST_OutputFile_349
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '349' )
                    )





