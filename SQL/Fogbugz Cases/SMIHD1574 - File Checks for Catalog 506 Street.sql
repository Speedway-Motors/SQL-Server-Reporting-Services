--  SMIHD1574 - File Checks for Catalog 506 Street
  -- previous CST case = SMIHD1122

PJC_SMIHD1574_CustomerFile_506
/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_SMIHD1574_CustomerFile_506

-- GLOBALLY REPLACE the following:
    /*
        PJC_SMIHD1574_CustomerFile_506
        '506%'
        '506'  
        506
    */  
    
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '506'
/*
ixCatalog	sDescription	sMarket	dtStartDate	dtEndDate	iQuantityPrinted
506	'15     MID SUM SR	SR	17403	17791	2015-08-24 00:00:00.000	2016-09-15 00:00:00.000	334000
*/

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixCatalog = '506' -- ixSourceCode LIKE '506%' 
ORDER BY ixCatalog
-- 24 source codes assigned to ixCatalog 506
/*
Source
Code	sDescription
50602	12M SREV42 $12+
50603	12M SREV42 $9-11.99
50604	12M SREV42 $4-8.99
50605	12M SREV42 $0-3.99
50606	24M SREV42 $12+
50607	24M SREV42 $9-11.99
50608	24M SREV42 $4-8.99
50609	24M SREV42 $0-3.99
50610C	36M SREV42 $12+ Offer
50611C	36M SREV42 $9-11.99 Offer
50612C	36M SREV42 $4-8.99 Offer
50613C	36M SREV42 $0-3.99 Offer
50620	12M, 5+ $1,000 CST
50621	12M, 3+ $150 CST
50622	12M, 3+ $1 CST
50623	12M, 2+ $150 CST
50624	12M, 2+ $1 CST
50625	12M, 1+ $150 CST
50626	12M, 1+ $1 CST
50627	24M, 3+ $1000
50628	24M, 3+ $150
50692	Counter
50698	DHL
50699	Request in Package

*/


SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '506%'
and ixCatalog <> '506'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan
/*
ixSourceCode	sDescription
5064	NPICUSTLIST
5064F	DO NOT USE
5067	WHEELGGODTRAD
5069	SPRINTCARMAR04
*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '506%'
  AND ixCatalog = '506'
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- NONE
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '506%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '506'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- NONE

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- DYLAN CORRECTED THE 2 THAT WERE IDENTICAL

-- BEFORE CHANGES
Select ixSourceCode, COUNT(*) Qty
from PJC_SMIHD1574_CustomerFile_506
group by ixSourceCode
order by ixSourceCode
/*
ixSourceCode	Qty
50602	74574
50603	16140
50604	47409
50605	45763
50606	6264
50607	4746
50608	26770
50609	37649
50610C	1097
50611C	940
50612C	5926
50613C	10207
50620	9
50621	234
50622	319
50623	340
50624	898
50625	877
50626	3178
50627	13
50628	134
*/


/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta -- should ALWAYS be 0
    FROM [SMITemp].dbo.PJC_SMIHD1574_CustomerFile_506  
    /*
    AllCnt	DistinctCount	Delta
    280922	280922	0
    */    
    

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_SMIHD1574_CustomerFile_506
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD1574_CustomerFile_506
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE


    
/**** REMOVE OPT-OUTS for Campaign Market *******/

select top 10 * from [SMI Reporting].dbo.tblMailingOptIn

    SELECT *
    -- DELETE
    FROM PJC_SMIHD1574_CustomerFile_506 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblMailingOptIn MOI
                         where MOI.ixMarket = 'SR' -- Street
                            and MOI.sOptInStatus = 'N')



/**********  REMOVE customers flagged as competitor,deceased, or "do not mail" ***********/
 
    -- competitor,deceased, or "do not mail" status                            
    SELECT * -- 31
    -- DELETE
    FROM PJC_SMIHD1574_CustomerFile_506 
    WHERE ixCustomer IN (SELECT ixCustomer
                         FROM [SMI Reporting].dbo.tblCustomer C
                         where C.sMailingStatus in ('9','8','7'))
                                       

     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_SMIHD1574_CustomerFile_506 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
                                
    select count(CF.ixCustomer) CustCount,
    count(distinct(CF.ixCustomer)) DistCustCnt
    from PJC_SMIHD1574_CustomerFile_506 CF
    /*
    CustCount	DistCustCnt
    280922	    280922
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
BEFORE  475         354
AFTER   475         354 
*/    


