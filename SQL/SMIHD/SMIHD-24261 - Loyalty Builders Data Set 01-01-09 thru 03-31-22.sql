 /* SMIHD-24261 - Loyalty Builders Data Set 01-01-09 thru 03-31-22
        Monthly extracts for LB  (parent case SMIHD-4104)  

 */
-- EDIT > OUTLINING > HIDE SELECTION   to condense snippets of code
 /********************************************************************************************
1) alter vwLBTransactionsSalesAndCredits 
        change the end date to the FINAL DAY of PREVIOUS MONTH
        Do NOT put a function to calculate it because it SLOWS THE VIEW DOWN TOO MUCH.

2) run <9> Customer Merges under Reporting Feeds Menu in SOP  -- about 4 mins to run
    
3) NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  (transaction file has 12m+ records. Cust - Cats Mailed file has 22m+

4) EXPORT files in Mgmt Studio by selecting "RESULTS TO FILE"
 **********************************************************************************************/
SELECT @@SPID as 'Current SPID' -- 126 

 /***********************  PREP QUERIES   ****************************************/
    -- verify vwLBTransactionsSalesAndCredits pulls data through the end of prev month
        /* extract files that use vwLBTransactionsSalesAndCredits
            #1 - Customer - Catalogs Mailed
            #2 - Customers
            #4 - Additional Markets File
            #5 - SKUs
            #6 - Transactions
        */
        SELECT top 3 * FROM vwLBTransactionsSalesAndCredits where txdate = '03/31/2022' and amount > 0
        UNION
        SELECT top 3 * FROM vwLBTransactionsSalesAndCredits where txdate = '03/31/2022' and amount < 0
         -- NO RESULTS for Credit Memmos (amounts < 0) for 05/30/21 and 05/31/21.  5/30 was a SUNDAY and 5/31 was a holiday so NO ISSUES

     
        SELECT CONVERT(VARCHAR(10), GETDATE(), 101) AS 'Date Ran  ', 
            FORMAT(COUNT(1),' ###,##0') 'Tot Rows', -- switched count(*) to count(1) 380 seconds instead of 618... this time
            FORMAT(count(distinct itemid),' ###,##0') 'DistinctItemIDs',
            FORMAT(count(distinct custid),' ###,##0') 'DistinctCustIDs'
        FROM vwLBTransactionsSalesAndCredits -- 88-760 sec    @633
        /*                       Distinct    Distinct
        Date Ran     Tot Rows 	 ItemIDs     CustIDs
        ==========   ==========  =======     =========
		04/04/2022	 16,471,729	 192,459	 1,892,197
		03/03/2022	 16,296,264	 191,021	 1,866,587
        01/03/2022	 16,035,490	 188,843	 1,828,980
        07/02/2021	 14,944,153	 182,156	 1,708,720

        01/04/2021	 13,953,037	 172,588	 1,550,757
        01/03/2020	 12,327,896	 150,712	 1,277,399
        01/03/2019	 10,740,831	 132,510	 1,075,751
        01/03/2018	  9,467,813	 111,407	   895,533
        01/04/2017	  8,240,767	  90,918	   765,784
        */

    -- MERGED CUSTOMERS
        -- recency check
        SELECT MAX(CONVERT(VARCHAR, dtDateMerged, 102) ) 'LatestMerged',
        MIN(CONVERT(VARCHAR, dtDateLastSOPUpdate, 102) ) 'OldestUpdated'
        FROM [SMI Reporting].dbo.tblMergedCustomers 
        /*
        Latest      Oldest
        Merged	    Updated
        2022.04.04	2022.04.04 -- if Latest Merged date <> current, run <9> Customer Merges under Reporting Feeds Menu in SOP 
        */

    
        SELECT CONVERT(VARCHAR, GETDATE(), 102) AS 'DateRan   ', 
            FORMAT( COUNT(*),'##,##0')  'TotCnt',
            FORMAT(COUNT(distinct ixCustomerOriginal),'##,##0')   'DistCnt',
            (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        FROM [SMI Reporting].dbo.tblMergedCustomers
        /*
        DateRan   	TotCnt	DistCnt	Dupes
        ==========  ======  ======  =====
		2022.04.04	96,891	96,891	0
		2022.03.03	96,189	96,189	0
        2022.01.03	94,399	94,399	0

        2021.07.02	72,392	72,392	0

        2021.01.04	69,428	69,428	0
        2020.01.03	65,836	65,836	0
        2019.01.03	60,930	60,930	0
        2018.01.03	51,440	51,440	0
        2017.01.04	44,998	44,998	0
        */


    -- import SKU/Market data FROM TNG
         -- history below
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB] 
        SELECT *                                        -- 352,214 @26sec     18-63 sec       
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
		2022.04.04	352,214
		2022.03.03	349,179
		2022.02.03	344,876
        2022.01.03	332,706

        2021.07.02	310,676

        2021.01.04	301,781
        2020.01.03	284,853
        2019.11.04	282,179 -- During October 2019, Ron & Wyatt removed a bunch of legacy data that had incorrect markets assinged to a lot of SKUs 
        2019.01.03	448,545
        */
                    
        SELECT top 10 * FROM [SMITemp].dbo.[PJC_SKUMarketsForLB]

        
        SELECT FORMAT( COUNT(ixSKU),'##,##0')  'SKUCnt', ixMarket  
        FROM [SMITemp].dbo.[PJC_SKUMarketsForLB]
        GROUP BY ixMarket
        ORDER BY COUNT(ixSKU) desc -- 14 Markets
        /*
        SKUCnt	ixMarket                  
        ======  =================	RAN 04-04-22
		55,967	Hot Rod
		52,187	Classic Truck
		47,996	Muscle Car
		43,388	T-Bucket
		35,966	Drag Racing
		33,084	Oval Track
		20,939	Truck Accessories
		17,167	Modern Muscle
		14,011	Off Road
		13,878	Sport Compact
		8,280	Demolition Derby
		4,158	Marine
		3,877	Open Wheel
		1,316	Pedal Car


        SKUCnt	ixMarket                  
        ======  =================	RAN 03-03-22
		55,584	Hot Rod
		51,812	Classic Truck
		47,612	Muscle Car
		43,124	T-Bucket
		35,650	Drag Racing
		32,911	Oval Track
		20,686	Truck Accessories
		16,889	Modern Muscle
		13,800	Off Road
		13,753	Sport Compact
		8,182	Demolition Derby
		4,090	Marine
		3,774	Open Wheel
		1,312	Pedal Car


   
        SKUCnt	ixMarket                  
        ======  =================	RAN 01-03-22
        52,810	Hot Rod
        49,026	Classic Truck
        46,691	Muscle Car
        41,643	T-Bucket
        34,180	Drag Racing
        32,450	Oval Track
        18,105	Truck Accessories
        15,035	Modern Muscle
        13,391	Sport Compact
        12,668	Off Road
        7,930	Demolition Derby
        4,076	Marine
        3,394	Open Wheel
        1,307	Pedal Car

   
        SKUCnt	ixMarket                  
        ======  =================	RAN 07-02-21
        50,491	Hot Rod
        46,710	Classic Truck
        44,396	Muscle Car
        38,979	T-Bucket
        30,952	Drag Racing
        30,934	Oval Track
        15,757	Truck Accessories
        13,181	Modern Muscle
        12,357	Sport Compact
        12,014	Off Road
        7,371	Demolition Derby
        4,008	Marine
        2,240	Open Wheel
        1,286	Pedal Car


    
        RESULTS FROM 01-03-20 RUN:      
        SKUCnt	ixMarket                  
        ======  =================	RAN 07-02-21
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
   */
     
        
