--  SMIHD-4950 - QC & Load Catalog mailing lists for 801 Muscle

    -- previous catalog mailing case = SMIHD-4641

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD4950_CustFile_801

-- GLOBALLY REPLACE the following:
    /*
        PJC_SMIHD4950_CustFile_801
        PJC_SMIHD4950_CustOffers_801    
        '801%'
        '801'  
        801
    */  
    
/***********  Update deceased exempt list   **********/
-- execute the following 2 queries BEFORE & AFTER running 
-- the <10> Update deceased exempt list in SOP's Reporting Menu 
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
BEFORE  461         362
AFTER   461         362
*/    


SELECT ixCatalog 'Cat#',sDescription 'Description',sMarket 'Mkt',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate',
    iQuantityPrinted 'QtyPrinted'
FROM [SMI Reporting].dbo.tblCatalogMaster 
WHERE ixCatalog = '801'
/*
Cat#	Description	    Mkt	StartDate	EndDate	    QtyPrinted
-- can't verify, wasn't built yet
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixCatalog = '801' -- ixSourceCode LIKE '801%' -- 12 at 8 PM
ORDER BY ixCatalog, ixSourceCode
-- 35 source codes assigned to ixCatalog 801
/*
Source
Code	sDescription
80100E	SHOW AND EVENT
80102	12M RECENCY NO OFFER
80102A	12M RECENCY +OFFER
80103A	24M+ C&C SKU PURCHASE +OFFER
80150	VENDOR BUYERS
80180A	TEN RENTAL LIST +OFFER
80192	COUNTER
80198	DHL BULK CENTER
80199	REQUEST IN PACKAGE
*/
-- check for Source codes with similar prefix to current catalog
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '801%'
and ixCatalog <> '801' 
ORDER BY ixSourceCode  -- 
/*
ixSource
Code	sDescription
801O3A	INACTIVE/NOT IN USE


select * from tblMarket

*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '801%'
  AND ixCatalog = '801' 
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- none
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '801%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '801'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- none

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD4950_CustFile_801
-- BEFORE CHANGES
Select ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD4950_CustFile_801 -- verify counts match provided LOL list
group by ixSourceCode
order by ixSourceCode
       
/*
ixSource
Code	Qty
80102	93748
80102A	140626
80103A	292
*/
-- DROP TABLE PJC_SMIHD4950_CustFile_801

/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD4950_CustFile_801  
    /*      Distinct
    AllCnt	Count	Delta
   234,666	234,666	0
    */    
    

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD4950_CustFile_801
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD4950_CustFile_801
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn

-- Opt-out counts
SELECT ixMarket, count(*) OptOuts
FROM [SMI Reporting].dbo.tblMailingOptIn
WHERE sOptInStatus = 'N'
GROUP BY ixMarket
ORDER BY ixMarket
        /*
        Mkt	OptOuts
        2B	20,750
        AD	16,800
        MC	    40
        R	18,908
        SM	24,871
        SR	 5,978
        */


    SELECT *
    -- DELETE -- 19 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD4950_CustFile_801 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'MC' -- Muscle             <-- BE SURE TO CHANGE TO CURRENT CATALOG MARKET!!!!!
                         /* 2B	TBucket
                            AD	AFCO/Dynatech
                            R	Race
                            SM	SprintMidget
                            SR	StreetRod */
                               and MOI.sOptInStatus = 'N')
                               

/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * 
    -- DELETE -- 26 customer removed
    FROM [SMITemp].dbo.PJC_SMIHD4950_CustFile_801 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD4950_CustFile_801 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                    
    -- Post clean-up Cust counts                                
    select count(CF.ixCustomer) 'CustCnt',
        count(distinct(CF.ixCustomer)) 'DistCustCnt',
        ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS 'Delta' -- should ALWAYS be 0
    from [SMITemp].dbo.PJC_SMIHD4950_CustFile_801 CF
    /*      Dist
    CustCnt	CustCnt	Delta
    234,647	234,647	    0
    */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD4950_CustFile_801
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
80102	93743
80102A	140612
80103A	292
*/

