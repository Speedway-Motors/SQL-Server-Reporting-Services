-- Case 20009 - CST output file checks for Cat 361 

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '361'
-- Catalog 361 = '13 RACE FALL

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file provided by Kyle into table.  
--      Naming convention = <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_19843_CST_OutputFile_361
-- globally replace old table name with new table name

-- if the text file from Kyle needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 361 CST Modified Output File.txt" and upload it to the case


/******************* QC CHECKLIST  *************************

1 - customer count in original file = 180,025
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - found no competitors, deceased, or do not mail customers

if steps 1-5 show no issues, notify Al (put the above results into the case and assign to Al) that the CST output file passed QC checks and ask to be notified once it's finished loading in SOP



-- PASTE BELOW (with needed alterations) INTO TICKET and assign to Al
CST output file "47-361.txt" for Catalog 361 has passed the following QC checks.

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
select top 10 * from PJC_19843_CST_OutputFile_361 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_19843_CST_OutputFile_361       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
180025	180025      239006
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_19843_CST_OutputFile_361
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_19843_CST_OutputFile_361
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_19843_CST_OutputFile_361
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
36102	14220
36103	5562
36104	2357
36105	1809
36106	2703
36107	10370
36108	1672
36109	6230
36110	7162
36111	1028
36112	1571
36113	5762
36114	6069
36115	16129
36116	4347
36117	5201
36118	6220
36119	1115
36120	4436
36121	5720
36122	786
36123	6088
36124	5030
36125	13676
36126	5341
36127	4021
36128	910
36129	3457
36130	4192
36131	6161
36132	3788
36133	6800
36170	10092




FROM CST SCREEN
Count Time: 15:01
Total Segments: 33 [count of segments in table = 23]

Total Source Codes: 33
          Included: 33
          Excluded:  0
          
Total Customers: 180,025 v
       Included: 180,025   
       Excluded:       0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_19843_CST_OutputFile_361 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_19843_CST_OutputFile_361 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then show details...
   
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
        from PJC_19843_CST_OutputFile_361
        where ixCustomer NOT in ('1840751','98839','1363521','1725857','1448401')
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 1
where ixSourceCode like '361%' and len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '361' 
    and len(ixSourceCode) >= 5

/*
SCode	Description
36070	12 Month Requestors
36102	12M, 6+, $1000+
36103	12M, 6+, $400+
36104	12M, 5+, $400+
36105	12M, 3+, $700+
36106	12M, 3+, $400+
36107	12M, 3+, $100+
36108	12M, 2+, $400+
36109	12M, 2+, $100+
36110	12M, 2+, $1+
36111	12M, 1+, $400+
36112	12M, 1+, $250+
36113	12M, 1+, $100+
36114	12M, 1+, $50+
36115	12M, 1+, $1+
36116	24M, 3+, $1000+
36117	24M, 3+, $400+
36118	24M, 3+, $100+
36119	24M, 2+, $400+
36120	24M, 2+, $100+
36121	24M, 2+, $1+
36122	24M, 1+, $400+
36123	24M, 1+, $100
36124	24M, 1+, $50
36125	24M, 1+, $1
36126	36M, 3+, $400
36127	36M, 3+, $100
36128	36M, 2+, $400
36129	36M, 2+, $100
36130	36M, 2+, $1+
36131	36M, 1+, $100+
36132	48M, 3+, $400+
36133	12M, 5+, $1000+ Street
36160	Bill's Friends
36170	12 Month Requestors
36171	PRS Dealers
36192	Counter
36197	Canadian RIP
36198	DHL Bulk Center
36199	RIP - Bouncebacks
*/

/***** 6. Load Customer Offers into SOP ******
Place file to load on Cloak:
-	START - \\cloak
-	navigate to \\cloak\QOPDL\CSTCustomerOfferFiles and paste CST file into the folder

SOP:
                <20> Reporting Menu
                <2> CST Customer offer load

Follow the onscreen instructions. Be sure to 
DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the FB case if its not already there.)

    In home date for Cat#361 = 11/4/13
    
NOTATE the time the Customer Offer load routine starts in SOP:
    
    Offer Load for Cat#361 started at 09:11
*/