/********** Provied counts by SC from the modified table to Dylan *******************/
Select ixSourceCode, COUNT(*) QtyToLoadIntoSOP
from PJC_SMIHD1574_CustomerFile_506
group by ixSourceCode
order by ixSourceCode


    
    
/**********  Load Customer Offers into SOP ***********/
    select ixCustomer,',',ixSourceCode 
    from PJC_SMIHD1574_CustomerFile_506
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files naming convention e.g. PJC_SMIHD1574_CustomerFile_506_MOD q.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow screen instructions. DOUBLE-CHECK the Customer in-home date. (Marketing must provide if it's in the ticket already) 

    In-home date for Catalog #506 = 07/20/15
    
When they are done loading DO NOT ENTER "OK" YET to "consolodate your lists"
open a new instance of SOP and MANUALLY refeed all of todays offers to DW. (ETA 43 rec/sec)

Compare Qty in SOP to the file.  If delta's are acceptable...
NOTIFY AL that you are about to load a customer file and give him an
ETA (# of records/2.1)/3600 hours) on when it should finish.

THEN 
    enter OK on you 1st SOP connection to begin the CUST record update
**********/
 
 
-- Customers in Offer table for Cat 506
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty to load into SOP',
    SOP.Qty as 'Qty LOADED in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_SMIHD1574_CustomerFile_506
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '506'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '506' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 


/*
                                    Qty to      Qty
                                    load        LOADED
SCode	Description	                into SOP	in SOP	Delta
50602	12M SREV42 $12+	            73700	    73697	-3
50603	12M SREV42 $9-11.99	        15955	    15954	-1
50604	12M SREV42 $4-8.99	        46984	    46979	-5
50605	12M SREV42 $0-3.99	        45537	    45535	-2
50606	24M SREV42 $12+	            6239	    6238	-1
50607	24M SREV42 $9-11.99	        4727	    4727	0
50608	24M SREV42 $4-8.99	        26640	    26636	-4
50609	24M SREV42 $0-3.99	        37279	    37278	-1
50610C	36M SREV42 $12+ Offer	    1092	    1092	0
50611C	36M SREV42 $9-11.99 Offer	929	        929	    0
50612C	36M SREV42 $4-8.99 Offer	5880	    5880	0
50613C	36M SREV42 $0-3.99 Offer	9928	    9927	-1
50620	12M, 5+ $1,000 CST	        9	        9	    0
50621	12M, 3+ $150 CST	        234	        234	    0
50622	12M, 3+ $1 CST	            319	        319	    0
50623	12M, 2+ $150 CST	        340	        340	    0
50624	12M, 2+ $1 CST	            898	        898	    0
50625	12M, 1+ $150 CST	        877	        876	    -1
50626	12M, 1+ $1 CST	            3177	    3177	0
50627	24M, 3+ $1000	            13	        13	    0
50628	24M, 3+ $150	            134	        134 	0
50692	Counter	                    NULL	    0	    0
50698	DHL	                        NULL	    0	    0
50699	Request in Package	        NULL	    0	    0

*/


   
/* after verifying the Delta's from above check are acceptable
   enter OK in SOP to start the CUST update routine.
   It is currently VERY slow at about 3 rec/sec and 
   CAN TAKE UP TO 50 HOURS to complete depending on # of records.
*/
    -- kicked off routine 7/21/15 @6:00PM (approx)      ETA 7:15 pm 7/22/15
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
    WHERE SC.ixCatalog = '506'
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
    700      60,082                             
    506     280,922                             kicked off routine TUE 7/21/15 @6:00PM (approx)
**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_SMIHD1574_CustomerFile_506 CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '506%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_SMIHD1574_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '506%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_SMIHD1574_CustomerFile_506 CST
 JOIN PJC_SMIHD1574_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 506 ONLY  ******************************/
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
                    from PJC_SMIHD1574_CustomerFile_506_MOD
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '506' )
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
            from PJC_SMIHD1574_CustomerFile_506 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '506%'
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
      