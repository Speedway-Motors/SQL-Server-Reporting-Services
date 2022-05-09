-- Zip code fields throughout SMI Reporting
SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) like '%ZIP%' )
ORDER BY name


/*
TABLE                       FIELD       DATATYPE
======================      ==========  ============
tblCatalogRequest           ixZipCode   varchar(15)
tblLocalTaxCode             ixZipCode   varchar(15)

tblTrailerZipTNT            ixZipCode   int         -- int? wtf!?! always zero pad this field or cast/convert other fied on any joins. Royal PITA!
tblDeliveryAreaSurcharge    ixZipCode   nvarchar(15)

tblDropship                 sZip        varchar(10)
tblVendor                   sZip        varchar(10)

tblCustomer                 sMailToZip  varchar(15)
tblEvent                    sZipCode    varchar(15)
tblOrder                    sShipToZip  varchar(15)



*/