--SOP Customer Offer Load Times
    select count(CO.ixCustomer) CustCnt, T.ixTime, T.chTime
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    where SC.ixCatalog = '361'
    group by T.ixTime, T.chTime
/* 180,025 total offers to load

CustCnt	ixTime	chTime      Rec/Min ETA
 31,499	37533	10:25:33    419    4:21PM
 33,679	37843	10:30:43    421
 65,864	42444	11:47:24    419    4:21PM 
108,839	48568	13:29:28    421    4:20PM    
160,875	56119	15:35:19    413 

   

CAT#    RECORDS SECONDS Rec/Sec Date        Day Loaded
====    ======= ======= ======= ========    ==========
353     118,353  36,971     3.2 06-04-13    Tuesday
366      48,114  17,563     2.7 06-18-13    Tuesday
364      32,040   1,139    28.1 06-26-13    Friday
354     330,968  18,118    18.3 07-22-13    Monday
355     239,006  33,388     7.2 09-11-13    Tuesday
361     179,997  25,772     7.0 10-02-13    Wednesday

*/



-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/*****  7. Compare CST file to Qty loaded into SOP and displaying the Delta   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_19843_CST_OutputFile_361
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '361'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '361'                            
order by SC.ixSourceCode 
-- note!  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

/*
SCode	Description	Qty in CST File	Qty in DW-STAGING1	Delta
36070	12 Month Requestors	NULL	0	0 <-- SHOULD NOT BE POINTING TO CAT 361!
36102	12M, 6+, $1000+	14220	14219	-1
36103	12M, 6+, $400+	5562	5562	0
36104	12M, 5+, $400+	2357	2356	-1
36105	12M, 3+, $700+	1809	1808	-1
36106	12M, 3+, $400+	2703	2702	-1
36107	12M, 3+, $100+	10370	10370	0
36108	12M, 2+, $400+	1672	1672	0
36109	12M, 2+, $100+	6230	6229	-1
36110	12M, 2+, $1+	7162	7160	-2
36111	12M, 1+, $400+	1028	1028	0
36112	12M, 1+, $250+	1571	1571	0
36113	12M, 1+, $100+	5762	5762	0
36114	12M, 1+, $50+	6069	6069	0
36115	12M, 1+, $1+	16129	16125	-4
36116	24M, 3+, $1000+	4347	4346	-1
36117	24M, 3+, $400+	5201	5201	0
36118	24M, 3+, $100+	6220	6219	-1
36119	24M, 2+, $400+	1115	1114	-1
36120	24M, 2+, $100+	4436	4436	0
36121	24M, 2+, $1+	5720	5719	-1
36122	24M, 1+, $400+	786	786	0
36123	24M, 1+, $100	6088	6087	-1
36124	24M, 1+, $50	5030	5030	0
36125	24M, 1+, $1	13676	13675	-1
36126	36M, 3+, $400	5341	5341	0
36127	36M, 3+, $100	4021	4021	0
36128	36M, 2+, $400	910	910	0
36129	36M, 2+, $100	3457	3457	0
36130	36M, 2+, $1+	4192	4191	-1
36131	36M, 1+, $100+	6161	6157	-4
36132	48M, 3+, $400+	3788	3787	-1
36133	12M, 5+, $1000+ Street	6800	6799	-1
361548	BLIZZARD BASH	NULL	0	0
36160	Bill's Friends	NULL	0	0
36170	12 Month Requestors	10092	10088	-4
36171	PRS Dealers	NULL	0	0
36175	NOT IN USE	NULL	0	0
36192	Counter	NULL	0	0
36197	Canadian RIP	NULL	0	0
36198	DHL Bulk Center	NULL	0	0
36199	RIP - Bouncebacks	NULL	0	0
*/
  
SELECT * FROM tblSourceCode where ixSourceCode = '36070'

