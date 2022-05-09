-- Case 24872 - CST Output File Checks for Catalog 501 
  -- previous CST case = 24044
USE [SMITemp]

SELECT * FROM [SMI Reporting].dbo.tblCatalogMaster WHERE ixCatalog = '501'
-- Catalog 501 = '15 WINTER SR

SELECT * FROM [SMI Reporting].dbo.tblSourceCode WHERE ixSourceCode LIKE '501%'

-- To check descriptions against data in CST 
SELECT ixSourceCode
     , sDescription
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '501%'
  AND LEN(ixSourceCode) >= 5
-- all matched
  
  
SELECT sDescription, COUNT(*) 'SCs' 
FROM [SMI Reporting].dbo.tblSourceCode 
WHERE ixSourceCode LIKE '501%'
  AND LEN(ixSourceCode) >= 5  
GROUP BY   sDescription
HAVING COUNT(*) > 1

/*************************************************** START  ****************************************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_24872_CST_OutputFile_501
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 501 CST Modified Output File.txt" and upload it to the case

/********************************** QC CHECKLIST  **************************************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "94-501.txt" for Catalog 501 has passed the following QC checks.

1 - customer count in original CST file = 61,163
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
SELECT TOP 20 * FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501 ORDER BY newid()

-- check to make sure there is no SC with invalid length
SELECT distinct ixSourceCode, LEN(ixSourceCode)  from [SMITemp].dbo.PJC_24872_CST_OutputFile_501
order by LEN(ixSourceCode) desc

/*********** 1.& 2. check for DUPE CUSTOMERS ***********/

select COUNT(*) AS 'AllCnt' 
     , COUNT(DISTINCT ixCustomer) AS 'DistinctCount' 
FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
381,375	381,375     381,375 v       
*/

/*********** 3. Invalid Customer Numbers ***********/

    SELECT * FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501
    WHERE ixCustomer NOT IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblCustomer)
    -- NONE

        -- Cust number too short or contains chars
    SELECT * FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501
    WHERE LEN(ixCustomer) < 5
       OR ISNUMERIC(ixCustomer) = 0
    -- NONE

/*********** 4. Verify file total counts & counts by segment = what's in CST ***********/

        SELECT ixSourceCode AS SCode
             , COUNT(*) AS Qty
        FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501
        GROUP BY ixSourceCode
        ORDER BY ixSourceCode

/**************
SCode	Qty 45
50102	28869
50103	41709
50104	17850
50105	10393
50106	9294
50107	10399
50108	25660
50109	1294
50110	24861

50111	7091
50112	18944
50113	27320
50114	7805
50115	6839
50116	6699
50117	7634
50118	20958
50119	1159
50120	15506

50121	15421
50122	5424
50123	5117
50124	5778
50125	1580
50150	6060
50170	34628
50171	9479
50172	7604

FROM CST SCREEN:
Count Time: 00:41  <-- yeah that's right... 41 freaking SECONDS!
Total Segments: 28
 
Total Source Codes: 28
    Included: 28
    Excluded:  0
 
Total Customers: 381,375
    Included:    381,375 v
    Excluded:         0
    */

