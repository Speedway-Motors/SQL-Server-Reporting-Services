 /* Case 25358 - Loyalty Builders Data Set Jan 19 2011 thru Jan 18 2015 */
 
 -- SQL based on Case 25148
 -- run on DW1.[SMI Reporting]   <-- it is POSSIBLE to run on DWSTAGING but very slow
 
 -- NOTEPAD++ must be used to open the HUGE (1M+ records) text files.  
 -- (transaction file has 4M+ records. Cust - Cats Mailed file has 9M+
   
/********************************************************************************************
-- EXPORT the first 5 files in Mgmt Studio by selecting "Results to File".
          the 6th file is generated in TOAD from the TNG(live) db (see details in that section).
 ********************************************************************************************/

/* view to build transaction file */
    -- ALTER the view script on DWSTAGING1 and either let replication pick it up or kick off the Replication job manually 
    -- so that everything can be run from DW1
ALTER VIEW vwLBSampleTransactions
as
(select      
        /*  COUNT(distinct O.ixCustomer) 466,900 */
	O.ixCustomer                        as 'custid',   
	OL.ixSKU                            as 'itemid',
	convert(varchar,O.dtOrderDate,101)  as 'txdate',
	OL.iQuantity                        as 'quantity',
	OL.mExtendedPrice                   as 'amount',
	O.sOrderChannel                     as 'order_channel'
--INTO [SMITemp].dbo.LBSampleTransactions_02012015	
from vwCSTStartingPool CST
    join tblOrder O on O.ixCustomer = CST.ixCustomer -- 1) must be in tblOrder AND CST Starting Pool
	left join tblOrderLine OL on OL.ixOrder = O.ixOrder
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
	left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
	left join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation=99
where
/* try and exclude as many 'fake' SKUs (intangible, etc.) from result set. LB only care about real items */
	C.sCustomerType = 'Retail'
 --   and C.ixCustomerType = '1' -- REMOVED.  This was excluding 6,500 valid customers that had types (4,6,20,35,50,56,60,76,78,78.1,79,80,81,85,86,87,88,89)
	and O.dtOrderDate between '02/02/2011' and '02/01/2015'
	and O.sOrderType='Retail'	
	--and O.sSourceCodeGiven <> 'CUST-SERV' -- REMOVED.  already handled. their sOrderType = 'Customer Service'	no change in # of customers
	and O.sOrderStatus = 'Shipped'
	and O.mMerchandise > 0	
	and O.sShipToCountry='US'
	and O.iShipMethod in (1,2,3,4,5,6,7,8,9,12,13,14,32) -- <-- excluding (10,11,15,18,19,26,27) which are all for non-US orders.    Waiting for AL to verify that is 100% true for 15,18.  Why doesn't the above line take care of this?		
	--and O.sOrderChannel <> 'INTERNAL' -- REMOVED. As long as the Order Type is Retail the order channel is irrelevant.  Split MoP orders are/were being classified as INTERNAL order channel because they required additional manual work
	and O.ixOrder not like '%-%'	
	and OL.flgKitComponent = 0
	and SKU.flgIntangible=0
	and OL.mExtendedPrice > 0
	and OL.ixSKU not like 'HELP%'   
	and SKU.sDescription not like '%CATALOG%'  -- <-- added
	and SL.sPickingBin not like '%!%'
	--and SL.sPickingBin not like 'INS%'   -- REMOVED. inserts are all in picking bins with ! which are already excluded
	)

select COUNT(*) from vwLBSampleTransactions -- 4,231,939
/* SAMPLE */ select top 10 * from vwLBSampleTransactions

select COUNT(*) from [SMITemp].dbo.LBSampleTransactions_02012015 -- 4,236,453 records

select count(distinct itemid) from vwLBSampleTransactions -- 55,699  
    
/**************************************************** 
FILE #1 - transaction file data 

    file name: LB - Transactions 02022011 to 02012015.txt 
                 approx
    storage(MB): 170 - 191
    records:     4.1M - 4.5M
    runtime:     60 sec 
      
****************************************************/
-- change SQL output to "RESULTS TO FILE"
select * from vwLBSampleTransactions -- 4,236,453 rows   @60 sec
                                    
