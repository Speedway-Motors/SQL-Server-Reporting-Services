--  SMIHD-2381 - File Checks for Catalog 406 Race
  -- previous CST case = SMIHD-1574

-- CST output file name = PJC_SMIHD2381_CustomerFile_406_FINAL

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD2381_CustomerFile_406_FINAL

-- GLOBALLY REPLACE the following:
    /*
        PJC_SMIHD2381_CustomerFile_406_FINAL
        '406%'
        '406'  
        406
    */  
    
USE [SMITemp]

SELECT ixCatalog 'Cat#',sDescription 'Description',sMarket 'Mkt',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate',
    iQuantityPrinted 'QtyPrinted'
FROM [SMI Reporting].dbo.tblCatalogMaster 
WHERE ixCatalog = '406'
/*
Cat#	Description 	Mkt	StartDate	EndDate	    QtyPrinted
406	    '15 HOLIDAY RAC	R	10/26/2015	11/16/2016	206000
*/


SELECT ixSourceCode,sDescription FROM [SMI Reporting].dbo.tblSourceCode WHERE ixCatalog = '406' -- ixSourceCode LIKE '406%' 
ORDER BY ixCatalog, ixSourceCode
-- 32 source codes assigned to ixCatalog 406
/*
Source
Code	sDescription
40600E	Show and Event
40602	12M EV42 $12+
40603	12M EV42 $9-11.99
40604	12M EV42 $4-8.99
40605	12M EV42 $0-3.99
40606	24M EV42 $12+
40607	24M EV42 $9-11.99
40608	24M EV42 $4-8.99
40609	24M EV42 $0-3.99
40610A	36M EV42 $12+
40610B	36M EV42 $12+ TEST
40611A	36M EV42 $9-11.99
40611B	36M EV42 $9-11.99 TEST
40612A	36M EV42 $4-8.99
40612B	36M EV42 $4-8.99 TEST
40613A	36M EV42 $0-3.99
40613B	36M EV42 $0-3.99 TEST
40614A	48M EV42 $12+
40614B	48M EV42 $12+ TEST
40615A	48M EV42 $9-11.99
40615B	48M EV42 $9-11.99 TEST
40616A	48M EV42 $4-8.99
40616B	48M EV42 $4-8.99 TEST
40617A	48M EV42 $0-3.99
40617B	48M EV42 $0-3.99 TEST
40650	36M Canadian Customers
40660	PRS Dealers
40670	6M Requestors
40692	COUNTER
40697	Canadian Request in Package
40698	DHL BULK CENTER
40699	Request in Package

*/

-- verify source codes are loaded & match the descriptions provided by Dylan
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '406%'
and ixCatalog <> '406'
ORDER BY ixSourceCode  -- 
/*
ixSourceCode	sDescription
4060	MUSTANGTRADER
4065	STKCARAPR 03
4066	VINTOVAL FEB03
4067	AREAAUTO JAN 03
4068	VICTRYLANE AD03
4069	SPRTMIDG MAR03

*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '406%'
  AND ixCatalog = '406'
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
--  NONE

-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '406%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '406'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- NONE

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- 

-- BEFORE CHANGES
Select ixSourceCode, COUNT(*) Qty
from PJC_SMIHD2381_CustomerFile_406_FINAL
group by ixSourceCode
order by ixSourceCode
/*
ixSourceCode	Qty
40602	30567
40603	6668
40604	12307
40605	11362
40606	1967
40607	2706
40608	7318
40609	14391
40610A	248
40610B	63
40611A	140
40611B	41
40612A	2658
40612B	660
40613A	8862
40613B	2169
40614A	3
40614B	55
40615A	344
40615B	35
40616A	950
40616B	229
40617A	7935
40617B	1902
40650	2611
40670	2982
*/


/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistCnt',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD2381_CustomerFile_406_FINAL  
    /*
    AllCnt	DistCnt	Delta
    119173	119173	0
    */    
    

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD2381_CustomerFile_406_FINAL
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD2381_CustomerFile_406_FINAL
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn

    SELECT *
    -- DELETE
    FROM PJC_SMIHD2381_CustomerFile_406_FINAL 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'R' -- be sure to CHANGE THE MARKET for the current catalg type !!!!
                            and MOI.sOptInStatus = 'N')
    -- 931 Race opt-outs customers removed


/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * -- 3 customers removed
    -- DELETE
    FROM PJC_SMIHD2381_CustomerFile_406_FINAL 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD2381_CustomerFile_406_FINAL 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                                
    select count(CF.ixCustomer) CustCount,
    count(distinct(CF.ixCustomer)) DistCnt,
    ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    from PJC_SMIHD2381_CustomerFile_406_FINAL CF
    /*
    CustCount	DistCnt	Delta
    118239	    118239	0
    */                        

/***********  Update deceased exempt list   **********/

-- execute the following 2 queries BEFORE & AFTER running 
-- the <9> Update deceased exempt list in SOP's Reporting Menu 
    SELECT COUNT(*) 'Deceased'
    FROM [SMI Reporting].dbo.tblCustomer    
    WHERE sMailingStatus = '8' AND flgDeletedFromSOP = 0
    
    SELECT COUNT(*) 'DeceasedExempt'
    FROM [SMI Reporting].dbo.tblCustomer 
    WHERE flgDeceasedMailingStatusExempt = 1
      AND flgDeletedFromSOP = 0  
