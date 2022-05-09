 /* Case 24847 - Loyalty Builders Data Set Dec 2010 thru Nov 2014 */
 
 -- SQL based on Case 24630
 -- run on DW1.[SMI Reporting]
 
 -- NOTEPAD++ must be used to open the HUGE text files.  
 -- (transaction file has 4M+ records. Cust - Cats Mailed file has (9M+)
   
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
-- INTO [SMITemp].dbo.LBSampleTransactions_12152014	
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
	and O.dtOrderDate between '12/01/2010' and '11/30/2014'
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

select CONVERT(VARCHAR(10), dtDate, 10) 'dtDate   ',ixDate from tblDate where dtDate in ('12/01/2010','11/30/2014')
/*
dtDate   	ixDate
12-01-10	15676
11-30-14	17136
*/


select COUNT(*) from vwLBSampleTransactions


[SMITemp].dbo.LBSampleTransactions_12152014 -- 4,134,749 records

    
/**************************************************** 
FILE #1 - transaction file data 

    file name: LB - Transactions 12012010 to 11302014.txt 
                 approx
    storage(MB): 170 - 191
    records:     4.1M - 4.5M
    runtime:     60 sec 
      
****************************************************/
-- change SQL output to "RESULTS TO FILE"
select COUNT(*) from vwLBSampleTransactions -- 4,134,749 rows   @60 sec
-- where custid = 814980                                     -- 1,071,842 rows   @:40

                                    
/****************************************************  
FILE #2 - SKU file 

    file name: LB - SKUs 12012010 to 11302014.txt
                 approx 
    storage(MB): 7.0 - 7.8
    records:     48K - 54K records
    runtime:     10 - 30 sec    
    
****************************************************/
select -- 53,170 records @23 sec 
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

    file name: LB - SKU - Additional Markets File 12012010 to 11302014.txt
    approx
    storage(MB):    3.5 - 3.8
    records:        165K - 176K
    runtime:        20-30 sec
 ****************************************************/
select -- 175,086 records
	sm.ixSKU as 'itemid',
	sm.ixMarket as 'market'
from
	[SMITemp].dbo.[ccc_sku_markets] sm -- <-- need the code behind this.  Should probably make it a view if possible.  vwLBSKUMarkets ?
where
	sm.ixSKU in (select distinct LBST.itemid from vwLBSampleTransactions LBST)
	and sm.ixMarket is not null

-- select * from [SMITemp].dbo.[ccc_sku_markets]



/****************************************************  
FILE #4 - CUSTOMER file 

    file name:   LB - Customer File 12012010 to 11302014.txt
    approx
    storage(MB): 10.1 - 10.5
    records:     457K - 472K
    runtime:     20-40 sec  
 ****************************************************/
select -- 460,898 records
	C.ixCustomer as 'custid',
	C.sMailToState as 'state',
	convert(varchar, C.dtAccountCreateDate,101) as 'create_date'
from 
	tblCustomer C 
where
	C.ixCustomer in (select distinct LBST.custid from vwLBSampleTransactions LBST)



/****************************************************  
FILE #5 - catalogs mailed to each cust & the corresponding type of catalog 
    file name:          LB - Customer - Catalogs Mailed File 12012010 to 11302014.txt
    approx storage(MB): 211 - 260
    approx records:     7.6M - 9.3M
    approx runtime:     1 - 3 mins
****************************************************/
select -- 9,183,216 records
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
	and co.dtActiveStartDate between '12/01/2010' and '11/30/2014'     
	and co.ixCustomer in (select lb.custid from vwLBSampleTransactions lb)
	and c.sCustomerType='Retail'


/****************************************************  
FILE #6 - SKUs & applications 
    
    file name:          LB - SKUs and applications File 12012010 to 11302014.txt
    approx storage(MB): 2.2 MB
    approx records:     62-63K
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
select  -- 62,813 records
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
1   4.1M - 4.5M      170 - 191  LB - Transactions <MM-DD-YYYY> to <MM-DD-YYYY>.txt 
2    48K - 53K       7.0 - 7.6  LB - SKUs <MM-DD-YYYY> to <MM-DD-YYYY>.txt 
3   165K - 175K      3.5 - 3.7  LB - SKU - Additional Markets <MM-DD-YYYY> to <MM-DD-YYYY>.txt 
4   457K - 472K     10.1 - 10.5 LB - Customers  <MM-DD-YYYY> to <MM-DD-YYYY>.txt 
5   7.6M - 9.3M      211 - 260  LB - Customer - Catalogs Mailed <MM-DD-YYYY> to <MM-DD-YYYY>.txt 
6       63K             2.2     LB - SKUs and applications <MM-DD-YYYY> to <MM-DD-YYYY>.txt 


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
