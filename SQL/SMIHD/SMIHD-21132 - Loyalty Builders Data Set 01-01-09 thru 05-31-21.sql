 /* SMIHD-21132 - Loyalty Builders Data Set 01-01-09 thru 05-31-21
        Monthly extracts for LB  (parent case SMIHD-4104)  

 */
-- EDIT > OUTLINING > HIDE SELECTION   to condense snippets of code
 /********************************************************************************************
1) alter vwLBTransactionsSalesAndCredits 
        change the end date to the FINAL DAY of PREVIOUS MONTH
        Do NOT put a function to calculate it because it SLOWS THE VIEW DOWN TOO MUCH.

2) run <9> Customer Merges under Reporting Feeds Menu in SOP 
 
3) NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  (transaction file has 12m+ records. Cust - Cats Mailed file has 22m+

4) EXPORT files in Mgmt Studio by selecting "RESULTS TO FILE"
 **********************************************************************************************/
SELECT @@SPID as 'Current SPID' -- 66 

 /***********************  PREP QUERIES   ****************************************/
    -- verify vwLBTransactionsSalesAndCredits pulls data through the end of prev month
        SELECT top 3 * FROM vwLBTransactionsSalesAndCredits where txdate = '05/31/2021' and amount > 0
        UNION
        SELECT top 3 * FROM vwLBTransactionsSalesAndCredits where txdate = '05/31/2021' and amount < 0 order by amount
         -- NO RESULTS for Credit Memmos (amounts < 0) for 05/30/21 and 05/31/21.  5/30 was a SUNDAY and 5/31 was a holiday so NO ISSUES

     
        SELECT CONVERT(VARCHAR(10), GETDATE(), 101) AS 'Date Ran  ', 
            FORMAT(COUNT(1),' ###,##0') 'Tot Rows', -- switched count(*) to count(1) 380 seconds instead of 618... this time
            FORMAT(count(distinct itemid),' ###,##0') 'DistinctItemIDs',
            FORMAT(count(distinct custid),' ###,##0') 'DistinctCustIDs'
        FROM vwLBTransactionsSalesAndCredits -- 88-540 sec    @292
        /*                       Distinct    Distinct
        Date Ran     Tot Rows 	 ItemIDs     CustIDs
        ==========   ==========  =======     =========
        06/04/2021	 14,795,301	 180,978	 1,685,163
        05/03/2021	 14,632,816	 179,555	 1,658,388

        04/02/2021	 14,446,379	 177,884	 1,627,686
        01/04/2021	 13,953,037	 172,588	 1,550,757

        08/03/2020	 13,339,771	 165,589	 1,439,112
        01/03/2020	 12,327,896	 150,712	 1,277,399

        07/03/2019	 11,460,020	 141,997	 1,182,689
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
        2021.06.04	2021.06.04 -- if Latest Merged date <> current, run <9> Customer Merges under Reporting Feeds Menu in SOP 
        */

    
        SELECT CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
            FORMAT( COUNT(*),'##,##0')  'TotCnt',
            FORMAT(COUNT(distinct ixCustomerOriginal),'##,##0')   'DistCnt',
            (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        FROM [SMI Reporting].dbo.tblMergedCustomers
        /*
        DateRan   	TotCnt	DistCnt	Dupes
        2021.06.04	71,369	71,369	0
        2021.05.03	70,934	70,934	0

        2021.01.04	69,428	69,428	0
        2020.01.03	65,836	65,836	0
        2019.01.03	60,930	60,930	0
        2018.01.03	51,440	51,440	0
        2017.01.04	44,998	44,998	0
        */


    -- import SKU/Market data FROM TNG
        -- SELECT FORMAT(COUNT(*),'###,###') 'SKUCnt' from [SMITemp].dbo.[PJC_SKUMarketsForLB]  
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB] 
        SELECT *                                        -- 310,083 @17 sec      big Qty change on 11/04/19 run see notes below  475,653    18-63 sec     
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
        2021.06.04	310,083
        2021.05.03	309,880
        2021.04.02	309,704

        2021.01.04	301,781
        2020.01.03	284,853
        2019.11.04	282,179 -- During October 2019, Ron & Wyatt removed a bunch of legacy data that had incorrect markets assinged to a lot of SKUs 
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
        RESULTS FROM 06-04-21 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        50,328	Street Rod
        46,541	Classic Truck
        44,239	Muscle Car
        38,963	T-Bucket
        30,927	Drag Racing
        30,917	Oval Track
        15,757	Truck Accessories
        13,181	Modern Muscle
        12,341	Sport Compact
        11,993	Off Road
        7,369	Demolition Derby
        4,008	Marine
        2,233	Open Wheel
        1,286	Pedal Car

        RESULTS FROM 05-03-21 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        50,324	Street Rod
        46,538	Classic Truck
        44,237	Muscle Car
        38,954	T-Bucket
        30,874	Drag Racing
        30,862	Oval Track
        15,752	Truck Accessories
        13,172	Modern Muscle
        12,330	Sport Compact
        11,977	Off Road
        7,351	Demolition Derby
        4,008	Marine
        2,215	Open Wheel
        1,286	Pedal Car


        RESULTS FROM 04-02-21 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        50,291	Street Rod
        46,503	Classic Truck
        44,221	Muscle Car
        38,926	T-Bucket
        30,870	Drag Racing
        30,835	Oval Track
        15,748	Truck Accessories
        13,172	Modern Muscle
        12,325	Sport Compact
        11,972	Off Road
        7,340	Demolition Derby
        4,007	Marine
        2,208	Open Wheel
        1,286	Pedal Car


        RESULTS FROM 01-04-21 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        48,130	Street Rod
        44,294	Classic Truck
        42,017	Muscle Car
        38,731	T-Bucket
        30,709	Drag Racing
        30,292	Oval Track
        15,707	Truck Accessories
        13,001	Modern Muscle
        12,297	Sport Compact
        11,935	Off Road
        7,314	Demolition Derby
        3,994	Marine
        2,074	Open Wheel
        1,286	Pedal Car

    
        RESULTS FROM 01-03-20 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        46,211	Street Rod
        42,674	Classic Truck
        40,174	Muscle Car
        37,825	T-Bucket
        29,706	Drag Racing
        29,270	Oval Track
        11,800	Modern Muscle
        11,687	Truck Accessories
        11,448	Off Road
        10,351	Sport Compact
        6,880	Demolition Derby
        3,964	Marine
        1,578	Open Wheel
        1,285	Pedal Car


        RESULTS FROM 11-04-19 RUN:      -- During October 2019, Ron & Wyatt removed a bunch of legacy data
        SKUCnt	ixMarket                   that had incorrect markets assinged to a lot of SKUs 
        ======  =================
        45,853	Street Rod
        42,331	Classic Truck
        39,870	Muscle Car
        37,618	T-Bucket
        29,544	Drag Racing
        29,145	Oval Track
        11,758	Modern Muscle
        11,653	Truck Accessories
        11,427	Off Road
        10,307	Sport Compact
        6,827	Demolition Derby
        3,955	Marine
        1,551	Open Wheel
        340	Pedal Car

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

   */
     
        
