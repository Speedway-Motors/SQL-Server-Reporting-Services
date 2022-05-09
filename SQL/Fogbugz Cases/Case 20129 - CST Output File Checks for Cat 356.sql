-- Case 20129 - CST output file checks for Cat 356

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '356'
-- Catalog 355 = '13 SR LATE FAL

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle/Dylan into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_20129_CST_OutputFile_356
-- globally replace old table name with new table name

-- if the text file from Kyle/Dylan needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 356 CST Modified Output File.txt" and upload it to the case


/******************* QC CHECKLIST  *************************

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) 
that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP
(NOTE--this step can be done by Reporting now by pasting the file into \\cloak\QOPDL\CSTCustomerOfferFiles
       then in SOP choose <20> Reporting Menu then <2> CST Customer offer load 
       following the instructions on screen (double check the in-home date)
   )

-- PASTE BELOW TEXT (with needed alterations) INTO TICKET and assign to Al

CST output file "59-356.txt" for Catalog 356 has passed the following QC checks.

1 - customer count in original file = 265,689
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

Please load the customer offers into SOP.  Assign this case back to me once the offers start loading and I'll provide final counts to Marketing once it's completed.


THEN, after Al notifies you offers have loaded OR you do it yourself and get the automated email from SOP -- 
verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created 
            and when it was loaded into SOP.

7. provide Kyle/Dylan a list of the counts            
***********************************************************/


-- quick review that data looks like correct format
select top 10 * from ASC_20129_CST_OutputFile_356 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from ASC_20129_CST_OutputFile_356       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
265689	265689      265689
*/

/****** 3. Invalid Customer Numbers ******/

select * from ASC_20129_CST_OutputFile_356
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from ASC_20129_CST_OutputFile_356
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from ASC_20129_CST_OutputFile_356
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35602	24839
35603	10475
35604	3243
35605	2815
35606	7523
35607	9387
35608	876
35609	3487
35610	9744
35611	6755
35612	15998
35613	26204
35614	7210
35615	4554
35616	1627
35617	1747
35618	6118
35619	12494
35620	12042
35621	3193
35622	2276
35623	838
35624	5124
35625	5501
35670	54505
35671	27114




FROM CST SCREEN
Count Time: 14:02
Total Segments: 26 [count of segments in table = 26]
Total Customers: 265,689 v

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from ASC_20129_CST_OutputFile_356 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from ASC_20129_CST_OutputFile_356 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then manually exclude them in the query below...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1315266')
            
            ixCustomer	sMailingStatus
            1315266	    9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for ebay buyers, afco purchasers, etc)REMOVING ABOVE CUSTOMERS and sending the remaining customers to Al in a modified output file
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_20129_CST_OutputFile_356
        where ixCustomer NOT in ('1840751','98839','1363521','1725857','1448401')
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '356%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '356' 
    and len(ixSourceCode) >= 5

/*
SCode	Description
35602	12M, 5+, $1000+
35603	12M, 5+, $400+
35604	12M, 5+, $100+
35605	12M, 3+, $1000+
35606	12M, 3+, $400+
35607	12M, 3+, $100+
35608	12M, 2+, $1000+
35609	12M, 2+, $400+
35610	12M, 2+, $100+
35611	12M, 2+, $1+
35612	12M, 1+, $100+
35613	12M, 1+, $1+
35614	24M, 5+, $1000+
35615	24M, 5+, $400+
35616	24M, 5+, $100+
35617	24M, 2+, $1000+
35618	24M, 2+, $400+
35619	24M, 2+, $100+
35620	24M, 1+, $100
35621	36M, 5+, $1000
35622	36M, 5+, $400
35623	36M, 5+, $100
35624	36M, 2+, $400
35625	48M, 3+, $400
35630	Mr. Roadster Dealers
35660	Bill's Friends
35670	12M REQ.
35671	18M REQ.
35692	Counter
35698	DHL Bulk Center
35699	RIP - Bouncebacks
*/

/***** 6. Load Customer Offers into SOP ******
Place file to load on Cloak:
-	START - \\cloak
-	navigate to \\cloak\QOPDL\CSTCustomerOfferFiles and past CST file into the folder

SOP:
                <20> Reporting Menu
                <2> CST Customer offer load
follow the onscreen instructions - DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the FB case if its not already there.)
*/




-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.