/*                  Deceased
When    Deceased    Exempt      
======  =======     ======           
BEFORE  473         356
AFTER   473         356 
*/    


/********** Provied counts by SC from the modified table to Dylan *******************/
Select F.ixSourceCode 'SourceCode', 
    SC.sDescription, COUNT(F.ixCustomer) CustQty
from PJC_SMIHD2381_CustomerFile_406_FINAL F
    left join [SMI Reporting].dbo.tblSourceCode SC on F.ixSourceCode = SC.ixSourceCode
group by F.ixSourceCode, SC.sDescription
order by F.ixSourceCode
/*
SourceCode	CustQty	sDescription
40602	    30295	12M EV42 $12+
40603	    6634	12M EV42 $9-11.99
40604	    12252	12M EV42 $4-8.99
40605	    11343	12M EV42 $0-3.99
40606	    1940	24M EV42 $12+
40607	    2691	24M EV42 $9-11.99
40608	    7260	24M EV42 $4-8.99
40609	    14298	24M EV42 $0-3.99
40610A	    243	    36M EV42 $12+
40610B	    60	    36M EV42 $12+ TEST
40611A	    137	    36M EV42 $9-11.99
40611B	    41	    36M EV42 $9-11.99 TEST
40612A	    2633	36M EV42 $4-8.99
40612B	    653	    36M EV42 $4-8.99 TEST
40613A	    8676	36M EV42 $0-3.99
40613B	    2119	36M EV42 $0-3.99 TEST
40614A	    3	    48M EV42 $12+
40614B	    55	    48M EV42 $12+ TEST
40615A	    342	    48M EV42 $9-11.99
40615B	    34	    48M EV42 $9-11.99 TEST
40616A	    943	    48M EV42 $4-8.99
40616B	    229	    48M EV42 $4-8.99 TEST
40617A	    7880	48M EV42 $0-3.99
40617B	    1885	48M EV42 $0-3.99 TEST
40650	    2611	36M Canadian Customers
40670	    2982	6M Requestors
*/


   
    
    
    

 

















/**********  Load Customer Offers into SOP ***********/
    select ixCustomer,',',ixSourceCode 
    from PJC_SMIHD2381_CustomerFile_406_FINAL
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD2381_CustomerFile_406_FINAL_MOD q.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's in the ticket already) 

    In-home date for Catalog #406 = 11/17/15
    
