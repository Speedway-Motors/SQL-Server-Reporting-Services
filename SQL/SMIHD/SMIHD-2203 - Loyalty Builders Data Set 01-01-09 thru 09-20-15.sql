 /* SMIHD-2203 - Loyalty Builders Data Set 01-01-09 thru 11-04-15 
        This extract is between the 507 & 508 STREET catalogs
 */
 
 /********************************************************************************************
    SQL based on SMIHD-2303
 -- run on DW1.[SMI Reporting]  
 
 -- CURRENTLY The range of each data set is 1/1/2009 to YESTERDAY.

 -- NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  
 -- (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+

 -- EXPORT files 1,2,4,5, 7 in Mgmt Studio by selecting "RESULTS TO FILE"
           files 3 & 6 are generated in TOAD from the TNG(live) db (see details in their sections)
 **********************************************************************************************/

/***********    PREP    ***********/
-- vwLBSampleTransactions (now contains data from 1/1/2009 to YESTERDAY)
    select top 25 * from vwLBSampleTransactions 
    where txdate = DATEADD(DD, -1, CONVERT(VARCHAR, GETDATE(), 110)) -- sample of orders from yesterday

    select COUNT(*) from vwLBSampleTransactions -- 6.8M

    select count(distinct itemid) from vwLBSampleTransactions -- 69.1K




/****************************************************  
FILE #1 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:  SMI - Customer - Catalogs Mailed File 01012009 to 09202015
    records:    11.5M-12.6M        
    runtime:     1:20-3:46         
****************************************************/
    select -- 13,145,108  records   
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
	    and co.dtActiveStartDate between '01/01/2011' and DATEADD(DD, -1, CONVERT(VARCHAR, GETDATE(), 110))     -- 1/1/2009 to YESTERDAY
	    and co.ixCustomer in (select custid 
	                          from vwLBSampleTransactions) 

    


      
/****************************************************  
FILE #2 - CUSTOMER file 
    file name:   SMI - Customers 01012009 to 09202015
    records:     570-593K    
    runtime:     20-40 sec  
****************************************************/
    select -- 592,866 records @24 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    from tblCustomer C 
    where C.ixCustomer in (select distinct custid 
                           from vwLBSampleTransactions)



                              
/****************************************************  
FILE #3 - Merged Customers
    file name:   SMI - Merged Customers 01012009 to 09202015
    records:     36K-39K   
    runtime:     3 sec   
****************************************************/
        -- Run SOP Reporting Menu <27> Customer Merges takes approx 2 mins to refeed all 39K records 
        select COUNT(*) 'TotCnt',
        COUNT(distinct ixCustomerOriginal) 'DistCnt',
        (COUNT(*) - COUNT(distinct ixCustomerOriginal)) 'Dupes'
        from [SMI Reporting].dbo.tblMergedCustomers
        /*
        TotCnt	DistCnt Dupes
        38939	38939   0
        */

        select * from [SMI Reporting].dbo.tblMergedCustomers

    -- CREATE OUTPUT FILE
    -- excludes cust account #'s that were re-used after their original customers were merged
    Select M.ixCustomerOriginal as 'OrigCustid',    -- 38,755
        M.ixCustomerMergedTo as 'CustidMergedTo',
        CONVERT(VARCHAR, M.dtDateMerged, 111) as 'DateMerged'
    from [SMI Reporting].dbo.tblMergedCustomers M
        join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    where C.flgDeletedFromSOP = 1
    order by M.dtDateMerged

    -- most recent merged customer
    SELECT MAX(dtDateMerged) 'LatestMerged',
    MIN(dtDateLastSOPUpdate) 'OldestUpdated'
    from [SMI Reporting].dbo.tblMergedCustomers 
    /*
    LatestMerged	OldestUpdated
    2015-09-21      2015-09-21
    */


