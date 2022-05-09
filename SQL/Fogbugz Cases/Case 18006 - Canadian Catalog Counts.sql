SELECT OL.ixSKU 
     , SUM(ISNULL(iQuantity,0)) AS Cnt 
FROM tblOrderLine OL
--LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
WHERE ixSKU IN ('91088328F', '91088332F', '91088333F', '91088334F', '91088335F', '91088336F',
				 '91088337F', '91088338F', '91088339F', '91088341F', '91088342F', '91088343F',
				'91088344F', '91088345F', '91088346F', '91088347F', '91088349F', '91088357F', 
				 '91088358F', '91088362F')
  AND flgLineStatus <> 'Cancelled'		
 -- AND sShipToCountry IN ('CANADA', 'US')
  AND OL.ixCustomer IN (SELECT ixCustomer 
						FROM [SMITemp].dbo.ASC_18006_CanadianCatalogCustomers)
GROUP BY OL.ixSKU 