/*************************************************************************************************  
FILE #1 - catalogs mailed to each cust w/market & SC   
                            file name:  SMI - Customer - Catalogs Mailed 01012009 to 03312022
                            records: 23.5m-24.4m         runtime: 14:52-38:56   pre 2022-> 7:20-45:28      
**************************************************************************************************/  
    SELECT DISTINCT co.ixCustomer as 'custid',     --  24,906,433 @17:10
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
	    co.ixSourceCode 'source_code'  
    FROM tblCustomerOffer co
    	join vwLBTransactionsSalesAndCredits ST on ST.custid = co.ixCustomer
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    WHERE co.sType='OFFER'
	   and co.dtActiveStartDate between '01/01/2011' and '03/31/2022'   
              
/************************************************************************************************* 
FILE #2 - CUSTOMER file      file name: SMI - Customers 01012009 to 03312022
                             records: 1.8-1.9m     runtime: 181-393 sec       pre 2022-> 31-244 sec
**************************************************************************************************/
    SELECT -- 1,892,195   @149 sec		
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (SELECT distinct custid 
                           FROM vwLBTransactionsSalesAndCredits)

                             
/*********************************************************************************************  
FILE #3 - Merged Customers    file name: SMI - Merged Customers 01012009 to 03312022
                              records: 93-95k       runtime: 1-3 sec   
**********************************************************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 96,703
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM tblMergedCustomers M
        join tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged


/*************************************************************************************************************  
FILE #4 - SKUs w/ advanced market info     file name: SMI - SKU - Additional Markets File 01012009 to 03312022
                                           records: 230-237k    runtime: 76-471 sec      pre 2022-> 20-123 sec
**************************************************************************************************************/
    -- Data is imported FROM tng into [SMITemp].dbo.[PJC_SKUMarketsForLB] in the Prep Steps section above
    SELECT DISTINCT sm.ixSKU as 'itemid', -- 241,788  @111 sec     
	    sm.ixMarket as 'market'
    FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
    WHERE sm.ixSKU in (SELECT distinct itemid 
                       FROM vwLBTransactionsSalesAndCredits)
	    and sm.ixMarket is NOT NULL

