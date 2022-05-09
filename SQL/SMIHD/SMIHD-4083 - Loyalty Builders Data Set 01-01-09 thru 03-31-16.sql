 /* SMIHD-4083 - Loyalty Builders Data Set 01-01-09 thru 03-31-16 
        This extract is for:
        counts and andlysis only
        Catalogs already pre-pulled
 */
 
 /********************************************************************************************
 - alter vwLBSampleTransactions on LNK-DWSTAGING1 
 
 - run everything else on DW1
 
 - The range of each data set is 01/01/2009 to 03/31/2016.

 - NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+

 - EXPORT files in Mgmt Studio by selecting "RESULTS TO FILE"

 **********************************************************************************************/

/***********    PREP    ***********/
/* ALWAYS ALTER vwLBSampleTransactions ON LNK-DWSTAGING1 !!!
     and change the end date to the final day of the previous month (or the previous day if this is a pull outside the normal delivery schedule)
     do NOT put a function to calculate it because it SLOWS THE VIEW DOWN TOO MUCH.
*/

    -- vwLBSampleTransactions (now contains data from 1/1/2009 to 03/31/2016)
        select top 25 * from vwLBSampleTransactions 
        where txdate = '03/31/2016' -- latest date being used in the extract

        select CONVERT(VARCHAR(10), GETDATE(), 101) AS 'DateRan   ', 
            COUNT(*) 'TotRows ',
            count(distinct itemid) 'DistinctItemIDs'
        from vwLBSampleTransactions -- 27-110 sec
        /*
        DateRan	    TotRows 	DistinctItemIDs
        04/04/2016	7,272,482	77,326
        */


    -- MERGED CUSTOMERS
        -- Run SOP Reporting Menu <9> Customer Merges takes approx 2 mins to refeed all 39K records 
        select COUNT(*) 'TotCnt',
        COUNT(distinct ixCustomerOriginal) 'DistCnt',
        (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        from [SMI Reporting].dbo.tblMergedCustomers
        /*
        TotCnt	DistCnt Dupes
        40858	40858	0
        */

        -- most recent merged customer
        SELECT MAX(dtDateMerged) 'LatestMerged',
        MIN(dtDateLastSOPUpdate) 'OldestUpdated'
        from [SMI Reporting].dbo.tblMergedCustomers 
        /*
        LatestMerged	OldestUpdated
        2016-04-04  	2016-04-04 
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
        select count(*) from [SMITemp].dbo.[PJC_SKUMarketsForLB]   -- 413,196
        select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
        
        
/****************************************************  
FILE #1 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:  SMI - Customer - Catalogs Mailed 01012009 to 03312016
    records: 13.0M-14.5M        runtime: 1:20-4:36         
****************************************************/
    SELECT -- 14,434,461  records   
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
	    and co.dtActiveStartDate between '01/01/2011' and '03/31/2016'    -- 1/1/2009 to '03/31/2016'



/****************************************************  
FILE #2 - CUSTOMER file 
    file name:   SMI - Customers 01012009 to 03312016
    records:     570-673K    runtime: 20-50 sec  
****************************************************/
    SELECT -- 672,249   records @36 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    FROM tblCustomer C 
    WHERE C.ixCustomer in (select distinct custid 
                           from vwLBSampleTransactions)


                              
/****************************************************  
FILE #3 - Merged Customers
    file name:   SMI - Merged Customers 01012009 to 03312016
    records:     36K-39K   
    runtime:     3 sec   
****************************************************/
    -- excludes cust account #'s that were re-used after their original customers were merged
    SELECT M.ixCustomerOriginal as 'OrigCustid',    -- 40,712
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    FROM [SMI Reporting].dbo.tblMergedCustomers M
        join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    WHERE C.flgDeletedFromSOP = 1
    order by M.dtDateMerged



/****************************************************  
FILE #4 - SKUs w/ advanced market info 
    file name: SMI - SKU - Additional Markets File 01012009 to 03312016
    records:   195 - 227K    runtime:   20-34 sec
 ****************************************************/
    SELECT DISTINCT sm.ixSKU as 'itemid', --  226,465     @27 sec
        sm.ixMarket as 'market'
    FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
    WHERE sm.ixSKU in (select distinct itemid 
                       from vwLBSampleTransactions)
        and sm.ixMarket is NOT NULL

 
 /****************************************************  
FILE #5 - SKU file 
    file name: SMI - SKUs 01012009 to 03312016
    records: 59-75K  (^ about 1K/month)    runtime: 10-32 sec    
****************************************************/
    SELECT -- 77,326 records @27 sec    
	    SKU.ixSKU as 'itemid',      
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
            ELSE 'OTHER' -- to catch any new markets	        
	    end as 'primary_market'
    FROM
	    tblSKU SKU
	    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
    WHERE
	    SKU.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
    	--and PGC.ixMarket <> 'SR' and PGC.ixMarket <> 'R' and PGC.ixMarket <> 'PC' and PGC.ixMarket <> 'SM' and PGC.ixMarket <> 'B' and PGC.ixMarket <> '2B' and PGC.ixMarket <> 'TE'

/**** NOTES from analysis done on 1-21-15
        1,879 SKUs (as of 1-21-15) are being excluded because they have no market assigned in TNG.

        Wyatt was sent a list of 1,043 the above SKUs (the ones that were still active as far as TNG determins).
        They had sales totalling $800K in 2014 alone.  He was going to review the list and have someone update 
        the markets based on the highesr 12 Month sales $ having priority.

        The SOP Market is assigned to a SKU in another file.
*/   


 
/**************************************************** 
FILE #6 - transaction file data 
    file name: SMI - Transactions 01012009 to 03312016
    records: 6.7-7.13M    runtime: 46-188 sec 
****************************************************/
    select top 10 * from vwLBSampleTransactions -- 7,272,436   @95 sec 
 


/**************************************************** 
FILE #7 - Customer print opt-outs data 
    file name: SMI - Customer - Print Opt-Outs as of 03312016
    records: 71-72K  runtime: 3 sec 
****************************************************/

SELECT COUNT(*) FROM tblMailingOptIn                                            -- 8,934,002
SELECT COUNT(*) FROM tblMailingOptIn WHERE sOptInStatus = 'N'                   --    89,187
SELECT COUNT(DISTINCT ixCustomer) FROM tblMailingOptIn WHERE sOptInStatus = 'N' --    27,686

SELECT distinct ixCustomer 'custid', -- 72,052  records (aprox 27K distinct customers)
    case
        when ixMarket = 'R' then 'Race'
	    when ixMarket = 'SR' then 'Street Rod'
	    when ixMarket = 'B' then 'Multi'
	    when ixMarket = 'SM' then 'Open Wheel'
	    when ixMarket = 'PC' then 'Pedal Car'
        when ixMarket = '2B' then 'T Bucket'
        when ixMarket = 'TE' then 'Tools'
        when ixMarket = 'SC' then 'Sport Compact'
        ELSE 'INVALID MARKET'
    end as 'optout_market'
--, ixMarket
FROM tblMailingOptIn
WHERE sOptInStatus = 'N'
    and ixMarket <> 'AD' -- AFCO Dynateck
order by 'optout_market'

/*** WE NO LONGER SEND THE FOLLOWING FILE TO LB
                /****************************************************  
                FILE #8 - SKUs & applications 
                    file name:   SMI - SKUs and Applications 01012009 to 03312016
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
1  13.5M-14.5M       350-396    SMI - Customer - Catalogs Mailed 01-01-2009 to <'03/31/2016'>.txt      Y    
2   689K-673K      12.6-13.6    SMI - Customers 01-01-2009 to <'03/31/2016'>.txt                       Y        
3    37K-41K           1-1.5    SMI - Merged Customers 01-01-2009 to <'03/31/2016'>.txt                Y       
4   179K-227K        3.9-4.3    SMI - SKU - Additional Markets 01-01-2009 to <'03/31/2016'>.txt        Y        
5     61-78K        8.6-10.1    SMI - SKUs 01-01-2009 to <'03/31/2016'>.txt                            Y     
6   6.9M-7.3M        255-297    SMI - Transactions 01-01-2009 to <'03/31/2016'>.txt                    Y      
7    71K-72K           1-1.5    SMI - Customer - Print Opt-Outs as of <'03/31/2016'>.txt               Y       

#8 WE NO LONGER SEND "SMI - SKUs and Applications"
    
   Zip the files (at "FAST" compression and place them in in N:\Misc Items.
   naming convention = "SMI - dataset 01-01-2009 to 02-29-2016.7z" <-- approx 1 minute to zip and 3 mins to transfer
*******************************************************************************************/    
    
/******************************  TRANSMIT FILES TO LOYALTY BUILDERS  ******************************
access the secured ftp account using Filezilla.
        hostname: sftp://ftp.longbowdm.com  
        Username = speedway     PW = yW4Sgwjj
If any PW issues, call Al Trudell at (603)610-8810 albertt@loyaltybuilders.com
************************************************************************************************** /

/******************************** SEND NOTIFICATION EMAIL  ********************************
TO: irenam@loyaltybuilders.com; albertt@loyaltybuilders.com; billv@loyaltybuilders.com; brianj@loyaltybuilders.com
CC: dwlee@speedwaymotors.com; djhajek@speedwaymotors.com; ccchance@speedwaymotors.com; ascrook@speedwaymotors.com
SUBJECT: Newest dataset uploaded

Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is “SMI - dataset 01-01-2009 to 03-31-2016.7z”.   

It consists of the following 8 files appended with the date range used:

    RECORDS     FILENAME 
    =========   ================================  
#1 14,434,461   SMI - Customer - Catalogs Mailed  
#2    672,249   SMI - Customers                      
#3     40,712   SMI - Merged Customers
#4    226,465   SMI - SKU - Additional Markets
#5     77,326   SMI - SKUs
#6  7,272,436   SMI - Transactions
#7     72,052   SMI - Customer - Print Opt-Outs



If there are any questions/concerns, email or call me prior to our next scheduled conference call.  Please let us know as soon as Longbow has been refreshed with this dataset.

Thanks!

*** END **** /