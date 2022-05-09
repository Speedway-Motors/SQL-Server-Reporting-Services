SELECT C.ixCustomer 
     , sCustomerFirstName
     , sCustomerLastName
     , sEmailAddress
     , sDayPhone 
     , sCustomerType 
     , ixCustomerType
     , iPriceLevel
     , ISNULL(sMapTerms, '') + ' - ' + ISNULL(sMapTermsLongDescription, '')
     , BNV.TNT AS BnvTNT
     , LNK.TNT AS LnkTNT     
     , sMailToZip 
     , sMailToState 
     , Orders.Merch
     , Orders.AfcoSales
     , Orders.DynaSales
     , Orders.ProSales
     , Orders.GM
     , Orders.AfcoGM
     , Orders.DynaGM
     , Orders.ProGM
     , Orders.Freight
FROM tblCustomer C 
LEFT JOIN (SELECT O.ixCustomer 
                , SUM(O.mMerchandise) AS Merch
                , AFCO.Merch AS AfcoSales
                , Dynatech.Merch AS DynaSales
                , PRO.Merch AS ProSales
                , SUM(O.mMerchandiseCost) AS Cost
                , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM
                , AFCO.GM AS AfcoGM
                , Dynatech.GM AS DynaGM
                , PRO.GM AS ProGM                                
                , SUM(O.mShipping) AS Freight
           FROM tblOrder O 
           LEFT JOIN (SELECT O.ixCustomer 
                           , SUM(OL.mExtendedPrice) AS Merch
                           , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GM                        
					  FROM tblOrder O 
					  LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
					  LEFT JOIN tblVendorSKU VS ON VS.ixSKU = OL.ixSKU 
					  WHERE O.dtShippedDate BETWEEN DATEADD(day,-365,'07/17/13') AND '07/17/13'
					    AND O.sOrderStatus = 'Shipped' 
					    AND VS.ixVendor IN ('0106', '0108', '0111', '0136')
					  GROUP BY O.ixCustomer
					 ) AFCO ON AFCO.ixCustomer = O.ixCustomer
           LEFT JOIN (SELECT O.ixCustomer 
                           , SUM(OL.mExtendedPrice) AS Merch
                           , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GM                        
					  FROM tblOrder O 
					  LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
					  LEFT JOIN tblVendorSKU VS ON VS.ixSKU = OL.ixSKU 
					  WHERE O.dtShippedDate BETWEEN DATEADD(day,-365,'07/17/13') AND '07/17/13'
					    AND O.sOrderStatus = 'Shipped' 
					    AND VS.ixVendor IN ('0311', '0313')
					  GROUP BY O.ixCustomer
					 ) Dynatech ON Dynatech.ixCustomer = O.ixCustomer
           LEFT JOIN (SELECT O.ixCustomer 
                           , SUM(OL.mExtendedPrice) AS Merch
                           , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GM                        
					  FROM tblOrder O 
					  LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
					  LEFT JOIN tblVendorSKU VS ON VS.ixSKU = OL.ixSKU 
					  WHERE O.dtShippedDate BETWEEN DATEADD(day,-365,'07/17/13') AND '07/17/13'
					    AND O.sOrderStatus = 'Shipped' 
					    AND VS.ixVendor IN ('0582')
					  GROUP BY O.ixCustomer
					 ) PRO ON PRO.ixCustomer = O.ixCustomer					 					 
           WHERE dtShippedDate BETWEEN DATEADD(day,-365,'07/17/13') AND '07/17/13'
             AND sOrderStatus = 'Shipped' 
           GROUP BY O.ixCustomer  
                  , AFCO.Merch 
                  , Dynatech.Merch 
                  , PRO.Merch 
                  , AFCO.GM 
                  , Dynatech.GM 
                  , PRO.GM                                      
          ) Orders ON Orders.ixCustomer = C.ixCustomer 
LEFT JOIN (SELECT DISTINCT dbo.BestBoonvilleTNT(C.sMailToZip) AS TNT
                , O.ixCustomer
           FROM tblOrder O 
           LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
           WHERE dtShippedDate BETWEEN DATEADD(day,-365,'07/17/13') AND '07/17/13'
            AND (C.sMailToCountry = 'USA' 
                  OR C.sMailToCountry IS NULL)
            AND C.sMailToZip NOT LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]' 
            AND C.sMailToZip NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-%'   
            AND C.sMailToZip <> 'F'                          
          ) BNV ON BNV.ixCustomer = C.ixCustomer            
LEFT JOIN (SELECT DISTINCT dbo.BestLincolnTNT(C.sMailToZip) AS TNT
                , O.ixCustomer
           FROM tblOrder O 
           LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
           WHERE dtShippedDate BETWEEN DATEADD(day,-365,'07/17/13') AND '07/17/13'
            AND (C.sMailToCountry = 'USA' 
                  OR C.sMailToCountry IS NULL)
            AND C.sMailToZip NOT LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]' 
            AND C.sMailToZip NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-%'  
            AND C.sMailToZip <> 'F'           
          ) LNK ON LNK.ixCustomer = C.ixCustomer           
WHERE ixCustomerType IN ('30', '40') -- <> '1' --   
  AND flgDeletedFromSOP = 0 
 -- AND sCustomerType <> 'Retail'     
 ORDER BY Merch DESC
     , ixCustomer 
