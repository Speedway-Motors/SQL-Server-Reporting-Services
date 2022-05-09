 /* Case 25678 - Loyalty Builders Data Set 03-09-11 thru 03-08-15 */
 
 /********************************************************************************************
    SQL based on Case 25542
 -- run on DW1.[SMI Reporting]   <-- it is POSSIBLE to run on DWSTAGING but very slow
 
 -- GLOBALLY REPLACE DATES 03092011 to 03082015
 -- NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  
 -- (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+

 -- EXPORT the first 5 files in Mgmt Studio by selecting "RESULTS TO FILE"
          the 6th file is generated in TOAD from the TNG(live) db (see details in that section).
 **********************************************************************************************/

-- ALTER vwLBSampleTransactions on DWSTAGING1. Replication will apply the change to DW1 a few seconds later

    select top 25 * from vwLBSampleTransactions -- SAMPLE

    select COUNT(*) from vwLBSampleTransactions -- 4,244,600

    select count(distinct itemid) from vwLBSampleTransactions -- 57,184
    
/**************************************************** 
FILE #1 - transaction file data 
    file name: SMI - Transactions 03092011 to 03082015
    records:     4.1M - 4.5M
    runtime:     60 sec 
****************************************************/
-- change SQL output to "Results to File"
    select * from vwLBSampleTransactions -- 4,244,601 rows   @46 sec
                                    
                                    
/****************************************************  
FILE #2 - SKU file 
    file name: SMI - SKUs 03092011 to 03082015
    records:     48K - 57K records (^ about 1K/month)
    runtime:     10 - 30 sec    
****************************************************/
    select -- 57,184 records @18 sec 
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
    --	and PGC.ixMarket <> 'SR' and PGC.ixMarket <> 'R' and PGC.ixMarket <> 'PC' and PGC.ixMarket <> 'SM' and PGC.ixMarket <> 'B' and PGC.ixMarket <> '2B' and PGC.ixMarket <> 'TE'


