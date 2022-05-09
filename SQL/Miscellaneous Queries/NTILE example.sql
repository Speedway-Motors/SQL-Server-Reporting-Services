-- NTILE example

-- ALSO SEE vwCSTRanking for more examples


SELECT p.FirstName, p.LastName
    ,NTILE(4) OVER(ORDER BY SalesYTD DESC) AS Quartile
    ,CONVERT(nvarchar(20),s.SalesYTD,1) AS SalesYTD
    , a.PostalCode
FROM Sales.SalesPerson AS s 
    INNER JOIN Person.Person AS p     ON s.BusinessEntityID = p.BusinessEntityID
    INNER JOIN Person.Address AS a     ON a.AddressID = p.BusinessEntityID
WHERE TerritoryID IS NOT NULL 
    AND SalesYTD <> 0;

/*
FirstName      LastName              Quartile  SalesYTD       PostalCode
-------------  --------------------- --------- -------------- ----------
Linda          Mitchell              1         4,251,368.55   98027
Jae            Pak                   1         4,116,871.23   98055
Michael        Blythe                1         3,763,178.18   98027
Jillian        Carson                1         3,189,418.37   98027
*/

