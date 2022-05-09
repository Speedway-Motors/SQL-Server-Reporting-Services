 /* SMIHD-5112 -  Loyalty Builders Data Set 01-01-09 thru 07-31-16 
        This is the standard monthly extract for LB
 */
 
 /********************************************************************************************
1) alter vwLBSampleTransactions on LNK-DWSTAGING1 
        change the end date to the final day of the previous month (or the previous day if this is a pull outside the normal delivery schedule)
        do NOT put a function to calculate it because it SLOWS THE VIEW DOWN TOO MUCH.
 
2) run everything else on DW1
 
3) NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+

4) EXPORT files in Mgmt Studio by selecting "RESULTS TO FILE"

 **********************************************************************************************/

    -- vwLBSampleTransactions (now contains data from 1/1/2009 to 07/31/16)
        select top 25 * from vwLBSampleTransactions -- where txdate LIKE '07%2016' 
        where txdate = '07/31/2016' --'= '07/31/2016' -- latest date being used in the extract
        
    

        select CONVERT(VARCHAR(10), GETDATE(), 101) AS 'DateRan   ', 
            COUNT(*) 'TotRows ',
            count(distinct itemid) 'DistinctItemIDs',
            count(distinct custid) 'DistinctCustIDs'
        from vwLBSampleTransactions -- 27-110 sec
        /*                      Distinct    Distinct
        DateRan	    TotRows 	ItemIDs     CustIDs
        08/03/2016	7,840,518	84,226		723,469
        07/05/2016	7,741,766	82,922	    713,711
        06/03/2016	7,635,689	81,557	    703,568
        05/05/2016	7,385,635	78,294	    682,050        
        04/13/2016	7,386,980	78,288      682,250  
        04/04/2016	7,272,482	77,326      ?
        */


    -- MERGED CUSTOMERS
    
        -- recency check
        SELECT MAX(dtDateMerged) 'LatestMerged',
        MIN(dtDateLastSOPUpdate) 'OldestUpdated'
        from [SMI Reporting].dbo.tblMergedCustomers 
        /*
        LatestMerged	OldestUpdated
        2016-08-02  	2016-07-05 
        */

        select CONVERT(VARCHAR(10), GETDATE(), 101) AS 'DateRan   ', 
        COUNT(*) 'TotCnt',
        COUNT(distinct ixCustomerOriginal) 'DistCnt',
        (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        from [SMI Reporting].dbo.tblMergedCustomers
        /*
        DateRan   	TotCnt	DistCnt	Dupes
        08/03/2016	41,729	41,729	0
        07/05/2016	41,526	41,526	0
        06/03/2016	41,342	41,342	0
        04/13/2016	40,996	40,996	0
        04/04/2016	40,858	40,858	0        
        */



    -- SKU/Market data from TNG
        -- import data from tng
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB] 
        select *                                        --   22-30 seconds
        from openquery([TNGREADREPLICA], '                SELECT ixSOPSKU as ''ixSKU'', 
                          M.sMarketName as ''ixMarket''
                        FROM tblmarket M 
                          left join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket  
                          left join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase 
                          left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase 
                        where 
                          SV.ixSOPSKU is NOT NULL
                          and M.sMarketName <> ''Garage Sale''
                          and SV.ixSOPSKU <>'' ''
                        order by SV.ixSOPSKU
                              ') 

        -- review data
        select CONVERT(VARCHAR(10), GETDATE(), 101) AS 'DateRan   ', 
            count(*) 'Records'
        from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
        /*
        DateRan   	Records
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
        SKUCnt	ixMarket
        88285	Oval Track
		64269	Open Wheel
		61772	Street Rod
		61498	Muscle Car
		56700	Classic Truck
		52755	T-Bucket
		25864	Drag Racing
		1194	Pedal Car
		778		Sport Compact
		195		Offroad
		24		Modern Muscle
		22		Demolition Derby
		3		Modern Truck
		2		Marine
        */
        
/****************************************************  
FILE #1 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:  SMI - Customer - Catalogs Mailed 01012009 to 07312016
    records: 15.5M-16M        runtime: 5:20-8:26        
****************************************************/
    SELECT -- 15,716,247 records   
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
            ELSE 'OTHER' -- to catch any new markets
	    end as 'catalog_market'
    FROM tblCustomerOffer co
    	join vwLBSampleTransactions ST on ST.custid = co.ixCustomer
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    WHERE co.sType='OFFER'
	    and co.dtActiveStartDate between '01/01/2011' and '07/31/2016'    -- 1/1/2009 to '07/31/2016'



/****************************************************  
FILE #2 - CUSTOMER file 
    file name:   SMI - Customers 01012009 to 07312016
    records:     700-750k    runtime: 20-50 sec  
****************************************************/
    SELECT -- 723,469      records @35 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (select distinct custid 
                           from vwLBSampleTransactions)


                              
/****************************************************  
FILE #3 - Merged Customers
    file name:   SMI - Merged Customers 01012009 to 07312016
    records:     40K-45K   
    runtime:     3 sec   
****************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 41,548
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM [SMI Reporting].dbo.tblMergedCustomers M
        join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged



/****************************************************  
FILE #4 - SKUs w/ advanced market info 
    file name: SMI - SKU - Additional Markets File 01012009 to 07312016
    records:   235 - 250K    runtime:   20-34 sec
 ****************************************************/
  -- Data is imported from tng into [SMITemp].dbo.[PJC_SKUMarketsForLB]
  -- in the Prep Steps section above
            
        -- create output for LB file               
            SELECT DISTINCT sm.ixSKU as 'itemid', --  237,117  @28 secs    
	            sm.ixMarket as 'market'
            FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
            WHERE sm.ixSKU in (select distinct itemid 
                               from vwLBSampleTransactions)
	            and sm.ixMarket is NOT NULL


/****************************************************
FILE #5 - SKU file 
file name: SMI - SKUs 01012009 to 07312016
records: 84-92K(^ about 1K/month)runtime: 60-80 sec
****************************************************/
SELECT SKU.ixSKU as 'itemid',-- 84,228 records @ 74sec
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
    file name: SMI - Transactions 01012009 to 07312016
    records: 7.6M-8M    runtime: 46-188 sec 
****************************************************/
    select * from vwLBSampleTransactions -- 7,840,518    @73 sec 
 


/**************************************************** 
FILE #7 - Customer print opt-outs data 
    file name: SMI - Customer - Print Opt-Outs as of 07312016
    records: 70-72K  runtime: 3 sec 
****************************************************/

SELECT COUNT(*) FROM tblMailingOptIn                                            -- 10,768,241
SELECT COUNT(*) FROM tblMailingOptIn WHERE sOptInStatus = 'N'                   --     87,448
SELECT COUNT(DISTINCT ixCustomer) FROM tblMailingOptIn WHERE sOptInStatus = 'N' --     27,143

SELECT distinct ixCustomer 'custid', -- 70,625  records (aprox 27K distinct customers)
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



/*** WE NO LONGER SEND THE FOLLOWING FILE TO LB
                /****************************************************  
                FILE #8 - SKUs & applications 
                    file name:   SMI - SKUs and Applications 01012009 to 07312016
                    records: 62-74K    runtime: 5-13 sec    
                ****************************************************/
                        -- data from tng
                        select *                            -- 74,219 records  !!! ONLY 1,380 records!?!
                        from openquery([TNGREADREPLICA], 'select  
                            sv.ixSOPSKU as ''itemid'',
                            a.sApplicationGroup as ''application_group'',
                            a.sApplicationValue as ''application_subgroup''
                        from tblskuvariant_application_xref svax
                            left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
                            left join tblapplication a on a.ixApplication = svax.ixApplication
                            ')

                --STREET data only!   6 mins 5.04M rows
                select top 100 *                            -- 5.04M records
                        from openquery([TNGREADREPLICA], '

                select
                s.ixSOPSKU as itemid
                , vy.ixVehicleYear
                , vm.sVehicleMakeName
                , vmod.sVehicleModelName
                from tblskuvariant_vehicle_base svb
                LEFT JOIN tblskuvariant s on svb.ixSKUVariant = s.ixSKUVariant
                LEFT JOIN tblvehicle_base vb ON svb.ixVehicleBase = vb.ixVehicleBase
                LEFT JOIN tblvehicle_year vy ON vb.ixVehicleYear = vy.ixVehicleYear
                LEFT JOIN tblvehicle_make vm ON vb.ixVehicleMake = vm.ixVehicleMake
                LEFT JOIN tblvehicle_model vmod ON vb.ixVehicleModel = vmod.ixVehicleModel

                ')
                 
                select *                            -- 74,024 records
                        from openquery([TNGREADREPLICA], '
                select s.ixSOPSKU as itemid
                , rt.sRaceType -- sRaceType
                from tblskuvariant s 
                     JOIN tblskuvariant_racetype_xref svrx on svrx.ixSKUVariant = s.ixSKUVariant
                 JOIN tblracetype rt on svrx.ixRaceType = rt.ixRaceType
                ')
*/

/************   Manually inspect each file. Compare size, format, and row count to previous extract  *********************** 
File Summary:                                                                                        /   QC CHECKS   \
                    Approx                                                                          /                 \
    Approx          File                                                                           /Size    Data       \
#   records         Size (MB)   File Name                                                           (MB)    Format  #Rec
==  ===========     =========   =================================================================   ====    ======  ====
1   15.5M-16M       400-450     SMI - Customer - Catalogs Mailed 01-01-2009 to <'07/31/2016'>.txt      Y    Y       Y
2   714K-750K      15.7-17.6    SMI - Customers 01-01-2009 to <'07/31/2016'>.txt                       Y    Y       Y
3    41K-45K           1-1.5    SMI - Merged Customers 01-01-2009 to <'07/31/2016'>.txt                Y    Y       Y   
4   236K-246K        5.0-5.7    SMI - SKU - Additional Markets 01-01-2009 to <'07/31/2016'>.txt        Y    Y       Y     
5     84-91K        14.0-16.1   SMI - SKUs 01-01-2009 to <'07/31/2016'>.txt                            Y    Y       Y   
6   7.7M-8.6M        315-400    SMI - Transactions 01-01-2009 to <'07/31/2016'>.txt                    Y    Y       Y  
7    71K-73K           1-1.5    SMI - Customer - Print Opt-Outs as of <'07/31/2016'>.txt               Y    Y       Y  

#8 WE NO LONGER SEND "SMI - SKUs and Applications"
    
   Zip the files (at "FAST" compression and place them in in N:\Misc Items.
   naming convention = "SMI - dataset 01-01-2009 to 06-30-2016.7z" <-- approx 1 minute to zip and 3 mins to transfer
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

Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is “SMI - dataset 01-01-2009 to 06-30-2016.7z”.   

It consists of the following 8 files appended with the date range used:

    RECORDS     FILENAME 
    =========   ================================  
#1 15,716,247   SMI - Customer - Catalogs Mailed  
#2    713,711   SMI - Customers                      
#3     41,343   SMI - Merged Customers
#4    235,492   SMI - SKU - Additional Markets
#5     82,922   SMI - SKUs
#6  7,741,766   SMI - Transactions
#7     70,531   SMI - Customer - Print Opt-Outs


If there are any questions/concerns, email or call me prior to our next scheduled conference call.  Please let us know as soon as Longbow has been refreshed with this dataset.

Thanks!

*** END **** /

