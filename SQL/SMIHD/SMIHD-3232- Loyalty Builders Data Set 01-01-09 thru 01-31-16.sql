 /* SMIHD-3232- Loyalty Builders Data Set 01-01-09 thru 01-31-16 
        This extract is for:
        Race	408
        Combo	905

 */
-- ALWAYS ALTER vwLBSampleTransactions to change the end date to the final day of the previous month!!!
-- do NOT put a function to calculate it because it SLOWS THE VIEW DOWN TOO MUCH.

select SUM(O.mMerchandise) 'Sales', 
COUNT(ixOrder) 'OrderCount',-- 38,310
getdate() 'As of'
from tblOrder O
where O.dtShippedDate between '01/01/2009' and '01/31/2016'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
/*    
Sales	        OrderCount	    As of
603,105,013     2,983,128	    2016-02-04 09:18:22
*/
 
 /********************************************************************************************
    SQL based on SMIHD-3104
 -- run on DW1.[SMI Reporting]  
 
 -- The range of each data set is 1/1/2009 to '01/31/2016'.

 -- NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  
 -- (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+

 -- EXPORT files in Mgmt Studio by selecting "RESULTS TO FILE"

 **********************************************************************************************/

/***********    PREP    ***********/
-- vwLBSampleTransactions (now contains data from 1/1/2009 to 01/31/2016)
    select top 25 * from vwLBSampleTransactions 
    where txdate = '01/31/2016'-- sample of orders from '01/31/2016'

    select COUNT(*) from vwLBSampleTransactions -- 7.12M  30-110 sec

    select count(distinct itemid) from vwLBSampleTransactions -- 74.2K



/****************************************************  
FILE #1 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:  SMI - Customer - Catalogs Mailed 01012009 to 01312016
    records: 13.0M-14.1M        runtime: 1:20-4:36         
****************************************************/
    SELECT -- 14,105,802 records   
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
	    end as 'catalog_market'
    FROM tblCustomerOffer co
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    WHERE co.sType='OFFER'
	    and co.dtActiveStartDate between '01/01/2011' and '01/31/2016'    -- 1/1/2009 to '01/31/2016'
	    and co.ixCustomer in (select custid 
	                          from vwLBSampleTransactions) 

    

/****************************************************  
FILE #2 - CUSTOMER file 
    file name:   SMI - Customers 01012009 to 01312016
    records:     570-656K    runtime: 20-50 sec  
****************************************************/
    select -- 654,508 records @33 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    from tblCustomer C 
    where C.ixCustomer in (select distinct custid 
                           from vwLBSampleTransactions)


                              
/****************************************************  
FILE #3 - Merged Customers
    file name:   SMI - Merged Customers 01012009 to 01312016
    records:     36K-39K   
    runtime:     3 sec   
****************************************************/
        -- Run SOP Reporting Menu <9> Customer Merges takes approx 2 mins to refeed all 39K records 
        select COUNT(*) 'TotCnt',
        COUNT(distinct ixCustomerOriginal) 'DistCnt',
        (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        from [SMI Reporting].dbo.tblMergedCustomers
        /*
        TotCnt	DistCnt Dupes
        40025	40025	0
        */

    -- most recent merged customer
    SELECT MAX(dtDateMerged) 'LatestMerged',
    MIN(dtDateLastSOPUpdate) 'OldestUpdated'
    from [SMI Reporting].dbo.tblMergedCustomers 
    /*
    LatestMerged	OldestUpdated
    2016-02-03      2016-02-04
    */

    select * from [SMI Reporting].dbo.tblMergedCustomers

    -- CREATE OUTPUT FILE
    -- excludes cust account #'s that were re-used after their original customers were merged
    Select M.ixCustomerOriginal as 'OrigCustid',    -- 39,844
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    from [SMI Reporting].dbo.tblMergedCustomers M
        join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    where C.flgDeletedFromSOP = 1
    order by M.dtDateMerged



/****************************************************  
FILE #4 - SKUs w/ advanced market info 
    file name: SMI - SKU - Additional Markets File 01012009 to 01312016
    records:   195 - 213K
    runtime:   3-4 sec
 ****************************************************/
        -- import data from tng
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB] 
        select *                                        -- 395-413 records     30 seconds
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
        select count(*) from [SMITemp].dbo.[PJC_SKUMarketsForLB]   -- 412,850
        select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
            
        -- create output for LB file               
            SELECT DISTINCT sm.ixSKU as 'itemid', --  220,707      @20-34 secs    
	            sm.ixMarket as 'market'
            FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
            WHERE sm.ixSKU in (select distinct itemid 
                               from vwLBSampleTransactions)
	            and sm.ixMarket is NOT NULL

 
 /****************************************************  
FILE #5 - SKU file 
    file name: SMI - SKUs 01012009 to 01312016
    records: 59-75K  (^ about 1K/month)    runtime: 10-30 sec    
****************************************************/
    select -- 74,398 records @27 sec 
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
	    end as 'primary_market'
    from
	    tblSKU SKU
	    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
    where
	    SKU.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
    	--and PGC.ixMarket <> 'SR' and PGC.ixMarket <> 'R' and PGC.ixMarket <> 'PC' and PGC.ixMarket <> 'SM' and PGC.ixMarket <> 'B' and PGC.ixMarket <> '2B' and PGC.ixMarket <> 'TE'
