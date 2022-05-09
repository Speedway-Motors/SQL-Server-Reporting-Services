-- Case 21566 - CST output file checks for Cat 374

USE [SMITemp]

select * from [SMI Reporting].dbo.tblCatalogMaster where ixCatalog = '374'

-- Catalog 374 = '14 SPRING RACE

/************************** START  ********************/
-- run ALL steps on SMITemp DB on DWSTAGING1 (NOT DW1)

-- import data from the CST output file that is emailed from CST into table with the following naming convention:  
--      <CreatorInitials>_<case #>_CST_OutputFile_<Catalog #>  e.g. PJC_21566_CST_OutputFile_374
-- globally replace old table name with new table name

-- if the text file from CST needs to be modified (i.e. a customer was removed from the list) rename the file 
-- with the following conventions e.g. "Catalog 374 CST Modified Output File.txt" and upload it to the case

/******************* QC CHECKLIST  *************************
-- complete steps 1-5 and PASTE BELOW (with any needed alterations) INTO TICKET 
CST output file "65-374.txt" for Catalog 374 has passed the following QC checks.

1 - customer count in original CST file = 165,820
2 - no duplicate customers
3 - all customer numbers are valid
4 - counts by segment match corresponding counts in CST
5 - SOP will filter out any customers recently flagged as competitor, deceased, or do not mail


complete remaining steps:

6. Load Customer Offers:
    in SOP under <20>Reporting Menu, run 
                    <2>CST Customer offer load 
    follow directions and make sure to enter the EXACT in-home date and file names

You will receive a notification email when SOP finishes the customer offer loads. Complete the following steps:

7. compare original CST file to what is now in tblCustomerOffer
     note:  There are usually around 10-40 customers that end up "missing" 
            These should just be customers that have been merged since the CST finalization
            and a handful of customers who's files were locked at the time customer offers were loading.

8. send Dylan and Kyle a list of the final counts of offers loaded by sourcecode through the case.
***********************************************************/

-- quick review to verify data formatted correctly
select top 10 * from dbo.PJC_21566_CST_OutputFile_374 order by newid()


/****** 1.& 2. check for DUPE CUSTOMERS ******/

select count(*)                'AllCnt', 
    count(distinct ixCustomer) 'DistinctCount' 
from PJC_21566_CST_OutputFile_374       
                       
/*
Row     Distinct    CST
Count   Cust Count  Count
165,820	165,820     165,820
*/

/****** 3. Invalid Customer Numbers ******/

select * from PJC_21566_CST_OutputFile_374
where ixCustomer NOT in (select ixCustomer from [SMI Reporting].dbo.tblCustomer)
-- NONE

    -- Cust number too short or contains chars
    select * from PJC_21566_CST_OutputFile_374
    where len(ixCustomer) < 5
        or isnumeric(ixCustomer) = 0
-- NONE

/****** 4. Verify file total counts & counts by segment = what's in CST ******/

select ixSourceCode SCode, count(*) Qty
from PJC_21566_CST_OutputFile_374
group by  ixSourceCode
order by  ixSourceCode

/*
SCode	Qty
37402	13571
37403	9908
37404	7456
37405	1837
37406	1228
37407	1815
37408	3169
37409	2809
37410	7565
37411	9193
37412	4491
37413	9714
37414	6622
37415	2980

37416	8413
37417	13468
37418	7529
37419	4731
37420	1691
37421	1876
37422	6499
37423	13056
37424	5530
37425	3277
37426	2425
37427	1153
37428	4257
37429	9557



FROM CST SCREEN
Count Time: 16:07
Total Segments: 28 (0 split segments) = 28 SCodes

Total Source Codes: 28
          Included: 28
          Excluded:  0
          
Total Customers: 165,820 v
       Included: 165,820   
       Excluded:       0
*/

/***** 5. check for customers flagged as competitor,deceased, or "do not mail" ******/
    
     -- known competitors
     
    select * from PJC_21566_CST_OutputFile_374 
    where ixCustomer in ('632784','632785','1139422','1426257','784799','1954339','967761','791201',
    '1803331','981666','380881','415596','127823','858983','446805','961634','212358','496845','824335','847314','761053','776728')
--NONE
    
    -- competitor,deceased, or "do not mail" status
    select * from PJC_21566_CST_OutputFile_374 
    where ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCustomer where sMailingStatus in ('9','8','7'))