/****************************************************  
FILE #4 - SKUs w/ advanced market info 
    file name: SMI - SKU - Additional Markets File 01012009 to 09202015
    records:   352K - 358K
    runtime:   3-4 sec
 ****************************************************/
        -- import data from tng
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]    
        GO
        INSERT into [SMITemp].dbo.[PJC_SKUMarketsForLB]
        select * 
        from openquery([TNGREADREPLICA], '                SELECT ixSOPSKU as ''ixSKU'', -- 395,150 Rows
                          M.sMarketName as ''ixMarket''
                        FROM tblmarket M 
                          left join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket  
                          left join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase 
                          left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase 
                        where 
                          SV.ixSOPSKU is not null 
                          and M.sMarketName <> ''Garage Sale''
                        order by SV.ixSOPSKU
                              ')

        -- review data
        select count(*) from [SMITemp].dbo.[PJC_SKUMarketsForLB]   -- 395,150
        select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
            
        -- create output for LB file               
            SELECT DISTINCT sm.ixSKU as 'itemid', --  200,094  previously 195,410 records  @20-28 secs    
	            sm.ixMarket as 'market'
            FROM [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
            WHERE sm.ixSKU in (select distinct LBST.itemid 
                               from vwLBSampleTransactions)
	            and sm.ixMarket is NOT null

 


 /****************************************************  
FILE #5 - SKU file 
    file name: SMI - SKUs 01012009 to 09202015
    records:     59-68K      previous = 48K - 57K records (^ about 1K/month)
    runtime:     10 - 30 sec    
****************************************************/
    select -- 65,544 records @22 sec 
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
    file name:   SMI - SKUs and Applications 01012009 to 09202015
    records:     62-74K
    runtime:     13 sec    
****************************************************/
/*  !! RUN IN TOAD from the TNG(live) db
        Tools/Export/Export Wizard
            click "Add" on Export Objects List
                select "Query"
                    paste query
                        <NEXT>
                            use defaults --> Tab Delimeted Text, NO column delimiter, NO Quote Character,Use Column Names for a Header Row
*/


    select  -- 69,158 records
        sv.ixSOPSKU as 'itemid',
        a.sApplicationGroup as 'application_group',
        a.sApplicationValue as 'application_subgroup'
    from tblskuvariant_application_xref svax
        left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
        left join tblapplication a on a.ixApplication = svax.ixApplication





        -- import data from tng
        select * 
        from openquery([TNGREADREPLICA], 'select  -- 73,744 records
            sv.ixSOPSKU as ''itemid'',
            a.sApplicationGroup as ''application_group'',
            a.sApplicationValue as ''application_subgroup''
        from tblskuvariant_application_xref svax
            left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
            left join tblapplication a on a.ixApplication = svax.ixApplication
            ')


 
/**************************************************** 
FILE #7 - transaction file data 
    file name: SMI - Transactions 01012009 to 09202015
    records: 6.7M      
    runtime: 46-85 sec 
****************************************************/
-- change SQL output to "Results to File"
    select * from vwLBSampleTransactions -- 6,689,967   rows   @83 sec 
 







/******************************   Manually inspect each file   ****************************** 
File Summary:                                                                                        /   QC CHECKS   \
                    Approx                                                                          /                 \
    Approx          File                                                                           /Size    Data       \
#   records         Size (MB)   File Name                                                           (MB)    Format  #Rec
==  ===========     =========   =================================================================   ====    ======  ====
1  11.5M-12.9M       321-360    SMI - Customer - Catalogs Mailed 01-01-2009 to <YESTERDAY>.txt      Y                 
2   569K-581K      12.6-13.0    SMI - Customers 01-01-2009 to <YESTERDAY>.txt                       Y             
3    37K-38K           1-1.5    SMI - Merged Customers 01-01-2009 to <YESTERDAY>.txt                Y           
4   179K-186K        3.9-4.2    SMI - SKU - Additional Markets 01-01-2009 to <YESTERDAY>.txt        Y           
5     61-64K         8.6-9.5    SMI - SKUs 01-01-2009 to <YESTERDAY>.txt                            Y              
6    63K-69k         2.3-2.5    SMI - SKUs and Applications 01-01-2009 to <YESTERDAY>.txt           Y          
7   6.3M-6.5M        255-273    SMI - Transactions 01-01-2009 to <YESTERDAY>.txt                    Y            
    
   Zip the files (at "FAST" compression and place them in in N:\Misc Items.
   naming convention = "SMI - dataset 01-01-2009 to 06-25-2015.7z" <-- approx 1 minute to zip and 3 mins to transfer
*******************************************************************************************/    
    
      

/******************************  TRANSMIT FILES TO LOYALTY BUILDERS  ******************************
access the secured ftp account: 
    use Filezilla
        hostname: sftp://ftp.longbowdm.com  
        Username = speedway
        PW = yW4Sgwjj
    
If there are any password issues, call Al Trudell at (603)610-8810 albertt@loyaltybuilders.com
************************************************************************************************** /



/******************************** SEND NOTIFICATION EMAIL  ********************************
TO: irenam@loyaltybuilders.com; albertt@loyaltybuilders.com; billv@loyaltybuilders.com; brianj@loyaltybuilders.com
CC: dwlee@speedwaymotors.com; djhajek@speedwaymotors.com; ccchance@speedwaymotors.com; ascrook@speedwaymotors.com
SUBJECT: Newest dataset uploaded


Loyalty Builders team, the latest dataset for Speedway Motors has been uploaded.  The filename is ?SMI - dataset 01-01-2009 to 06-25-2015.7z?.   

It consists of the following 7 files appended with the date range used:

    RECORDS     FILENAME 
    =========   =======================  
#1 13,145,108   SMI - Customer - Catalogs Mailed  
#2    592,866   SMI - Customers                      
#3     38,755   SMI - Merged Customers
#4    200,094   SMI - SKU - Additional Markets
#5     67,275   SMI - SKUs
#6     73,744   SMI - SKUs and Applications
#7  6,689,967   SMI - Transactions


If there are any questions/concerns, email or call me prior to our next scheduled conference call. 

Thanks!

*** END **** /