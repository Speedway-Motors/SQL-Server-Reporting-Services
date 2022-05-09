-- Case 19078 - CST output file checks for Cat 364 

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '364'
-- Catalog 364 = FALL '13 SPRINT

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_19078_CST_OutputFile_364
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 364 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in original file = 32,047
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP



CST output file "45-364.txt" for Catalog 366 has passed the following QC checks.

1 - customer count in original file = 32,047
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers
 
Please load the file into SOP to update the customer offers.  Please assign this case back to me once the offers start loading in SOP and I'll provide final counts to Marketing once it's completed.



verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from PJC_19078_CST_OutputFile_364 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_19078_CST_OutputFile_364       
                       
/*
AllCnt	DistinctCount
32047	32047
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_19078_CST_OutputFile_364
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_19078_CST_OutputFile_364
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_19078_CST_OutputFile_364
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
36402	3109
36403	1182
36404	2187
36405	1051
36406	4204
36407	1457
36408	1624
36409	776
36410	1955
36411	915
36412	9442
36470	2967
36471	1178



FROM CST SCREEN
Total Segments: 13 segments [total row count = 13]
Total Customers: 32,047 v

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_19078_CST_OutputFile_364 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_19078_CST_OutputFile_364 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then manually exclude them in the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1840751','98839','1363521','1725857','1448401')
            
            ixCustomer	sMailingStatus
            98839	9
            1363521	9
            1448401	9
            1725857	9
            1840751	9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for ebay buyers, afco purchasers, etc)REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_19078_CST_OutputFile_364
        where ixCustomer NOT in ('1840751','98839','1363521','1725857','1448401')
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '364%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '364' 
    and len(ixSourceCode) >= 5

/*
SCode	Description
36402	12M, 3+, $400+
36403	12M, 3+, $100+
36404	12M, 2+, $1+
36405	12M, 1+, $100+
36406	12M, 1+, $1+
36407	24M, 3+, $100+
36408	24M, 2+, $1+
36409	24M, 1+, $100+
36410	36M, 1+, $100+
36411	48M, 2+, $100+
36412	12m, 5+, $1000 Race
36460	Bill's Friends
36461	PRS DEALERS
36470	12M Requestors
36471	18M Requestors
36492	COUNTER
36498	DHL Bulk Center
36499	RIP - Bouncebacks

*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_19078_CST_OutputFile_364
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '364'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '364'                            
order by SC.ixSourceCode 

/*

Total SOP Customer Offer load time for Cat 364 was   .32 hours = 28.1 avg rec/sec @6-26-13
Total SOP Customer Offer load time for Cat 366 was 28.25 hours =  3.3 avg rec/sec @6-18-13

  
  
*/  

-- Customers in Offer table for Cat 364
/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '364' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
36402	3109	12M, 3+, $400+
36403	1181	12M, 3+, $100+
36404	2186	12M, 2+, $1+
36405	1051	12M, 1+, $100+
36406	4202	12M, 1+, $1+
36407	1457	24M, 3+, $100+
36408	1624	24M, 2+, $1+
36409	776	    24M, 1+, $100+
36410	1954	36M, 1+, $100+
36411	915	    48M, 2+, $100+
36412	9441	12m, 5+, $1000 Race
36460	9	    Bill's Friends
36461	416	    PRS DEALERS
36470	2966	12M Requestors
36471	1178	18M Requestors
36492	0	    COUNTER
36498	0	    DHL Bulk Center
36499	0	    RIP - Bouncebacks


*/ 

/***** FOR CATALOG #364 ONLY
only 163,451 customers loaded from SOP.
     169,173 failed to load
     =======
     332,624
Will run query below to reload the remaining customers/SCs

select distinct SC.ixSourceCode
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '364' 
        
select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '364'         
        
        
select distinct CO.ixCustomer, count(SC.ixSourceCode)
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where SC.ixCatalog = '364'   
        and CO.ixCustomer is NOT NULL
              
        group by CO.ixCustomer
        having count(SC.ixSourceCode) >1
        
select distinct CO.ixCustomer, SC.ixSourceCode
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '364'         
        and CO.ixCustomer is NULL  
       
        

select * from [SMI Reporting].dbo.tblCustomerOffer 
where ixSourceCode like '364%'
--and len(ixSourceCode) = 5
order by ixSourceCode
*/

-- Customers in output file but NOT in tblCustomerOffer
select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
from PJC_19078_CST_OutputFile_364 CST
               -- Customers in tblCustomerOffer for current catalog
    left join (select CO.ixCustomer
                from [SMI Reporting].dbo.tblCustomerOffer CO 
                where CO.ixSourceCode like '364%'
                and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
where CO.ixCustomer is NULL 
order by  CST.ixSourceCode, CST.ixCustomer              
--1120022, 1257248, 1796601, 1159262, 1439053, 1798929, 553750, 508074, 1485669, 503279, 
--1845730, 641296, 716052, 1458337, 509186, 1341450, 1016262, 1526519, 1293644, 150999, 
--1571668, 1247335, 1711043

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_19078_CST_OutputFile_364
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '364' )
                    )

/********************************************
ixCustomer	sMailingStatus	flgDeletedFromSOP
1798929		0				1
508074		0				0
553750		0				0
503279		0				1

**********************************************/



