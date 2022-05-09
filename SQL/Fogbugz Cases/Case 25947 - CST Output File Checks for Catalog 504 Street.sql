-- Case 25947 - CST Output File Checks for Catalog 504 Street 
  -- previous CST case = 25606

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_25947_CST_OutputFile_504

-- GLOBALLY REPLACE the following:
    /*
        PJC_25947_CST_OutputFile_504
        '504%'
        '504'  
        504
    */  
    
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '504'
-- Catalog 504 = '15 ER SUM SR

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '504%' ORDER BY ixCatalog
-- 94 source codes assigned to ixCatalog 504

SELECT ixSourceCode
     , sDescription 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '504%'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan
/*
ixSourceCode	sDescription
50402A	12M 5+ $1,000+ SR No Offer
50402C	12M 5+ $1,000+ SR $7.99 FR
50402F	12M 5+ $1,000+ SR FREE SHIP
50403A	12M 3+ $150+ SR No Offer
50403C	12M 3+ $150+ SR $7.99 FR
50403F	12M 3+ $150+ SR FREE SHIP
50404A	12M 3+ $1+ SR No Offer
50404C	12M 3+ $1+ SR $7.99 FR
50404F	12M 3+ $1+ SR FREE SHIP
50405A	12M 2+ $150+ SR No Offer
50405C	12M 2+ $150+ SR $7.99 FR
50405F	12M 2+ $150+ SR FREE SHIP
50406A	12M 2+ $1+ SR No Offer
50406C	12M 2+ $1+ SR $7.99 FR
50406F	12M 2+ $1+ SR FREE SHIP
50407A	12M 1+ $150+ SR No Offer
50407C	12M 1+ $150+ SR $7.99 FR
50407F	12M 1+ $150+ SR FREE SHIP
50407G	12M 1+ $1 EBAY SR FREE SHIP
50408A	12M 1+ $1+ SR No Offer
50408C	12M 1+ $1+ SR $7.99 FR
50408F	12M 1+ $1+ SR FREE SHIP
50408G	12M 1+ $1 EBAY SR FREE SHIP
50409A	12M 1+ $1+ 2B No Offer
50409C	12M 1+ $1+ 2B $7.99 FR
50409F	12M 1+ $1+ 2B FREE SHIP
50409G	12M 1+ $1 EBAY 2B FREE SHIP
50410A	12M 2+ $1+ B No Offer
50410C	12M 2+ $1+ B $7.99 FR
50410F	12M 2+ $1+ B FREE SHIP
50411A	12M 1+ $1+ B No Offer
50411C	12M 1+ $1+ B $7.99 FR
50411F	12M 1+ $1+ B FREE SHIP
50411G	12M 1+ $1 EBAY B FREE SHIP
50412A	12M 3+ $1,000+ R No Offer
50412C	12M 3+ $1,000+ R $7.99 FR
50412F	12M 3+ $1,000+ R FREE SHIP
50413A	12M 3+ $150+ R No Offer
50413C	12M 3+ $150+ R $7.99 FR
50413F	12M 3+ $150+ R FREE SHIP
50414A	12M 3+ $1+ R No Offer
50414C	12M 3+ $1+ R $7.99 FR
50414F	12M 3+ $1+ R FREE SHIP
50415A	12M 2+ $150+ R No Offer
50415C	12M 2+ $150+ R $7.99 FR
50415F	12M 2+ $150+ R FREE SHIP
50416A	12M 2+ $1+ R No Offer
50416C	12M 2+ $1+ R $7.99 FR
50416F	12M 2+ $1+ R FREE SHIP
50417A	12M 1+ $150+ R No Offer
50417C	12M 1+ $150+ R $7.99 FR
50417F	12M 1+ $150+ R FREE SHIP
50417G	12M 1+ $150+ EBAY R FREE SHIP
50418A	12M 1+ $1+ R No Offer
50418C	12M 1+ $1+ R $7.99 FR
50418F	12M 1+ $1+ R FREE SHIP
50418G	12M 1+ $1 EBAY R FREE SHIP
50419A	12M 1+ $1+ SM No Offer
50419C	12M 1+ $1+ SM $7.99 FR
50419F	12M 1+ $1+ SM FREE SHIP
50419G	12M 1+ $1 EBAY SM FREE SHIP
50420A	24M 3+ $1,000+ SR No Offer
50420C	24M 3+ $1,000+ SR $7.99 FR
50420F	24M 3+ $1,000+ SR FREE SHIP
50421A	24M 3+ $150+ SR No Offer
50421C	24M 3+ $150+ SR $7.99 FR
50421F	24M 3+ $150+ SR FREE SHIP
50422A	24M 3+ $1+ SR No Offer
50422C	24M 3+ $1+ SR $7.99 FR
50422F	24M 3+ $1+ SR FREE SHIP
50423A	24M 2+ $150+ SR No Offer
50423C	24M 2+ $150+ SR $7.99 FR
50423F	24M 2+ $150+ SR FREE SHIP
50424A	24M 2+ $1+ SR No Offer
50424C	24M 2+ $1+ SR $7.99 FR
50424F	24M 2+ $1+ SR FREE SHIP
50425A	24M 1+ $150+ SR No Offer
50425C	24M 1+ $150+ SR $7.99 FR
50425F	24M 1+ $150+ SR FREE SHIP
50425G	24M 1+ $150+ EBAY SR FREE SHIP
50426A	24 mo 1+ $1+ SR No Offer
50426C	24 mo 1+ $1+ SR $7.99 FR
50426F	24 mo 1+ $1+ SR FREE SHIP
50426G	24M 1+ $1+ EBAY SR FREE SHIP
50427A	24 mo 2+ $1+ B No Offer
50427C	24 mo 2+ $1+ B $7.99 FR
50427F	24 mo 2+ $1+ B FREE SHIP
50428A	24 mo 1+ $1+ B No Offer
50428C	24 mo 1+ $1+ B $7.99 FR
50428F	24 mo 1+ $1+ B FREE SHIP
50428G	24M 1+ $1+ EBAY B FREE SHIP
50430H	Camaros and Classics List
5046	ROD&CUSAPT04
5049	CUSTCLCATNOV03
*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '504%'
  AND ixCatalog = '504'
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- NONE
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '504%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '504'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- 2

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL





/********************** START of QC for CST output file  ********************************/

