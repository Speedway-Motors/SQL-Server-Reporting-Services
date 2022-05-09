--  SMIHD-8088 - QC & Load Catalog mailing lists for 518 Street
  -- previous CST case = SMIHD-7101

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD8088_CustFile_518

-- GLOBALLY REPLACE the following:
    /*SMIHD-8088
        PJC_SMIHD8088_CustFile_518
        PJC_SMIHD8088_CustOffers_518    
        '518%'
        '518'  
        518
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
BEFORE  447         371
AFTER   447         371
*/    


SELECT ixCatalog 'Cat#',sDescription 'Description',sMarket 'Mkt',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'EndDate',
    iQuantityPrinted 'QtyPrinted'
FROM [SMI Reporting].dbo.tblCatalogMaster 
WHERE ixCatalog = '518'
/*
Cat#	Description	    Mkt	StartDate	EndDate	    QtyPrinted
518	    '17 SEPT STREET	SR	08/28/2017	09/11/2018	230,397
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixCatalog = '518' -- ixSourceCode LIKE '518%' -- 12 at 8 PM
ORDER BY ixCatalog, ixSourceCode
-- 11 source codes assigned to ixCatalog 518
/*
Source
Code	sDescription                #of SCs = 27
=====   =========================
51802	LOYALISTS SREV42 CAT MAIL
51802N	LOYALISTS SREV42 NO MAIL
51802P	LOYALISTS SREV42 PC MAIL
51803	NURTURERS SREV42
51804	1&2XBUYERS SREV42
51805	UNDERPERFORMERS SREV42
51806	WINBACKS SREV42
51807	FADERS SREV42
51808	CST 12M POOL NOT IN LB ACTIVES
51860	MR ROADSTER DEALERS
51870	3M REQUESTORS CAT MAIL
51870N	3M REQUESTORS NO MAIL
51870P	3M REQUESTORS PC MAIL
51871	6M REQUESTORS CAT MAIL
51871N	6M REQUESTORS NO MAIL
51871P	6M REQUESTORS PC MAIL
51872	9M REQUESTORS CAT MAIL
51872N	9M REQUESTORS NO MAIL
51872P	9M REQUESTORS PC MAIL
51873	12M REQUESTORS CAT MAIL
51873N	12M REQUESTORS NO MAIL
51873P	12M REQUESTORS PC MAIL
51892	COUNTER
51896	CANADA MAIL GROUP BULK CENTER
51898	MAIL GROUP BULK CENTER
51899	REQUEST IN PACKAGE
518E	SHOW AND EVENT
*/
-- check for Source codes with similar prefix to current catalog
SELECT ixSourceCode
     , sDescription, sCatalogMarket
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '518%'
and ixCatalog <> '518' 
ORDER BY ixSourceCode  -- 
/*
ixSource                sCatalog
Code	sDescription    Market
5181	DRIVEAUG04	    SR
5182	KNOXPROGRA	    R
5183	GOODGUYSHEAR	R
5184	STRRODDERAUG04	SR
5189	RODCUSAD04	    SR


select * from tblMarket
ixMarket	sDescription        #ofMarkets = 16
2B	TBucket
AD	AFCO/Dynatech
B	BothRaceStreet
CR	Canadian Race
CT	Canadian Street
G	Generic
MC	MuscleCar
Other	Other
PC	PedalCar
R	Race
SC	SportCompact
SE	Safety Equipment
SM	SprintMidget
SR	StreetRod
TE	Tools&Equip
UK	Unknown
*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '518%'
  AND ixCatalog = '518' 
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- 518E	SHOW AND EVENT   valid
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '518%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '518'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- none

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '<DUPED DESCRIPTION>'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL


/*******   IMPORT FROM txt file to PJC_SMIHD8088_CustFile_518    **************/

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
Select ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD8088_CustFile_518   
group by  ixSourceCode
order by  ixSourceCode

/*
ixSource
Code	Qty
51802	25604
51802N	25605
51802P	25605
51803	63330
51804	65832
51805	31435
51806	6479
51807	13275
51808	7778
51870	1574
51870N	1575
51870P	1574
51871	1596
51871N	1596
51871P	1597
51872	1544
51872N	1544
51872P	1544
51873	1850
51873N	1850
51873P	1849
*/


