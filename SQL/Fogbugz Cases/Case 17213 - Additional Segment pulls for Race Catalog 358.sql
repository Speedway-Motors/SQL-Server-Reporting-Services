-- Case 17213 - Additional Segment pulls for Race Catalog 358

/*
Add any customers that have NOT YET BEEN LOADED via the normal CST/SOP process (not in tblCustomerOffer for cat 358)
mark them based on their original source codes below with their corisponding segments for this Catalog.

Original    Mailing
SC          SC
=======     =======  
357500      35880
RB10        35881
RCB9        35882
RCB8        35883
*/


SELECT ixSourceCode, -- starting pool = 2,595 based on SOME of the CST filters
        count(*) QTY
FROM [SMI Reporting].dbo.tblCustomer
WHERE ixSourceCode in ('347500','RB10','RCB9','RCB8')
    and flgDeletedFromSOP = 0
    and (sMailingStatus is NULL or sMailingStatus = 0)
/********** add a CHECK for opt-outs where Market is 'R') ****************/
-- and ixCustomer NOT in      (select ixCustomer
                               --from optin table
                               --where opted out of Market 'R'
                               --)
-- and ixCustomer NOT in (select ixCustomer  -- customer not pulled yet for Cat 358
                          --from tblCustomerOffer
                          --where ixSourceCode like '358%')                                                                  
GROUP BY ixSourceCode

/*
ixSourceCode	QTY
347500	        620
RB10	        289
RCB8	        1311
RCB9	        358
*/

SELECT ixSourceCode, -- starting pool = 2,595 based on SOME of the CST filters
        count(*) QTY
FROM [SMI Reporting].dbo.tblCustomer
WHERE ixSourceCode in ('347500','RB10','RCB9','RCB8')
    and flgDeletedFromSOP = 0
    and (sMailingStatus is NULL or sMailingStatus = 0)
/********** add a CHECK for opt-outs where Market is 'R') ****************/
    and ixCustomer NOT in  (select ixCustomer
                            from [SMI Reporting].dbo.tblMailingOptIn
                            where sOptInStatus = 'N'
                              and ixMarket = 'R')
and ixCustomer NOT in (select ixCustomer  -- customer not pulled yet for Cat 358
                       from PJC_17280_CST_OutputFile_358)                                                                  
GROUP BY ixSourceCode
/*  
347500	614
RB10	 22
RCB9	175
RCB8	968
       ====
      1,779
      
35880	614
35881	22
35882	175
35883	968      
*/

SELECT C.ixCustomer,
       (Case when C.ixSourceCode = '347500' then '35880'
             when C.ixSourceCode = 'RB10'   then '35881'
             when C.ixSourceCode = 'RCB9'   then '35882'
             when C.ixSourceCode = 'RCB8'   then '35883'
             else 'ERROR'
         end) ixSourceCode
into PJC_17280_BanquetCustomersToLoad         
FROM [SMI Reporting].dbo.tblCustomer C
WHERE C.ixSourceCode in ('347500','RB10','RCB9','RCB8')
    and C.flgDeletedFromSOP = 0
    and (C.sMailingStatus is NULL or C.sMailingStatus = 0)
    /********** CHECK for opt-outs where Market is 'R') ****************/
    and C.ixCustomer NOT in  (select ixCustomer
                              from [SMI Reporting].dbo.tblMailingOptIn
                              where sOptInStatus = 'N'
                                and ixMarket = 'R')
    /********** verify customers not in current CST output file****************/                                
    and C.ixCustomer NOT in (select ixCustomer  -- customer not pulled yet for Cat 358
                             from PJC_17280_CST_OutputFile_358)                                                                  

select ixSourceCode, count(*) CustQty
from PJC_17280_BanquetCustomersToLoad
group by ixSourceCode
order by ixSourceCode
/*
ixSourceCode	CustQty
35880	        614
35881	        22
35882	        175
35883	        968

35880	613
35881	22
35882	175
35883	966
*/

-- taking original CST file, adding the not yet pulled Banquet customers and saving as a new file
-- then importing the new file into the PJC_17280_CST_OutputFile_358_MOD table to re-run standard checks

select * from PJC_17280_CST_OutputFile_358
select * from PJC_17280_BanquetCustomersToLoad


select count(*) from PJC_17280_CST_OutputFile_358       -- 319,012    318,956
select count(*) from PJC_17280_BanquetCustomersToLoad   --   1,779
                                                        -- =======
select count(*) from PJC_17280_CST_OutputFile_358_MOD   -- 320,791 v







/***** RECHECKING MERGED FILE *********/

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
5 - no DO NOT MAIL customers in file

--found 1 customer (375940) flagged as '9' - DO NOT MAIL - in file. Manually removed from file, re-saved, and re-uploaded

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP

verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from PJC_17280_CST_OutputFile_358_MOD


/****** 1.& 2. check for DUPE CUSTOMERS ******/
select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistCnt' 
from PJC_17280_CST_OutputFile_358_MOD                              
/*
AllCnt	DistCnt
320791	320791
*/
Catalog 358 CST Modified Output File.txt 


/****** 3. Invalid Customer Numbers ******/
select * from PJC_17280_CST_OutputFile_358_MOD
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)

    -- Cust number too short or contains chars
    select * from PJC_17280_CST_OutputFile_358_MOD
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0


