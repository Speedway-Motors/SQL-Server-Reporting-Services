 /* SMIHD-1403 - Loyalty Builders Data Set 01-01-09 thru 06-25-15 */
 
 /********************************************************************************************
    SQL based on Case 25801
 -- run on DW1.[SMI Reporting]   (POSSIBLE to run on DWSTAGING but very slow)
 
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

    select COUNT(*) from vwLBSampleTransactions -- 6.5M

    select count(distinct itemid) from vwLBSampleTransactions -- 63K




/****************************************************  
FILE #1 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:  SMI - Customer - Catalogs Mailed File 01012009 to 06252015
    records:    11.5M-12.6M        previously 7.6M - 9.5M
    runtime:     3:06-3:46         previously 1 - 3 mins
****************************************************/
    select -- 12,582,796  records   
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
    file name:   SMI - Customers 01012009 to 06252015
    records:     570-581K     previously 457K - 472K
    runtime:     20-40 sec  
****************************************************/
    select -- 575,888 records @24 sec
	    C.ixCustomer as 'custid',
	    C.sMailToState as 'state',
	    convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
    from tblCustomer C 
    where C.ixCustomer in (select distinct custid 
                           from vwLBSampleTransactions)



                              
/****************************************************  
FILE #3 - Merged Customers
    file name:   SMI - Merged Customers 01012009 to 06252015
    records:     36K-38K   
    runtime:     3 sec   
****************************************************/
    -- PREP
    
        -- Al can currently export the list from SOP (we need to eventually make this a permanent table waiting on case SMIHD-927)
        -- TRUNCATE TABLE [SMITemp].dbo.PJC_MergedCustomers
        SELECT * INTO [SMITemp].dbo.PJC_MergedCustomers_BU06252015 -- 37,231
        FROM [SMITemp].dbo.PJC_MergedCustomers

        -- import data from latest file provided by Al
        -- column names and orders are:
        -- ixCustomerOriginal	ixCustomerMergedTo	dtDateMerged	MergedBy

        select COUNT(*) 'TotRows',
        COUNT(distinct ixCustomerOriginal) 'UniqueCusts'
        from [SMITemp].dbo.PJC_MergedCustomers
        /*
        TotRows	UniqueCusts
        38307	38307
        */

        select top 10 * from [SMITemp].dbo.PJC_MergedCustomers 

    -- CREATE OUTPUT FILE
    -- some customer account #'s were re-used after their original customers were merged
    -- This excludes those records
    Select M.ixCustomerOriginal as 'OrigCustid',    -- 38,125
        M.ixCustomerMergedTo as 'CustidMergedTo',
        M.dtDateMerged as 'DateMerged'
    --C.ixCustomer, C.dtAccountCreateDate, dtDateMerged --dtDateLastSOPUpdate, M.*
    from [SMITemp].dbo.PJC_MergedCustomers M
        join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    where C.flgDeletedFromSOP = 1

SELECT *
from [SMITemp].dbo.PJC_MergedCustomers
where dtDateMerged >= '06/17/2015'

-- example of an old account # that was merged.... then was re-used for a new account later
    SELECT * FROM tblCustomer
    where ixCustomer = 2458646

    SELECT * FROM vwCSTStartingPool
    where ixCustomer = 2458646

    select * from tblCustomerType
    where ixCustomerType = '82.1'

select M.*, C.dtAccountCreateDate
from [SMITemp].dbo.PJC_MergedCustomers M
    join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
where C.flgDeletedFromSOP = 0
order by dtAccountCreateDate

    -- how many are merged each month
    select iYear, iMonth, COUNT(*) QtyMerged
    from [SMITemp].dbo.PJC_MergedCustomers M
    join tblDate D on M.dtDateMerged = D.dtDate
    GROUP BY iYear, iMonth
    ORDER BY iYear desc, iMonth desc
    
    -- try refeeding any that aren't flagged as deleted... some account #s have been re-used!!!    
    select distinct M.ixCustomerOriginal, C.dtDateLastSOPUpdate
    from  [SMITemp].dbo.PJC_MergedCustomers M  
     join [SMI Reporting].dbo.tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
    where C.flgDeletedFromSOP = 0
    order by C.dtDateLastSOPUpdate




	


