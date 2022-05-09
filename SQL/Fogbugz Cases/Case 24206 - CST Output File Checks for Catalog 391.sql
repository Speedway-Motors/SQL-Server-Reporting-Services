-- Case 24206 - CST Output File Checks for Catalog 391
  -- previous CST case = 24044
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '391'
-- Catalog 391 = '14 Street Late Fall 

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '391%'

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '391%'
  AND LEN(ixSourceCode) >= 5
-- all matched
  

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. ASC_24206_CST_OutputFile_391
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 391 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "98-391.txt" for Catalog 391 has passed the following QC checks.

1 - customer count in original CST file = 293,416
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - SOP will filter out any customers recently flagged as competitor, deceased, or do not mail


complete remaining steps:

6. Update deceased/exempt counts

7. Load Customer Offers:
    in SOP under <20>Reporting Menu, run 
                    <2>CST Customer offer load 
    follow directions and make sure to enter the EXACT in-home date and file names

You will receive a notification email when SOP finishes the customer offer loads. Complete the following steps:

8. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually around 10-40 customers that end up "missing" 
            These should just be customers that have been merged since the CST finalization
            and a handful of customers who's files were locked at the time customer offers were loading.

9. send Dylan and CC Philip a list of the final counts of offers loaded by sourcecode through the case.
******************************************************************************************************************/
-- quick review to verify data formatted correctly
SELECT TOP 10 * FROM [SMITemp].dbo.ASC_24206_CST_OutputFile_391 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode from [SMITemp].dbo.ASC_24206_CST_OutputFile_391
where len(ixSourceCode) <> 5

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM ASC_24206_CST_OutputFile_391       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
293,416	293,416     293,416
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM ASC_24206_CST_OutputFile_391
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM ASC_24206_CST_OutputFile_391
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM ASC_24206_CST_OutputFile_391
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty 42


FROM CST SCREEN:
Count Time: 28:57
Total Segments: 38
 
Total Source Codes: 42
    Included: 42
    Excluded:  0
 
Total Customers: 293,416
    Included:    293,416 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM ASC_24206_CST_OutputFile_391 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM ASC_24206_CST_OutputFile_391 CST
         JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    WHERE CST.ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer WHERE sMailingStatus IN ('9','8','7'))
    ORDER BY sMailingStatus
/*
	-- NONE
    ixCustomer	ixSourceCode	sMailingStatus

    
*/

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from ASC_24206_CST_OutputFile_391
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 8 
    WHERE ixSourceCode LIKE '391%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog
    3910	209
    3911	209
    3912	209
    3913	209
    3914	209
    3915	209
    3916	209
    3919	209
*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '391' 
   --   AND LEN(ixSourceCode) = 5 
      
   /* MISMATCHES! 
	Source Code = ####
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.ASC_24206_CST_OutputFile_391
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '391'                              )
   group by  ixSourceCode      
   -- NONE                        
   /* MISSING!!!
   ixSourceCode	Qty

    */


-- Quick count of customer offers that have loaded 

 SELECT COUNT(DISTINCT CST.ixCustomer) 
 FROM ASC_24206_CST_OutputFile_391 CST 
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '391%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NOT NULL -- 43,701 @ 3:52P 10/14
								 -- 144,895 @ 8:51A 10/15
								 -- 164,410 final count of current offers loaded @ 9:02A 10/15 
								 -- 293, 381 final count of offers after 2nd load @ 10:36A 10/16
 
-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM ASC_24206_CST_OutputFile_391 CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '391%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 into ASC_24206_CST_391_PulledSoFar2
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '391%' AND len(CO.ixSourceCode) = 5
 
 
-- 164417
 
 SELECT * FROM ASC_24206_CST_OutputFile_391 CST
 JOIN ASC_24206_CST_391_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
 
 
 SELECT * 
 --INTO ASC_24206_CST_391_OffersToReload2
 FROM ASC_24206_CST_OutputFile_391 CST 
 WHERE ixCustomer NOT IN (SELECT ixCustomer FROM ASC_24206_CST_391_PulledSoFar2) -- 35 CUSTOMERS --- all NOT FOUND IN SOP 
 
 SELECT * 
 FROM ASC_24206_CST_391_OffersToReload
         
