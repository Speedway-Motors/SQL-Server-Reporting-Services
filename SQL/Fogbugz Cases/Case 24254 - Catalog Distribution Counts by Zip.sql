SELECT DISTINCT sMailToZip
     , COUNT(DISTINCT ixCustomerOffer) AS OffersMailed 
     , G.ixState
FROM tblCustomerOffer CO
LEFT JOIN tblCustomer C ON C.ixCustomer = CO.ixCustomer
LEFT JOIN tblGeography G ON G.ixZip3 = SUBSTRING(C.sMailToZip, 1, 3) 
WHERE CO.ixSourceCode LIKE '375%' 
  AND LEN(CO.ixSourceCode) = 5 
  AND G.ixCountry IS NOT NULL 
GROUP BY sMailToZip
       , G.ixState
ORDER BY ixState

-- 31,096 rows 