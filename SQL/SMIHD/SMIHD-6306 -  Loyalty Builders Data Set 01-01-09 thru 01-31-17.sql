 /* SMIHD-6306 -  Loyalty Builders Data Set 01-01-09 thru 01-31-17
        This is the standard monthly extract for LB
 */
 
 /********************************************************************************************
1) alter vwLBSampleTransactions on LNK-DWSTAGING1 
        change the end date to the final day of the previous month (or the previous day if this is a pull outside the normal delivery schedule)
        Do NOT put a function to calculate it because it SLOWS THE VIEW DOWN TOO MUCH.
 
2) run everything else on DW1
 
3) NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+

4) EXPORT files in Mgmt Studio by selecting "RESULTS TO FILE"
 **********************************************************************************************/

    -- verify vwLBSampleTransactions pulls data through the end of prev month
        select top 25 * from vwLBSampleTransactions -- where txdate LIKE '07%2016' 
        where txdate = '01/31/2017' 
        
    
     
        select CONVERT(VARCHAR(10), GETDATE(), 101) AS 'DateRan   ', 
            COUNT(*) 'TotRows ',
            count(distinct itemid) 'DistinctItemIDs',
            count(distinct custid) 'DistinctCustIDs'
        from vwLBSampleTransactions -- 27-140 sec
        /*                      Distinct    Distinct
        DateRan	    TotRows 	ItemIDs     CustIDs
        ==========  =========   =======     ========
        02/03/2017	8,334,337	92,681	    773,987
        01/04/2017	8,240,767	90,918	    765,784
        12/02/2016	8,163,847	89,283	    757,247
        11/04/2016	8,086,068	87,814	    749,196
        10/04/2016	8,017,246	86,756	    741,614
        08/31/2016	7,939,968	85,573	    733,307
        08/03/2016	7,840,518	84,226		723,469
        07/05/2016	7,741,766	82,922	    713,711
        06/03/2016	7,635,689	81,557	    703,568
        05/05/2016	7,385,635	78,294	    682,050        
        04/13/2016	7,386,980	78,288      682,250  
        04/04/2016	7,272,482	77,326      ?
        */


    -- MERGED CUSTOMERS
        -- recency check
        SELECT MAX(CONVERT(VARCHAR, dtDateMerged, 102) ) 'LatestMerged',
        MIN(CONVERT(VARCHAR, dtDateLastSOPUpdate, 102) ) 'OldestUpdated'
        from [SMI Reporting].dbo.tblMergedCustomers 
        /*
        Latest      Oldest
        Merged	    Updated
        2017.02.03	2017.02.03     -- if Latest Merged date is not current, run <9> Customer Merges under Reporting Feeds Menu in SOP 
        */
    
    
        select CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
        COUNT(*) 'TotCnt',
        COUNT(distinct ixCustomerOriginal) 'DistCnt',
        (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        from [SMI Reporting].dbo.tblMergedCustomers
        /*
        DateRan   	TotCnt	DistCnt	Dupes
        2017.02.03	47,074	47,074	0
        2017.01.04	44,998	44,998	0
        12/02/2016	43,159	43,159	0
        11/04/2016	42,218	42,218	0
        10/04/2016	42,078	42,078	0
        09/02/2016	41,898	41,898	0        
        08/03/2016	41,729	41,729	0
        07/05/2016	41,526	41,526	0
        06/03/2016	41,342	41,342	0
        04/13/2016	40,996	40,996	0
        04/04/2016	40,858	40,858	0        
        */



    -- import SKU/Market data from TNG
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB] 
        select *                                        -- 439,846  22-84 seconds
        from openquery([TNGREADREPLICA], 'SELECT ixSOPSKU as ''ixSKU'', 
                          M.sMarketName as ''ixMarket''
                        FROM tblmarket M 
                          left join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket  
                          left join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase 
                          left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase 
                        where 
                          SV.ixSOPSKU is NOT NULL
                          and M.sMarketName <> ''Garage Sale''
                          and SV.ixSOPSKU <>'' ''
                        order by SV.ixSOPSKU ') 
        UNION
            select *                                        
            from openquery([TNGREADREPLICA], '                SELECT ixSOPSKU as ''ixSKU'', 
                              M.sMarketName as ''ixMarket''
                            FROM tblmarket M 
                              left join tblskubase_universal_market SUMKT on M.ixMarket = SUMKT.ixMarket  
                              left join tblskubase SB on SUMKT.ixSKUBase = SB.ixSKUBase 
                              left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase 
                            where 
                              SV.ixSOPSKU is NOT NULL
                              and M.sMarketName <> ''Garage Sale''
                              and SV.ixSOPSKU <>'' ''
                            order by SV.ixSOPSKU ') 
                              
                              
                              
        -- review data
        select CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
            count(*) 'Records'
        from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
        /*
        DateRan   	Records
        2017.02.03	439,846
        2017.01.04	437,515
        12/02/2016	406,345
        11/04/2016	404,446
        10/04/2016	403,098 <-- started pulling from tblskubasemarket AND tblskubase_universal_market now
        09/02/2016	413,402
        08/03/2016	413,361
        07/05/2016	413,324
        06/03/2016	413,318
        05/05/2016	413,277
        04/13/2016	413,233           
        04/04/2016	413,196                        
        */
                    
        select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]

        
        select COUNT(ixSKU) 'SKUCnt', ixMarket
        from [SMITemp].dbo.[PJC_SKUMarketsForLB]
        group by  ixMarket
        order by COUNT(ixSKU) desc
        /*
        RESULTS FROM 01-31-17 RUN:
        SKUCnt	ixMarket
        ======  =================
        71763	Street Rod
        64327	T-Bucket
        63513	Oval Track
        62433	Classic Truck
        61398	Muscle Car
        55660	Open Wheel
        35069	Drag Racing
        6092	Offroad
        5281	Sport Compact
        4956	Modern Muscle
        4570	Modern Truck
        3013	Demolition Derby
        1419	Pedal Car
        352	    Marine
        
                
        RESULTS FROM 12-31-16 RUN:
        SKUCnt	ixMarket
        ======  =================
        71392	Street Rod
        64010	T-Bucket
        63325	Oval Track
        62123	Classic Truck
        61061	Muscle Car
        55518	Open Wheel
        34802	Drag Racing
        6031	Offroad
        5196	Sport Compact
        4878	Modern Muscle
        4495	Modern Truck
        2917	Demolition Derby
        1417	Pedal Car
        350	    Marine
        
        
        RESULTS FROM 11-30-16 RUN:
        SKUCnt	ixMarket
        ======  =================
        67558	Street Rod
        61703	T-Bucket
        60662	Oval Track
        58214	Classic Truck
        57198	Muscle Car
        53347	Open Wheel
        32219	Drag Racing
        2942	Sport Compact
        2903	Modern Muscle
        2879	Demolition Derby
        2635	Offroad
        2407	Modern Truck
        1414	Pedal Car
        264	    Marine
                
        RESULTS FROM 10-31-16 RUN:
        SKUCnt	ixMarket
        ======  =================
        67170	Street Rod
        61641	T-Bucket
        60431	Oval Track
        57876	Classic Truck
        56896	Muscle Car
        53162	Open Wheel
        32003	Drag Racing
        2917	Sport Compact
        2879	Modern Muscle
        2834	Demolition Derby
        2592	Offroad
        2382	Modern Truck
        1407	Pedal Car
        256	    Marine
        */
        
/****************************************************  
FILE #1 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:  SMI - Customer - Catalogs Mailed 01012009 to 01312017
    records: 15.5M-16.5M        runtime: 5:20-8:26        
****************************************************/
    SELECT -- 16,713,488 records   
        DISTINCT
 	    co.ixCustomer as 'custid',
	    convert(varchar,co.dtActiveStartDate,101) as 'mailed_date',
	    case
		    when cm.sMarket = 'R' then 'Race'
		    when cm.sMarket = 'SR' then 'Street Rod'
		    when cm.sMarket = 'B' then 'Multi'
		    when cm.sMarket = 'SM' then 'Open Wheel'
		    when cm.sMarket = 'PC' then 'Pedal Car'
		    when cm.sMarket = '2B' then 'T Bucket'
		    when cm.sMarket = 'TE' then 'Tools'
		    when cm.sMarket = 'SC' then 'Sport Compact'
            when cm.sMarket = 'G' then 'Combo'
            when cm.sMarket = 'MC' then 'Muscle Car'            
            ELSE 'OTHER' -- to catch any new markets
	    end as 'catalog_market'
    FROM tblCustomerOffer co
    	join vwLBSampleTransactions ST on ST.custid = co.ixCustomer
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    WHERE co.sType='OFFER'
	    and co.dtActiveStartDate between '01/01/2011' and '01/31/2017'    -- 1/1/2009 to '01/31/2017'


/****************************************************  
FILE #2 - CUSTOMER file 
    file name:   SMI - Customers 01012009 to 01312017
    records:     700-770k    runtime: 20-50 sec  
****************************************************/
    SELECT -- 773,986      @42 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (select distinct custid 
                           from vwLBSampleTransactions)


                              
/****************************************************  
FILE #3 - Merged Customers
    file name:   SMI - Merged Customers 01012009 to 01312017
    records:     40K-45K   
    runtime:     3 sec   
****************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 46,873
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM [SMI Reporting].dbo.tblMergedCustomers M
        join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged



/****************************************************  
FILE #4 - SKUs w/ advanced market info 
    file name: SMI - SKU - Additional Markets File 01012009 to 01312017
    records:   235 - 250K    runtime:   20-35 sec
 ****************************************************/
  -- Data is imported from tng into [SMITemp].dbo.[PJC_SKUMarketsForLB]
  -- in the Prep Steps section above
            
        -- create output for LB file               
            SELECT DISTINCT sm.ixSKU as 'itemid', --  252,487  @30 secs    
	            sm.ixMarket as 'market'
            FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
            WHERE sm.ixSKU in (select distinct itemid 
                               from vwLBSampleTransactions)
	            and sm.ixMarket is NOT NULL


/****************************************************
FILE #5 - SKU file 
file name: SMI - SKUs 01012009 to 01312017
records: 84-92K(^ about 1K/month)runtime: 60-98 sec
****************************************************/
SELECT SKU.ixSKU as 'itemid',-- 92,681  @85sec
    SKU.sDescription as 'itemdesc',
    SKU.sSEMACategory as 'prodcat',
    SKU.sSEMASubCategory as 'prodclass',
    SKU.sSEMAPart as 'prodsubclass',
    SKU.sWebDescription as 'itemdesc_long',
    case
            when PGC.ixMarket = 'R' then 'Race'
            when PGC.ixMarket = 'SR' then 'Street Rod'
            when PGC.ixMarket = 'B' then 'Multi'
            when PGC.ixMarket = 'SM' then 'Open Wheel'
            when PGC.ixMarket = 'PC' then 'Pedal Car'
            when PGC.ixMarket = '2B' then 'T Bucket'
            when PGC.ixMarket = 'TE' then 'Tools'
            when PGC.ixMarket = 'SC' then 'Sport Compact'
            when PGC.ixMarket = 'G' then 'Combo'
            when PGC.ixMarket = 'MC' then 'Muscle Care' -- added 6-16-2016
        ELSE 'OTHER' -- to catch any new markets
    end as 'primary_market',
    SKU.ixBrand 'brandid',
    B.sBrandDescription 'brand_description',
     -- SKU.sBaseIndex, -- SOP<-- it appears SOP has the wrong base for 500+ SKUs
    tng.ixSOPSKUBase 'skubase'
FROM tblSKU SKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
    left join tblBrand B on SKU.ixBrand = B.ixBrand
    left join (select *
                FROM openquery([TNGREADREPLICA], '
                SELECT DISTINCT SB.ixSOPSKUBase
                ,SV.ixSOPSKU
                FROM tblskubase SB 
                JOIN tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
                LEFT JOIN tblproductline PL ON PL.ixProductLine = SB.ixProductLine 
                LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand 
                 ')
                ) tng on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = tng.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
WHERE SKU.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
--and SKU.sBaseIndex COLLATE SQL_Latin1_General_CP1_CI_AS <> tng.ixSOPSKUBaseCOLLATE SQL_Latin1_General_CP1_CI_AS-- Finds SKUs that don't have matching bases



/**** NOTES from analysis done on 1-21-15
        1,879 SKUs (as of 1-21-15) are being excluded because they have no market assigned in TNG.

        Wyatt was sent a list of 1,043 the above SKUs (the ones that were still active as far as TNG determins).
        They had sales totalling $800K in 2014 alone.  He was going to review the list and have someone update 
        the markets based on the highesr 12 Month sales $ having priority.

        The SOP Market is assigned to a SKU in another file.
*/   

 
/**************************************************** 
FILE #6 - transaction file data 
    file name: SMI - Transactions 01012009 to 01312017
    records: 7.6M-8.3M    runtime: 46-188 sec 
****************************************************/
    select * from vwLBSampleTransactions -- 8,334,337    @83 sec 
 

/**************************************************** 
FILE #7 - Customer print opt-outs data 
    file name: SMI - Customer - Print Opt-Outs as of 01312017
    records: 70-72K  runtime: 3 sec 
****************************************************/

SELECT COUNT(*) FROM tblMailingOptIn                                            -- 11,153,249
SELECT COUNT(*) FROM tblMailingOptIn WHERE sOptInStatus = 'N'                   --     88,294
SELECT COUNT(DISTINCT ixCustomer) FROM tblMailingOptIn WHERE sOptInStatus = 'N' --     27,380

SELECT distinct ixCustomer 'custid', -- 71,266  records (aprox 27K distinct customers)
    case
        when ixMarket = 'R' then 'Race'
	    when ixMarket = 'SR' then 'Street Rod'
	    when ixMarket = 'B' then 'Multi'
	    when ixMarket = 'SM' then 'Open Wheel'
	    when ixMarket = 'PC' then 'Pedal Car'
        when ixMarket = '2B' then 'T Bucket'
        when ixMarket = 'TE' then 'Tools'
        when ixMarket = 'SC' then 'Sport Compact'
        when ixMarket = 'MC' then 'Muscle Car'
        ELSE 'INVALID MARKET' --ELSE ixMarket
    end as 'optout_market'
FROM tblMailingOptIn
WHERE sOptInStatus = 'N'
    and ixMarket <> 'AD' -- AFCO Dynateck
    --and ixMarket <> 'R' and ixMarket <> 'SR' and ixMarket <> 'B' and ixMarket <> 'SM' and ixMarket <> 'PC' 
    -- and ixMarket <> '2B' and ixMarket <> 'TE' and ixMarket <> 'SC' and ixMarket <> 'G' and ixMarket <> 'MC'
order by 'optout_market'



/************   Manually inspect each file. Compare size, format, and row count to previous extract  *********************** 
File Summary:                                                                                        /   QC CHECKS   \
                    Approx                                                                          /                 \
    Approx          File                                                                           /Size    Data       \
#   records         Size (MB)   File Name                                                           (MB)    Format  #Rec
==  ===========     =========   =================================================================   ====    ======  ====
1   15.5M-16.5M     400-465     SMI - Customer - Catalogs Mailed 01-01-2009 to <'01/31/2017'>.txt      Y    Y       Y
2   714K-760K      15.7-17.6    SMI - Customers 01-01-2009 to <'01/31/2017'>.txt                       Y    Y       Y   
3    41K-45K          1-1.5     SMI - Merged Customers 01-01-2009 to <'01/31/2017'>.txt                Y    Y       Y   
4   236K-248K       5.0-5.7     SMI - SKU - Additional Markets 01-01-2009 to <'01/31/2017'>.txt        Y    Y       Y   
5     84-91K       14.0-16.1    SMI - SKUs 01-01-2009 to <'01/31/2017'>.txt                            Y     
6   7.7M-8.6M       315-400     SMI - Transactions 01-01-2009 to <'01/31/2017'>.txt                    Y    
7    71K-73K          1-1.5     SMI - Customer - Print Opt-Outs as of <'01/31/2017'>.txt               Y     Y       Y    
#8 WE NO LONGER SEND "SMI - SKUs and Applications"
    
   Zip the files (at "FASTEST" compression and place them in in N:\Misc Items.
   naming convention = "SMI - dataset 01-01-2009 to 12-31-2016.7z" <-- approx 1-2 mins to zip and 4 mins to transfer
*******************************************************************************************/    
    
/******************************  TRANSMIT FILES TO LOYALTY BUILDERS  ******************************
access the secured ftp account using Filezilla.
        hostname: sftp://ftp.longbowdm.com  
        Username = speedway     PW = yW4Sgwjj
If any PW issues, call Al Trudell at (603)610-8810 albertt@loyaltybuilders.com
************************************************************************************************** /

/******************************** SEND NOTIFICATION EMAIL  ********************************
TO: irenam@loyaltybuilders.com; albertt@loyaltybuilders.com; billv@loyaltybuilders.com; brianj@loyaltybuilders.com
CC: dwlee@speedwaymotors.com; ccchance@speedwaymotors.com; ascrook@speedwaymotors.com
SUBJECT: Newest dataset uploaded

Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is ?SMI - dataset 01-01-2009 to 01-31-2017.7z?.   

It consists of the following 7 files appended with the date range used:

    RECORDS     FILENAME 
    =========   ================================  
#1 16,713,488   SMI - Customer - Catalogs Mailed  
#2    773,986   SMI - Customers      
#3     46,873   SMI - Merged Customers
#4    252,487   SMI - SKU - Additional Markets
#5     92,681   SMI - SKUs
#6  8,334,337   SMI - Transactions
#7     71,266   SMI - Customer - Print Opt-Outs

If there are any questions/concerns, email or call me prior to our next scheduled conference call.  Please let us know as soon as Longbow has been refreshed with this dataset.

Thanks!

*** END **** /