/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518  
    /*      Distinct
    AllCnt	Count	Delta
    284636	284636	0
    */    

    -- DUPE Customers found
    select ixCustomer--, count(*) -- 3,266 duplicate customers 
    into [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#### -- temp table for deleting them
    from  [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
    group by ixCustomer
    having count(*) > 1   
    order by count(*) desc

    -- examples
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
    WHERE ixCustomer in ('2665769','2547468','2561661','2681568','2675067','2503764','2566367','2611664','2514664','2587767')
    ORDER BY ixCustomer  

    BEGIN TRAN
        DELETE from [SMITemp].dbo.PJC_SMIHD8088_CustFile_518  -- 3,266
        where ixSourceCode = '51811'
            and ixCustomer in (select ixCustomer from [SMITemp].dbo.PJC_SMIHD5060_DupeCustsToRemoveFrom#####)
    ROLLBACK TRAN                     

    -- Verify dupe remove worked
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518  
    /*
    AllCnt	DistinctCount	Delta

    */
    
    
/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn

-- 
    SELECT *
    -- DELETE -- 27 customers removed
    FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'SR' -- Street             <-- BE SURE TO CHANGE TO CURRENT CATALOG MARKET!!!!!
                         /* 2B	TBucket
                            AD	AFCO/Dynatech
                            MC  Muscle Car
                            R	Race
                            SM	SprintMidget
                            SR	StreetRod */
                               and MOI.sOptInStatus = 'N')
                               
select ixMarket, COUNT(*) from  [SMI Reporting].dbo.tblMailingOptIn
group by   ixMarket                            
/*
ixMarket	
2B	1930399
AD	1930398
MC	1930399
R	1930399
SM	1930399
SR	1930399
*/

/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * 
    -- DELETE -- 97 customer removed
    FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * 
    FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                                
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518  
    /*      Distinct
    AllCnt	Count	    Delta
    284,512	284,512	0
    */                        



/********** Provide counts by SC from the modified table to Alaina unless the Deltas are <1%  *******************/
Select ixSourceCode, COUNT(*) CustQty
from [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	CustQty
51802	25588
51802N	25589
51802P	25583
51803	63295
51804	65815
51805	31420
51806	6479
51807	13272
51808	7778
51870	1574
51870N	1575
51870P	1574
51871	1596
51871N	1596
51871P	1597
51872	1544
51872N	1544
51872P	1544
51873	1850
51873N	1850
51873P	1849
*/

/**********  Load Customer Offers into SOP  ***********
    Customer offers may be loaded AFTER
    A) Alaina confirms the counts by SC look accurate
        OR
    B) Delta of the counts to load vs. Alaina's expected counts file < 1%
*/             
    SELECT ixCustomer,',',ixSourceCode 
    FROM [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
    ORDER BY ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD8088_CustOffers_518.txt
    
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load
    
    takes approx 5 mins for 300K records to load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's not already in the ticket) 

    In-home date for Catalog #518 = 05/30/17
   
-- Customer <O>ffers kicked off 07/12/17 12:02:41  -- finished with 189.5 rec/sec
-- push 284,564 Customer Offer from SOP to SMI Reporting:  kicked off 07/12/17 12:54:31 -- finished in 24 mins for avg speed of 197 rec/sec
       
    
When they are done loading MANUALLY refeed all of todays offers to DW. (speeds range anywhere from 43 to 250 rec/sec) 

Compare Qty in SOP to the file.  If delta's are acceptable, update final counts by SC file.
Attach file to case with comments telling Alaiana that:
QC checks were passed, offers loaded, and that she can finish remaining manual steops.

**********/
 
-- Customers in Offer table for Cat 518
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description          ',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (   -- customers expected to load
                        select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_SMIHD8088_CustFile_518
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (   -- customers actually loaded
                        select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '518' 
                        group by SC.ixSourceCode, SC.sDescription 
                       -- order by SC.ixSourceCode
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '518' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 
/*
                                        Qty to      Qty
                                        load        LOADED
SCode	Description	                    into SOP	in SOP	Delta

*/  

-- DETAILS on customers that did NOT get their customer offers loaded
        select CF.*, 
            C.ixCustomer, C.flgDeletedFromSOP, C.ixCustomerType, C.sCustomerType, C.sMailingStatus
        from [SMITemp].dbo.PJC_SMIHD8088_CustFile_518 CF
        left join tblCustomer C on CF.ixCustomer = C.ixCustomer
where CF.ixCustomer NOT IN ( select distinct CO.ixCustomer
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '518' )
-- 100 customer flagged as deleted FROM SOP in the last 30 days

   
/* 
    run the CUST routine by selecting Customer <U>pdates

ETA (# of records/2.1)/3600 hours) on when it should finish.
kicked off at 8:05 finished at 8:28  

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
    WHERE SC.ixCatalog = '518' 
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  262,107 total offers to load
                latest ETA is 01:44 PM */                

                   

/*************   SPECIAL NOTES FOR CAT 507 ONLY  ******************************/
none

