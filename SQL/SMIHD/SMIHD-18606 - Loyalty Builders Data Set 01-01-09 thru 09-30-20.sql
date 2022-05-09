 /* SMIHD-18606 - Loyalty Builders Data Set 01-01-09 thru 09-30-20
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
SELECT @@SPID as 'Current SPID' -- 60 

 /***********************  PREP QUERIES   ****************************************/
    -- verify vwLBTransactionsSalesAndCredits pulls data through the end of prev month
        SELECT top 3 * FROM vwLBTransactionsSalesAndCredits where txdate = '09/30/2020' and amount > 0
        UNION
        SELECT top 3 * FROM vwLBTransactionsSalesAndCredits where txdate = '09/30/2020' and amount < 0 order by amount

     
        SELECT CONVERT(VARCHAR(10), GETDATE(), 101) AS 'Date Ran  ', 
            FORMAT(COUNT(*),' ###,##0') 'Tot Rows',
            FORMAT(count(distinct itemid),' ###,##0') 'DistinctItemIDs',
            FORMAT(count(distinct custid),' ###,##0') 'DistinctCustIDs'
        FROM vwLBTransactionsSalesAndCredits -- 88-183 sec           174
        /*                       Distinct    Distinct
        Date Ran     Tot Rows 	 ItemIDs     CustIDs
        ==========   ==========  =======     =========
        10/02/2020	 13,605,822	 168,760	 1,486,535
        09/03/2020	 13,482,024	 167,371	 1,464,091
        08/03/2020	 13,339,771	 165,589	 1,439,112
        06/03/2020	 13,028,026	 162,121	 1,386,098
        05/04/2020	 12,855,860	 160,310	 1,356,451
        04/03/2020	 12,682,944	 154,693	 1,327,029
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
        2020.10.02	2020.10.02  -- if Latest Merged date <> current, run <9> Customer Merges under Reporting Feeds Menu in SOP 
        */

    
        SELECT CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
            FORMAT( COUNT(*),'##,##0')  'TotCnt',
            FORMAT(COUNT(distinct ixCustomerOriginal),'##,##0')   'DistCnt',
            (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        FROM [SMI Reporting].dbo.tblMergedCustomers
        /*
        DateRan   	TotCnt	DistCnt	Dupes
        2020.10.02	68,389	68,389	0
        2020.09.03	68,035	68,035	0
        2020.08.03	67,580	67,580	0
        2020.06.03	66,911	66,911	0

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
        SELECT *                                        -- 295,360 @16 sec   big Qty change on 11/04/19 run see notes below  475,653    18-54 sec     
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
        2020.10.02	295,360
        2020.09.03	294,882
        2020.08.03	289,703
        2020.06.03	289,218
        2020.04.03	287,173

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
        RESULTS FROM 10-02-20 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        47,370	Street Rod
        43,524	Classic Truck
        41,236	Muscle Car
        38,406	T-Bucket
        30,216	Drag Racing
        29,892	Oval Track
        15,579	Truck Accessories
        12,635	Modern Muscle
        11,700	Off Road
        10,651	Sport Compact
        7,100	Demolition Derby
        3,935	Marine
        1,832	Open Wheel
        1,284	Pedal Car


        RESULTS FROM 09-03-20 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        47,292	Street Rod
        43,447	Classic Truck
        41,166	Muscle Car
        38,345	T-Bucket
        30,168	Drag Racing
        29,858	Oval Track
        15,574	Truck Accessories
        12,602	Modern Muscle
        11,672	Off Road
        10,635	Sport Compact
        7,085	Demolition Derby
        3,931	Marine
        1,823	Open Wheel
        1,284	Pedal Car



        RESULTS FROM 08-03-20 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        46,959	Street Rod
        43,420	Classic Truck
        40,837	Muscle Car
        38,333	T-Bucket
        30,131	Drag Racing
        29,816	Oval Track
        12,289	Modern Muscle
        11,857	Truck Accessories
        11,596	Off Road
        10,544	Sport Compact
        6,980	Demolition Derby
        3,929	Marine
        1,728	Open Wheel
        1,284	Pedal Car



        RESULTS FROM 04-03-20 RUN:      
        SKUCnt	ixMarket                  
        ======  =================
        46,538	Street Rod
        43,018	Classic Truck
        40,454	Muscle Car
        38,027	T-Bucket
        29,832	Drag Racing
        29,567	Oval Track
        12,255	Modern Muscle
        11,811	Truck Accessories
        11,479	Off Road
        10,387	Sport Compact
        6,914	Demolition Derby
        3,976	Marine
        1,627	Open Wheel
        1,288	Pedal Car

        
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
                            file name:  SMI - Customer - Catalogs Mailed 01012009 to 09302020
                            records: 22.5m-23.2m         runtime: 7:20-31:37      
*********************************************************************************************/  
    SELECT DISTINCT co.ixCustomer as 'custid',     --  23,530,259    @26:58
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
	   and co.dtActiveStartDate between '01/01/2011' and '09/30/2020'   


/***************************************************************************** 
FILE #2 - CUSTOMER file      file name: SMI - Customers 01012009 to 09302020
                             records: 1.4-1.5m     runtime: 11-69 sec  
******************************************************************************/
    SELECT -- 1,486,534   @65 sec		
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (SELECT distinct custid 
                           FROM vwLBTransactionsSalesAndCredits)

                              
/*********************************************************************************************  
FILE #3 - Merged Customers    file name: SMI - Merged Customers 01012009 to 09302020
                              records: 65-67k       runtime: 3 sec   
**********************************************************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 68,192
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM tblMergedCustomers M
        join tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged


/*************************************************************************************************************  
FILE #4 - SKUs w/ advanced market info     file name: SMI - SKU - Additional Markets File 01012009 to 09302020
                                           records:   211k - 230k    runtime:   10-40 sec
**************************************************************************************************************/
    -- Data is imported FROM tng into [SMITemp].dbo.[PJC_SKUMarketsForLB] in the Prep Steps section above
    -- create output for LB file               
    SELECT DISTINCT sm.ixSKU as 'itemid', -- 212,814  @28 sec     
	    sm.ixMarket as 'market'
    FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
    WHERE sm.ixSKU in (SELECT distinct itemid 
                        FROM vwLBTransactionsSalesAndCredits)
	    and sm.ixMarket is NOT NULL

/*********************************************************************************************
FILE #5 - SKU file                  file name: SMI - SKUs 01012009 to 09302020
                                    records: 166k-169k ^ about 1k/mo)       runtime: 60-132 sec
 *********************************************************************************************/
    SELECT SKU.ixSKU as 'itemid',-- 168,760 @99 sec
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
FILE #6 - transaction file data     file name: SMI - Transactions 01012009 to 09302020
                                    records: 13.4m-13.8m ^about 700k/mo   runtime: 46-180 sec 
*********************************************************************************************/
    SELECT * FROM vwLBTransactionsSalesAndCredits -- 13,605,818    @172 sec 
 
/************************************************************************************************** 
FILE #7 - Customer print opt-outs data     file name: SMI - Customer - Print Opt-Outs as of 09302020
                                           records: 75-78K  runtime: 3-9 sec 
****************************************************************************************************/
    SELECT distinct ixCustomer 'custid', -- 77,711
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

    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn                                          -- 15,927,599
    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'                 --     96,483
    SELECT FORMAT(COUNT(DISTINCT ixCustomer),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'--    29,470


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

Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is “SMI - dataset 01-01-2009 to 05-31-2020.7z”.   

It consists of the following 7 files appended with the date range used:
   RECORDS      FILENAME 
   ==========   ================================  
#1 1,486,534   SMI - Customer - Catalogs Mailed 
#2  1,486,534   SMI - Customers      
#3     68,192   SMI - Merged Customers
#4    212,814   SMI - SKU - Additional Markets   
#5    168,760   SMI - SKUs
#6 13,605,818   SMI - Transactions
#7     77,711   SMI - Customer - Print Opt-Outs

If there are any questions/concerns, email or call me as soon as possible. 

Thanks!

*** END **** /