-- DROP TABLE [SMITemp].dbo.PJC_25947_CST_OutputFile_504

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  
from [SMITemp].dbo.PJC_25947_CST_OutputFile_504 
where LEN(ixSourceCode) <>5
order by LEN(ixSourceCode) desc

50407EB -- <--10 DIF segments with EB appended

/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
         'lookup' as CSTCount
    FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504       
    /*
    All     Distinct            CST
    Count	Count	    Delta   Count
    ======= ========    =====   =======
    297896	297896	    0	    297896 v
    */

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        -- easier to resize and line up codes if you paste this output in Excel
        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode
        
/**************
SCode	Qty 
50402	29959
50403	43267
50404	18825
50405	10837
50406	9937
50407	9607
50407EB	1341
50408	21902
50408EB	4865
50409	1201
50409EB	211
50410	15947
50411	8338
50411EB	1885
50412	817
50413	3006
50414	478
50415	2951
50416	1830
50417	3753
50417EB	521
50418	10802
50418EB	3124
50419	1163
50419EB	302
50420	9005
50421	17893
50422	7453
50423	6834
50424	6392
50425	6431
50425EB	1108
50426	16033
50426EB	4600
50427	7564
50428	5917
50428EB	1797

FROM CST SCREEN:
Count Time: 00:27
Total Segments: 27
 
Total Source Codes: 37
    Included: 37
    Excluded:  0
 
Total Customers: 297,896
    Included:    297,896 v
    Excluded:          0
    */