-- Customers in Offer table for Cat 361
/***** 8. PROVIDE THESE COUNTS TO Dylan/Klye once after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '361' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
36102	14219	12M, 6+, $1000+
36103	5562	12M, 6+, $400+
36104	2356	12M, 5+, $400+
36105	1808	12M, 3+, $700+
36106	2702	12M, 3+, $400+
36107	10370	12M, 3+, $100+
36108	1672	12M, 2+, $400+
36109	6229	12M, 2+, $100+
36110	7160	12M, 2+, $1+
36111	1028	12M, 1+, $400+
36112	1571	12M, 1+, $250+
36113	5762	12M, 1+, $100+
36114	6069	12M, 1+, $50+
36115	16125	12M, 1+, $1+
36116	4346	24M, 3+, $1000+
36117	5201	24M, 3+, $400+
36118	6219	24M, 3+, $100+
36119	1114	24M, 2+, $400+
36120	4436	24M, 2+, $100+
36121	5719	24M, 2+, $1+
36122	786	24M, 1+, $400+
36123	6087	24M, 1+, $100
36124	5030	24M, 1+, $50
36125	13675	24M, 1+, $1
36126	5341	36M, 3+, $400
36127	4021	36M, 3+, $100
36128	910	36M, 2+, $400
36129	3457	36M, 2+, $100
36130	4191	36M, 2+, $1+
36131	6157	36M, 1+, $100+
36132	3787	48M, 3+, $400+
36133	6799	12M, 5+, $1000+ Street
361548	0	BLIZZARD BASH
36160	0	Bill's Friends
36170	10088	12 Month Requestors
36171	0	PRS Dealers
36175	0	NOT IN USE
36192	0	Counter
36197	0	Canadian RIP
36198	0	DHL Bulk Center
36199	0	RIP - Bouncebacks
*/ 


-- Customers in output file but NOT in tblCustomerOffer
select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
from PJC_19843_CST_OutputFile_361 CST
               -- Customers in tblCustomerOffer for current catalog
    left join (select CO.ixCustomer
                from [SMI Reporting].dbo.tblCustomerOffer CO 
                where CO.ixSourceCode like '361%'
                and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
where CO.ixCustomer is NULL 
order by  CST.ixSourceCode, CST.ixCustomer              
/*
304959,36102
1104715,36104
1077454,36105
1153867,36105
1362868,36106
1951734,36106
1712831,36109
1240160,36110
1344629,36110
1772039,36110
1318469,36113
1191469,36115
1264162,36115
1270867,36115
1296373,36115
1415165,36115
231903,36116
1730017,36118
991018,36118
1724734,36119
678475,36121
1439856,36122
1959619,36123
1972438,36123
1058156,36125
1661835,36130
1292725,36131
1511239,36131
1540537,36131
1866432,36131
1961901,36132
953353,36133
1018062,36170
1272060,36170
1387761,36170
1925750,36170
1973551,36170
*/

-- details on Customers that "failed to load" into tblCustomerOffer
-- most should be recently changed mail status or merged customers that are now flagged as deleted
select ixCustomer 'Cust #'
    , sMailingStatus+'    ' as 'MailingStatus' 
    , flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_19843_CST_OutputFile_361
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '361' )
                    )

/********************************************
Cust #	Mailing flgDeleted
        Status	FromSOP
1951734	0    	1
991018	0    	0
1730017	0    	0
1077454	0    	0
1344629	0    	0
1866432	0    	0
1973551	0    	1
1439856	NULL	0
1296373	0    	1
1712831	0    	1
231903	0    	0
1191469	0    	0
1240160	0    	0
1270867	0    	1
1415165	0    	0
1972438	0    	0
678475	0    	0
1540537	0    	1
1292725	0    	1
1511239	0    	1
1661835	0    	1
1959619	0    	1
1264162	0    	0
1362868	NULL	0
1772039	0    	1
1018062	0    	1
1153867	NULL	1
1387761	0    	0
1272060	0    	1
1318469	NULL	0
1724734	0    	1
1925750	0    	0
304959	0    	0
953353	0    	1
1058156	0    	1
1104715	0    	1
1961901	0    	0

**********************************************/