/**********  Load Customer Offers into SOP AFTER ***********
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Alaina provided expected counts by SC and the delta on her list vs the counts to load is < 1%
*/             
    select ixCustomer,',',ixSourceCode 
    from [SMITemp].dbo.PJC_SMIHD4950_CustFile_801
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD4950_CustOffers_801.txt
    
 /*    
SOP: Reporting Menu
    <3> CST Customer offer load
        <O>ffers - then follow screen instructions.  
        DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's not already in the ticket) 
        In-home date for Catalog #801 = 08/29/16
            
            approx 7 mins/100K records to load into SOP (234K took 16 mins)

        MANUALLY refeed all of todays offers to DW. 
        <2> Reporting Feeds Menu
            <10> Customer Offers
                <D>ate (enter today's date, assuming all of the above steps were completed today)
                -- started  11:08:27           first 10 mins processed first 27K records
                   finished 11:29:40                 11 mins to process remaining 207K records!?!
                            ========
                    tot sec 1,273/234,637 = 184 rec/sec   (speeds range anywhere from 43 to 250 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to run the CUST Update routine and give him an ETA on when it should finish (# of records/2.1)/3600 hours)
**********/

-- Customers in Offer table for Cat 801
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (   -- customers expected to load
                        select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD4950_CustFile_801
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (   -- customers actually loaded
                        select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '801' 
                        group by SC.ixSourceCode, SC.sDescription 
                       -- order by SC.ixSourceCode
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '801' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
                                    Qty to      Qty
                                    load        LOADED
SCode	Description	                into SOP	in SOP	Delta
80100E	SHOW AND EVENT	NULL	0	0
80102	12M RECENCY NO OFFER	93743	93740	-3
80102A	12M RECENCY +OFFER	140612	140605	-7
80103A	24M+ C&C SKU PURCHASE +OFFER	292	292	0
80150	VENDOR BUYERS	NULL	0	0
80180A	TEN RENTAL LIST +OFFER	NULL	0	0
80192	COUNTER	NULL	0	0
80198	DHL BULK CENTER	NULL	0	0
80199	REQUEST IN PACKAGE	NULL	0	0
*/

-- DETAILS on customers that did NOT get their customer offers loaded
SELECT CF.*, 
    C.ixCustomer, C.flgDeletedFromSOP, C.ixCustomerType, C.sCustomerType, C.sMailingStatus
FROM [SMITemp].dbo.PJC_SMIHD4950_CustFile_801 CF
    left join tblCustomer C on CF.ixCustomer = C.ixCustomer
WHERE CF.ixCustomer NOT IN (select distinct CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where SC.ixCatalog = '801' 
                            )
                
                        
                                                

   
/* CUST update routine
    after verifying the Delta's from above check are acceptable,
    
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
    WHERE SC.ixCatalog = '801' 
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */                
      
/*
  
-- kicked off customer offer load routine 05/31/16 3:16PM     .... finished 
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
    506     280,870  98,930     2.8 07-21-15    kicked off routine TUE 7/21/15 @6:00PM (approx)  
    507     294,490 127,894     2.3 09-17-15    kicked off routine WED 9/17/15 @7:145PM  
    406     118,223  44,002     2.7 09-29-15
    508     288,264 101,585     2.8 12-13-15

**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_SMIHD4950_CustFile_801_FINAL CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '801%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_SMIHD1574_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '801%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_SMIHD4950_CustFile_801_FINAL CST
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
                    from [SMITemp].dbo.PJC_SMIHD4950_CustFile_801
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '801' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1278330	0    	0


-- 44 were deleted from SOP

*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer,CST.ixSourceCode --ixCustomer
            from [SMITemp].dbo.PJC_SMIHD4950_CustFile_801 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '801%'
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
      
      
      select * from tblCustomerOffer 
      where ixSourceCode like '801%'
      and dtDateLastSOPUpdate = '05/31/2016'
      
      