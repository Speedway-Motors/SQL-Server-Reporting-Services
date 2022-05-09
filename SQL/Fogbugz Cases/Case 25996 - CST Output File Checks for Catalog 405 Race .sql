-- Case 25996 - CST Output File Checks for Catalog 405 Race 
  -- previous CST case = 25947

/*******************************************************************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into a table in SMITEMP -- e.g. PJC_25996_CST_OutputFile_405

-- GLOBALLY REPLACE the following:
    /*
        PJC_25996_CST_OutputFile_405
        '405%'
        '405'  
        405
    */  
    
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '405'
-- Catalog 405 = '15 ER SUM SR

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '405%' ORDER BY ixCatalog
-- 94 source codes assigned to ixCatalog 405

SELECT ixSourceCode
     , sDescription 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '405%'
ORDER BY ixSourceCode  -- all source codes are loaded and match the descriptions provided by Dylan
/*
ixSourceCode	sDescription

CAN'T VERIFY... THEY WEREN'T BUILT YET.
*/

-- POTENTIALLY invalid SCs in tblSourceCode based on # of chars
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '405%'
  AND ixCatalog = '405'
  AND (LEN(ixSourceCode) < 5
        OR LEN(ixSourceCode) > 6)
-- CAN'T VERIFY... THEY WEREN'T BUILT YET.
  
-- SC's with identical descriptions  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '405%'
  AND LEN(ixSourceCode) >= 5
    AND ixCatalog = '405'  
GROUP BY   sDescription
HAVING COUNT(*) > 1
-- CAN'T VERIFY... THEY WEREN'T BUILT YET.

    --if results from above
      SELECT * FROM [SMI Reporting].dbo.tblSourceCode 
      WHERE sDescription = '12M 1+ $1 EBAY SR FREE SHIP'
      -- NONE





/********************** START of QC for CST output file  ********************************/

-- DROP TABLE [SMITemp].dbo.PJC_25996_CST_OutputFile_405

-- quick review to verify data formatted correctly
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  
from [SMITemp].dbo.PJC_25996_CST_OutputFile_405 
where LEN(ixSourceCode) <>5
order by LEN(ixSourceCode) desc

40507EB -- <--14 DIF segments with EB appended

/*********** check for DUPE CUSTOMERS   ***********/
    select COUNT(*) AS 'AllCnt' 
         , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
         ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
         'lookup' as CSTCount
    FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405       
    /*
    All     Distinct            CST
    Count	Count	    Delta   Count
    ======= ========    =====   =======
    301892	301892	    0	    301892 v
    */

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        -- easier to resize and line up codes if you paste this output in Excel
        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode
        
/**************
SCode	Qty 
40502	18431
40503	33802
40504	31268
40505	5562
40506	8720
40507	4714
40507EB	540
40508	14722
40508EB	3264
40509	667
40509EB	57
40510	2178
40510EB	370
40511	2786
40512	15230
40513	571
40513EB	88
40514	8328
40514EB	1864
40515	9218
40516	1019
40517	6468
40518	3864
40519	8330
40519EB	1375
40520	18907
40520EB	4920
40521	3955
40522	11272
40523	12494
40524	3077
40525	5405
40526	2796
40526EB	432
40527	10058
40527EB	3170
40528	1424
40528EB	336
40529	1196
40530	7844
40531	332
40531EB	63
40532	5768
40532EB	1734
40533	4360
40534	598
40535	3930
40536	2502
40537	5428
40537EB	1091
40570	3348
40571	2016

FROM CST SCREEN:
Count Time: 00:32
Total Segments: 38
 
Total Source Codes: 52
    Included: 52
    Excluded:  0
 
Total Customers: 301,892
    Included:    301,892 v
    Excluded:          0
    */

