-- Case 18250 - CST output file checks for Cat 368

-- Catalog 368 = 

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_AD_ManualPull_Cat368
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 368 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************

1 - customer count in file = 53,569 [modified file with DO NOT MAIL removed]
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers [modified file]

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP

verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/



-- quick review that data looks like correct format
select top 10 * from PJC_AD_ManualPull_Cat368 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_AD_ManualPull_Cat368       
                       
/*
AllCnt	DistinctCount
53569	53569
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_AD_ManualPull_Cat368
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_AD_ManualPull_Cat368
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. check that file counts by segment = segment counts in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_AD_ManualPull_Cat368
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
36802	13216
36803	2117
36804	3039
36805	1123
36806	3070
36807	1212
36830	18801
36831	8133
36840	12544
36841	7445

FROM CST SCREEN
Total Segments: 21 segments
Total Customers: 53,569

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_AD_ManualPull_Cat368 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_AD_ManualPull_Cat368 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
   /*if any customers are returned then manually exclude them in the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ( <LIST HERE> )

            ixCustomer	sMailingStatus

            			
    */

    -- REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    select ixCustomer+','+ixSourceCode
    from PJC_AD_ManualPull_Cat368
    where ixCustomer NOT in ( <LIST HERE> )

select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '368%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '368' 

/*
SCode	Description
36802	12M, 5+, $1000+
36803	12M, 5+, $1+
36804	12M, 2+, $1+
36805	12M, 1+, $1+
36806	24M, 5+, $1+
36807	36M, 5+, $1+
36830	12M, 5+, $1000+ Race
36831	12M, 5+, $200+ Race
36840	12M, 5+, $1000+ Open Wheel
36841	12M, 5+, $200+ Open Wheel
36861	PRS DEALERS
36862	MR. ROADSTER DEALERS
36892	Counter
36899	RIP - Bouncebacks
*/

-- Customers in Offer table for Cat 368 
select count(CO.ixCustomer) Qty -- 10,900 @2:54
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '368'  


-- THE REMAINING STEPS ARE COMPLETED AFTER AL LOADS THE CUSTOMER FILE INTO SOP

/*****  6. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/

select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty loaded into SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_AD_ManualPull_Cat368
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '368'  
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '368'                            
order by SC.ixSourceCode 
/*
SCode	Qty		Description

*/ 

/***** 7. PROVIDE THESE COUNTS TO KYLE once Al finishes SOP loads *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) Qty, SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '368' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

-- Customers in output file but NOT in tblCustomerOffer
select ixCustomer
from [SMITemp].dbo.PJC_AD_ManualPull_Cat368
except (select CO.ixCustomer
        from [SMI Reporting].dbo.tblSourceCode SC 
            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        where 
        SC.ixCatalog = '368' )
--851794, 1159261, 1366138, 1169064, 1195738, 1087515, 81988, 1399515, 570028, 1165658, 1953149, 
--1458650, 322802, 988098, 1256250, 1299767, 1244066, 1715024, 1210122

-- details on Customers that "failed to load" into tblCustomerOffer
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_AD_ManualPull_Cat368
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '368' )
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