/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_17280_CST_OutputFile_358_MOD
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
35880	614
35881	22
35882	175
35883	968

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
    select * from PJC_17280_CST_OutputFile_358_MOD 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_17280_CST_OutputFile_358_MOD 
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
                from PJC_17280_CST_OutputFile_358_MOD
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
34850	0	INCORRECT CODE DISREGARD
35802	27891	12M, 6+, $1000+
35803	3445	12M, 6+, $700+
35804	2531	12M, 6+, $400+
35805	1423	12M, 5+, $1000+
35806	2337	12M, 5+, $400+
35807	1941	12M, 3+, $1000+
35808	1664	12M, 3+, $700+
35809	3637	12M, 3+, $400+
35810	7190	12M, 3+, $100+
35811	2616	12M, 2+, $400+
35812	5874	12M, 2+, $100+
35813	2691	12M, 2+, $1+
35814	1347	12M, 1+, $400+
35815	7356	12M, 1+, $100+
35816	12626	12M, 1+, $1+
35817	11155	12M, 2+, $1000+, S&R
35818	8140	12M, 2+, $400+, S&R
35819	10772	12M, 2+, $1+, S&R
35820	4386	12M, 1+, $100+, S&R
35821	10519	12M, 1+, $1+, S&R
35822	7575	24M, 6+, $1000+
35823	1419	24M, 6+, $700+
35824	1522	24M, 6+, $1+
35825	1851	24M, 5+, $400+
35826	3937	24M, 3+, $400+
35827	3810	24M, 3+, $100+
35828	1622	24M, 2+, $400+
35829	3987	24M, 2+, $100+
35830	1778	24M, 2+, $1+
35831	6264	24M, 1+, $100+
35832	9677	24M, 1+, $1+
35833	8314	24M, 2+, $400+ S&R
35834	6805	24M, 1+, $100+ S&R
35835	7637	24M, 1+, $1+ S&R
35836	2237	36M, 6+, $1000+ $7.99 FR
35837	2238	36M, 6+, $1000+ Tiered Ofr
35838	3173	36M, 5+, $400+ $7.99 FR
35839	3082	36M, 3+, $400+ $7.99 FR
35840	3226	36M, 3+, $100+ $7.99 FR
35841	1269	36M, 2+, $400+ $7.99 FR
35842	3209	36M, 2+, $100+ $7.99 FR
35843	1416	36M, 2+, $1+ $7.99 FR
35844	2482	36M, 1+, $100+ $7.99 FR
35845	2482	36M, 1+, $100+ Tiered Ofr
35846	3640	36M, 1+, $1+ $7.99 FR
35847	3641	36M, 1+, $1+ Tiered Ofr
35848	3612	48M, 6+, $1000+ $7.99 FR
35849	2691	48M, 5+, $400+ $7.99 FR
35850	2779	48M, 3+, $400+ $7.99 FR
35851	3017	48M, 3+, $100+ $7.99 FR
35852	2068	48M, 2+, $100+ $7.99 FR
35853	2068	48M, 2+, $100+ Tiered Ofr
35854	1307	48M, 2+, $1+ $7.99 FR
35855	2200	48M, 1+, $100+ $7.99 FR
35856	2200	48M, 1+, $100+ Tiered Ofr
35857	3094	48M, 1+, $1+ $7.99 FR
35858	3095	48M, 1+, $1+ Tiered Ofr
35859	2135	60M, 6+, $1000+ $7.99 FR
35860	1981	60M, 5+, $400+ $7.99 FR
35861	3487	60M, 2+, $400+ $7.99 FR
35862	2690	60M, 2+, $100+ $7.99 FR
35863	2690	60M, 2+, $100+ Tiered Ofr
35864	1224	60M, 2+, $1+ $7.99 FR
35865	1144	72M, 6+, $1000+ $7.99 FR
35866	3975	72M, 2+, $400+ $7.99 FR
35867	2016	72M, 2+, $100+ $7.99 FR
35868	2015	72M, 2+, $100+ Tiered Ofr
35869	4233	72M, 1+, $100+ $7.99 FR
35870	4233	72M, 1+, $100+ Tiered Ofr
35871	5815	12M Requestors $7.99 FR
35872	5815	12M Requestors Tiered Ofr
35873	4540	24M Requestors $7.99 FR
35874	4540	24M Requestors Tiered Ofr
35875	5228	36M Requestors $7.99 FR
35876	5230	36M Requestors Tiered Ofr
35880	613	    2012 Banquet $7.99 FR
35881	22	    2010 Banquet $7.99 FR
35882	175	    2009 Banquet $7.99 FR
35883	966	    2008 Banquet $7.99 FR
35884	0	    IMCA List $7.99 FR
35885	0	    Wissota List $7.99 FR
35886	0	    BILLS FRIENDS
35887	0	    PRS DEALERS
35888	0	    Dataline List $7.99 FR
35892	0	    COUNTER
35898	0	    DHL BULK
35899	0	    RIP REQUEST IN PACKAGE


select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '358' 

*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from PJC_17280_CST_OutputFile_358_MOD
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
                    from PJC_17280_CST_OutputFile_358_MOD
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '358' )
                    )





