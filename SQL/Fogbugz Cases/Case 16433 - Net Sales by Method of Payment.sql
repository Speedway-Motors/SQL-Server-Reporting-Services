-- To determine orders --14219
SELECT O.ixCustomer AS Customer 
     , ISNULL(C.sCustomerFirstName, '') + ' ' + ISNULL(C.sCustomerLastName, '') AS Name
     , C.ixCustomerType AS Flag
     , C.sMapTerms AS Terms
     , C.sMapTermsLongDescription AS TermDescription
     , O.ixOrder AS OrderNumber 
     , NULL AS CreditMemo
     , SUM(ISNULL(mMerchandise,0)) AS MerchTotal
     , NULL AS MerchRfnd
     , SUM(ISNULL(mCredits,0)) + SUM(ISNULL(mPromoDiscount,0)) AS OtherTotal
     , NULL AS RestockCharge
     , SUM(ISNULL(mShipping,0)) AS Freight
     , NULL AS FreightRfnd
     , SUM(ISNULL(mTax,0)) AS SalesTax
     , NULL AS TaxRfnd
     , SUM(ISNULL(mMerchandise,0)) + SUM(ISNULL(mCredits,0)) + SUM(ISNULL(mPromoDiscount,0)) + SUM(ISNULL(mShipping,0)) + SUM(ISNULL(mTax,0)) AS SubTotal
     , sMethodOfPayment AS MOP
     , COUNT(DISTINCT O.ixOrder) AS OrdCnt 
     , NULL AS CreditCnt
FROM tblOrder O  
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE dtShippedDate BETWEEN '11/01/12' AND DATEADD(dd,-1,GETDATE()) --@StartDate AND @EndDate 
  and sOrderStatus IN ('Shipped', 'Dropshipped')
GROUP BY O.ixCustomer
       , ISNULL(C.sCustomerFirstName, '') + ' ' + ISNULL(C.sCustomerLastName, '') 
       , C.ixCustomerType
       , C.sMapTerms
       , C.sMapTermsLongDescription 
       , O.ixOrder      
	   , sMethodOfPayment


UNION 


--To determine credits
SELECT CMM.ixCustomer AS Customer 
     , ISNULL(C.sCustomerFirstName, '') + ' ' + ISNULL(C.sCustomerLastName, '') AS Name
     , C.ixCustomerType AS Flag
     , C.sMapTerms AS Terms
     , C.sMapTermsLongDescription AS TermDescription
     , CMM.ixOrder AS OrderNumber 
     , CMM.ixCreditMemo AS CreditMemo
     , NULL AS MerchTotal
     , (SUM(ISNULL(CMM.mMerchandise,0)))*-1 AS MerchRfnd
     , NULL AS OtherTotal
     , (SUM(ISNULL(CMM.mRestockFee,0)))*-1 AS RestockCharge
     , NULL AS Freight
     , SUM(ISNULL(CMM.mShipping,0)) AS FreightRfnd
     , NULL AS SalesTax
     , SUM(ISNULL(CMM.mTax,0)) AS TaxRfnd
     , (SUM(ISNULL(CMM.mMerchandise,0)))*-1 + (SUM(ISNULL(CMM.mRestockFee,0)))*-1 + SUM(ISNULL(CMM.mShipping,0)) + SUM(ISNULL(CMM.mTax,0)) AS SubTotal
     , CMM.sMethodOfPayment AS MOP
     , NULL AS OrdCnt 
     , COUNT(DISTINCT CMM.ixCreditMemo) AS CreditCnt
FROM tblCreditMemoMaster CMM  
LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer
WHERE dtCreateDate BETWEEN '11/01/12' AND DATEADD(dd,-1,GETDATE()) --@StartDate AND @EndDate 
  and flgCanceled = '0'
GROUP BY CMM.ixCustomer
       , ISNULL(C.sCustomerFirstName, '') + ' ' + ISNULL(C.sCustomerLastName, '') 
       , C.ixCustomerType
       , C.sMapTerms
       , C.sMapTermsLongDescription 
       , CMM.ixOrder    
       , CMM.ixCreditMemo  
	   , CMM.sMethodOfPayment