/**********  check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
	OR --- 
    ixCustomer	ixSourceCode	sMailingStatus
    1771582	50411	9
    2150440	50408	9
    511466	50404	9
    1571972	50426	9
    2381244	50411EB	9
    1736126	50424	9
    197326	50420	9
    1855874	50428EB	9
    175670	50405	9
    1472744	50422	9
    1057386	50402	9


*/

    -- SOP will exclude above people (44 customers) 
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_25947_CST_OutputFile_504
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 28 (28 addt'l incl. the split segments that they appended 'A,C, or F' to) 
    WHERE ixSourceCode LIKE '504%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog

    JUST THE SCs with 5 digits and the additional letter indicating which promo type they're getting

*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '504' 
 --   AND LEN(ixSourceCode) = 5 
 
   /* MISMATCHES! 
	
        -- NONE
	
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.PJC_25947_CST_OutputFile_504
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '504'                              )
   group by  ixSourceCode                             
   /* POTENTIALLY MISSING!!!
   
   This check isn't applicable at this time, most of the "final" source codes will be segments appended by various letters depending on the type of offer
   they will be giving the customer.
 
		
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
BEFORE  487         343      
AFTER   485         345 
*/    
    

-- create file to give to DYlan so he can reassign customers to their FINAL SCs
SELECT CST.*
FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504 CST

/*********************  END of QC for CST output file  ***********************/



/******************************************************************************
****** START of QC for MODIFIED load list provided by Marketing         ******
****** DOING ALL OF THE SAME STEPS AGAIN BUT NOW FOR THE MODIFIED FILE  ******
******************************************************************************/
-- DROP table PJC_25947_CST_OutputFile_504_MOD
-- Dupe check
select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.PJC_25947_CST_OutputFile_504_MOD
    /*
    AllCnt	DistinctCount	Delta	
    297896	297896	        0	
    */
    
    -- if dupes are found    
        select ixCustomer, COUNT(*) from  PJC_25947_CST_OutputFile_504_MOD
        group by ixCustomer
        having COUNT(*) > 1
   
        select * from PJC_25947_CST_OutputFile_504_MOD
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
        order by ixCustomer
   
        -- removing one of each dupe
        set rowcount 1
        Delete 
        from PJC_25947_CST_OutputFile_504_MOD
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
            and ixCustomer in (select ixCustomer from  PJC_25947_CST_OutputFile_504_MOD
                            group by ixCustomer
                            having COUNT(*) > 1)
        set rowcount 0                          
                            
-- verify counts by Source Code match 504 LOL.xls sheet provided by Marketing
Select ixSourceCode, COUNT(ixCustomer) QTY
from [SMITemp].dbo.PJC_25947_CST_OutputFile_504_MOD
group by ixSourceCode
order by ixSourceCode
/*  1st Mod file FAILED
    504 LOL.xls had counts differing in 3 source codes
    After notifying Dylan he made the necessary changes and re-sent the new file. 
    I dropped table PJC_25947_CST_OutputFile_504_MOD, rebuilt it with the new file, and started the QC checks over.
       
all delta's were <2 
*/                     


select * 
from PJC_25947_CST_OutputFile_504_MOD
where ixSourceCode in (', 50303',', 50328',',50372C','161521,50303','322','404')

-- all customers in tblCustomer?
select ixCustomer -- 100% 
from [SMITemp].dbo.PJC_25947_CST_OutputFile_504_MOD
where ixCustomer in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomer)
-- and ixCustomer NOT like '2046946%'                     
                     
    -- delete from PJC_25947_CST_OutputFile_504_MOD
    -- where ixCustomer = '2046946%'


/*********************  END of QC for MODIFIED output file  ***********************/


    
    
/**********  Load Customer Offers into SOP ***********/
    select ixCustomer,',',ixSourceCode 
    from PJC_25947_CST_OutputFile_504_MOD
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files
    -- naming convention like PJC_25947_CST_OutputFile_504_MOD.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #504 = 05/18/15
*/
      
   
/**********     Compare file to Qty loaded into SOP and provide counts to Dylan 
                AFTER the Customer OFFERS have finished loading into SOP 
                AND Offers have been REFED to SMI Reporting                     **********/
 
 
-- Customers in Offer table for Cat 504
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_25947_CST_OutputFile_504_MOD
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '504'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '504' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 


