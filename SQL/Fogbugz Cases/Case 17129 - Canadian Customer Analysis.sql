SELECT DC.ixCustomer
     , C.*
FROM ASC_DistinctCanadianBillingCustomers DC
LEFT JOIN [SMI Reporting].dbo.tblCustomer C ON C.ixCustomer = DC.ixCustomer 
WHERE sMailToCountry IS NOT NULL 
 -- and sMailingStatus IN ('7', '8', '9') --Lose 11 customers 
ORDER BY ISNULL(C.sMailToCountry, 'NONE'), ISNULL(C.sMailToState, 'NONE')

/***************************************
   1 Argentina mailing address (1403458)
   6 Australia mailing addresses (632544, 1344500, 1382816, 1098106, 951082, 1974225)
   2 Belgium mailing addresses (784840, 1315211)
   7,303 Canadian mailing addresses (remainder customer numbers from select) --4,541 have Postal Code 'F'
   3 French mailing addresses (725735, 973451, 1188719)
   1 Great Britain mailing address (952218)
   1 Hong Kong mailing address (1668625)
   4 New Zealand mailing addresses (1394201, 836656, 1255952, 1735525)
   2 Sweden mailing addresses (428721, 671962)
   1 Thailand mailing address (1511243)
   3 United Kingdom mailing addresses (979793, 948721, 1305800)
   38 US mailing addresses (1034096, 960678, 426644, 1612844, 1954925, 1073338, 1237520, 1978012, 1695046,
							1816515, 1934026, 1169334, 1071326, 146135, 317230, 632420, 780764, 1438338, 991391, 
							1927415, 1727132, 180054, 1099205, 1420551, 1838715, 1742940, 1600047, 1480724, 205912
							849035, 959527, 1075855, 1133513, 1002335, 851136, 790282, 1707714, 1805809) --36 have email addresses on file
*************************************/

SELECT DC.ixCustomer
     , C.*
FROM ASC_DistinctCanadianBillingCustomers DC
LEFT JOIN [SMI Reporting].dbo.tblCustomer C ON C.ixCustomer = DC.ixCustomer 
WHERE sMailToCountry IS NULL 
 -- and sMailingStatus IN ('7', '8', '9') --Lose 19 customers 
ORDER BY ISNULL(sMailToState, 'NONE') --sMailToCountry

/***************************************
   4 Canadian mailing addresses (1406931, 1651800, 1478025, 177640) -- 2 have Postal Code 'F'
   36 ALL NULL information (915761, 915856, 935453, 935921, 958364, 953455, 982094, 961974, 867749, 891434,
							892404, 894291, 701713, 744225, 709445, 791145, 351942, 398040, 588862, 104365, 
							1785408, 1820311, 1821404, 1721139, 1725506, 1446906, 1432820, 1475708, 1275008,
							1377002, 1171026, 1155711, 1175212, 1895901, 1967305, 1955007)
   277 US mailing addresses (remainder customer numbers from select) --183 have email addresses on file
*************************************/
      							