/****************************************************  
FILE #3 - PRODUCTS w/ advanced market info 
    file name: SMI - SKU - Additional Markets File 03092011 to 03082015
    records:   165K - 176K
    runtime:   20-30 sec
 ****************************************************/
    -- STEP 1 of 3
        -- !! RUN IN TOAD from the TNG(live) db
                -- UPDATED VERSION FROM CCC 1-21-15  
                SELECT ixSOPSKU as 'ixSKU', -- 333,836 Rows
                  M.sMarketName as 'ixMarket'
                FROM tblmarket M
                  left join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket 
                  left join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase
                  left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase
                where
                  SV.ixSOPSKU is not null
                  and M.sMarketName <> 'Garage Sale'
                order by SV.ixSOPSKU
                      
    -- STEP 2 of 3
        -- RightClick on result set> QuickExport >File   >CSVFile > Save as PJC_SKUMarketsForLB
        -- TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]
        -- populate [SMITemp].dbo.[PJC_SKUMarketsForLB] with data in the PJC_SKUMarketsForLB.csv file that was just created
        -- select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
            
    -- STEP 3 of 3  create output for LB file               
            select -- 175,973 records  @20 secs
            distinct  /* sm.ixMarket  */
	            sm.ixSKU as 'itemid',
	            sm.ixMarket as 'market'
            from [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
             -- [SMITemp].dbo.[ccc_sku_markets]  <-- got blown away...no code in the repository so rebuilt manually in the above table
            where sm.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
	            and sm.ixMarket is NOT null
	
/**** NOTES from analysis done on 1-21-15
as of 1-21-15 1,879 SKUs are being excluded because they have no market assigned in TNG.

Wyatt was sent a list of 1,043 the above SKUs (the ones that were still active as far as TNG determins).
They had sales totalling $800K in 2014 alone.  He was going to review the list and have someone update 
the markets based on the highesr 12 Month sales $ having priority.

The SOP Market is assigned to a SKU in another file.
*/


/****************************************************  
FILE #4 - CUSTOMER file 
    file name:   SMI - Customers 03092011 to 03082015
    records:     457K - 472K
    runtime:     20-40 sec  
 ****************************************************/
    select -- 472,956 records @28 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    from 
	    tblCustomer C 
    where
	    C.ixCustomer in (select distinct LBST.custid from vwLBSampleTransactions LBST)


/****************************************************  
FILE #5 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:          SMI - Customer - Catalogs Mailed File 03092011 to 03082015
    approx storage(MB): 211 - 260
    approx records:     7.6M - 9.5M
    approx runtime:     1 - 3 mins
****************************************************/
    select -- 9,524,373  records      
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
    from
	    tblCustomerOffer co
	    left join tblSourceCode sc on co.ixSourceCode=sc.ixSourceCode
	    left join tblCatalogMaster cm on sc.ixCatalog=cm.ixCatalog
	    left join tblCustomer c on co.ixCustomer=c.ixCustomer
    where
	    co.sType='OFFER'
	    and co.dtActiveStartDate between '03/09/2011' and '03/08/2015'     
	    and co.ixCustomer in (select lb.custid from vwLBSampleTransactions lb) 


/****************************************************  
FILE #6 - SKUs & applications 
    
    file name:          SMI - SKUs and Applications 03092011 to 03082015.txt
    approx storage(MB): 2.2 MB
    approx records:     62-63K
    approx runtime:     2 sec    
****************************************************/
/*  !! RUN IN TOAD from the TNG(live) db
        Tools/Export/Export Wizard
            click "Add" on Export Objects List
                select "Query"
                    paste query
                        select Tab Delimeted Text
                        NO quote delimiter
                        Use Column Names for a Header Row
*/
    select  -- 63,352 records
        sv.ixSOPSKU as 'itemid',
        a.sApplicationGroup as 'application_group',
        a.sApplicationValue as 'application_subgroup'
    from 
        tblskuvariant_application_xref svax
        left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
        left join tblapplication a on a.ixApplication = svax.ixApplication



/************************************************
Manually inspect each file.

File Summary:                                                                                        /   QC CHECKS   \
                    Approx                                                                          /                 \
    Approx          File                                                                           /Size    Data       \
#   records         Size (MB)   File Name                                                           (MB)    Format  #Rec
==  ===========     =========   =================================================================   ====    ======  ====
1   4.1M - 4.5M      170 - 191  SMI - Transactions <MM-DD-YYYY> to <MM-DD-YYYY>.txt                 Y       Y       Y
2    48K - 57K       7.0 - 8.3  SMI - SKUs <MM-DD-YYYY> to <MM-DD-YYYY>.txt                         Y       Y       Y
3   165K - 175K      3.5 - 3.8  SMI - SKU - Additional Markets <MM-DD-YYYY> to <MM-DD-YYYY>.txt     Y       Y       Y
4   457K - 472K     10.1 - 10.5 SMI - Customers  <MM-DD-YYYY> to <MM-DD-YYYY>.txt                   Y       Y       Y     
5   7.6M - 9.5M      211 - 268  SMI - Customer - Catalogs Mailed <MM-DD-YYYY> to <MM-DD-YYYY>.txt   Y       Y       Y         
6       63K          2.2 - 2.3  SMI - SKUs and Applications <MM-DD-YYYY> to <MM-DD-YYYY>.txt        Y       Y       Y


   Zip the files and place them in in N:\Misc Items.
   naming convention = "SMI - dataset 03-09-2011 to 03-08-2015.zip" <-- or .7z
*/    
    
    
      

/***********  TRANSMIT FILES TO LOYALTY BUILDERS  ***********

access the secured ftp account: 

    use Filezilla

    hostname: sftp://ftp.longbowdm.com  
    Username = speedway
    PW = yW4Sgwjj
    
If there are any password issues, 
call Al Trudell at (603)610-8810
albertt@loyaltybuilders.com

********************************************************* /