/********** 5. check for customers flagged as competitor,deceased, or "do not mail" ***********/
    
     -- known competitors
    SELECT * FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501 
    WHERE ixCustomer IN ('632784','632785','1139422','1426257','784799','1954339','967761','791201'
                          ,'1803331','981666','380881','415596','127823','858983','446805','961634'
                          ,'212358','496845','824335','847314','761053','776728')
    -- NONE
    
    -- competitor,deceased, or "do not mail" status
    SELECT CST.*, C.sMailingStatus FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501 CST
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
        from PJC_24872_CST_OutputFile_501
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
    SELECT * FROM [SMI Reporting].dbo.tblSourceCode -- 5 (12 addt'l incl. the split segments that they appended 'B' to) 
    WHERE ixSourceCode LIKE '501%' AND len(ixSourceCode) <> 5
    /*
    ixSource
    Code	ixCatalog
    311020	50113	9
    708258	50117	9
    1814122	50102	9
    1342587	50108	9
    1538874	50110	9
    1619379	50103	9
    909938	50113	9
    760751	50114	9
    1286072	50118	9
    949227	50106	9
    1157835	50103	9
    1389685	50107	9
    1508488	50108	9
    1139347	50104	9
    1514776	50108	9
    1616551	50117	9
    1097861	50115	9
    1103284	50103	9
    1284771	50110	9
    1450806	50121	9
    1633376	50112	9
    1688826	50102	9
*/
    -- VERIFY all source codes in the CST campaign exist in SOP
    SELECT ixSourceCode SCode, sDescription 'Description'
    FROM [SMI Reporting].dbo.tblSourceCode
    WHERE ixCatalog = '501' 
   --   AND LEN(ixSourceCode) = 5 
      
   /* MISMATCHES! 
	
	Special case... all of the source codes will be built in SOP just PRIOR to loading the customer offers
	
   */
   
   -- SC in CST file but NOT in SOP
   SELECT ixSourceCode, count(*) 'Qty'
   from [SMITemp].dbo.PJC_24872_CST_OutputFile_501
   where ixSourceCode NOT IN (SELECT ixSourceCode-- SCode, sDescription 'Description'
                              FROM [SMI Reporting].dbo.tblSourceCode
                              WHERE ixCatalog = '501'                              )
   group by  ixSourceCode                             
   /* MISSING!!!
   ixSourceCode	Qty

	Special case... all of the source codes will be built in SOP just PRIOR to loading the customer offers
	
    */

-- CUSTOMERS THAT HAVE NOT LOADED YET

 SELECT CST.* 
 FROM PJC_24872_CST_OutputFile_501 CST --     LOADED
 LEFT JOIN [SMI Reporting].dbo.tblCustomerOffer CO on CST.ixCustomer = CO.ixCustomer AND CO.ixSourceCode LIKE '501%' AND len(CO.ixSourceCode) = 5
 WHERE CO.ixCustomer is NULL
 
 select ixCustomer, ixSourceCode
 --into PJC_24872_CST_501_PulledSoFar
 from [SMI Reporting].dbo.tblCustomerOffer CO 
 where CO.ixSourceCode LIKE '501%' AND len(CO.ixSourceCode) = 5
 
 
 51399
 
 SELECT * FROM PJC_24872_CST_OutputFile_501 CST
 JOIN PJC_24872_CST_501_PulledSoFar PSF on CST.ixCustomer = PSF.ixCustomer and CST.ixSourceCode = PSF.ixSourceCode
         
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



               
/************************ SPECIAL STEPS ********************************************************
    Dylan Provided an excel file with the customers all reassigned to their final Source Codes
 ***********************************************************************************************/                 
-- TRUNCATE TABLE PJC_24872_FinalSegmentation
select COUNT(*) from PJC_24872_FinalSegmentation                    -- 381,375
select COUNT(Distinct ixCustomer) from PJC_24872_FinalSegmentation  -- 381,375
select COUNT(distinct ixSourceCode) from PJC_24872_FinalSegmentation  -- 130   

select ixSourceCode, COUNT(*) 
from    PJC_24872_FinalSegmentation
group by ixSourceCode 
order by  ixSourceCode     
               
-- customers NOT IN original CST output file
select * from    PJC_24872_FinalSegmentation
where ixCustomer NOT IN (select ixCustomer FROM [SMITemp].dbo.PJC_24872_CST_OutputFile_501)
-- NONE

-- customers in original CST output file but NOT in Final file
select * from [SMITemp].dbo.PJC_24872_CST_OutputFile_501
where ixCustomer NOT IN (select ixCustomer FROM [SMITemp].dbo.PJC_24872_FinalSegmentation)
/*
1517752
1711775
1708669
1609136
1007981
1257063
1473264
1369171
1374160
1879878
*/

-- Final Segments the LB Don't Mail customers ended up in 
Select FS.ixSourceCode, COUNT(LB.CSTCustomer)
FROM [SMITemp].dbo.PJC_24872_FinalSegmentation FS
    join PJC_24872_Cat501_CSTandLB LB on FS.ixCustomer = LB.CSTCustomer and LB.LBCustomer is NULL
group by FS.ixSourceCode                  
order by FS.ixSourceCode    
    


-- Final Segments the LB MAIL customers ended up in 
Select FS.ixSourceCode, COUNT(LB.CSTCustomer)
FROM [SMITemp].dbo.PJC_24872_FinalSegmentation FS
    join PJC_24872_Cat501_CSTandLB LB on FS.ixCustomer = LB.CSTCustomer and LB.LBCustomer is NOT NULL
group by FS.ixSourceCode                  
order by FS.ixSourceCode        
 

-- pull data for final file to load into SOP               
select ixCustomer, ',', ixSourceCode
from [SMITemp].dbo.PJC_24872_FinalSegmentation               
-- named file 501MOD.txt               

-- kicked off customer offer load routine 12/23/14 5:22PM     .... finished 12/25/2014 5:29 PM         
-- 381,375 records in file
               
Current                                                         ETA @
Count     Time  Rec Fed Mins    Sec     Rec/Sec     Remaining   Current rate
======= ======= ======= ====    ======= =======     =========   ============
      0 17:22 T          
138,148 09:26 W 138,148 960     57,600  2.4         243,227     
149,815 11:07 W  11,667 101      6,060  1.9         231,360     26.8 - 33.8
381,375 
























               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
/********** 7. Load Customer Offers into SOP ***********
SOP:
    <20> Reporting Menu
    <3> CST Customer offer load

Follow the onscreen instructions. Be sure to DOUBLE-CHECK the Customer in-home date. 
 (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #501 = 10/06/14
    -- kicked off routine @11:11AM
*/

     -- Customer Offer LOAD TIMES
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    DECLARE @QtyToLoad INT
    SELECT @QtyToLoad = 381375  -- <-- total amount of customer offers in the CST campaign that's loading
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
    WHERE SC.ixCatalog = '501'
    --    AND CO.dtDateLastSOPUpdate >= '12/12/2014' 
      --  AND CO.ixTimeLastSOPUpdate >= 35100 -- 09:45AM
    GROUP BY T.ixTime, T.chTime
  
    /*  405,920 total offers to load
                latest ETA is 09:50 PM */
                
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
    501     381,375 173,220     2.2 12-22-14     
       !!!  CONSIDER SCRIPTING THE INDEXES ON tblCustomerOffer then:
                1) backup the table to SMITemp
                2) DROP the indexes
                3) feed Customer Offer file
                4) REBUILD the indexes
            