/*
SCode	Description					Qty in CST File	Qty in SOP	Delta
SCode	Description	Qty in CST File	Qty in SOP	Delta
50402A	12M 5+ $1,000+ SR No Offer	9986	9985	-1
50402C	12M 5+ $1,000+ SR $7.99 FR	9986	9984	-2
50402F	12M 5+ $1,000+ SR FREE SHIP	9987	9987	0
50403A	12M 3+ $150+ SR No Offer	14422	14422	0
50403C	12M 3+ $150+ SR $7.99 FR	14422	14421	-1
50403F	12M 3+ $150+ SR FREE SHIP	14423	14420	-3
50404A	12M 3+ $1+ SR No Offer	6275	6274	-1
50404C	12M 3+ $1+ SR $7.99 FR	6275	6275	0
50404F	12M 3+ $1+ SR FREE SHIP	6275	6275	0
50405A	12M 2+ $150+ SR No Offer	3612	3612	0
50405C	12M 2+ $150+ SR $7.99 FR	3612	3612	0
50405F	12M 2+ $150+ SR FREE SHIP	3613	3613	0
50406A	12M 2+ $1+ SR No Offer	3312	3312	0
50406C	12M 2+ $1+ SR $7.99 FR	3312	3312	0
50406F	12M 2+ $1+ SR FREE SHIP	3313	3313	0
50407A	12M 1+ $150+ SR No Offer	3202	3202	0
50407C	12M 1+ $150+ SR $7.99 FR	3202	3202	0
50407F	12M 1+ $150+ SR FREE SHIP	3203	3203	0
50407G	12M 1+ $150 EBAY SR FREE SHIP	1341	1341	0
50408A	12M 1+ $1+ SR No Offer	7300	7300	0
50408C	12M 1+ $1+ SR $7.99 FR	7301	7301	0
50408F	12M 1+ $1+ SR FREE SHIP	7301	7301	0
50408G	12M 1+ $1 EBAY SR FREE SHIP	4865	4865	0
50409A	12M 1+ $1+ 2B No Offer	400	400	0
50409C	12M 1+ $1+ 2B $7.99 FR	400	400	0
50409F	12M 1+ $1+ 2B FREE SHIP	401	401	0
50409G	12M 1+ $1 EBAY 2B FREE SHIP	211	211	0
50410A	12M 2+ $1+ B No Offer	5315	5315	0
50410C	12M 2+ $1+ B $7.99 FR	5316	5316	0
50410F	12M 2+ $1+ B FREE SHIP	5316	5316	0
50411A	12M 1+ $1+ B No Offer	2779	2779	0
50411C	12M 1+ $1+ B $7.99 FR	2780	2780	0
50411F	12M 1+ $1+ B FREE SHIP	2779	2779	0
50411G	12M 1+ $1 EBAY B FREE SHIP	1885	1885	0
50412A	12M 3+ $1,000+ R No Offer	272	272	0
50412C	12M 3+ $1,000+ R $7.99 FR	273	273	0
50412F	12M 3+ $1,000+ R FREE SHIP	272	272	0
50413A	12M 3+ $150+ R No Offer	1002	1002	0
50413C	12M 3+ $150+ R $7.99 FR	1002	1002	0
50413F	12M 3+ $150+ R FREE SHIP	1002	1002	0
50414A	12M 3+ $1+ R No Offer	159	159	0
50414C	12M 3+ $1+ R $7.99 FR	160	160	0
50414F	12M 3+ $1+ R FREE SHIP	159	159	0
50415A	12M 2+ $150+ R No Offer	983	983	0
50415C	12M 2+ $150+ R $7.99 FR	984	984	0
50415F	12M 2+ $150+ R FREE SHIP	984	984	0
50416A	12M 2+ $1+ R No Offer	610	609	-1
50416C	12M 2+ $1+ R $7.99 FR	610	609	-1
50416F	12M 2+ $1+ R FREE SHIP	610	610	0
50417A	12M 1+ $150+ R No Offer	1251	1251	0
50417C	12M 1+ $150+ R $7.99 FR	1251	1251	0
50417F	12M 1+ $150+ R FREE SHIP	1251	1250	-1
50417G	12M 1+ $150+ EBAY R FREE SHIP	521	521	0
50418A	12M 1+ $1+ R No Offer	3601	3601	0
50418C	12M 1+ $1+ R $7.99 FR	3600	3600	0
50418F	12M 1+ $1+ R FREE SHIP	3601	3601	0
50418G	12M 1+ $1 EBAY R FREE SHIP	3124	3124	0
50419A	12M 1+ $1+ SM No Offer	388	388	0
50419C	12M 1+ $1+ SM $7.99 FR	388	388	0
50419F	12M 1+ $1+ SM FREE SHIP	387	387	0
50419G	12M 1+ $1 EBAY SM FREE SHIP	302	302	0
50420A	24M 3+ $1,000+ SR No Offer	3001	3001	0
50420C	24M 3+ $1,000+ SR $7.99 FR	3002	3002	0
50420F	24M 3+ $1,000+ SR FREE SHIP	3002	3002	0
50421A	24M 3+ $150+ SR No Offer	5964	5964	0
50421C	24M 3+ $150+ SR $7.99 FR	5964	5963	-1
50421F	24M 3+ $150+ SR FREE SHIP	5965	5964	-1
50422A	24M 3+ $1+ SR No Offer	2484	2484	0
50422C	24M 3+ $1+ SR $7.99 FR	2484	2484	0
50422F	24M 3+ $1+ SR FREE SHIP	2485	2485	0
50423A	24M 2+ $150+ SR No Offer	2278	2278	0
50423C	24M 2+ $150+ SR $7.99 FR	2278	2277	-1
50423F	24M 2+ $150+ SR FREE SHIP	2278	2278	0
50424A	24M 2+ $1+ SR No Offer	2130	2130	0
50424C	24M 2+ $1+ SR $7.99 FR	2131	2131	0
50424F	24M 2+ $1+ SR FREE SHIP	2131	2131	0
50425A	24M 1+ $150+ SR No Offer	2143	2143	0
50425C	24M 1+ $150+ SR $7.99 FR	2144	2144	0
50425F	24M 1+ $150+ SR FREE SHIP	2144	2144	0
50425G	24M 1+ $150+ EBAY SR FREE SHIP	1108	1108	0
50426A	24 mo 1+ $1+ SR No Offer	5344	5342	-2
50426C	24 mo 1+ $1+ SR $7.99 FR	5345	5345	0
50426F	24 mo 1+ $1+ SR FREE SHIP	5344	5344	0
50426G	24M 1+ $1+ EBAY SR FREE SHIP	4600	4600	0
50427A	24 mo 2+ $1+ B No Offer	2521	2520	-1
50427C	24 mo 2+ $1+ B $7.99 FR	2521	2520	-1
50427F	24 mo 2+ $1+ B FREE SHIP	2522	2522	0
50428A	24 mo 1+ $1+ B No Offer	1972	1972	0
50428C	24 mo 1+ $1+ B $7.99 FR	1972	1972	0
50428F	24 mo 1+ $1+ B FREE SHIP	1973	1973	0
50428G	24M 1+ $1+ EBAY B FREE SHIP	1797	1797	0
50430H	Camaros and Classics List	NULL	0	0
6988	CLASSIC TRUCKS	NULL	0	0
6990	HOT ROD DELUXE	NULL	0	0
6994	CHEVY HIGH PERFORMANCE	NULL	0	0
6995	HEMMINGS MOTOR NEWS	NULL	0	0
6998	HOT ROD	NULL	0	0
6999	STREET RODDER	NULL	0	0
7000	OL' SKOOL RODZ	NULL	0	0
*/


   
/* after verifying the Delta's from above check are acceptable
   enter OK in SOP to start the CUST update routine.
   It is currently VERY slow at about 3 rec/sec and 
   CAN TAKE UP TO 50 HOURS to complete depending on # of records.
*/
    -- kicked off routine 4/16/15 @11:19AM
    
    
    
     -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 262107  -- <-- total amount of customer offers in the CST campaign that's loading
    SELECT 
        CONVERT(VARCHAR, GETDATE(), 8)    AS 'As Of   '
        ,@QtyToLoad 'TotQty'
        ,count(CO.ixCustomer) 'Loaded'
        , (@QtyToLoad-count(CO.ixCustomer)) 'ToGo'
    --   ,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as 'SecRun'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 'Rec/Sec'
       --,CONVERT(DECIMAL(10,0),(CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *60.00) as 'Rec/Min'
        ,CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00)) as 'Rec/Hr'
       ,(@QtyToLoad-count(CO.ixCustomer))/(CONVERT(DECIMAL(10,0),((CONVERT(DECIMAL(10,2),count(CO.ixCustomer))) /(CONVERT(DECIMAL(10,2),T.ixTime) - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) *3600.00))) as 'EstHrsToFinish'
    FROM [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    WHERE SC.ixCatalog = '504'
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */
                
select * from [SMI Reporting].dbo.tblTime where chTime like '09:45%'                
      
      
/*
  
-- kicked off customer offer load routine 02/12/15 1:23PM     .... finished 02/13/15 1:03 PM         
--  262,106 records in file
               
Current                                                         ETA @
Count     Time      Rec Fed Mins    Sec     Rec/Sec     Remaining   Current rate    ETA
======= =======     ======= ====    ======= =======     =========   ============    ===========
      0 13:03 Sat          
 28,600 16:26        28,600 203     12,180  2.3         230,779     27.9 hours      ~8:30PM SUN   
177,400 09:52 Sun   148,800         62,760  2.3          81,979     
259,324 21:18 Sun   259,324 1,935  116,100  2.2   
*/  



/***********    CUST LOADING SPEEDS    ********************************* 
          
    CAT#    RECORDS SECONDS Rec/Sec Date        Day Loaded
    ====    ======= ======= ======= ========    ==========
    353     118,353  36,971     3.2 06-04-13    Tuesday
    366      48,114  17,563     2.7 06-18-13    Tuesday
    364      32,040   1,139    28.1 06-26-13    Friday
    354     330,968  18,118    18.3 07-22-13    Monday
    355     239,006  33,388     7.2 09-11-13    Tuesday
    361     179,997  25,772     7.0 10-02-13    Wednesday
    383      40,649   5,750     7.1 11-05-13    Tuesday
    377     265,994  41,260     6.4 12-06-13    Friday (ran during production hours)
    373     328,438             6.7 01-03-14    Friday - avg speed AFTER the feed issues (group locks) were resolved    
       /********** CLOAK 2.0 launched ***********/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    378     219,574	 21,780	   10.0	01-30-14	Monday (ran during production hours) 
    374     165,820  16,323    10.2 02-13-14    Thursday (11:50AM - 4:20PM) 
    384		 43,703	  3,717	   11.8	02-19-14	Wednesday (ran during production hours)  
    379     100,993            10.3 03-07-14    Thur night & Fri morning (ran in two parts)
    380     237,171             8.2 04-14-14    Tue night & Wed (ran in two parts)
    385      36,572   4,569     8.0 05-20-14    Tue late morning
    381     102,433  12,548     8.2 06-04-14    Wed mid morning
    388     377,093	 46,236		8.1	06-19-14	Thursday (ran during production hours) 
    387		 61,163	 10,368		5.9	06-24-14	Tuesday (ran during production hours) 
    389     405,920  63,000     6.4 07-22-14    Tuesday (kicked off at 11:01 AM, ran straight thru until completed 4:29AM Wed) 
    390     242,902  39,438     6.2 09-04-14    Thursday (kicked off at 11:11 AM) 
    382     177,308  57,600     3.1 09-30-14    Tuesday (kicked off at 9:45 AM)
    391     
    501     381,375 173,220     2.2 12-22-14    
    402     259,379 116,100     2.2 01-11-15    Sat 1:03PM finished Sun 9:18 PM
    600      49,515 
    502     411,369 
    403		262,106  85,200     3.1 02-12-15	Thursday 1:23PM finished Fri 1:03PM
    504     297,896                             Kicked off Thur 4/16/15 @11:19AM
**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_25947_CST_OutputFile_504_MOD CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '504%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_25947_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '504%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_25947_CST_OutputFile_504_MOD CST
 JOIN PJC_25947_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 504 ONLY  ******************************/
none

-- COMPLETE THE REMAINING STEPS 



-- NOTE --  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

-- details on Customers that "failed to load" into tblCustomerOffer
-- most should be recently changed mail status or merged customers that are now flagged as deleted
select ixCustomer 'Cust #'
    , sMailingStatus+'    ' as 'MailingStatus' 
    , flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_25947_CST_OutputFile_504_MOD
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '504' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1278330	0    	0
1908620	0    	0
156303	0    	0
778123	0    	0

-- 44 were deleted from SOP

*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer,CST.ixSourceCode --ixCustomer
            from PJC_25947_CST_OutputFile_504_MOD3 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '504%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            
            SELECT COUNT(*) Qty, C.sMailingStatus 'Status', C.flgDeletedFromSOP
            from [SMI Reporting].dbo.tblCustomer C
            where ixCustomer in ('2479247','1171745','375007','1721188','1918731','1722407','1325038','397326','1483369','1669856','1406935','2466243','846897','2061843','2187345','1569083','1569984','1653083','1640621','2000649','2437040','1123686','2399942','2882732','2411147','1059338','1782119','1224338','1648121','190251')
            group by C.flgDeletedFromSOP, C.sMailingStatus
            /*
                Qty	Status	flgDeletedFromSOP
                3	NULL	1
                5	0	    0
                22	0	    1
                */                
      