--NONE     

   /*if any customers are returned then show details...
   
             SELECT ixCustomer, sMailingStatus
             FROM [SMI Reporting].dbo.tblCustomer
             WHERE ixCustomer in ('1794679')
            
            ixCustomer	sMailingStatus
            1794679	9
            			
    */

    -- SOP will exclude above people
    -- DO NOT CREATE A MANUALLY MODIFIED FILE unless there are special steps Marketing requested
    -- that CST can not handle (splitting out a segment for afco purchasers, etc)
    /*
        -- run this ONLY when a manual file MUST be created
        select ixCustomer+','+ixSourceCode
        from PJC_21566_CST_OutputFile_374
        where ixCustomer NOT in (###,###,###)
        order by ixSourceCode, ixCustomer
    */
select * from [SMI Reporting].dbo.tblSourceCode -- 6
where ixSourceCode like '374%' and len(ixSourceCode) <> 5

-- VERIFY all source codes in the CST campaign exist in SOP
select ixSourceCode SCode, sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode
where ixCatalog = '374' 
    and len(ixSourceCode) = 5

/*
SCode	Description
37402	12M, 6+, $2000+
37403	12M, 6+, $1000+
37404	12M, 6+, $400+
37405	12M, 5+, $1000+
37406	12M, 5+, $700+
37407	12M, 5+, $400+
37408	12M, 5+, $100+
37409	12M, 3+, $1000+
37410	12M, 3+, $400+
37411	12M, 3+, $100+
37412	12M, 2+, $400+
37413	12M, 2+, $100+
37414	12M, 2+, $1+
37415	12M, 1+, $400+
37416	12M, 1+, $150+
37417	12M, 1+, $50+
37418	24M, 5+, $1000+
37419	24M, 5+, $400+
37420	24M, 5+, $100+
37421	24M, 2+, $1000+
37422	24M, 2+, $400+
37423	24M, 2+, $100+
37424	24M, 2+, $1+
37425	36M, 5+, $1000+
37426	36M, 5+, $400+
37427	36M, 2+, $1000+
37428	36M, 2+, $400+
37429	36M, 2+, $100+

*/

/***** 6. Update deceased exempt list   *****/

    -- execute the following BEFORE and AFTER running the update 
    select count(*) from [SMI Reporting].dbo.tblCustomer 
    where flgDeceasedMailingStatusExempt = 1
        and flgDeletedFromSOP = 0  
    -- Count BEFORE = 353    
    -- Run <9> Update deceased exempt list in SOP's Reporting Menu    
    -- Count AFTER  = 350
    
    
    
