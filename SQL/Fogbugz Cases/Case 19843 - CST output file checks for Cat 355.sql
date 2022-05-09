-- Case 19843 - CST output file checks for Cat 355 

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '355'
-- Catalog 355 = '13 SR EAR FALL

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_19843_CST_OutputFile_355
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 355 CST Modified Output File.txt" and upload it to the case


/******************* QC CHECKLIST  *************************

1 - customer count in original file = 32,047
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP



-- PASTE BELOW (with needed alterations) INTO TICKET and assign to Al
CST output file "47-355.txt" for Catalog 355 has passed the following QC checks.

1 - customer count in original file = 239,006
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

Please load the customer offers into SOP.  Assign this case back to me once the offers start loading and I'll provide final counts to Marketing once it's completed.



verify SOP has finished updating DWSTAGING1 (feeds are not up to date with no queue)

complete the remaining steps

6. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually a small number  of customers (50 or less) that end up "missing".  
            These should just be the customers that have been merged between the time the CST file was created and when it was loaded into SOP.

7. provide Kyle a list of the counts            
***********************************************************/


-- quick review that data looks like correct format
select top 10 * from PJC_19843_CST_OutputFile_355 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_19843_CST_OutputFile_355       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
239006	239006      239006
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_19843_CST_OutputFile_355
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_19843_CST_OutputFile_355
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_19843_CST_OutputFile_355
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
35502	24741
35503	10368
35504	3213
35505	2773
35506	7511
35507	9417
35508	875
35509	3476
35510	9661
35511	6772
35512	16024
35513	26174
35514	6993
35515	4537
35516	1586
35517	1731
35518	6044
35519	12359
35520	11912
35521	3128
35522	2297
35523	9346
35524	58068




FROM CST SCREEN
Count Time: 11:58.54
Total Segments: 23 [count of segments in table = 23]
Total Customers: 239,006 v

*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_19843_CST_OutputFile_355 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_19843_CST_OutputFile_355 
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
        from PJC_19843_CST_OutputFile_355
        where ixCustomer NOT in ('1840751','98839','1363521','1725857','1448401')
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '355%' and len(ixSourceCode) <> 5

-- source code list
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '355' 
    and len(ixSourceCode) >= 5

/*
SCode	Description
35502	12M, 5+, $1000+
35503	12M, 5+, $400+
35504	12M, 5+, $100+
35505	12M, 3+, $1000+
35506	12M, 3+, $400+
35507	12M, 3+, $100+
35508	12M, 2+, $1000+
35509	12M, 2+, $400+
35510	12M, 2+, $100+
35511	12M, 2+, $1+
35512	12M, 1+, $100+
35513	12M, 1+, $1+
35514	24M, 5+, $1000+
35515	24M, 5+, $400+
35516	24M, 5+, $100+
35517	24M, 2+, $1000+
35518	24M, 2+, $400+
35519	24M, 2+, $100+
35520	24M, 1+, $100
35521	36M, 5+, $1000
35522	36M, 5+, $400
35523	12M, 1+, $100 Race & Street
35560	Bill's Friends
35561	Mr. Roadster Dealers
35570	12M REQ.
35592	Counter
35597	Canadian RIP- Bouncebacks
35598	DHL Bulk Center
35599	RIP - Bouncebacks
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




-- COMPLETE THE REMAINING STEOPS AFTER the Customer Offers have been loaded into SOP.


/*****  7. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_19843_CST_OutputFile_355
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '355'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '355'                            
order by SC.ixSourceCode 
-- note!  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

/*

select ixSourceCode, count(*)
from PJC_19843_CST_OutputFile_355
group by ixSourceCode
order by ixSourceCode
/*
SOP Customer Offer Load Times

    select count(CO.ixCustomer) Qty
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
    where SC.ixCatalog = '355'
    -- 63,858  
    

CAT#    RECORDS SECONDS Rec/Sec Date        Day Loaded
====    ======= ======= ======= ========    ==========
353     118,353  36,971     3.2 06-04-13    Tuesday
366      48,114  17,563     2.7 06-18-13    Tuesday
364      32,040   1,139    28.1 06-26-13    Friday
354     330,968  18,118    18.3 07-22-13    Monday
355     239,006  33,388     7.2 09-11-13    Tuesday


1,936 starting records 

speed after one min 484/min
10 mins = 443/min ->   9 hours Tot load time      
65 mins = 413/min -> 
        
 
*/  
SCode	Description	Qty in CST File	Qty in DW-STAGING1	Delta
35502	12M, 5+, $1000+	24741	24740	-1
35503	12M, 5+, $400+	10368	10368	0
35504	12M, 5+, $100+	3213	3213	0
35505	12M, 3+, $1000+	2773	2772	-1
35506	12M, 3+, $400+	7511	7511	0
35507	12M, 3+, $100+	9417	9416	-1
35508	12M, 2+, $1000+	875	875	0
35509	12M, 2+, $400+	3476	3476	0
35510	12M, 2+, $100+	9661	9661	0
35511	12M, 2+, $1+	6772	6772	0
35512	12M, 1+, $100+	16024	16024	0
35513	12M, 1+, $1+	26174	26172	-2
35514	24M, 5+, $1000+	6993	6993	0
35515	24M, 5+, $400+	4537	4536	-1
35516	24M, 5+, $100+	1586	1586	0
35517	24M, 2+, $1000+	1731	1731	0
35518	24M, 2+, $400+	6044	6044	0
35519	24M, 2+, $100+	12359	12359	0
35520	24M, 1+, $100	11912	11907	-5
35521	36M, 5+, $1000	3128	3128	0
35522	36M, 5+, $400	2297	2297	0
35523	12M, 1+, $100 Race & Street	9346	9343	-3
35524	12M REQ.	58068	58059	-9
35560	Bill's Friends	NULL	9	9
35561	Mr. Roadster Dealers	NULL	567	567
35570	12M REQ.	NULL	0	0
35592	Counter	NULL	0	0
35597	Canadian RIP- Bouncebacks	NULL	0	0
35598	DHL Bulk Center	NULL	0	0
35599	RIP - Bouncebacks	NULL	0	0

*/

-- Customers in Offer table for Cat 355
/***** 8. PROVIDE THESE COUNTS TO Dylan/Klye once after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '355' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
35502	24530	12M, 5+, $1000+
35503	10320	12M, 5+, $400+
35504	3210	12M, 5+, $100+


*/ 


-- Customers in output file but NOT in tblCustomerOffer
select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
from PJC_19843_CST_OutputFile_355 CST
               -- Customers in tblCustomerOffer for current catalog
    left join (select CO.ixCustomer
                from [SMI Reporting].dbo.tblCustomerOffer CO 
                where CO.ixSourceCode like '355%'
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
                    select ixCustomer
                    from PJC_19843_CST_OutputFile_355
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '355' )
                    )

/********************************************
Cust	sMailing
  #     Status	flgDeletedFromSOP
1770867	NULL	0
1032401	0	1
730775	0	0
1114027	0	1


**********************************************/

