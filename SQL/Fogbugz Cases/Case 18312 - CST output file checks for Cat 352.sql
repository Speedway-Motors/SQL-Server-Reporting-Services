-- Case 18312 - CST output file checks for Cat 352

-- Catalog 352 = Campaign 352 2013 Street Early Summer Catalog (SR)

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Marketing into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_#####_CST_OutputFile_Cat###
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 352 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 136,723 [modified file with DO NOT MAIL removed]
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers [modified file]

6 -if steps 1-5 show no issues, notify Al (put the results below into the case and assign to Al) 


        /******* IF ORIGINAL FILE NEEDED NO MODIFICATIONS   *******/
The <filenamehere> file has passed the QC checks below:

1 - customer count in modified file = ###,###
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST.
5 - found no competitors, deceased, or do not mail customers

Please start the SOP Customer Offer update process and assign back to me.  
Once I receive the automated notification that it has completed loading, 
I will run final checks and provide the counts to Marketing.



        /*******  IF MODIFICATIONS WERE NEEDED  *******/
The original output file contained X customers that had a mailing status of 9 <or other issues if applicable>.  
They have been removed and the remaining customers are in the attached modified file <filenamehere>.

The modified file has passed the QC checks below:

1 - customer count in modified file = ###,###
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST (minus the above exceptions)
5 - found no competitors, deceased, or do not mail customers

Please start the SOP Customer Offer update process and assign back to me.  
Once I receive the automated notification that it has completed loading, 
I will run final checks and provide the counts to Marketing.




7 - Watch for an automated email telling when the process has completed then verify SOP has 
finished updating DWSTAGING1 (feeds are not up to date with no queue)

8 - compare original CST file to what is now in tblCustomerOffer
    note:  There are usually a small number  of customers (50 or less) that end up "missing".  
           These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

9. provide Marketing a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from PJC_AD_ManualPull_Cat352 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_AD_ManualPull_Cat352       
                       
/*
AllCnt	DistinctCount
136723	136723
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_AD_ManualPull_Cat352
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_AD_ManualPull_Cat352
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_AD_ManualPull_Cat352
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35202	35230
35203	11126
35204	2574
35205	3058
35206	8018
35207	8429
35208	4606
35209	9257
35210	4425
35211	2954
35212	12583

35213	12997
35214	12802
352850	8664

FROM CST SCREEN
Total Segments: 14 segments (1 of which is a split)
Total Customers: 137,7123
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_AD_ManualPull_Cat352 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select C.sMailingStatus as MStat,  C.ixCustomer
    from [SMI Reporting].dbo.tblCustomer C
        join  PJC_AD_ManualPull_Cat352 MP on C.ixCustomer = MP.ixCustomer
    where C.sMailingStatus in ('9','8','7') 
    /*
    MStat	ixCustomer
    9	436817
    9	505791
    9	974712
    9	1910659
    9	1562640
    9	870922
    9	1031669
    9	1481843
    9	1735451
    */

    -- REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    select ixCustomer+','+ixSourceCode CustPlusSC
    into PJC_AD_ManualPull_Cat352MOD -- 136,714 v (verify orig count minus new count = qty in Mod table
    from PJC_AD_ManualPull_Cat352
    where ixCustomer NOT in 
               (select  C.ixCustomer
                from [SMI Reporting].dbo.tblCustomer C
                    join  PJC_AD_ManualPull_Cat352 MP on C.ixCustomer = MP.ixCustomer
                where C.sMailingStatus in ('9','8','7'))

select * from PJC_AD_ManualPull_Cat352MOD
                

select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '352%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '352' 

/*
SCode	Description
35202	12M, 5+, $1000+
35203	12M, 5+, $400+
35204	12M, 5+, $100+
35205	12M, 3+, $1000+
35206	12M, 3+, $400+
35207	12M, 3+, $100+
35208	12M, 2+, $400+
35209	12M, 2+, $100+
35210	12M, 2+, $1+
35211	12M, 1+, $400+
35212	12M, 1+, $100+
35213	12M, 1+, $1+
35214	24M, 5+, $1000+
35261	MR. ROADSTER
*/

-- Customers in Offer table for Cat 352 -- tot qty target = 136,723
select count(CO.ixCustomer) Qty --  ~9:52 SOP start time    
                                -- @11:41 71,983 
                                -- @12:04 86,440  628 per/min  eta 13:25      
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '352'  


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_AD_ManualPull_Cat352
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '352'  
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '352'                            
order by SC.ixSourceCode 
/*
SCode	Qty		Description

*/ 

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '352' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from [SMITemp].dbo.PJC_AD_ManualPull_Cat352
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '352' )
--851794, 1159261, 1366138, 1169064, 1195738, 1087515, 81988, 1399515, 570028, 1165658, 1953149, 
--1458650, 322802, 988098, 1256250, 1299767, 1244066, 1715024, 1210122

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_AD_ManualPull_Cat352
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '352' )
                    )

/********************************************
ixCustomer	sMailingStatus	flgDeletedFromSOP

81988		9				0
1399515		9				0
1165658		9				0
988098		9				0
1256250		9				0
1244066		0				1
1458650		0				1
851794		9				0
1159261		9				0
1087515		0				1
1169064		9				0

	1953149		0				0
	570028		0				0
	1299767		0				0
	1210122		0				0
	1715024		0				0 
	322802		0				0
	1366138		0				0
	1195738		0				0
**********************************************/



