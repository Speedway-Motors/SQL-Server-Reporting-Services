 /* SMIHD-14672 - Loyalty Builders Data Set 01-01-09 thru 08-31-19
        This is the standard monthly extract for LB SMIHD-4104 (parent case)  
 */
-- EDIT > OUTLINING > HIDE SELECTION   to condense snippets of code
 /********************************************************************************************
1) alter vwLBSampleTransactions 
        change the end date to the FINAL DAY of PREVIOUS MONTH
        Do NOT put a function to calculate it because it SLOWS THE VIEW DOWN TOO MUCH.

2) run <9> Customer Merges under Reporting Feeds Menu in SOP 
 
3) NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+

4) EXPORT files in Mgmt Studio by selecting "RESULTS TO FILE"
 **********************************************************************************************/
SELECT @@SPID as 'Current SPID' -- 69 

 /***********************  PREP QUERIES   ****************************************/
    -- verify vwLBSampleTransactions pulls data through the end of prev month
        SELECT top 25 * FROM vwLBSampleTransactions
        where txdate = '08/31/2019' 
        
     
        SELECT CONVERT(VARCHAR(10), GETDATE(), 101) AS 'DateRan   ', 
            FORMAT(COUNT(*),' ###,##0') 'TotRows ',
            FORMAT(count(distinct itemid),' ###,##0') 'DistinctItemIDs',
            FORMAT(count(distinct custid),' ###,##0') 'DistinctCustIDs'
        FROM vwLBSampleTransactions -- 88-183 sec           165
        /*                       Distinct    Distinct
        Date Ran     Tot Rows 	 ItemIDs     CustIDs
        ==========   ==========  =======     =========
        09/03/2019	 11,668,540	 144,650	 1,215,452

        07/03/2019	 11,460,020	 141,997	 1,182,689
        04/03/2019	 11,091,579	 137,321	 1,125,029
        01/03/2019	 10,740,831	 132,510	 1,075,751

        07/03/2018   10,188,002	 123,651	   986,417
        01/03/2018	  9,467,813	 111,407	   895,533

        01/04/2017	  8,240,767	  90,918	   765,784
        07/05/2016	  7,741,766	  82,922	   713,711
        04/04/2016	  7,272,482	  77,326          ?
        */


    -- MERGED CUSTOMERS
        -- recency check
        SELECT MAX(CONVERT(VARCHAR, dtDateMerged, 102) ) 'LatestMerged',
        MIN(CONVERT(VARCHAR, dtDateLastSOPUpdate, 102) ) 'OldestUpdated'
        FROM [SMI Reporting].dbo.tblMergedCustomers 
        /*
        Latest      Oldest
        Merged	    Updated
        2019.09.03	2019.09.03 -- if Latest Merged date <> current, run <9> Customer Merges under Reporting Feeds Menu in SOP 
        */

    
        SELECT CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
            FORMAT( COUNT(*),'##,##0')  'TotCnt',
            FORMAT(COUNT(distinct ixCustomerOriginal),'##,##0')   'DistCnt',
            (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        FROM [SMI Reporting].dbo.tblMergedCustomers
        /*
        DateRan   	TotCnt	DistCnt	Dupes
        2019.09.03	64,607	64,607	0
        2019.07.03	63,890	63,890	0
        2019.04.03	62,761	62,761	0

        2019.01.03	60,930	60,930	0
        2018.01.03	51,440	51,440	0
        2017.01.04	44,998	44,998	0
        */


    -- import SKU/Market data FROM TNG
        -- SELECT FORMAT(COUNT(*),'###,###') 'SKUCnt' from [SMITemp].dbo.[PJC_SKUMarketsForLB]  -- 459,435
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB] 
        SELECT *                                        -- 468,014    21-54 sec     @27 sec
        FROM openquery([TNGREADREPLICA], 'SELECT ixSOPSKU as ''ixSKU'', 
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
            SELECT *                                        
            FROM openquery([TNGREADREPLICA], '                SELECT ixSOPSKU as ''ixSKU'', 
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
        SELECT CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
            FORMAT( COUNT(*),'##,##0') 'Records'
        FROM [SMITemp].dbo.[PJC_SKUMarketsForLB]   
        /*
        Date Ran   	Records
        ==========  =======
        2019.09.03	468,014
        2019.07.03	452,064
        2019.04.03	451,133
        2019.01.03	448,545

        2018.01.03	490,135
        2017.01.04	437,515
        2016.07.05  413,324
        */
                    
        SELECT top 10 * FROM [SMITemp].dbo.[PJC_SKUMarketsForLB]

        
        SELECT FORMAT( COUNT(ixSKU),'##,##0')  'SKUCnt', ixMarket  -- 14 Markets
        FROM [SMITemp].dbo.[PJC_SKUMarketsForLB]
        GROUP BY ixMarket
        ORDER BY COUNT(ixSKU) desc
        /*
        RESULTS FROM 09-03-19 RUN:
        SKUCnt	ixMarket
        ======  =================
        83,056	Street Rod
        74,020	Classic Truck
        72,620	Muscle Car
        72,045	T-Bucket
        68,317	Oval Track
        42,486	Drag Racing
        10,947	Off Road
        10,821	Truck Accessories
        10,790	Modern Muscle
        10,274	Sport Compact
        6,270	Demolition Derby
        3,414	Marine
        1,479	Pedal Car
        1,475	Open Wheel


        RESULTS FROM 08-02-19 RUN:
        SKUCnt	ixMarket
        ======  =================
        81,277	Street Rod
        72,314	Classic Truck
        71,403	T-Bucket
        70,857	Muscle Car
        67,809	Oval Track
        41,885	Drag Racing
        10,841	Off Road
        10,333	Modern Muscle
        10,332	Truck Accessories
        10,216	Sport Compact
        5,876	Demolition Derby
        3,404	Marine
        1,479	Pedal Car
        1,409	Open Wheel



        RESULTS FROM 07-03-19 RUN:
        SKUCnt	ixMarket
        ======  =================
        80,373	Street Rod
        71,423	Classic Truck
        70,767	T-Bucket
        70,073	Muscle Car
        67,127	Oval Track
        41,719	Drag Racing
        10,585	Off Road
        10,087	Modern Muscle
        9,993	Truck Accessories
        9,413	Sport Compact
        5,100	Demolition Derby
        3,354	Marine
        1,473	Pedal Car
          577	Open Wheel

        RESULTS FROM 04-03-19 RUN:
        SKUCnt	ixMarket
        ======  =================
        80,236	Street Rod
        71,316	Classic Truck
        70,653	T-Bucket
        70,006	Muscle Car
        66,974	Oval Track
        41,543	Drag Racing
        10,567	Off Road
        10,067	Modern Muscle
        9,987	Truck Accessories
        9,402	Sport Compact
        5,056	Demolition Derby
        3,349	Marine
        1,473	Pedal Car
        504	Open Wheel


        RESULTS FROM 01-03-19 RUN:
        SKUCnt	ixMarket
        ======  =================
        79,845	Street Rod
        70,983	Classic Truck
        70,316	T-Bucket
        69,721	Muscle Car
        66,631	Oval Track
        41,186	Drag Racing
        10,436	Off Road
        9,978	Modern Muscle
        9,975	Truck Accessories
        9,323	Sport Compact
        4,976	Demolition Derby
        3,323	Marine
        1,459	Pedal Car
        393	    Open Wheel

        RESULTS FROM 01-03-18 RUN:
        SKUCnt	ixMarket
        ======  =================
        76,764	Street Rod
        68,422	T-Bucket
        67,157	Oval Track
        66,867	Classic Truck
        65,670	Muscle Car
        58,540	Open Wheel
        40,231	Drag Racing
        9,778	Off Road
        9,365	Modern Muscle
        9,148	Sport Compact
        8,999	Truck Accessories
        4,449	Demolition Derby
        3,296	Marine
        1,449	Pedal Car
          
        RESULTS FROM 12-31-16 RUN:
        SKUCnt	ixMarket
        ======  =================
        71,392	Street Rod
        64,010	T-Bucket
        63,325	Oval Track
        62,123	Classic Truck
        61,061	Muscle Car
        55,518	Open Wheel
        34,802	Drag Racing
        6,031	Offroad
        5,196	Sport Compact
        4,878	Modern Muscle
        4,495	Modern Truck
        2,917	Demolition Derby
        1,417	Pedal Car
        350	    Marine
   */
     
        
/********************************************************************************************  
FILE #1 - catalogs mailed to each cust w/market & SC   
                            file name:  SMI - Customer - Catalogs Mailed 01012009 to 08312019
                            records: 20.5M-21.8M        runtime: 7:20-31:37       
*********************************************************************************************/  
    SELECT DISTINCT co.ixCustomer as 'custid',     -- 22,368,448     @12:48
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
	    end as 'catalog_market',
	    co.ixSourceCode 'source_code'   -- added 5/4/17 per 
    FROM tblCustomerOffer co
    	join vwLBSampleTransactions ST on ST.custid = co.ixCustomer
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    WHERE co.sType='OFFER'
	   and co.dtActiveStartDate between '01/01/2011' and '08/31/2019'   


/***************************************************************************** 
FILE #2 - CUSTOMER file      file name: SMI - Customers 01012009 to 08312019
                             records: 1.0-1.2m     runtime: 11-44 sec  
******************************************************************************/
    SELECT -- 1,215,451    @21 sec		
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (SELECT distinct custid 
                           FROM vwLBSampleTransactions)

                              
/*********************************************************************************************  
FILE #3 - Merged Customers    file name: SMI - Merged Customers 01012009 to 08312019
                              records: 52K-55K       runtime: 3 sec   
**********************************************************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 64,422
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM tblMergedCustomers M
        join tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged


/*************************************************************************************************************  
FILE #4 - SKUs w/ advanced market info     file name: SMI - SKU - Additional Markets File 01012009 to 08312019
                                           records:   255 - 294    runtime:   10-40 sec
**************************************************************************************************************/
    -- Data is imported FROM tng into [SMITemp].dbo.[PJC_SKUMarketsForLB] in the Prep Steps section above
    -- create output for LB file               
    SELECT DISTINCT sm.ixSKU as 'itemid', -- 311,343 @13 sec     
	    sm.ixMarket as 'market'
    FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
    WHERE sm.ixSKU in (SELECT distinct itemid 
                        FROM vwLBSampleTransactions)
	    and sm.ixMarket is NOT NULL

/*********************************************************************************************
FILE #5 - SKU file                  file name: SMI - SKUs 01012009 to 08312019
                                    records: 127-138k^ about 1k/mo)       runtime: 60-132 sec
 *********************************************************************************************/
    SELECT SKU.ixSKU as 'itemid',-- 144,650 @132 sec
    SKU.sDescription as 'itemdesc',
    SKU.sSEMACategory as 'prodcat',
    SKU.sSEMASubCategory as 'prodclass',
    SKU.sSEMAPart as 'prodsubclass',
    SKU.sWebDescription as 'itemdesc_long',
    CASE    when PGC.ixMarket = 'R' then 'Race'
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
    tng.ixSOPSKUBase 'skubase',
    convert(varchar, SKU.dtDiscontinuedDate,101) as 'discontinued_date',
    (CASE WHEN SKU.dtDiscontinuedDate < GETDATE() THEN 'Y'
     ELSE 'N'
     END) AS 'discontinued'
FROM tblSKU SKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
    left join tblBrand B on SKU.ixBrand = B.ixBrand
    left join (SELECT *
                FROM openquery([TNGREADREPLICA], '
                SELECT DISTINCT SB.ixSOPSKUBase
                ,SV.ixSOPSKU
                FROM tblskubase SB 
                JOIN tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
                LEFT JOIN tblproductline PL ON PL.ixProductLine = SB.ixProductLine 
                LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand 
                 ')
                ) tng on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = tng.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
WHERE SKU.ixSKU in (SELECT distinct LBST.itemid FROM vwLBSampleTransactions LBST)
--and SKU.sBaseIndex COLLATE SQL_Latin1_General_CP1_CI_AS <> tng.ixSOPSKUBaseCOLLATE SQL_Latin1_General_CP1_CI_AS-- Finds SKUs that don't have matching bases
  

/********************************************************************************************* 
FILE #6 - transaction file data     file name: SMI - Transactions 01012009 to 08312019
                                    records: 10.6m-11.2m ^about 700k/mo   runtime: 46-180 sec 
*********************************************************************************************/
    SELECT * FROM vwLBSampleTransactions -- 11,668,539     @134 sec 
 
/************************************************************************************************** 
FILE #7 - Customer print opt-outs data     file name: SMI - Customer - Print Opt-Outs as of 08312019
                                           records: 73-77K  runtime: 3-9 sec 
****************************************************************************************************/
    SELECT distinct ixCustomer 'custid', -- 76,983
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

    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn                                          -- 14,189,507
    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'                 --     95,526
    SELECT FORMAT(COUNT(DISTINCT ixCustomer),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'--    29,217

/***************   INSPECT EACH FILE. Compare size, format, and row count to previous extract  ***************
File Summary:                                                                        /   QC CHECKS   \
                    Approx                                                          /                 \
    Approx          File                                                           /Size    Data       \
#   records         Size (MB)   File Name  (all end with  <'MM/DD/YYYY'>.txt        (MB)    Format  #Rec
==  ===========     =========   ===============================================     ====    ======  ====
1  20.0m-20.4m      650-690     SMI - Customer - Catalogs Mailed 01-01-2009 to      Y       Y       Y
2   940k-9600k       20-22      SMI - Customers 01-01-2009 to                       Y       Y       Y 
3    52k-53k        1.2-1.5     SMI - Merged Customers 01-01-2009 to                Y       Y       Y
4   277k-311k       5.8-6.2     SMI - SKU - Additional Markets 01-01-2009 to        Y       Y       Y
5   115k-122k        20-22      SMI - SKUs 01-01-2009 to                            Y       Y       Y
6  10.6m-11.2m      390-410     SMI - Transactions 01-01-2009 to                    Y       Y       Y
7    73K-76K        1.2-1.5     SMI - Customer - Print Opt-Outs as of               Y       Y       Y
    
/***********************************   ZIP & TRANSFER FILES VIA FTP   *********************************** 
   Zip the files ("NORMAL" compression [NOT WORTH COMPRESSING tighter than "NORMAL" level]
   naming convention: "SMI - dataset 01-01-2009 to 03-31-2019.7z"  file size approx 200MB, @5 mins to zip
   place in N:\Misc Items
    
    --TRANSMIT FILES TO LOYALTY BUILDERS via FTP using Filezilla.
        HOSTNAME: 52.91.54.151      OLD VALUE --> sftp://ftp.longbowdm.com    
        USERNAME = speedway     
        PW = yW4Sgwjj              PORT: 22

        approx 2 mins to transfer
    !!! VERIFY THE TRANSMITTED FILE SIZE MATCHES the size that was sent !!!!
        If any PW issues, call Al Trudell at (603)610-8810 albertt@loyaltybuilders.com

/***************************** SEND NOTIFICATION EMAIL  *****************************
TO: irenam@loyaltybuilders.com; albertt@loyaltybuilders.com; billv@loyaltybuilders.com; brianj@loyaltybuilders.com
CC: dwlee@speedwaymotors.com; ccchance@speedwaymotors.com; ascrook@speedwaymotors.com
SUBJECT: Newest dataset uploaded

Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is “SMI - dataset 01-01-2009 to 10-31-2018.7z”.   

It consists of the following 7 files appended with the date range used:
   RECORDS      FILENAME 
   ==========   ================================  
    #1 22,368,448   SMI - Customer - Catalogs Mailed 
    #2  1,215,451   SMI - Customers      
    #3     64,422   SMI - Merged Customers
    #4    311,343   SMI - SKU - Additional Markets
    #5    144,650   SMI - SKUs
    #6 11,668,539   SMI - Transactions
    #7     76,983   SMI - Customer - Print Opt-Outs

If there are any questions/concerns, email or call me prior to our next scheduled conference call. Please let us know as soon as Longbow has been refreshed with this dataset.

Thanks!

*** END **** /


