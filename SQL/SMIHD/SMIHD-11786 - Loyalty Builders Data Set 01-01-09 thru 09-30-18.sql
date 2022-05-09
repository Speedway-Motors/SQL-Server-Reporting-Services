 /* SMIHD-11786 - Loyalty Builders Data Set 01-01-09 thru 09-30-18
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

 /***********************  PREP QUERIES   ****************************************/
    -- verify vwLBSampleTransactions pulls data through the end of prev month
        select top 25 * from vwLBSampleTransactions
        where txdate = '09/30/2018' 
        
     
        select CONVERT(VARCHAR(10), GETDATE(), 101) AS 'DateRan   ', 
            FORMAT(COUNT(*),' ###,##0') 'TotRows ',
            FORMAT(count(distinct itemid),' ###,##0') 'DistinctItemIDs',
            FORMAT(count(distinct custid),' ###,##0') 'DistinctCustIDs'
        from vwLBSampleTransactions -- 77-154 sec           154
        /*                      Distinct    Distinct
        DateRan	    TotRows 	ItemIDs     CustIDs
        ==========  =========   =======     =========
        10/03/2018 10,483,152	128,202	    1,032,249
        09/04/2018 10,407,899	126,973	    1,018,584
        08/03/2018 10,297,690	125,350	    1,002,396
        07/03/2018 10,188,002	123,651	      986,417
        06/04/2018 10,074,445	121,872	      970,297
        05/03/2018	9,953,611	119,955	      954,036
        04/04/2018	9,820,739	117,724	      937,205
        01/03/2018	9,467,813	111,407	      895,533
        10/03/2017	9,228,587	107,050	      864,014
        07/03/2017	8,942,735	102,485	      831,513
        04/04/2017	8,587,251	 96,846	      796,940
        01/04/2017	8,240,767	 90,918	      765,784
        10/04/2016	8,017,246	 86,756	      741,614
        07/05/2016	7,741,766	 82,922	      713,711
        04/04/2016	7,272,482	 77,326      ?
        */


    -- MERGED CUSTOMERS
        -- recency check
        SELECT MAX(CONVERT(VARCHAR, dtDateMerged, 102) ) 'LatestMerged',
        MIN(CONVERT(VARCHAR, dtDateLastSOPUpdate, 102) ) 'OldestUpdated'
        from [SMI Reporting].dbo.tblMergedCustomers 
        /*
        Latest      Oldest
        Merged	    Updated
        2018.10.03	2018.10.03   -- if Latest Merged date <> current, run <9> Customer Merges under Reporting Feeds Menu in SOP 
        */
    
    
        SELECT CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
            FORMAT( COUNT(*),'##,##0')  'TotCnt',
            FORMAT(COUNT(distinct ixCustomerOriginal),'##,##0')   'DistCnt',
            (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        from [SMI Reporting].dbo.tblMergedCustomers
        /*
        DateRan   	TotCnt	DistCnt	Dupes
        2018.10.03	56,515	56,515	0
        2018.09.04	54,638	54,638	0
        2018.08.03	53,367	53,367	0
        2018.07.03	53,072	53,072	0
        2018.06.04	52,773	52,773	0
        2018.05.03	52,493	52,493	0
        2018.04.04	52,217	52,217	0
        2018.01.03	51,440	51,440	0
        2017.07.03	49,681	49,681	0
        2017.01.04	44,998	44,998	0
        2016.04.04	40,858	40,858	0        
        */


    -- import SKU/Market data from TNG
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB] 
        select *                                        -- 444,108  21-54 seconds			23 sec
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
            FORMAT( COUNT(*),'##,##0') 'Records'
        from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
        /*
        Date Ran   	Records
        ==========  =======
        2018.10.03	444,108
        2018.09.04	443,974
        2018.08.03	443,462
        2018.07.03	435,735
        2018.06.04	434,979
        2018.04.04	432,990
        2018.03.02	491,842
        2018.01.03	490,135
        2017.07.03	469,629
        2017.01.04	437,515
        2016.10.04	403,098 <-- started pulling from tblskubasemarket AND tblskubase_universal_market now
        2016.07.05  413,324
        */
                    
        select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]

        
        SELECT FORMAT( COUNT(ixSKU),'##,##0')  'SKUCnt', ixMarket  -- 14 Markets
        FROM [SMITemp].dbo.[PJC_SKUMarketsForLB]
        GROUP BY ixMarket
        ORDER BY COUNT(ixSKU) desc
        /*

        RESULTS FROM 10-03-18 RUN:
        SKUCnt	ixMarket
        ======  =================
        78,983	Street Rod
        70,439	Classic Truck
        69,920	T-Bucket
        69,246	Muscle Car
        66,337	Oval Track
        40,719	Drag Racing
        10,191	Off Road
        9,671	Modern Muscle
        9,473	Truck Accessories
        9,241	Sport Compact
        4,846	Demolition Derby
        3,292	Marine
        1,458	Pedal Car
          292	Open Wheel



        RESULTS FROM 07-03-18 RUN:
        SKUCnt	ixMarket
        ======  =================
        77,947	Street Rod
        69,180	T-Bucket
        67,764	Classic Truck
        66,465	Muscle Car
        66,232	Oval Track
        40,596	Drag Racing
        10,076	Off Road
        9,493	Modern Muscle
        9,219	Sport Compact
        9,071	Truck Accessories
        4,721	Demolition Derby
        3,280	Marine
        1,449	Pedal Car
        242	    Open Wheel

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
                            file name:  SMI - Customer - Catalogs Mailed 01012009 to 09302018
                            records: 19.5M-21.2M        runtime: 7:20-16:07        
*********************************************************************************************/  
    SELECT -- 21,099,342    @11:43
             -- 21,091,141 CURRENT RUN THRU 9/30/18    
             -- 21,090,861
             -- created INDEX [IX_tblCustomerOffer_sType_dtActiveStartDate_Include] 10/03/18
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
	    end as 'catalog_market',
	    co.ixSourceCode 'source_code'   -- added 5/4/17 per 
    FROM tblCustomerOffer co
    	join vwLBSampleTransactions ST on ST.custid = co.ixCustomer
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    WHERE co.sType='OFFER'
	    and co.dtActiveStartDate between '01/01/2011' and '08/31/2018'   

