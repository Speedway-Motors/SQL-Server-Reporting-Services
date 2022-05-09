SELECT V.ixVendor
     , V.sName
     , VS.ixSKU
     , S.sDescription
     , Sales.Gross 
     , Rtns.Rtns 
     , Sales.Gross - ISNULL(Rtns.Rtns,0) AS NetSales 
     , S.ixPGC
     , S.ixHarmonizedTariffCode
     , S.sSEMACategory
     , S.sSEMASubCategory
     , S.sSEMAPart
FROM tblVendorSKU VS
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor     
LEFT JOIN tblSKU S ON S.ixSKU = VS.ixSKU
LEFT JOIN (SELECT OL.ixSKU 
                , SUM(ISNULL(OL.mExtendedPrice,0)) AS Gross
           FROM tblOrderLine OL 
           LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder
           WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() --@StartDate AND @EndDate
			 AND O.sOrderStatus = 'Shipped' 
			 --AND O.sOrderType <> 'Internal' --include per JJM
			 --AND O.sOrderChannel <> 'INTERNAL' --include per JJM
			 AND O.mMerchandise > 0 
		   GROUP BY OL.ixSKU 
		  ) Sales ON Sales.ixSKU = VS.ixSKU
LEFT JOIN (SELECT CMD.ixSKU 
                , SUM(ISNULL(CMD.mExtendedPrice,0)) AS Rtns 
		   FROM tblCreditMemoDetail CMD
		   LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo
		   WHERE CMM.dtCreateDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() --@StartDate AND @EndDate
		     AND CMM.flgCanceled = '0'
		   GROUP BY CMD.ixSKU
		  ) Rtns ON Rtns.ixSKU = VS.ixSKU		
WHERE V.ixVendor = '1275'
--(V.flgOverseas = '1'
--    OR V.ixVendor IN ('0900', '0916', '0917', '0940', '0945', '0950', '0955', '0555 ', '0111', '0106', '0108')
--      ) 
   AND VS.iOrdinality = '1'
 		    
		  