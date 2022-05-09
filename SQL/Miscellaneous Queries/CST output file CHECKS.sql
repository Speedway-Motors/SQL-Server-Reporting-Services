select top 10 * from PJC_344_CST_MODIFIED_OutputFile

 -- competitors
select * from PJC_344_CST_MODIFIED_OutputFile 
where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
'1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')

select * from tblCustomer where ixCustomer = '1426257'


select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'Distinct' 
from PJC_344_CST_MODIFIED_OutputFile                              
/*
AllCnt	Distinct
208104	208104
*/


-- verify query results vs CST counts
select ixSourceCode SCode, count(*) Qty
from PJC_344_CST_MODIFIED_OutputFile
group by  ixSourceCode
order by  ixSourceCode
/*
SCode	Qty
34302	33254
34303	10827
34304	2447
34305	2910
34306	7726
34307	8310
34308	831
34309	3535
34310	9268
34311	4440
34312	454
34313	2308
34314	12448
34315	21637
34316	11437
34317	5234
34318	1279
34319	4338
34320	423
34321	14117
34322	3090
34323	1663
34324	8564
34325	6893
34326	1486
34370	17024
34371	12161
*/



select * from tblSourceCode
where ixSourceCode like '343%'

select ixSourceCode SCode, sDescription 'Description'
from tblSourceCode
where ixCatalog = '344' 
/*
SCode	Description
34302	12M, 5+, $1000+
34303	12M, 5+, $400+
34304	12M, 5+, $100+
34305	12M, 3+, $1000+
34306	12M, 3+, $400+
34307	12M, 3+, $100+
34308	12M, 2+, $1000+
34309	12M, 2+, $400+
34310	12M, 2+, $100+
34311	12M, 2+, $1+
34312	12M, 1+, $1000+
34313	12M, 1+, $400+
34314	12M, 1+, $100+
34315	12M, 1+, $1+
34316	24M, 5+, $1000+
34317	24M, 5+, $400+
34318	24M, 3+, $1000+
34319	24M, 3+, $400+
34320	24M, 2+, $1000+
34321	24M, 2+, $100+
34322	24M, 2+, $1+
34323	24M, 1+, $400+
34324	24M, 1+, $100+
34325	36M, 5+, $1000+
34326	36M, 1+, $1000+
34360	BILLS FRIENDS
34361	MR RDST DEALER
34370	3M Requestors
34371	6M Requestors
34392	COUNTER
34398	DHL REQUESTORS
34399	RIP PACKAGE INSERT
*/



-- Comparting CST file to Qty loaded into SOP and displaying the Delta
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_344_CST_MODIFIED_OutputFile
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from tblSourceCode SC 
                    left join tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '344'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '344'                            
order by SC.ixSourceCode




-- Customers in Offer table for Cat 343
-- PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from tblSourceCode SC 
    left join tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '344' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   
/*
SCode	Qty	Description
34402	31787	12M, 6+, $1000+
34403	2004	12M, 5+, $1000+
34404	10951	12M, 5+, $400+
34405	2469	12M, 5+, $100+
34406	2911	12M, 3+, $1000+
34407	7761	12M, 3+, $400+
34408	8443	12M, 3+, $100+
34409	4358	12M, 2+, $400+
34410	9183	12M, 2+, $100+
34411	4440	12M, 2+, $1+
34412	2750	12M, 1+, $400+
34413	12337	12M, 1+, $100+
34414	21560	12M, 1+, $1+
34415	11356	24M, 5+, $1000+
34416	5205	24M, 5+, $400+
34417	1310	24M, 5+, $100+
34418	1290	24M, 3+, $1000+
34419	17470	24M, 2+, $100+
34420	3059	24M, 2+, $1+
34421	1612	24M, 1+, $400+
34422	8594	24M, 1+, $100+
34423	16447	24M, 1+, $1+
34424	6877	36M, 5+, $1000+
34425	3463	36M, 5+, $400+
34426	962	36M, 3+, $1000+
34460	0	BILLS FRIENDS
34461	0	MR RDSTR DEALER
34471	24038	12M WEB REQUESTORS
34472	29269	12M CALL CENTER REQUESTORS
34473	1107	12M CATALOGS.COM REQUESTORS
34492	0	COUNTER
34498	0	DHL
34499	0	REQ IN PACKAGE
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from PJC_344_CST_MODIFIED_OutputFile
except (select CO.ixCustomer
        from tblSourceCode SC 
            left join tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '344' )

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_344_CST_MODIFIED_OutputFile
                    except (select CO.ixCustomer
                            from tblSourceCode SC 
                                left join tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '344' )
                    )