/****************************************************  
FILE #4 - SKUs w/ advanced market info 
    file name: SMI - SKU - Additional Markets File 01012009 to 06252015
    records:   352K - 358K
    runtime:   3-4 sec
 ****************************************************/
    -- STEP 1 of 3
        -- !! RUN IN TOAD from the TNG(live) db
                -- UPDATED VERSION FROM CCC 1-21-15  
                SELECT ixSOPSKU as 'ixSKU', -- 357,531 Rows
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
        -- RightClick on result set> QuickExport >File   >CSVFile > Save as PJC_SKUMarketsForLB    -- FILE SAVES IN MY DOCUMENTS FOLDER
        TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]
        -- populate [SMITemp].dbo.[PJC_SKUMarketsForLB] with data in the 
        -- PJC_SKUMarketsForLB.csv file that was just created (default locaion is My Documents)
        select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]   
            
    -- STEP 3 of 3  create output for LB file               
            select --  190,953   previously 185,572 records  @20-22 secs
            distinct  /* sm.ixMarket  */
	            sm.ixSKU as 'itemid',
	            sm.ixMarket as 'market'
            from [SMITemp].dbo.[PJC_SKUMarketsForLB] sm 
             -- [SMITemp].dbo.[ccc_sku_markets]  <-- got blown away...no code in the repository so rebuilt manually in the above table
            where sm.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
	            and sm.ixMarket is NOT null

 




 /****************************************************  
FILE #5 - SKU file 
    file name: SMI - SKUs 01012009 to 06252015
    records:     59-64K      previous = 48K - 57K records (^ about 1K/month)
    runtime:     10 - 30 sec    
****************************************************/
    select -- 63,474 records @22 sec 
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
    file name:          SMI - SKUs and Applications 01012009 to 06252015.txt
    records:     62-69K
    runtime:     2 sec    
****************************************************/
/*  !! RUN IN TOAD from the TNG(live) db
        Tools/Export/Export Wizard
            click "Add" on Export Objects List
                select "Query"
                    paste query
                        <NEXT>
                            use defaults --> Tab Delimeted Text, NO column delimiter, NO Quote Character,Use Column Names for a Header Row
*/
    select  -- 68,849 records
        sv.ixSOPSKU as 'itemid',
        a.sApplicationGroup as 'application_group',
        a.sApplicationValue as 'application_subgroup'
    from tblskuvariant_application_xref svax
        left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
        left join tblapplication a on a.ixApplication = svax.ixApplication





 
/**************************************************** 
FILE #7 - transaction file data 
    file name: SMI - Transactions 01012009 to 06252015
    records: 6.5M       previous = 4.1M - 4.5M
    runtime: 46-83 sec 
****************************************************/
-- change SQL output to "Results to File"
    select * from vwLBSampleTransactions -- 6470129 rows   @83 sec 
 







/******************************   Manually inspect each file   ****************************** 
File Summary:                                                                                        /   QC CHECKS   \
                    Approx                                                                          /                 \
    Approx          File                                                                           /Size    Data       \
#   records         Size (MB)   File Name                                                           (MB)    Format  #Rec
==  ===========     =========   =================================================================   ====    ======  ====
1  11.5M-11.9M       321-350    SMI - Customer - Catalogs Mailed 01-01-2009 to <YESTERDAY>.txt      Y       Y       Y
2   569K-581K      12.6-12.9    SMI - Customers 01-01-2009 to <YESTERDAY>.txt                       Y       Y       Y
3    37K-38K           1-1.5    SMI - Merged Customers 01-01-2009 to <YESTERDAY>.txt                Y       Y       Y
4   179K-186K        3.9-4.1    SMI - SKU - Additional Markets 01-01-2009 to <YESTERDAY>.txt        Y       Y       Y  
5     61-64K         8.6-9.3    SMI - SKUs 01-01-2009 to <YESTERDAY>.txt                            Y       Y       Y        
6    63K-69k         2.3-2.4    SMI - SKUs and Applications 01-01-2009 to <YESTERDAY>.txt           Y       Y       Y         
7   6.3M-6.5M        255-268    SMI - Transactions 01-01-2009 to <YESTERDAY>.txt                    Y       Y       Y         
    
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

Loyalty Builders team, the latest dataset for Speedway has been uploaded.  The filename is “SMI - dataset 01-01-2009 to 06-25-2015.7z”.   

It consists of the following 7 files appended with the date range used:

    RECORDS     FILENAME 
    =========   =======================  
#1 12,582,796   SMI - Customer - Catalogs Mailed  
#2    580,895   SMI - Customers                      
#3     38,125   SMI - Merged Customers
#4    190,953   SMI - SKU - Additional Markets
#5     63,474   SMI - SKUs
#6     68,849   SMI - SKUs and Applications
#7  6,470,129   SMI - Transactions


If there are any questions/concerns, email or call me prior to our next scheduled conference call. 

Thanks!

*** END **** /