/*****  7. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from ASC_20129_CST_OutputFile_356
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '356'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '356'                            
order by SC.ixSourceCode 
-- note!  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

/*

select ixSourceCode, count(*)
from ASC_20129_CST_OutputFile_356
group by ixSourceCode
order by ixSourceCode
/*
SOP Customer Offer Load Times

    select count(CO.ixCustomer) Qty
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
    where SC.ixCatalog = '356'
    -- 258,468
    

CAT#    RECORDS SECONDS Rec/Sec Date        Day Loaded
====    ======= ======= ======= ========    ==========
353     118,353  36,971     3.2 06-04-13    Tuesday
366      48,114  17,563     2.7 06-18-13    Tuesday
364      32,040   1,139    28.1 06-26-13    Friday
354     330,968  18,118    18.3 07-22-13    Monday
355     239,006  33,388     7.2 09-11-13    Tuesday
356     265,689	 38,524		6.9	10-15-13    Tuesday



 
*/  
SCode	Description			Qty in CST File	Qty in DW-STAGING1	Delta
35602	12M, 5+, $1000+		24839			24837				-2
35603	12M, 5+, $400+		10475			10475				0
35604	12M, 5+, $100+		3243			3243				0
35605	12M, 3+, $1000+		2815			2813				-2
35606	12M, 3+, $400+		7523			7523				0
35607	12M, 3+, $100+		9387			9387				0
35608	12M, 2+, $1000+		876				875					-1
35609	12M, 2+, $400+		3487			3487				0
35610	12M, 2+, $100+		9744			9744				0
35611	12M, 2+, $1+		6755			6755				0
35612	12M, 1+, $100+		15998			15997				-1
35613	12M, 1+, $1+		26204			26203				-1
35614	24M, 5+, $1000+		7210			7210				0
35615	24M, 5+, $400+		4554			4554				0
35616	24M, 5+, $100+		1627			1627				0
35617	24M, 2+, $1000+		1747			1747				0
35618	24M, 2+, $400+		6118			6118				0
35619	24M, 2+, $100+		12494			12494				0
35620	24M, 1+, $100		12042			12041				-1
35621	36M, 5+, $1000		3193			3193				0
35622	36M, 5+, $400		2276			2276				0
35623	36M, 5+, $100		838				838					0
35624	36M, 2+, $400		5124			5124				0
35625	48M, 3+, $400		5501			5501				0
35630	Mr. Roadster		NULL			0					0
35660	Bill's Friends		NULL			0					0
35670	12M REQ.			54505			54503				-2
35671	18M REQ.			27114			27113				-1
35692	Counter				NULL			0					0
35698	DHL Bulk Center		NULL			0					0
35699	RIP - Bouncebacks	NULL			0					0

*/

-- Customers in Offer table for Cat 356
/***** 8. PROVIDE THESE COUNTS TO Dylan/Kyle once after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '356' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
35602	24837	12M, 5+, $1000+
35603	10475	12M, 5+, $400+
35604	3243	12M, 5+, $100+
35605	2813	12M, 3+, $1000+
35606	7523	12M, 3+, $400+
35607	9387	12M, 3+, $100+
35608	875		12M, 2+, $1000+
35609	3487	12M, 2+, $400+
35610	9744	12M, 2+, $100+
35611	6755	12M, 2+, $1+
35612	15997	12M, 1+, $100+
35613	26203	12M, 1+, $1+
35614	7210	24M, 5+, $1000+
35615	4554	24M, 5+, $400+
35616	1627	24M, 5+, $100+
35617	1747	24M, 2+, $1000+
35618	6118	24M, 2+, $400+
35619	12494	24M, 2+, $100+
35620	12041	24M, 1+, $100
35621	3193	36M, 5+, $1000
35622	2276	36M, 5+, $400
35623	838		36M, 5+, $100
35624	5124	36M, 2+, $400
35625	5501	48M, 3+, $400
35630	0		Mr. Roadster Dealers
35660	0		Bill's Friends
35670	54503	12M REQ.
35671	27113	18M REQ.
35692	0		Counter
35698	0		DHL Bulk Center
35699	0		RIP - Bouncebacks

*/ 


-- Customers in output file but NOT in tblCustomerOffer
select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
from ASC_20129_CST_OutputFile_356 CST
               -- Customers in tblCustomerOffer for current catalog
    left join (select CO.ixCustomer
                from [SMI Reporting].dbo.tblCustomerOffer CO 
                where CO.ixSourceCode like '356%'
                and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
where CO.ixCustomer is NULL 
order by  CST.ixSourceCode, CST.ixCustomer              
/*

*/

-- details on Customers that "failed to load" into tblCustomerOffer
-- most should be recently changed mail status or merged customers that are now flagged as deleted
select ixCustomer, sMailingStatus, flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select CST.ixCustomer--+','+CST.ixSourceCode --ixCustomer
from ASC_20129_CST_OutputFile_356 CST
               -- Customers in tblCustomerOffer for current catalog
    left join (select CO.ixCustomer
                from [SMI Reporting].dbo.tblCustomerOffer CO 
                where CO.ixSourceCode like '356%'
                and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
where CO.ixCustomer is NULL 
                    )

/********************************************
Cust	sMailing
  #     Status	flgDeletedFromSOP
1225177	0		0
1830660	0		1
1286268	NULL	1
1058978	0		1
1143065	0		1
1137204	0		0
1650163	0		1
1845063	0		1
1572950	0		1
442250	0		1
1697156	NULL	1
1335973	NULL	0
200709	0		0
1999623	0		0


**********************************************/

