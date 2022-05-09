-- Case 17915 - CST output file checks for Cat 359

-- Catalog 359 = 2013 SPRNG RMAL (SR)

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_17915_CST_OutputFile_359
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 359 CST Modified Output File.txt" and upload it to the case

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
select top 10 * from PJC_17915_CST_OutputFile_359 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_17915_CST_OutputFile_359       
                       
/*
AllCnt	DistinctCount
97955	97955
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_17915_CST_OutputFile_359
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_17915_CST_OutputFile_359
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_17915_CST_OutputFile_359
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35902	26436
35903	3066
35904	2526
35905	1440
35906	2276
35907	1452
35908	4549
35909	4784
35910	10139
35911	1390
3591111	1391
35912	6508
35913	10486
35914	1936
35915	3898
35916	4712
35917	5099
35918	1818
3592222	341
3593333	161
3594444	532
3595555	1127
3596666	723
3597777	1165

FROM CST SCREEN
Total Segments: 24 segments
Total Customers: 97,955

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_17915_CST_OutputFile_359 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_17915_CST_OutputFile_359 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
   /*if any customers are returned then manually exclude themin the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('969916','453017','201930','1084441','1088568','352114','1277137','1417025','1993030','1729928',
                                  '594635','1992800','493340','743667','1110260','1113911','1174368','1217365')

            201930	8
            352114	8
            453017	8
            493340	8
            594635	8
            743667	8
            969916	9
            1084441	9
            1088568	8
            1110260	8
            1113911	8
            1174368	8
            1217365	8
            1277137	8
            1417025	8
            1729928	9
            1992800	8
            1993030	8
            */

    -- REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    select ixCustomer+','+ixSourceCode
    from PJC_17915_CST_OutputFile_359
    where ixCustomer NOT in ('969916','453017','201930','1084441','1088568','352114','1277137','1417025','1993030','1729928',
                              '594635','1992800','493340','743667','1110260','1113911','1174368','1217365')
     

select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '359%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '359' 

/*
35902	12M, 6+, $1000+
35903	12M, 6+, $700+
35904	12M, 6+, $400+
35905	12M, 5+, $1000+
35906	12M, 5+, $400+
35907	12M, 5+, $100+
35908	12M, 2+, $700+
35909	12M, 2+, $400+
35910	12M, 2+, $100+
35911	12M, 1+, $400+
3591111	NO-MAIL OF 35902
35912	12M, 1+, $100+
35913	24M, 6+, $1000+
35914	24M, 6+, $700+
35915	24M, 5+, $400+
35916	24M, 3+, $400+
35917	24M, 3+, $100+
35918	24M, 2+, $400+
359222	SC NOT IN USE
3592222	NO-MAIL OF 35903
3593333	NO-MAIL OF 35907
3594444	NO-MAIL OF 35909
3595555	NO-MAIL OF 35910
35961	PRS DEALERS
3596666	NO-MAIL OF 35912
3597777	NO-MAIL OF 35913
*/


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_17915_CST_OutputFile_359
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '359'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '359'                            
order by SC.ixSourceCode 

-- Customers in Offer table for Cat 359

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '359' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty	Description
35902	33602	12M, 5+, $1000+
35903	11240	12M, 5+, $400+
35904	2575	12M, 5+, $100+
35905	4022	12M, 2+, $1000+
35906	11610	12M, 2+, $400+
35907	16257	12M, 2+, $100+
35908	4512	12M, 2+, $1+
35909	2877	12M, 1+, $400+
35910	8152	12M, 1+, $150+
35911	9248	24M, 5+, $1000+
3591111	1769	NON-MAIL OF 35902
3592222	1806	NO-MAIL OF 35907
3593333	2312	NO-MAIL OF 35911
*/ 

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from PJC_17915_CST_OutputFile_359
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '359' )
--337805, 1752649, 1399536, 775895

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_17915_CST_OutputFile_359
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '359' )
                    )

/********************************************
ixCustomer	sMailingStatus	flgDeletedFromSOP
337805			0					0
1752649			0					1
775895			0					0
1399536			0					1
**********************************************/