When they are done loading DO NOT ENTER "OK" YET to "consolodate your lists"
open a new instance of SOP and MANUALLY refeed all of todays offers to DW. (ETA 43 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to load a customer file and give him an
ETA (# of records/2.1)/3600 hours) on when it should finish.

THEN 
    enter OK on you 1st SOP connection to begin the CUST record update
**********/
 
 
-- Customers in Offer table for Cat 406
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_SMIHD2381_CustomerFile_406_FINAL
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '406'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '406' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 


/*
                                    Qty to      Qty
                                    load        LOADED
SCode	Description	                into SOP	in SOP	Delta
40600E	Show and Event	NULL	0	0
40602	12M EV42 $12+	30295	30289	-6
40603	12M EV42 $9-11.99	6634	6634	0
40604	12M EV42 $4-8.99	12252	12250	-2
40605	12M EV42 $0-3.99	11343	11343	0
40606	24M EV42 $12+	1940	1940	0
40607	24M EV42 $9-11.99	2691	2691	0
40608	24M EV42 $4-8.99	7260	7258	-2
40609	24M EV42 $0-3.99	14298	14294	-4
40610A	36M EV42 $12+	243	243	0
40610B	36M EV42 $12+ TEST	60	60	0
40611A	36M EV42 $9-11.99	137	137	0
40611B	36M EV42 $9-11.99 TEST	41	41	0
40612A	36M EV42 $4-8.99	2633	2633	0
40612B	36M EV42 $4-8.99 TEST	653	653	0
40613A	36M EV42 $0-3.99	8676	8676	0
40613B	36M EV42 $0-3.99 TEST	2119	2119	0
40614A	48M EV42 $12+	3	3	0
40614B	48M EV42 $12+ TEST	55	55	0
40615A	48M EV42 $9-11.99	342	342	0
40615B	48M EV42 $9-11.99 TEST	34	34	0
40616A	48M EV42 $4-8.99	943	943	0
40616B	48M EV42 $4-8.99 TEST	229	229	0
40617A	48M EV42 $0-3.99	7880	7880	0
40617B	48M EV42 $0-3.99 TEST	1885	1885	0
40650	36M Canadian Customers	2611	2609	-2
40660	PRS Dealers	NULL	0	0
40670	6M Requestors	2982	2982	0
40692	COUNTER	NULL	0	0
40697	Canadian Request in Package	NULL	0	0
40698	DHL BULK CENTER	NULL	0	0
40699	Request in Package	NULL	0	0

*/


   
/* after verifying the Delta's from above check are acceptable
   enter OK in SOP to start the CUST update routine.
   It is currently VERY slow at about 1.8 rec/sec and 
   CAN TAKE UP TO 50 HOURS to complete depending on # of records.
*/


/* kicked off routine Tues 9/29/15 @12:38PM (approx)      ETA 7:00 AN 9/30/15
   118,223 total offers to load
    
Current                                                                             
Count     Time      Rec Fed Mins    Sec     Rec/Sec     Remaining   Current rate    ETA
======= =======     ======= ====    ======= =======     =========   ============    ===========
      0 12:38 Tue    17,400 120      7,200  2.4         100,823                      2:40 AM WED
 35,400 16:38        18,000 120      7,200  2.5          82,823      9.3 hours       1:40 AM WED   
 65,600 19:38        30,200 180     10,800  2.8          52,623      5.2 hours       1:00 AM WED
 
 
 
*/  

/***********    CUST LOADING SPEEDS    ********************************* 
          
    CAT#    RECORDS SECONDS Rec/Sec Date        Day Loaded
    ====    ======= ======= ======= ========    ==========
    364      32,040   1,139    28.1 06-26-13    Friday
    354     330,968  18,118    18.3 07-22-13    Monday
    355     239,006  33,388     7.2 09-11-13    Tuesday
    383      40,649   5,750     7.1 11-05-13    Tuesday
    373     328,438             6.7 01-03-14    Friday - avg speed AFTER the feed issues (group locks) were resolved    
       /********** CLOAK 2.0 launched ***********/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    378     219,574	 21,780	   10.0	01-30-14	Monday (ran during production hours) 
    379     100,993            10.3 03-07-14    Thur night & Fri morning (ran in two parts)
    380     237,171             8.2 04-14-14    Tue night & Wed (ran in two parts)
    381     102,433  12,548     8.2 06-04-14    Wed mid morning
    388     377,093	 46,236		8.1	06-19-14	Thursday (ran during production hours) 
    389     405,920  63,000     6.4 07-22-14    Tuesday (kicked off at 11:01 AM, ran straight thru until completed 4:29AM Wed) 
    390     242,902  39,438     6.2 09-04-14    Thursday (kicked off at 11:11 AM) 
    382     177,308  57,600     3.1 09-30-14    Tuesday (kicked off at 9:45 AM)
    501     381,375 173,220     2.2 12-22-14    
    402     259,379 116,100     2.2 01-11-15    Sat 1:03PM finished Sun 9:18 PM
    600      49,515                 01-15-15
    502     411,369                 01-28-15
    403		262,106  85,200     3.1 02-12-15	Thursday 1:23PM finished Fri 1:03PM
    503     446,246                 03-11-15                    finished Wed 6:59AM
    404     229,483                 03-20-15                    finished Fri 12:01PM
    504     297,877             2.9 04-16-15    Thur 4/16/15 11:19AM finished Fri 4:07PM
    505     301,884                 04-24-15                    finished Sat 6:15PM    
    700      60,082             2.3 05-13-15            
    505     350,364             2.8 05-29-15                    finished Sat 4:11PM
    506     280,922             2.8 07-21-15    kicked off routine TUE 7/21/15 @6:00PM (approx)
    507     294,552             2.3 09-16-15    kicked off routine WED 9/17/15 @7:15PM    
    406     118,223  44,002     2.7 09-29-15    kicked off routine TUE 9/28/15 @12:385PM
**********************************************************************************/

                

/*************   SPECIAL NOTES FOR CAT 406 ONLY  ******************************/
-- NONW



-- COMPLETE THE REMAINING STEPS 
-- NOTE --  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

-- details on Customers that "failed to load" into tblCustomerOffer
--  most should be recently changed mail status or merged customers that are now flagged as deleted and potentialy a dozen or less customers that were locked at the time
select ixCustomer 'Cust #'
    , sMailingStatus+'    ' as 'MailingStatus' 
    , flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_SMIHD2381_CustomerFile_406_FINAL
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '406' )
                    )
                    
                    
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1815317	0    	1
2302154	0    	1
1929473	0    	1
264520	0    	0
897367	0    	0
2170455	0    	1
1390482	0    	1
897896	0    	0
1293773	0    	1
2516246	0    	1
291561	0    	0
1447368	0    	1
1894953	0    	1
1788082	0    	1
775691	0    	1
1641646	0    	1

-- 12 were deleted from SOP

*/

            SELECT COUNT(*) Qty, C.sMailingStatus 'Status', C.flgDeletedFromSOP
            from [SMI Reporting].dbo.tblCustomer C
            where ixCustomer in ('2479247','1171745','375007','1721188','1918731','1722407','1325038','397326','1483369','1669856','1406935','2466243','846897','2061843','2187345','1569083','1569984','1653083','1640621','2000649','2437040','1123686','2399942','2882732','2411147','1059338','1782119','1224338','1648121','190251')
            group by C.flgDeletedFromSOP, C.sMailingStatus
            /*
                Qty	Status	flgDeletedFromSOP
                3	NULL	1
                4	0	    0
                23	0	    1    
                */                
      
      
      