/********************************************************************************************  
FILE #1 - catalogs mailed to each cust w/market & SC   
                            file name:  SMI - Customer - Catalogs Mailed 01012009 to 05312021
                            records: 22.5m-23.2m         runtime: 7:20-31:37      
*********************************************************************************************/  
    SELECT DISTINCT co.ixCustomer as 'custid',     --  24,3732,52     @16:38
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
    	join vwLBTransactionsSalesAndCredits ST on ST.custid = co.ixCustomer
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    WHERE co.sType='OFFER'
	   and co.dtActiveStartDate between '01/01/2011' and '05/31/2021'   

       
/***************************************************************************** 
FILE #2 - CUSTOMER file      file name: SMI - Customers 01012009 to 05312021
                             records: 1.4-1.5m     runtime: 31-102 sec  
******************************************************************************/
    SELECT -- 1,685,164   @90 sec		
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (SELECT distinct custid 
                           FROM vwLBTransactionsSalesAndCredits)

                              
/*********************************************************************************************  
FILE #3 - Merged Customers    file name: SMI - Merged Customers 01012009 to 05312021
                              records: 65-67k       runtime: 3 sec   
**********************************************************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 71,173
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM tblMergedCustomers M
        join tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged


/*************************************************************************************************************  
FILE #4 - SKUs w/ advanced market info     file name: SMI - SKU - Additional Markets File 01012009 to 05312021
                                           records:   211k - 230k    runtime:   20-123 sec
**************************************************************************************************************/
    -- Data is imported FROM tng into [SMITemp].dbo.[PJC_SKUMarketsForLB] in the Prep Steps section above
    SELECT DISTINCT sm.ixSKU as 'itemid', -- 226,634  @123 sec     
	    sm.ixMarket as 'market'
    FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
    WHERE sm.ixSKU in (SELECT distinct itemid 
                        FROM vwLBTransactionsSalesAndCredits)
	    and sm.ixMarket is NOT NULL

