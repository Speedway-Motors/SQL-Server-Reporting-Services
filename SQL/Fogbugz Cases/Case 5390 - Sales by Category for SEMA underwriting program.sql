/***** revenue by PRC *******/
/*
SELECT
    isnull(SALES.ixPGC,RETURNS.ixPGC)		                ixPGC,
    isnull(SALES.sDescription,RETURNS.sDescription)		    PGC,    
    isnull(SALES.Sales,0)						            GrossSales,
    isnull(RETURNS.Returns,0)						        'Returns',
    isnull(SALES.Sales,0)-isnull(RETURNS.Returns,0)			NetSales
FROM
             /****** SALES *********/	
             (select PGC.ixPGC,
                    PGC.sDescription,
		            SUM(OL.iQuantity*(CASE when OL.flgKitComponent = 0 then OL.mUnitPrice
                                           else S.mPriceLevel1
                                           end)) Sales
             from tblOrder O 
	            left join tblOrderLine OL   on OL.ixOrder = O.ixOrder
	            left join tblSKU S          on S.ixSKU = OL.ixSKU	
                left join tblVendorSKU VS   on VS.ixSKU = S.ixSKU	
                left join tblPGC PGC        on PGC.ixPGC = S.ixPGC	
                     join tblDate D         on OL.ixShippedDate = D.ixDate	
             where O.sOrderChannel <> 'INTERNAL'
               and OL.flgLineStatus = 'Shipped'
               --and OL.flgKitComponent = 0
               and S.flgIsKit = 0
               and D.dtDate >= '01/01/2009' 
               and D.dtDate <  '01/01/2010'
               and (VS.iOrdinality = 1
                    and ixVendor not in ('0106','0108','0311','0313')) -- AFCO primary Vendor
and S.ixSKU in ('4580458','458103','458108','458112','45811210','458116','4581161','45811610','458122','4581221',
'45812210','458132','4581321','45813210','4581632','458208','4582080','45820810','458222','4582221','45822210',
'458232','45827004','458275','715750','715752','91053440','91053445','91053446','91053450','91053455','91053456',
'91076050','91076054')
             group by PGC.ixPGC, PGC.sDescription
             ) SALES   
	  full outer join
			/****** RETURNS *********/	
			(select PGC.ixPGC,
                   PGC.sDescription,
				   SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Returns
			from tblCreditMemoDetail CMD
				left join tblSKU S                  on S.ixSKU = CMD.ixSKU
                left join tblVendorSKU VS           on VS.ixSKU = S.ixSKU	
				left join tblCreditMemoMaster CMM   on CMM.ixCreditMemo = CMD.ixCreditMemo
                left join tblPGC PGC                on PGC.ixPGC = S.ixPGC	
			where
				    CMM.dtCreateDate >= '01/01/2009' 
		        and CMM.dtCreateDate <  '01/01/2010' 
			    and S.flgIsKit = 0
                and (VS.iOrdinality = 1
                    and ixVendor not in ('0106','0108','0311','0313'))
and S.ixSKU in ('4580458','458103','458108','458112','45811210','458116','4581161','45811610','458122','4581221',
'45812210','458132','4581321','45813210','4581632','458208','4582080','45820810','458222','4582221','45822210',
'458232','45827004','458275','715750','715752','91053440','91053445','91053446','91053450','91053455','91053456',
'91076050','91076054')
		    group by PGC.ixPGC, PGC.sDescription
            ) RETURNS on SALES.ixPGC = RETURNS.ixPGC
ORDER BY isnull(SALES.ixPGC,RETURNS.ixPGC)

SELECT
    isnull(SALES.ixVendor,RETURNS.ixVendor)		            ixVendor,
    isnull(SALES.Vendor,RETURNS.Vendor)		                Vendor,    
    isnull(SALES.Sales,0)						            GrossSales,
    isnull(RETURNS.Returns,0)						        'Returns',
    isnull(SALES.Sales,0)-isnull(RETURNS.Returns,0)			NetSales,
    isnull(SALES.Country,RETURNS.Country)                 sCountry,
    isnull(SALES.MailingAddress,RETURNS.MailingAddress)		MailingAddress
