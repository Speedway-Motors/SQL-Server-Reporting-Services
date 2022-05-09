-- Case 17280 - CST output file checks for Cat 358

-- see FB case# 16647 for an example of the process flow between Kyle, us and Al.

-- Catalog 358 = 2013 Sprint Winter Catalog 

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_14493_CST_OutputFile_339
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 358 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 319,012
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
select top 10 * from PJC_17280_CST_OutputFile_358


/****** 1.& 2. check for DUPE CUSTOMERS ******/
select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistCnt' 
from PJC_17280_CST_OutputFile_358                              
/*
AllCnt	DistCnt
319012	319012
*/

/****** 3. Invalid Customer Numbers ******/
select * from PJC_17280_CST_OutputFile_358
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)

    -- Cust number too short or contains chars
    select * from PJC_17280_CST_OutputFile_358
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0


/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_17280_CST_OutputFile_358
group by  ixSourceCode
order by  ixSourceCode
/*
SCode	Qty
35802	27897
35803	3446
35804	2531
35805	1423
35806	2338
35807	1941
35808	1664
35809	3639
35810	7190

35811	2616
35812	5878
35813	2691
35814	1347
35815	7357
35816	12626
35817	11155
35818	8140
35819	10776
35820	4388

35821	10521
35822	7575
35823	1419
35824	1523
35825	1852
35826	3937
35827	3810
35828	1623
35829	3988
35830	1778

35831	6264
35832	9678
35833	8317
35834	6806
35835	7638
35836	2238
35837	2238
35838	3174
35839	3082
35840	3226

35841	1270
35842	3209
35843	1417
35844	2482
35845	2482
35846	3642
35847	3642
35848	3614
35849	2691
35850	2780

35851	3017
35852	2068
35853	2068
35854	1307
35855	2200
35856	2201
35857	3095
35858	3095
35859	2136
35860	1981

35861	3489
35862	2690
35863	2691
35864	1224
35865	1144
35866	3975
35867	2016
35868	2015
35869	4234
35870	4235

35871	5815
35872	5815
35873	4540
35874	4540
35875	5231
35876	5231

FROM CST SCREEN
Total Segments: 63
Total Customers: 319012
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
    select * from PJC_17280_CST_OutputFile_358 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_17280_CST_OutputFile_358 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))

--SELECT * FROM [SMI Reporting].dbo.tblCustomer WHERE ixCustomer = '375940' --sMailingStatus = '9' 



select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '358%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '358' 
/*
SCode	Description
34850	INCORRECT CODE DISREGARD
35802	12M, 6+, $1000+
35803	12M, 6+, $700+
35804	12M, 6+, $400+
35805	12M, 5+, $1000+
35806	12M, 5+, $400+
35807	12M, 3+, $1000+
35808	12M, 3+, $700+
35809	12M, 3+, $400+
35810	12M, 3+, $100+
35811	12M, 2+, $400+
35812	12M, 2+, $100+
35813	12M, 2+, $1+
35814	12M, 1+, $400+
35815	12M, 1+, $100+
35816	12M, 1+, $1+
35817	12M, 2+, $1000+, S&R
35818	12M, 2+, $400+, S&R
35819	12M, 2+, $1+, S&R
35820	12M, 1+, $100+, S&R
35821	12M, 1+, $1+, S&R
35822	24M, 6+, $1000+
35823	24M, 6+, $700+
35824	24M, 6+, $1+
35825	24M, 5+, $400+
35826	24M, 3+, $400+
35827	24M, 3+, $100+
35828	24M, 2+, $400+
35829	24M, 2+, $100+
35830	24M, 2+, $1+
35831	24M, 1+, $100+
35832	24M, 1+, $1+
35833	24M, 2+, $400+ S&R
35834	24M, 1+, $100+ S&R
35835	24M, 1+, $1+ S&R
35836	36M, 6+, $1000+ $7.99 FR
35837	36M, 6+, $1000+ Tiered Ofr
35838	36M, 5+, $400+ $7.99 FR
35839	36M, 3+, $400+ $7.99 FR
35840	36M, 3+, $100+ $7.99 FR
35841	36M, 2+, $400+ $7.99 FR
35842	36M, 2+, $100+ $7.99 FR
35843	36M, 2+, $1+ $7.99 FR
35844	36M, 1+, $100+ $7.99 FR
35845	36M, 1+, $100+ Tiered Ofr
35846	36M, 1+, $1+ $7.99 FR
35847	36M, 1+, $1+ Tiered Ofr
35848	48M, 6+, $1000+ $7.99 FR
35849	48M, 5+, $400+ $7.99 FR
35850	48M, 3+, $400+ $7.99 FR
35851	48M, 3+, $100+ $7.99 FR
35852	48M, 2+, $100+ $7.99 FR
35853	48M, 2+, $100+ Tiered Ofr
35854	48M, 2+, $1+ $7.99 FR
35855	48M, 1+, $100+ $7.99 FR
35856	48M, 1+, $100+ Tiered Ofr
35857	48M, 1+, $1+ $7.99 FR
35858	48M, 1+, $1+ Tiered Ofr
35859	60M, 6+, $1000+ $7.99 FR
35860	60M, 5+, $400+ $7.99 FR
35861	60M, 2+, $400+ $7.99 FR
35862	60M, 2+, $100+ $7.99 FR
35863	60M, 2+, $100+ Tiered Ofr
35864	60M, 2+, $1+ $7.99 FR
35865	72M, 6+, $1000+ $7.99 FR
35866	72M, 2+, $400+ $7.99 FR
35867	72M, 2+, $100+ $7.99 FR
35868	72M, 2+, $100+ Tiered Ofr
35869	72M, 1+, $100+ $7.99 FR
35870	72M, 1+, $100+ Tiered Ofr
35871	12M Requestors $7.99 FR
35872	12M Requestors Tiered Ofr
35873	24M Requestors $7.99 FR
35874	24M Requestors Tiered Ofr
35875	36M Requestors $7.99 FR
35876	36M Requestors Tiered Ofr
35880	2012 Banquet $7.99 FR
35881	2010 Banquet $7.99 FR
35882	2009 Banquet $7.99 FR
35883	2008 Banquet $7.99 FR
35884	IMCA List $7.99 FR
35885	Wissota List $7.99 FR
35886	BILLS FRIENDS
35887	PRS DEALERS
35888	Dataline List $7.99 FR
35892	COUNTER
35898	DHL BULK
35899	RIP REQUEST IN PACKAGE
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_17280_CST_OutputFile_358
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '358'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '358'                            
order by SC.ixSourceCode





-- Customers in Offer table for Cat 343

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '358' 
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
from PJC_17280_CST_OutputFile_358
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '358' )

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_17280_CST_OutputFile_358
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '358' )
                    )