/**** NOTES from analysis done on 1-21-15
as of 1-21-15 1,879 SKUs are being excluded because they have no market assigned in TNG.

Wyatt was sent a list of 1,043 the above SKUs (the ones that were still active as far as TNG determins).
They had sales totalling $800K in 2014 alone.  He was going to review the list and have someone update 
the markets based on the highesr 12 Month sales $ having priority.

The SOP Market is assigned to a SKU in another file.
*/   


/****************************************************  
FILE #6 - SKUs & applications 
    file name:   SMI - SKUs and Applications 01012009 to 01312016
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

 
/**************************************************** 
FILE #7 - transaction file data 
    file name: SMI - Transactions 01012009 to 01312016
    records: 6.7-7.13M    runtime: 46-188 sec 
****************************************************/
    select * from vwLBSampleTransactions -- 7,123,191 rows   @86 sec 
 


/**************************************************** 
FILE #8 - Customer print opt-outs data 
    file name: SMI - Customer - Print Opt-Outs as of 01312016
    records: 71-72K  runtime: 3 sec 
****************************************************/

SELECT COUNT(*) FROM tblMailingOptIn                                            -- 8,800,427
SELECT COUNT(*) FROM tblMailingOptIn WHERE sOptInStatus = 'N'                   --    88,836
SELECT COUNT(DISTINCT ixCustomer) FROM tblMailingOptIn WHERE sOptInStatus = 'N' --    27,591

SELECT distinct ixCustomer 'custid', -- 71,780  records (aprox 27K distinct customers)
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


/******************************   Manually inspect each file   ****************************** 
File Summary:                                                                                        /   QC CHECKS   \
                    Approx                                                                          /                 \
    Approx          File                                                                           /Size    Data       \
#   records         Size (MB)   File Name                                                           (MB)    Format  #Rec
==  ===========     =========   =================================================================   ====    ======  ====
1  11.5M-14.1M       350-395    SMI - Customer - Catalogs Mailed 01-01-2009 to <'01/31/2016'>.txt      Y    Y       Y
2   589K-655K      12.6-13.6    SMI - Customers 01-01-2009 to <'01/31/2016'>.txt                       Y    Y       Y      
3    37K-40K           1-1.5    SMI - Merged Customers 01-01-2009 to <'01/31/2016'>.txt                Y    Y       Y     
4   179K-213K        3.9-4.3    SMI - SKU - Additional Markets 01-01-2009 to <'01/31/2016'>.txt        Y    Y       Y       
5     61-75K        8.6-10.1    SMI - SKUs 01-01-2009 to <'01/31/2016'>.txt                            Y    Y       Y   
6    63K-74k         2.3-2.5    SMI - SKUs and Applications 01-01-2009 to <'01/31/2016'>.txt           WAITING ON RESPONSE FROM LB       
7   6.3M-6.8M        255-281    SMI - Transactions 01-01-2009 to <'01/31/2016'>.txt                    Y    Y       Y    
8    71K-72K           1-1.5    SMI - Customer - Print Opt-Outs as of <'01/31/2016'>.txt               Y    Y       Y      
    
   Zip the files (at "FAST" compression and place them in in N:\Misc Items.
   naming convention = "SMI - dataset 01-01-2009 to 01-31-2016.7z" <-- approx 1 minute to zip and 3 mins to transfer
*******************************************************************************************/    
    
/******************************  TRANSMIT FILES TO LOYALTY BUILDERS  ******************************
access the secured ftp account: 
    use Filezilla
        hostname: sftp://ftp.longbowdm.com  
        Username = speedway     PW = yW4Sgwjj
    
If any PW issues, call Al Trudell at (603)610-8810 albertt@loyaltybuilders.com
************************************************************************************************** /

/******************************** SEND NOTIFICATION EMAIL  ********************************
TO: irenam@loyaltybuilders.com; albertt@loyaltybuilders.com; billv@loyaltybuilders.com; brianj@loyaltybuilders.com
CC: dwlee@speedwaymotors.com; djhajek@speedwaymotors.com; ccchance@speedwaymotors.com; ascrook@speedwaymotors.com
SUBJECT: Newest dataset uploaded


Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is “SMI - dataset 01-01-2009 to 11-30-2015.7z”.   

It consists of the following 8 files appended with the date range used:

    RECORDS     FILENAME 
    =========   =======================  
#1 14,105,802   SMI - Customer - Catalogs Mailed  
#2    654,508   SMI - Customers                      
#3     39,844   SMI - Merged Customers
#4    220,707   SMI - SKU - Additional Markets
#5     74,219   SMI - SKUs
#6 DID NOT SEND SMI - SKUs and Applications
#7  7,123,191   SMI - Transactions
#8     71,780   SMI - Customer - Print Opt-Outs


If there are any questions/concerns, email or call me prior to our next scheduled conference call.  Please let us know as soon as Longbow has been refreshed with this dataset.

Thanks!

*** END **** /