/****************************************************  
FILE #2 - SKU file 

    file name: LB - SKUs 02022011 to 02012015.txt
                 approx 
    storage(MB): 7.0 - 7.8
    records:     48K - 54K records
    runtime:     10 - 30 sec    
    
****************************************************/
select --55,699 records @18 sec 
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

    file name: LB - SKU - Additional Markets File 02022011 to 02012015.txt
    approx
    storage(MB):    3.5 - 3.8
    records:        165K - 176K
    runtime:        20-30 sec
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

            -- UPDATED VERSION FROM CCC 1-21-15  
            SELECT ixSOPSKU as 'ixSKU', -- 330,537 Rows
              M.sMarketName as 'ixMarket'
            FROM tblarket M
              left join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket 
              left join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase
              left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase
            where
              SV.ixSOPSKU is not null
              and M.sMarketName <> 'Garage Sale'
            order by SV.ixSOPSKU
            
-- TRUNCATE TABLE [SMITemp].dbo.[PJC_SKUMarketsForLB]
-- AND populate with output from Query above

-- select top 10 * from [SMITemp].dbo.[PJC_SKUMarketsForLB]                  
                  

                  
-- output for LB file
select -- 171,831 records  
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

    file name:   LB - Customers 02022011 to 02012015.txt
    approx
    storage(MB): 10.1 - 10.5
    records:     457K - 472K
    runtime:     20-40 sec  
 ****************************************************/
select -- 469,396 records
	C.ixCustomer as 'custid',
	C.sMailToState as 'state',
	convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
from 
	tblCustomer C 
where
	C.ixCustomer in (select distinct LBST.custid from vwLBSampleTransactions LBST)





/****************************************************  
FILE #5 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:          LB - Customer - Catalogs Mailed File 02022011 to 02012015.txt
    approx storage(MB): 211 - 260
    approx records:     7.6M - 9.3M
    approx runtime:     1 - 3 mins
****************************************************/
select -- 9,199,668  records      
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
	and co.dtActiveStartDate between '02/02/2011' and '02/01/2015'     
	and co.ixCustomer in (select lb.custid from vwLBSampleTransactions lb) 


/****************************************************  
FILE #6 - SKUs & applications 
    
    file name:          LB - SKUs and Applications 02022011 to 02012015.txt
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
select  -- 63,148 records
    sv.ixSOPSKU as 'itemid',
    a.sApplicationGroup as 'application_group',
    a.sApplicationValue as 'application_subgroup'
from 
    tblskuvariant_application_xref svax
    left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
    left join tblapplication a on a.ixApplication = svax.ixApplication



/************************************************
Manually inspect each file.

File Summary:                                                                                        /       QC CHECKS        \
                    Approx                                                                          /                          \
    Approx          File                                                                           /Size    Data Format         \
#   records         Size (MB)   File Name                                                           (MB)    (top few rows)  #Rec
==  ===========     =========   =================================================================   ====    ==============  ====
1   4.1M - 4.5M      170 - 191  LB - Transactions <MM-DD-YYYY> to <MM-DD-YYYY>.txt                  Y       Y               Y
2    48K - 56K       7.0 - 8.1  LB - SKUs <MM-DD-YYYY> to <MM-DD-YYYY>.txt                          Y       Y               Y  
3   165K - 175K      3.5 - 3.7  LB - SKU - Additional Markets <MM-DD-YYYY> to <MM-DD-YYYY>.txt      Y       Y               Y    
4   457K - 472K     10.1 - 10.5 LB - Customers  <MM-DD-YYYY> to <MM-DD-YYYY>.txt                    Y       Y               Y  
5   7.6M - 9.3M      211 - 260  LB - Customer - Catalogs Mailed <MM-DD-YYYY> to <MM-DD-YYYY>.txt    Y       Y               Y 
6       63K          2.2 - 2.3  LB - SKUs and Applications <MM-DD-YYYY> to <MM-DD-YYYY>.txt         Y       Y               Y


   Zip the files and place them in in N:\Misc Items.
   naming convention = "LB - dataset  <MM-DD-YYYY> to <MM-DD-YYYY>.zip" <-- or .7z
*/    
    
    
      

/***********  TRANSMIT FILES TO LOYALTY BUILDERS  ***********

access the secured ftp account: 

    use Filezilla

    hostname: sftp://ftp.longbowdm.com  
    Username = speedway
    PW = yW4Sgwjj
    
In the event you no longer have your password, 
call Al Trudell at (603)610-8810
albertt@loyaltybuilders.com

********************************************************* /