**********************************************************************************/
                   

/*************   SPECIAL NOTES FOR CAT 501 ONLY  ******************************/
none

-- COMPLETE THE REMAINING STEPS 

/**********  8. Compare CST file to Qty loaded into SOP and     **********
 **********     provide counts to Dylan & Philip AFTER the      **********
 **********     Customer Offers have finished loading into SOP  **********/

-- Customers in Offer table for Cat 501
select ISNULL(SC.ixSourceCode, CST.ixSourceCode) 'SCode', 
    SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in SOP',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    full outer join (select ixSourceCode, count(*) Qty
                        from PJC_24872_CST_OutputFile_501MOD
                        group by  ixSourceCode
                       ) CST on CST.ixSourceCode = SC.ixSourceCode
    full outer join (select SC.ixSourceCode, count(distinct CO.ixCustomer) Qty
                        from [SMI Reporting].dbo.tblSourceCode SC 
                            left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                        where SC.ixCatalog = '501'
                        group by SC.ixSourceCode, SC.sDescription 
                        ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where (ixCatalog = '501' or ixCatalog is NULL)
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
                    from PJC_24872_CST_OutputFile_501
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '501' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
431212	0    	1
1267734	0    	0
843034	0    	1
1724631	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from PJC_24872_CST_OutputFile_501 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from  FULL OUTER tblCustomerOffer CO 
                            where CO.ixSourceCode like '501%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
                843034,38714
				1267734,38716
				431212,38716
				1724631,38770
            */

select ixCustomer, ',',ixSourceCode
from [SMITemp].dbo.PJC_LB_streetrod20140711_CSTPull_MODIFIED   


select * from PJC_24872_CST_OutputFile_501
where ixSourceCode = '501340'

select * from tblSourceCode where ixSourceCode = '501340'

SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) LIKE '%SOURCECODE%' )
ORDER BY name





select distinct sOrderType
from tblOrder
/*
Customer Service
MRR
PRS
Retail
*/

select distinct sOrderChannel
from tblOrder
/*