/*********************************************************************************************
FILE #5 - SKU file                  file name: SMI - SKUs 01012009 to 05312021
                                    records: 166k-169k ^ about 1k/mo)       runtime: 60-171 sec
 *********************************************************************************************/
    SELECT SKU.ixSKU as 'itemid',   -- 180,978 @153 sec         
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
WHERE SKU.ixSKU in (SELECT distinct LBST.itemid FROM vwLBTransactionsSalesAndCredits LBST)
--and SKU.sBaseIndex COLLATE SQL_Latin1_General_CP1_CI_AS <> tng.ixSOPSKUBaseCOLLATE SQL_Latin1_General_CP1_CI_AS-- Finds SKUs that don't have matching bases
  

/********************************************************************************************* 
FILE #6 - transaction file data     file name: SMI - Transactions 01012009 to 05312021
                                    records: 13.4m-13.8m ^about 700k/mo   runtime: 46-274 sec 
*********************************************************************************************/
    SELECT * FROM vwLBTransactionsSalesAndCredits -- 14,795,302  @274 sec 
 
/************************************************************************************************** 
FILE #7 - Customer print opt-outs data     file name: SMI - Customer - Print Opt-Outs as of 05312021
                                           records: 75-78K  runtime: 3-17 sec 
****************************************************************************************************/
    SELECT distinct ixCustomer 'custid', -- 78,108
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

    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn                                          -- 17,244,275
    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'                 --     96,994
    SELECT FORMAT(COUNT(DISTINCT ixCustomer),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'--    29,603


/***************   INSPECT EACH FILE. Compare size, format, and row count to previous extract  ***************
File Summary:                                                                        /   QC CHECKS   \
                    Approx                                                          /                 \
    Approx          File                                                           /Size    Data       \
#   records         Size (MB)   File Name  (all end with  <'MM/DD/YYYY'>.txt        (MB)    Format  #Rec
==  ===========     =========   ===============================================     ====    ======  ====
1     23-24m        780-820     SMI - Customer - Catalogs Mailed 01-01-2009 to      Y       Y       Y
2    1.4-1.6m        32-35      SMI - Customers 01-01-2009 to                       Y       Y       Y
3     68-70k        1.2-1.5     SMI - Merged Customers 01-01-2009 to                Y       Y       Y
4    208-218k       4.3-5.3     SMI - SKU - Additional Markets 01-01-2009 to        Y       Y       Y
5    165-175k        31-34      SMI - SKUs 01-01-2009 to                            Y       Y       Y
6   13.2-14.2m      550-590     SMI - Transactions 01-01-2009 to                    Y       Y       Y
7     77-79k        1.2-1.5     SMI - Customer - Print Opt-Outs as of               Y       Y       Y   
    
7zip ENCRPTION PW = 4*Punw$Zt93T

/***********************************   ZIP & TRANSFER FILES VIA FTP   *********************************** 
   Zip the files - "FAST" compression
   naming convention: "SMI - dataset 01-01-2009 to 05-31-2019.7z"  file size approx 200MB, @5 mins to zip
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

Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is �SMI - dataset 01-01-2009 to 05-31-2020.7z�.   

It consists of the following 7 files appended with the date range used:
   RECORDS      FILENAME 
   ==========   ================================  
    #1 24,3732,52   SMI - Customer - Catalogs Mailed 
    #2  1,685,164   SMI - Customers      
    #3     71,173   SMI - Merged Customers
    #4    226,634   SMI - SKU - Additional Markets
    #5    180,978   SMI - SKUs
    #6 14,795,302   SMI - Transactions
    #7     78,108   SMI - Customer - Print Opt-Outs

If there are any questions/concerns, email or call me as soon as possible. 

Thanks!

*** END **** /