/***************************************************************************** 
FILE #2 - CUSTOMER file      file name: SMI - Customers 01012009 to 09302018
                             records: 865-1.1M     runtime: 11-44 sec  
******************************************************************************/
    SELECT -- 1,032,222    @16 sec		
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (select distinct custid 
                           from vwLBSampleTransactions)

                              
/*********************************************************************************************  
FILE #3 - Merged Customers    file name: SMI - Merged Customers 01012009 to 09302018
                              records: 52K-55K       runtime: 3 sec   
**********************************************************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 56,286
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM tblMergedCustomers M
        join tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged


/*************************************************************************************************************  
FILE #4 - SKUs w/ advanced market info     file name: SMI - SKU - Additional Markets File 01012009 to 09302018
                                           records:   255 - 294    runtime:   10-40 sec
**************************************************************************************************************/
    -- Data is imported from tng into [SMITemp].dbo.[PJC_SKUMarketsForLB] in the Prep Steps section above
    -- create output for LB file               
    SELECT DISTINCT sm.ixSKU as 'itemid', -- 291,262 @10 sec     
	    sm.ixMarket as 'market'
    FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
    WHERE sm.ixSKU in (select distinct itemid 
                        from vwLBSampleTransactions)
	    and sm.ixMarket is NOT NULL

/*********************************************************************************************
FILE #5 - SKU file                  file name: SMI - SKUs 01012009 to 09302018
                                    records: 1185-128k^ about 1k/mo)       runtime: 58-98 sec
 *********************************************************************************************/
    SELECT SKU.ixSKU as 'itemid',-- 128,202 @58 sec
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

  

/********************************************************************************************* 
FILE #6 - transaction file data     file name: SMI - Transactions 01012009 to 09302018
                                    records: 10m-10.6m ^about 700k/mo   runtime: 46-180 sec 
*********************************************************************************************/
    SELECT * from vwLBSampleTransactions -- 10,483,153     @127 sec 
 
 /************************************************************************************************** 
FILE #7 - Customer print opt-outs data     file name: SMI - Customer - Print Opt-Outs as of 09302018
                                           records: 73-77K  runtime: 3 sec 
****************************************************************************************************/

    SELECT distinct ixCustomer 'custid', -- 76,399
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


    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn                                              -- 12,949,757
    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'                     --     94,744
    SELECT FORMAT(COUNT(DISTINCT ixCustomer),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'   --     28,984

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
6   9.8m-10.0m      390-410     SMI - Transactions 01-01-2009 to                    Y       Y       Y  
7    73K-76K        1.2-1.5     SMI - Customer - Print Opt-Outs as of               Y       
8  NO LONGER SENT     n/a       SMI - SKUs and Applications                         n/a     n/a     n/a
    
/***********************************   ZIP & TRANSFER FILES VIA FTP   *********************************** 
   Zip the files ("NORMAL" compression [NOT WORTH COMPRESSING tighter than "NORMAL" level]
   naming convention: "SMI - dataset 01-01-2009 to 09-30-2018.7z"  file size approx 195MB, @5 mins to zip) 
   place in N:\Misc Items
    
    --TRANSMIT FILES TO LOYALTY BUILDERS  
        access the secured ftp account using Filezilla.
        hostname: sftp://ftp.longbowdm.com  
        Username = speedway     PW = yW4Sgwjj
        approx 4-5 mins to transfer

    !!! VERIFY THE TRANSMITTED FILE SIZE MATCHES the size that was sent !!!!

If any PW issues, call Al Trudell at (603)610-8810 albertt@loyaltybuilders.com
*********************************************************************************************************/

/******************************** SEND NOTIFICATION EMAIL  ********************************
TO: irenam@loyaltybuilders.com; albertt@loyaltybuilders.com; billv@loyaltybuilders.com; brianj@loyaltybuilders.com
CC: dwlee@speedwaymotors.com; ccchance@speedwaymotors.com; ascrook@speedwaymotors.com
SUBJECT: Newest dataset uploaded

Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is “SMI - dataset 01-01-2009 to 11-30-2017.7z”.   

It consists of the following 7 files appended with the date range used:
   RECORDS      FILENAME 
   ==========   ================================  
#1 21,091,141   SMI - Customer - Catalogs Mailed 
#2  1,032,222   SMI - Customers      
#3     56,286   SMI - Merged Customers
#4    291,262   SMI - SKU - Additional Markets
#5    128,202   SMI - SKUs
#6 10,483,153   SMI - Transactions
#7     76,399   SMI - Customer - Print Opt-Outs

If there are any questions/concerns, email or call me prior to our next scheduled conference call. Please let us know as soon as Longbow has been refreshed with this dataset.

Thanks!

*** END **** /


