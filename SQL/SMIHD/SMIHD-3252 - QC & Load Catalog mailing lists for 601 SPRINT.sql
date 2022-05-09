--  SMIHD-3252 - QC & Load Catalog mailing lists for 601 SPRINT
  -- previous CST case = SMIHD-3137

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD3252_CustFile_601

-- GLOBALLY REPLACE the following:
    /*
        PJC_SMIHD3252_CustFile_601
        PJC_SMIHD3252_CustOffers_601    
        '601%'
        '601'  
        601
    */  
    
/***********  Update deceased exempt list   **********/
-- execute the following 2 queries BEFORE & AFTER running 
-- the <9> Update deceased exempt list in SOP's Reporting Menu 
    SELECT COUNT(*) 'Deceased'
    FROM [SMI Reporting].dbo.tblCustomer    
    WHERE sMailingStatus = '8' AND flgDeletedFromSOP = 0 --472
    
    SELECT COUNT(*) 'DeceasedExempt'
    FROM [SMI Reporting].dbo.tblCustomer 
    WHERE flgDeceasedMailingStatusExempt = 1
      AND flgDeletedFromSOP = 0  
/*                  Deceased
When    Deceased    Exempt      
======  =======     ======           
BEFORE  467         359
AFTER   467         359
*/    


SELECT ixCatalog 'Cat#',sDescription 'Description',sMarket 'Mkt',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate',
    iQuantityPrinted 'QtyPrinted'
FROM [SMI Reporting].dbo.tblCatalogMaster 
WHERE ixCatalog = '601'
/*
Cat#	Description	    Mkt	StartDate	EndDate	    QtyPrinted
601	    '16 SPRG SPRINT SM	05/25/2015	02/28/2017	0
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixCatalog = '601' -- ixSourceCode LIKE '601%' -- 12 at 8 PM
ORDER BY ixCatalog
-- 24 source codes assigned to ixCatalog 507
/*
Source
Code	sDescription
60100E	SHOW AND EVENT
60102	LOYALISTS SMEV42
60103	NURTURERS SMEV42
60104	1&2XBUYERS SMEV42
60105	UNDERPERFORM SMEV42
60106	WINBACKS SMEV42
60107	FADERS SMEV42
60108	CST 12M POOL
60109	CST 24M POOL
60110	CST 36M POOL
60111	CST 48M+ POOL
60160	PRO RACER DEALERS
60170	12M REQUESTORS
60192	COUNTER
60199	REQUEST IN PACKAGE

*/

-- check for Source codes with similar prefix to current catalog
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '601%'
and ixCatalog <> '601'
ORDER BY ixSourceCode  -- 
/*
ixSource
Code	sDescription

none

*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '601%'
  AND ixCatalog = '601'
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- none
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '601%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '601'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- none

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL

-- BEFORE CHANGES
Select ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD3252_CustFile_601
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	Qty
60102	17062
60103	1408
60104	4629
60105	3438
60107	328
60108	14882
60109	5556
60110	3200
60111	1181
60170	817
*/
-- DROP TABLE PJC_SMIHD3252_CustFile_601

/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD3252_CustFile_601  
    /*      Distinct
    AllCnt	Count	Delta
   52500	52500	0
    */    
    

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD3252_CustFile_601
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD3252_CustFile_601
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn


    SELECT *
    -- DELETE -- 0 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD3252_CustFile_601 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'SM' -- Street             <-- BE SURE TO CHANGE TO CURRENT CATALOG MARKET!!!!!
                         /* 2B	TBucket
                            AD	AFCO/Dynatech
                            R	Race
                            SM	SprintMidget
                            SR	StreetRod */
                               and MOI.sOptInStatus = 'N')

/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * 
    -- DELETE -- 1 customer removed
    FROM [SMITemp].dbo.PJC_SMIHD3252_CustFile_601 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD3252_CustFile_601 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                                
    select count(CF.ixCustomer) CustCount,
    count(distinct(CF.ixCustomer)) DistCustCnt
    from [SMITemp].dbo.PJC_SMIHD3252_CustFile_601 CF
    /*
    CustCount	DistCustCnt
    52500	52500  
    */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD3252_CustFile_601
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
60102	17061
60103	1408
60104	4629
60105	3438
60107	328
60108	14882
60109	5556
60110	3200
60111	1181
60170	817

*/



-- no spreadsheet was provided so I visually compared quantities the the screenshot of counts that Alaina sent.


