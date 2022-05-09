 /* Case 24630 - Loyalty Builders refresh Data Sets */

/********************************************************************************************
-- EXPORT the first 5 files in Mgmt Studio by selecting "Results to File".
          the 6th file is generated in TOAD from the TNG(live) db (see details in that section).
 ********************************************************************************************/

/* view to build transaction file */
alter view vwLBSampleTransactions
as
(select                         --  2 day range took    4 mins with rolling calc order dates
                                --  4 years range took  1 min with hardcoded dates    
	O.ixCustomer as 'custid',   --  4,126,533 records @10/10/14
	OL.ixSKU as 'itemid',
	convert(varchar,O.dtOrderDate,101) as 'txdate',
	OL.iQuantity as 'quantity',
	OL.mExtendedPrice as 'amount',
	O.sOrderChannel as 'order_channel'
INTO [SMITemp].dbo.LBSampleTransactions_11182014	
from vwCSTStartingPool CST
    join tblOrder O on O.ixCustomer = CST.ixCustomer -- 1) must be in tblOrder AND CST Starting Pool
	left join tblOrderLine OL on OL.ixOrder = O.ixOrder
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
	left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
	left join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation=99
where
/* try and exclude as many 'fake' SKUs (intangible, etc.) from result set. LB only care about real items */
	C.sCustomerType = 'Retail'
    and C.ixCustomerType = '1'
	and O.dtOrderDate between '11/19/2010' and '11/18/2014'
	and O.sOrderType='Retail'	
	and O.sOrderStatus = 'Shipped'
	and O.iShipMethod in (1,2,3,4,5,6,7,8,9,12,13,14,32) -- <-- added 5,6,7,12 to the include list  (UPS 3 Day, USPS Priority, USPS Express, and UPS Standard)
	and O.mMerchandise > 0	
	and O.sShipToCountry='US'	
	and O.sOrderChannel <> 'INTERNAL'
	and O.ixOrder not like '%-%'	
	and O.sSourceCodeGiven <> 'CUST-SERV'	
	and OL.flgKitComponent = 0
	and SKU.flgIntangible=0
	and OL.mExtendedPrice > 0
	and OL.ixSKU not like 'HELP%'   
	and SKU.sDescription not like '%CATALOG%'  -- <-- added
	--and SL.sPickingBin not like 'INS%'          -- <-- inserts are all in picking bins with !, handled below
	and SL.sPickingBin not like '%!%'
	)

select * from tblDate where dtDate = '11/19/2010'

select * from [SMITemp].dbo.LBSampleTransactions_11182014 -- 4,136,091 records

    
/**************************************************** 
FILE #1 - transaction file data 

    file name: LB - 11-19-2010 onward Transaction File.txt 
                 approx
    storage(MB): 170 - 191
    records:     4.1M - 4.5M
    runtime:     60 sec 
      
****************************************************/
select * from vwLBSampleTransactions -- 4,123,392 rows   @1:26
where custid = 814980                                     -- 1,071,842 rows   @:40

                                    
/****************************************************  
FILE #2 - SKU file 

    file name: LB - 11-19-2010 onward SKU File.txt
                 approx 
    storage(MB): 7.0 - 7.6
    records:     48K - 53K records
    runtime:     10 - 30 sec    
    
****************************************************/
select -- 52,845 records
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

    file name: LB - 11-19-2010 onward SKU - Additional Markets File.txt
    approx
    storage(MB):    3.5 - 3.7
    records:        165K - 175K
    runtime:        30 sec
 ****************************************************/
select -- 174,799 records
	sm.ixSKU as 'itemid',
	sm.ixMarket as 'market'
from
	[SMITemp].dbo.[ccc_sku_markets] sm
where
	sm.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
	and sm.ixMarket is not null


/****************************************************  
FILE #4 - CUSTOMER file 

    file name:          LB - 11-19-2010 onward Customer File.txt
    approx
    storage(MB): 10.1 - 10.5
    records:     457K - 472K
    runtime:     37 sec  
 ****************************************************/
select -- 460,643 records
	C.ixCustomer as 'custid',
	C.sMailToState as 'state',
	convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
from 
	tblCustomer C 
where
	C.ixCustomer in (select distinct LBST.custid from vwLBSampleTransactions LBST)



/****************************************************  
FILE #5 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:          LB - 11-19-2010 onward Customer - Catalogs Mailed File.txt
    approx storage(MB): 211 - 260
    approx records:     7.6M - 9.3M
    approx runtime:     1 - 3 mins
****************************************************/
select -- 9,234,005 records
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
	--and co.dtActiveStartDate between DATEADD(mm, -48, getdate()) and DATEADD(dd,-1,DATEDIFF(dd,0,getdate())) -- 48 months ago TO yesterday (excludes future offers)
	and co.dtActiveStartDate between '10/09/2010' and '10/08/2014'     
	and co.ixCustomer in (select lb.custid from vwLBSampleTransactions lb)
	and c.sCustomerType='Retail'


/****************************************************  
FILE #6 - SKUs & applications 
    
    file name:          LB - 11-24-2014 SKUs and applications File.txt
    approx storage(MB): 2.2 MB
    approx records:     63K
    approx runtime:     ## sec    
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
select  -- 62,665 records
    sv.ixSOPSKU as 'itemid',
    a.sApplicationGroup as 'application_group',
    a.sApplicationValue as 'application_subgroup'
from 
    tblskuvariant_application_xref svax
    left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
    left join tblapplication a on a.ixApplication = svax.ixApplication



/************************************************
Manually inspect each file.

File Summary:
                    Approx
    Approx          File          
#   records         Size (MB)   File Name
==  ===========     =========   =======================================================================
1   4.1M - 4.5M      170 - 191  LB - <MM-DD-YYYY (start date)> onward Transaction File.txt 
2    48K - 53K       7.0 - 7.6  LB - <MM-DD-YYYY (start date)> onward SKU File.txt
3   165K - 175K      3.5 - 3.7  LB - <MM-DD-YYYY (start date)> onward SKU - Additional Markets File.txt
4   457K - 472K     10.1 - 10.5 LB - <MM-DD-YYYY (start date)> onward Customer File.txt
5   7.6M - 9.3M      211 - 260  LB - <MM-DD-YYYY (start date)> onward Customer - Catalogs Mailed File.txt
6       63K             2.2     LB - <MM-DD-YYYY (date executed)> SKUs and applications File.txt


   Zip the files and place them in in N:\Misc Items.
   naming convention = "LB - MM-DD-YYYY onward dataset.zip" <-- or .7z
*/    
    
    
      

/***********  TRANSMIT FILES TO LOYALTY BUILDERS  ***********

access the secured ftp account: 

    ie browser best

    hostname: sftp://ftp.longbowdm.com  
    Username = speedway
    PW = 
    
In the event you no longer have your password, 
call Al Bertt at (603)610-8810
albertt@loyaltybuilders.com

********************************************************* /
