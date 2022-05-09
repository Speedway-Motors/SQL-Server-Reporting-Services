-- RESULTS FOR SPECIFIC VENDORS/PGCs
SELECT
    isnull(SALES.ixVendor,RETURNS.ixVendor)		    ixVendor,
    isnull(SALES.sName,RETURNS.sName)		        Vendor,
    isnull(SALES.sCountry,RETURNS.sCountry)		    Country,    
    isnull(SALES.Sales,0)						    GrossSales,
    isnull(RETURNS.Returns,0)						'Returns',
    isnull(SALES.Sales,0)-isnull(RETURNS.Returns,0) NetSales

FROM
             /****** SALES *********/	
             (select V.ixVendor,V.sName, V.sCountry,
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
--and (V.ixVendor NOT in ('0210','0449')
    AND (VS.iOrdinality = 1
         AND S.ixPGC = 'ZC')   -- in ('MC','RC','SC','ZC')
             group by V.ixVendor, V.sName, V.sCountry,
                    V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip
             ) SALES   
	  full outer join
			/****** RETURNS *********/	
			(select V.ixVendor,V.sName, V.sCountry,
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
--and (V.ixVendor in ('0210','0449')
    AND (VS.iOrdinality = 1
         AND S.ixPGC = 'ZC')   -- in ('MC','RC','SC','ZC')
		    group by V.ixVendor, V.sName, V.sCountry,V.sAddress1+' '+V.sAddress2+' '+V.sCity+' '+V.sState+' '+V.sZip
            ) RETURNS on SALES.ixVendor = RETURNS.ixVendor
ORDER BY isnull(SALES.ixVendor,RETURNS.ixVendor)