/***** 7. Load Customer Offers into SOP ******
SOP:
    <20> Reporting Menu
        <3> CST Customer offer load

Follow the onscreen instructions. Be sure to 
DOUBLE-CHECK the Customer in-home date.  (Have Marketing put it in the case if its not already there.)

    In-home date for Catalog #374 = 03/17/14
    -- kicked off routine @11:50AM
*/

 
    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    select count(CO.ixCustomer) CustCnt
        ,CONVERT(VARCHAR, getdate(), 20)  as 'RunTime'
        ,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as SecRun
        --  (count(CO.ixCustomer) / (T.ixTime - min(CO.ixTimeLastSOPUpdate)) )*60 as 'Rec/Min',
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer)))
           /(CONVERT(DECIMAL(10,2),T.ixTime) 
                - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 
                    *60.00 
                        as 'Rec/Min'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer)))
           /(CONVERT(DECIMAL(10,2),T.ixTime) 
                - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 
                    *3600.00 
                        as 'Rec/Hour'                        
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    where SC.ixCatalog = '374'
    group by T.ixTime, T.chTime
    /* 165,820 total offers to load

Cust
Count	RunTime			    	SecRun	Rec/Min Rec/Hour	Rec/Sec
1472	2014-02-13 11:52:10	    120	    735.99	44159.99
4359	2014-02-13 11:56:36     386	    677.56  40653.88
72142	2014-02-13 13:43:59	    6829	633.84	38030.63            
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
       /***** CLOAK 2.0 launched ******/
    386		 45,879	  4,202	   10.9 01-09-14    Thursday (ran during production hours) 
    378     219,574	 21,780	   10.0	01-30-14	Monday (ran during production hours) 
    374     165,820  16,323    10.2 02-13-14    Thursday (11:50AM - 4:20PM) 
       /***** Network switches on the server rack 
              will go live sometime mid Feb.  
                   Potential speed boost!   *****/
    */


/********   SPECIAL NOTES FOR CAT 374 ONLY  ***************
    no special issues 
*/

  

-- COMPLETE THE REMAINING STEPS AFTER the Customer Offers have been loaded into SOP.

/*****  8. Compare CST file to Qty loaded into SOP   *****/
select SC.ixSourceCode SCode, SC.sDescription 'Description',
    CST.Qty as 'Qty in CST File',
    SOP.Qty as 'Qty in DW-STAGING1',
    (isnull(SOP.Qty,0) - isnull(CST.Qty,0)) as 'Delta'
from [SMI Reporting].dbo.tblSourceCode SC
    left join (select ixSourceCode, count(*) Qty
                from PJC_21566_CST_OutputFile_374
                group by  ixSourceCode
               ) CST on CST.ixSourceCode = SC.ixSourceCode
    left join (select SC.ixSourceCode, count(CO.ixCustomer) Qty
                from [SMI Reporting].dbo.tblSourceCode SC 
                    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                where SC.ixCatalog = '374'
                group by SC.ixSourceCode, SC.sDescription 
                ) SOP on SOP.ixSourceCode = SC.ixSourceCode 
where ixCatalog = '374'                            
order by SC.ixSourceCode 
-- note!  If totals don't match, verify that all of the sourcecodes in CST exist in SOP

-- details on Customers that "failed to load" into tblCustomerOffer
-- most should be recently changed mail status or merged customers that are now flagged as deleted
select ixCustomer 'Cust #'
    , sMailingStatus+'    ' as 'MailingStatus' 
    , flgDeletedFromSOP
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in(
                    -- Customers in output file but NOT in tblCustomerOffer
                    select ixCustomer
                    from PJC_21566_CST_OutputFile_374
                    except (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblSourceCode SC 
                                left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
                            where 
                            SC.ixCatalog = '374' )
                    )
/*
Cust #	Mailing flgDeleted
        Status	FromSOP
706690	0    	0
1775075	NULL	0
1357025	0    	0
1149217	0    	0
1068363	0    	0
1422726	0    	0
208452	0    	0
886763	0    	0
*/

            -- Customers in output file but NOT in tblCustomerOffer
            select CST.ixCustomer+','+CST.ixSourceCode --ixCustomer
            from PJC_21566_CST_OutputFile_374 CST
                           -- Customers in tblCustomerOffer for current catalog
                left join (select CO.ixCustomer
                            from [SMI Reporting].dbo.tblCustomerOffer CO 
                            where CO.ixSourceCode like '374%'
                            and len(CO.ixSourceCode) >= 5 ) CO on CST.ixCustomer = CO.ixCustomer
            where CO.ixCustomer is NULL 
            order by  CST.ixSourceCode, CST.ixCustomer              
            /*
            1422726,37402
            1068363,37407
            208452,37412
            1775075,37417
            1357025,37418
            886763,37419
            1149217,37423
            706690,37429
            */


-- Customers in Offer table for Cat 374
/***** PROVIDE THESE COUNTS TO Dylan/Klye after SOP loads all of the customer offers *****/
select SC.ixSourceCode 'SCode', count(CO.ixCustomer) 'Qty Loaded' , SC.sDescription 'Description'
from [SMI Reporting].dbo.tblSourceCode SC 
    left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '374' 
group by SC.ixSourceCode, SC.sDescription 
order by SC.ixSourceCode   

/*
SCode	Qty Loaded	Description
37402	13571	12M, 6+, $2000+
37403	9908	12M, 6+, $1000+
37404	7456	12M, 6+, $400+
37405	1837	12M, 5+, $1000+
37406	1228	12M, 5+, $700+
37407	1814	12M, 5+, $400+
37408	3169	12M, 5+, $100+
37409	2809	12M, 3+, $1000+
37410	7565	12M, 3+, $400+
37411	9193	12M, 3+, $100+
37412	4490	12M, 2+, $400+
37413	9714	12M, 2+, $100+
37414	6622	12M, 2+, $1+
37415	2980	12M, 1+, $400+
37416	8413	12M, 1+, $150+
37417	13468	12M, 1+, $50+
37418	7528	24M, 5+, $1000+
37419	4730	24M, 5+, $400+
37420	1691	24M, 5+, $100+
37421	1876	24M, 2+, $1000+
37422	6499	24M, 2+, $400+
37423	13055	24M, 2+, $100+
37424	5530	24M, 2+, $1+
37425	3277	36M, 5+, $1000+
37426	2425	36M, 5+, $400+
37427	1153	36M, 2+, $1000+
37428	4257	36M, 2+, $400+
37429	9556	36M, 2+, $100+
*/