FROM
             /****** SALES *********/	
             (select V.ixVendor,
                    V.sName Vendor,
                    V.sCountry Country,
                    V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip MailingAddress,
		            SUM(OL.iQuantity*(CASE when OL.flgKitComponent = 0 then OL.mUnitPrice
                                           else S.mPriceLevel1
                                           end)) Sales
             from tblOrder O 
	            left join tblOrderLine OL   on OL.ixOrder = O.ixOrder
	            left join tblSKU S          on S.ixSKU = OL.ixSKU	
                left join tblVendorSKU VS   on VS.ixSKU = S.ixSKU	
                left join tblVendor V       on V.ixVendor = VS.ixVendor
                left join tblPGC PGC        on PGC.ixPGC = S.ixPGC	
                     join tblDate D         on OL.ixShippedDate = D.ixDate	
             where O.sOrderChannel <> 'INTERNAL'
               and OL.flgLineStatus = 'Shipped'
               --and OL.flgKitComponent = 0
               and S.flgIsKit = 0
               and D.dtDate >= '01/01/2009' 
               and D.dtDate <  '01/01/2010'
               and (VS.iOrdinality = 1
                    and VS.ixVendor not in ('0106','0108','0311','0313')) -- AFCO primary Vendor
             group by V.ixVendor, V.sName, V.sCountry,
                    V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip
             ) SALES   
	  full outer join
			/****** RETURNS *********/	
			(select V.ixVendor,
                    V.sName Vendor,
                    V.sCountry Country,
                    V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip MailingAddress,
				   SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Returns
			from tblCreditMemoDetail CMD
				left join tblSKU S                  on S.ixSKU = CMD.ixSKU
                left join tblVendorSKU VS           on VS.ixSKU = S.ixSKU	
                left join tblVendor V               on V.ixVendor = VS.ixVendor
				left join tblCreditMemoMaster CMM   on CMM.ixCreditMemo = CMD.ixCreditMemo
                left join tblPGC PGC                on PGC.ixPGC = S.ixPGC	
			where
				    CMM.dtCreateDate >= '01/01/2009' 
		        and CMM.dtCreateDate <  '01/01/2010' 
			    and S.flgIsKit = 0
                and (VS.iOrdinality = 1
                    and VS.ixVendor not in ('0106','0108','0311','0313'))
		    group by V.ixVendor, V.sName, V.sCountry,V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip
            ) RETURNS on SALES.ixVendor = RETURNS.ixVendor
ORDER BY isnull(SALES.ixVendor,RETURNS.ixVendor)
*/




-- RESULTS FOR SPECIFIC VENDORS/PGCs
SELECT
    isnull(SALES.ixVendor,RETURNS.ixVendor)		    ixVendor,
    isnull(SALES.Sales,0)						    GrossSales,
    isnull(RETURNS.Returns,0)						'Returns',
    isnull(SALES.Sales,0)-isnull(RETURNS.Returns,0) NetSales

FROM
             /****** SALES *********/	
             (select V.ixVendor,
		            SUM(OL.iQuantity*(CASE when OL.flgKitComponent = 0 then OL.mUnitPrice
                                           else S.mPriceLevel1
                                           end)) Sales
             from tblOrder O 
	            left join tblOrderLine OL   on OL.ixOrder = O.ixOrder
	            left join tblSKU S          on S.ixSKU = OL.ixSKU	
                left join tblVendorSKU VS   on VS.ixSKU = S.ixSKU	
                left join tblVendor V       on V.ixVendor = VS.ixVendor
                left join tblPGC PGC        on PGC.ixPGC = S.ixPGC	
                     join tblDate D         on OL.ixShippedDate = D.ixDate	
             where O.sOrderChannel <> 'INTERNAL'
               and OL.flgLineStatus = 'Shipped'
               --and OL.flgKitComponent = 0
               and S.flgIsKit = 0
               and D.dtDate >= '01/01/2009' 
               and D.dtDate <  '01/01/2010'
               and (VS.iOrdinality = 1
                    and VS.ixVendor not in ('0106','0108','0311','0313')) -- AFCO primary Vendor
and (V.ixVendor in ('0099','1265','1363','1625','1729','1735','1825','2115','2240','2423','2793','2895','2915','2920','3415','3895')
    AND upper(S.ixPGC) in ('2D','5D','CD','HD','KD','MD','OD','RD','SD','ZD'))
             group by V.ixVendor, V.sName, V.sCountry,
                    V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip
             ) SALES   
	  full outer join
			/****** RETURNS *********/	
			(select V.ixVendor,
				   SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Returns
			from tblCreditMemoDetail CMD
				left join tblSKU S                  on S.ixSKU = CMD.ixSKU
                left join tblVendorSKU VS           on VS.ixSKU = S.ixSKU	
                left join tblVendor V               on V.ixVendor = VS.ixVendor
				left join tblCreditMemoMaster CMM   on CMM.ixCreditMemo = CMD.ixCreditMemo
                left join tblPGC PGC                on PGC.ixPGC = S.ixPGC	
			where
				    CMM.dtCreateDate >= '01/01/2009' 
		        and CMM.dtCreateDate <  '01/01/2010' 
			    and S.flgIsKit = 0
                and (VS.iOrdinality = 1
                    and VS.ixVendor not in ('0106','0108','0311','0313'))
and (V.ixVendor in ('0099','1265','1363','1625','1729','1735','1825','2115','2240','2423','2793','2895','2915','2920','3415','3895')
    AND (S.ixPGC) in ('2D','5D','CD','HD','KD','MD','OD','RD','SD','ZD'))
		    group by V.ixVendor, V.sName, V.sCountry,V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip
            ) RETURNS on SALES.ixVendor = RETURNS.ixVendor
ORDER BY isnull(SALES.ixVendor,RETURNS.ixVendor)

/*
select distinct VS.ixVendor, SKU.ixPGC
from tblSKU SKU
    join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
where VS.iOrdinality = 1
and VS.ixVendor in ('0099','1265','1363','1625','1729','1735','1825','2115','2240','2423','2793','2895','2915','2920','3415','3895')
 AND (SKU.ixPGC) in ('2D','5D','CD','HD','KD','MD','OD','RD','SD','ZD')
order by VS.ixVendor, SKU.ixPGC




select distinct ixPGC from tblSKU
order by ixPGC


select * from tblSKU where UPPER (ixPGC) = 'ZS'



*/