/*********** 6. Update deceased exempt list   **********/

-- execute the following 2 queries ON STAGING beofre and after running the update 
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
BEFORE  407         327      v
AFTER   407         327
*/    
    
 -- Run <9> Update deceased exempt list in SOP's Reporting Menu    

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #391 = 11/17/14
    -- kicked off routine @09:02AM
*/

     -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 293416  -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '391'
        AND CO.dtDateLastSOPUpdate = '09/30/2014' 
        AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  293,416  total offers to load
                latest ETA is 08:45 PM */
                
select * from [SMI Reporting].dbo.tblTime where chTime like '09:45%'                
      
      
/*
As Of   	TotQty	Loaded	ToGo	Rec/Sec	            Rec/Hr  EstHrsToFinish  QueryRunTime        ETA	    

*/  



/***********    CUSTOMER OFFER LOADING SPEEDS    ********************************* 
          
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
       !!!  CONSIDER SCRIPTING THE INDEXES ON tblCustomerOffer then:
                1) backup the table to SMITemp
                2) DROP the indexes
                3) feed Customer Offer file
                4) REBUILD the indexes
            
**********************************************************************************/
                   

/*************   SPECIAL NOTES FOR CAT 391 ONLY  ******************************

 This catalog was initially kicked off on the SOP side at 2A on 10/14 by PJC
 using a new process where no data feeds to Staging until we manually push
 the data over. It was already loading VERY slow in SOP (2.98 records/sec)
 when Connie at PSG kicked off another HUGE customer feed of 300K records. 
 Our process was cancelled before midnight. I uploaded all processed offers
 to Staging then made a new file of offers that still needed to be loaded 
 and kicked that off around 9:02A on 10/15. Offers initially were still under 
 3 records/sec but towards the end of the day had increased to almost 4 records/sec
 and finished loading all just before 8:45P on 10/15. 
 
*******************             END             ***************************/ 

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan & Philip AFTER the      **********
 **********     Customer Offers have finished loading into SOP  **********/

-- Customers in Offer table for Cat 391
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from ASC_24206_CST_OutputFile_391
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '391'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '391' or ixCatalog is NULL)
  and (ISNULL(SC.ixSourceCode, CST.ixSourceCode) NOT IN ('21','CA01','CT59','CT61','HP03','STS59'))                           
order by SC.ixSourceCode 

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
                    from ASC_24206_CST_OutputFile_391
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '391' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
1498737	0    	1
273813	0    	1
775338	0    	1
1706507	0    	1
1794865	0    	1
1798157	0    	0
1941437	0    	1
882600	0    	1
1176488	NULL	1
1291553	0    	1
1517555	0    	1
1088361	0    	1
696085	0    	1
1763459	0    	1
463856	0    	1
474384	0    	1
1236542	0    	1
1797805	0    	1
165079	0    	1
694913	0    	1
1917472	0    	1
360245	0    	1
1229926	0    	1
1488267	0    	1
1722480	NULL	1
1692748	0    	1
2900837	0    	1
1164316	0    	1
1566227	0    	1
1742977	0    	1
1863761	0    	1
1060691	0    	1
1231018	0    	1
1241260	0    	1
1778073	0    	1
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from ASC_24206_CST_OutputFile_391 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from  [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '391%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
				165079,39102
				1797805,39102
				1692748,39103
				1517555,39105
				1798157,39105
				775338,39105
				1941437,39108
				360245,39109
				1488267,39111
				1236542,39112
				1241260,39113
				1176488,39114
				1742977,39114
				1706507,39116
				1722480,39118
				1763459,39118
				1778073,39118
				1863761,39118
				1917472,39118
				273813,39118
				474384,39120
				694913,39121
				1088361,39123
				1291553,39123
				696085,39125
				1794865,39126
				1060691,39127
				1164316,39127
				1498737,39131
				1229926,39132
				1566227,39132
				463856,39135
				882600,39138
				1231018,39140
				2900837,39143
	        */



SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) LIKE '%SOURCECODE%' )
ORDER BY name