/***************************************************************************************************************
FILE #5 - SKU file                  file name: SMI - SKUs 01012009 to 03312022
                                    records: 187-190k ^about 1k/mo)  runtime: 129-387 sec  pre 2022->  60-171 sec
 ***************************************************************************************************************/
    SELECT SKU.ixSKU as 'itemid',   -- 192,459 @350 sec    -- 58 minutes!?!   replaced OPENQUERY with direct calls and completed in 4:30      
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
				when PGC.ixMarket = 'MC' then 'Muscle Care' 
			ELSE 'OTHER' -- to catch any new markets
		end as 'primary_market',
		SKU.ixBrand 'brandid',
		B.sBrandDescription 'brand_description',
		tng.ixSOPSKUBase 'skubase',
		convert(varchar, SKU.dtDiscontinuedDate,101) as 'discontinued_date',
		(CASE WHEN SKU.dtDiscontinuedDate < GETDATE() THEN 'Y'
		 ELSE 'N'
		 END) AS 'discontinued'
-- INTO #SKUEXTRACT
	FROM tblSKU SKU
		left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
		left join tblBrand B on SKU.ixBrand = B.ixBrand
		left join (SELECT DISTINCT SB.ixSOPSKUBase
					,SV.ixSOPSKU
					FROM [DW.SPEEDWAY2.COM].DW.tngLive.tblskubase SB 
						JOIN [DW.SPEEDWAY2.COM].DW.tngLive.tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
						LEFT JOIN [DW.SPEEDWAY2.COM].DW.tngLive.tblproductline PL ON PL.ixProductLine = SB.ixProductLine 
						LEFT JOIN [DW.SPEEDWAY2.COM].DW.tngLive.tblbrand B ON B.ixBrand = SB.ixBrand 
				   ) tng on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = tng.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
	WHERE SKU.ixSKU in (SELECT distinct LBST.itemid FROM vwLBTransactionsSalesAndCredits LBST)

/********************************************************************************************************************* 
FILE #6 - transaction file data     file name: SMI - Transactions 01012009 to 03312022
                                    records: 15.5-16.1m ^about 700k/mo   runtime: 109-755 sec     pre 2022-> 46-274 sec 
*********************************************************************************************************************/
    SELECT * FROM vwLBTransactionsSalesAndCredits -- 16,471,731  @109 sec 
 
/************************************************************************************************** 
FILE #7 - Customer print opt-outs data     file name: SMI - Customer - Print Opt-Outs as of 03312022
                                           records: 75-78K  runtime: 19-35 sec   pre 2022->  3-17 sec
****************************************************************************************************/
    SELECT distinct ixCustomer 'custid', -- 78,502 @39 sec  
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
        
    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn                                          -- 18,681,119
    SELECT FORMAT(COUNT(*),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'                 --     97,517
    SELECT FORMAT(COUNT(DISTINCT ixCustomer),'###,##0') FROM tblMailingOptIn WHERE sOptInStatus = 'N'--    29,738

/***************   INSPECT EACH FILE. Compare size, format, and row count to previous extract  ***************
File Summary:                                                                        /   QC CHECKS   \
                    Approx                                                          /                 \
    Approx          File                                                           /Size    Data       \
#   records         Size (MB)   File Name  (all end with  <'MM/DD/YYYY'>.txt        (MB)    Format  #Rec
==  ===========     =========   ===============================================     ====    ======  ====
1     23-25m        780-820     SMI - Customer - Catalogs Mailed 01-01-2009 to      Y		Y		Y
2    1.8-1.9m        32-35      SMI - Customers 01-01-2009 to                       Y		Y		Y
3     93-95k        1.2-1.5     SMI - Merged Customers 01-01-2009 to                Y		Y		Y
4    230-240k       4.3-5.3     SMI - SKU - Additional Markets 01-01-2009 to        Y		Y		Y
5    187-190k        31-34      SMI - SKUs 01-01-2009 to                            Y		Y		Y
6   15.8-16.2m      550-590     SMI - Transactions 01-01-2009 to                    Y		Y		Y
7     77-79k        1.2-1.5     SMI - Customer - Print Opt-Outs as of               Y		Y		Y
    

/***********************************   ZIP & TRANSFER FILES VIA FTP   *********************************** 
   Zip the files - "FAST" compression
   naming convention: "SMI - dataset 01-01-2009 to 03-31-2021.7z"  size approx 445MB, @35 sec to zip
   7zip ENCRPTION PW = 4*Punw$Zt93T
   PLACE COPY IN N:\Misc Items\LB Data Extracts
    
    --TRANSMIT FILES TO LB via FTP using Filezilla.
        HOSTNAME: 72.55.241.230		 PORT: 22
        USERNAME = speedway			PW = yW4Sgwjj     
                    
        approx 2 mins to transfer
    !!! VERIFY THE TRANSMITTED FILE SIZE MATCHES the size that was sent !!!!
        If any PW issues, call Al Trudell at (603)610-8810 albertt@loyaltybuilders.com

/***************************** SEND NOTIFICATION EMAIL  *****************************

   RECORDS      FILENAME 
   ==========   ================================  
#1 24,906,433   SMI - Customer - Catalogs Mailed 
#2  1,892,195   SMI - Customers   
#3     96,703   SMI - Merged Customers
#4    244,216   SMI - SKU - Additional Markets
#5    192,459   SMI - SKUs
#6 16,471,731   SMI - Transactions
#7     78,502   SMI - Customer - Print Opt-Outs

*/