/**********  check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
	OR --- 
    ixCustomer	ixSourceCode	sMailingStatus
    1641860	    40532	9
    2038240	    40514EB	9
    1781489	    40520	9
    1835870	    40525	9
    1781672	    40524	9
    1691577 	40525	9


*/

    -- SOP will exclude above people (6 customers) 
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_25996_CST_OutputFile_405
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 28 (28 addt'l incl. the split segments that they appended 'A,C, or F' to) 
    WHERE ixSourceCode LIKE '405%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog

    -- CAN'T VERIFY... THEY WEREN'T BUILT YET.

*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '405' 
 --   AND LEN(ixSourceCode) = 5 
 
   /* MISMATCHES! 
	
        -- CAN'T VERIFY... THEY WEREN'T BUILT YET.
	
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.PJC_25996_CST_OutputFile_405
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '405'                              )
   group by  ixSourceCode                             
   /* POTENTIALLY MISSING!!!
   
   -- CAN'T VERIFY... THEY WEREN'T BUILT YET.
 
		
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
BEFORE  485         345      
AFTER   485         345 
*/    
    

-- create file to give to DYlan so he can reassign customers to their FINAL SCs
SELECT CST.*
FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405 CST

/*********************  END of QC for CST output file  ***********************/



/******************************************************************************
****** START of QC for MODIFIED load list provided by Marketing         ******
****** DOING ALL OF THE SAME STEPS AGAIN BUT NOW FOR THE MODIFIED FILE  ******
******************************************************************************/
-- DROP table [SMITemp].dbo.PJC_25996_CST_OutputFile_405_MOD
-- Dupe check
select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount',
     ABS( COUNT(*) - COUNT(DISTINCT ixCustomer)) AS Delta, -- should ALWAYS be 0
     'lookup' as CSTCount
FROM [SMITemp].dbo.PJC_25996_CST_OutputFile_405_MOD
    /*
    AllCnt	DistinctCount	Delta	
    301892	301892	        0	
    */
    
    -- if dupes are found    
        select ixCustomer, COUNT(*) from  PJC_25996_CST_OutputFile_405_MOD
        group by ixCustomer
        having COUNT(*) > 1
   
        select * from PJC_25996_CST_OutputFile_405_MOD
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
        order by ixCustomer
   
        -- removing one of each dupe
        set rowcount 1
        Delete 
        from PJC_25996_CST_OutputFile_405_MOD
        where ixCustomer in ('415846','415838','415933','415943','415859','415840','415927','415920','415875','415893','415837','415913','415895','415894')
            and ixCustomer in (select ixCustomer from  PJC_25996_CST_OutputFile_405_MOD
                            group by ixCustomer
                            having COUNT(*) > 1)
        set rowcount 0                          
                            
-- verify counts by Source Code match 405 LOL.xls sheet provided by Marketing
Select ixSourceCode, COUNT(ixCustomer) QTY
from [SMITemp].dbo.PJC_25996_CST_OutputFile_405_MOD
                   PJC_25947_CST_OutputFile_504_MOD
group by ixSourceCode
order by ixSourceCode
/*  1st Mod file FAILED
    405 LOL.xls had counts differing in 4 source codes
    
    SC	    Expected Actual	Delta
    40503A	11,267	 11,308	-41
    40503F	11,268	 11,227	41
    40522A	3,757	 4,758 	-1,001
    40522F	3,758	 2,757 	1,001       
all other delta's were <2 

    After notifying Dylan he made the necessary changes and re-sent the new file. 
    I dropped table PJC_25996_CST_OutputFile_405_MOD, rebuilt it with the new file, and started the QC checks over.
*/                     


select * 
from PJC_25996_CST_OutputFile_405_MOD
where ixSourceCode in (', 50303',', 50328',',50372C','161521,50303','322','404')

-- all customers in tblCustomer?
select ixCustomer -- 100% 
from [SMITemp].dbo.PJC_25996_CST_OutputFile_405_MOD
where ixCustomer in (select ixCustomer 
                     from [SMI Reporting].dbo.tblCustomer)
-- and ixCustomer NOT like '2046946%'                     
                     
    -- delete from PJC_25996_CST_OutputFile_405_MOD
    -- where ixCustomer = '2046946%'

/***********************************************************************************
***********************  END of QC for MODIFIED output file  ***********************
************************************************************************************/

    
    
/**********  Load Customer Offers into SOP ***********/
    select ixCustomer,',',ixSourceCode 
    from [SMITemp].dbo.PJC_25996_CST_OutputFile_405_MOD
    order by ixSourceCode
    -- save output to .txt file in \\cloak\QOPDL\CST Customer Offer Files
    -- naming convention like PJC_25996_CST_OutputFile_405_MOD.txt
   
 /*    
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #405 = 06/08/15
*/
      
   
/**********     Compare file to Qty loaded into SOP and provide counts to Dylan 
                AFTER the Customer OFFERS have finished loading into SOP 
                AND Offers have been REFED to SMI Reporting                     **********/
 
 
-- Customers in Offer table for Cat 405
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from [SMITemp].dbo.PJC_25996_CST_OutputFile_405_MOD
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '405'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '405' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 


/*
SCode	Description					Qty in CST File	Qty in SOP	Delta
SCode	Description	Qty in CST File	Qty in SOP	Delta

*/


   
/* after verifying the Delta's from above check are acceptable
   enter OK in SOP to start the CUST update routine.
   It is currently VERY slow at about 3 rec/sec and 
   CAN TAKE UP TO 50 HOURS to complete depending on # of records.
*/
    -- kicked off routine 4/24/15 @1:25PM
    
    
    
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
    WHERE SC.ixCatalog = '405'
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
    403		262,106  85,200     3.1 02-12-15	Thur  1:23PM fin Fri 1:03PM
    504     297,896 103,680     2.9 4/16/15     Thur 11:19AM fin Fri 4:07PM
    405     301,892 103,800     2.9 4/24/15     Fri 1:25PM   fin Sat 6:15 PM                 ETA 30 hours
**********************************************************************************/

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_25996_CST_OutputFile_405_MOD CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '405%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_25996_CST_404_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '405%' AND len(CO.ixSourceCode) = 5
 
 
 SELECT * FROM PJC_25996_CST_OutputFile_405_MOD CST
 JOIN PJC_25996_CST_404_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
                    

/*************   SPECIAL NOTES FOR CAT 405 ONLY  ******************************/
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
                    from PJC_25996_CST_OutputFile_405_MOD
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '405' )
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
            from PJC_25996_CST_OutputFile_405_MOD3 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from   [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '405%'
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
      