/**********  Load Customer Offers into SOP AFTER ***********
    Customer offers may be loaded AFTER
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Alaina provided expected counts already and the delta on her list vs the counts to load is < 1%
*/             
    select ixCustomer,',',ixSourceCode 
    from [SMITemp].dbo.PJC_SMIHD3252_CustFile_601
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD3252_CustOffers_601.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load
    
    takes approx 5 mins for 300K records to load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's in the ticket already) 

    In-home date for Catalog #407 = 02/15/16
    
When they are done loading DO NOT ENTER "OK" YET to "consolodate your lists"
open a new instance of SOP and MANUALLY refeed all of todays offers to DW. (ETA 43 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to load a customer file and give him an
ETA (# of records/2.1)/3600 hours) on when it should finish.

THEN 
    enter OK on you 1st SOP connection to begin the CUST record update

kicked off at 8:05 finished at 8:28  
**********/
 
 
-- Customers in Offer table for Cat 407
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD3252_CustFile_601
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '601'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '601' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 


/*
                                    Qty to      Qty
                                    load        LOADED
SCode	Description	                into SOP	in SOP	Delta
40702	LOYALISTS REV42	            23867	    23865	-2
40703	NURTURERS REV42	            18533	    18533	0
40704	1&2XBUYERS REV42	        41236   	41233	-3
40705	UNDERPERFORM REV42	        6101	    6100	-1
40706	WINBACKS REV42	            1259    	1259	0
40707	FADERS REV42	            3717	    3717	0
40708	12M CST POOL	            12635   	12634	-1
40709	CST 24M POOL	            16236   	16235	-1
40710	CST 36M POOL	            20452   	20452	0
40711	CST 48M+ POOL	            21226   	21226	0
40712	STR MAIL WITH HIGH REV42	5000    	4997	-3
40712A	RCV R VS COMBO TEST	        1001    	1000	-1
40770	12M REQUESTORS	            6343    	6343	0

*/
   
/* after verifying the Delta's from above check are acceptable
   enter OK in SOP to start the CUST update routine.
   It is currently VERY slow at about 3 rec/sec and 
   CAN TAKE UP TO 50 HOURS to complete depending on # of records.
*/
    -- kicked off routine 9/16/15 @7:45PM (approx)      ETA 7:15 pm 7/22/15
     -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 294552  -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '601'
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */
                
      
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
    364      32,040   1,139    28.1 06-26-13    Friday
    354     330,968  18,118    18.3 07-22-13    Monday
    355     239,006  33,388     7.2 09-11-13    Tuesday
    377     265,994  41,260     6.4 12-06-13    Friday (ran during production hours)
       /********** CLOAK 2.0 launched ***********/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    388     377,093	 46,236		8.1	06-19-14	Thursday (ran during production hours) 
    389     405,920  63,000     6.4 07-22-14    Tuesday (kicked off at 11:01 AM, ran straight thru until completed 4:29AM Wed) 
    390     242,902  39,438     6.2 09-04-14    Thursday (kicked off at 11:11 AM) 
    382     177,308  57,600     3.1 09-30-14    Tuesday (kicked off at 9:45 AM)
    402     259,379 116,100     2.2 01-11-15    Sat 1:03PM finished Sun 9:18 PM
    403		262,106  85,200     3.1 02-12-15	Thursday 1:23PM finished Fri 1:03PM
    504     297,877 103,608     2.9 04-16-15    Kicked off Thur 4/16/15 @11:19AM
    405     301,884 103,800     2.9 04-24-15
    700      60,077  25,656     2.3 05-12-15    
    505     350,364 123,676     2.8 05-31-15    
    506     280,870  98,930     2.8 07-21-15    kicked off routine TUE 7/21/15 @6:00PM (approx)  
    507     294,490 127,894     2.3 09-17-15    kicked off routine WED 9/17/15 @7:145PM  
    406     118,223  44,002     2.7 09-29-15
    508     288,264 101,585     2.8 12-13-15
    407     177,594 
    904      
**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_SMIHD3252_CustFile_601_FINAL CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '601%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_SMIHD1574_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '601%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_SMIHD3252_CustFile_601_FINAL CST
 JOIN PJC_SMIHD1574_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 507 ONLY  ******************************/
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
                    from PJC_SMIHD3252_CustFile_601
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '601' )
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
            from PJC_SMIHD3252_CustFile_601_FINAL CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '601%'
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
                4	0	    0
                23	0	    1    
                */                
      
      
      