--Number of customers who are in the Donnely deceased files that are currently on the list to receive #349
SELECT DISTINCT ixCustomer 
FROM dbo.ASC_16951_Deceased_Analysis_Old
WHERE ixCustomer IN (SELECT DISTINCT ixCustomer FROM dbo.ASC_16940_CST_OutputFile_349)
  AND ixCustomer NOT IN (SELECT DISTINCT ixCustomer 
						 FROM [SMI Reporting].dbo.tblOrder
						 WHERE ixCustomer IN (SELECT ixCustomer FROM dbo.ASC_16951_Deceased_Analysis_Old) 
                           AND dtShippedDate BETWEEN '09/01/12' AND GETDATE()
                           AND sOrderStatus IN ('Open', 'Dropshipped', 'Shipped')
                         )

--Number of offers by SC of customers who are in the Donnely deceased files that are currently on the list to receive #349
SELECT DISTINCT ixSourceCode 
     , COUNT(ixCustomer) CNT
FROM dbo.ASC_16940_CST_OutputFile_349
WHERE ixCustomer IN (SELECT ixCustomer FROM dbo.ASC_16951_Deceased_Analysis_Old) 
GROUP BY ixSourceCode
ORDER BY CNT DESC

--Number of customers who are in the Donnely deceased files that have had "order" activity on their account since Sept. 2012
SELECT DISTINCT ixCustomer 
FROM dbo.ASC_16951_Deceased_Analysis_Old
WHERE ixCustomer IN (SELECT ixCustomer FROM [SMI Reporting].dbo.tblOrder
                                       WHERE dtOrderDate BETWEEN '09/01/12' AND GETDATE())

--Number of customer who have had true shipped orders and the merch. total of these orders since Sept. 2012
SELECT DISTINCT ixCustomer 
     , SUM(mMerchandise) MERCH
FROM [SMI Reporting].dbo.tblOrder
WHERE ixCustomer IN (SELECT ixCustomer FROM dbo.ASC_16951_Deceased_Analysis_Old) 
  AND dtShippedDate BETWEEN '09/01/12' AND GETDATE()
  AND sOrderStatus IN ('Open', 'Dropshipped', 'Shipped')
GROUP BY ixCustomer 
--Merch sum of roughly $37K                                                
                                       
--Number of customers who have received at least 1 offer from the lists of catalogs sent by Kyle Y. that should have been
-- on a deceased list per Donnely as of Sept. 2012
SELECT DISTINCT ixCustomer 
FROM dbo.ASC_16951_Deceased_Analysis_Old
WHERE ixCustomer IN (SELECT DISTINCT ixCustomer FROM [SMI Reporting].dbo.tblCustomerOffer 
                                       WHERE (ixSourceCode LIKE '343%'
                                            OR ixSourceCode LIKE '344%'
                                            OR ixSourceCode LIKE '347%'
                                            OR ixSourceCode LIKE '357%'
                                            OR ixSourceCode LIKE '345%'
                                            OR ixSourceCode LIKE '346%')
                                            and LEN(ixSourceCode) = 5
                                            )
--Number of offers customers have received from the lists of catalogs sent by Kyle Y. that should have been
-- on a deceased list per Donnely as of Sept. 2012                                       
SELECT DISTINCT ixCustomer 
     , COUNT(ixCustomerOffer) 
FROM [SMI Reporting].dbo.tblCustomerOffer 
WHERE ixCustomer IN (SELECT ixCustomer FROM dbo.ASC_16951_Deceased_Analysis_Old) 
  AND (ixSourceCode LIKE '343%'
                                            OR ixSourceCode LIKE '344%'
                                            OR ixSourceCode LIKE '347%'
                                            OR ixSourceCode LIKE '357%'
                                            OR ixSourceCode LIKE '345%'
                                            OR ixSourceCode LIKE '346%')
  AND     LEN(ixSourceCode) = 5
GROUP BY ixCustomer                  
--3946 Total                                                          
