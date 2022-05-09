-- Dealer Customer Offer counts for PRO and MR

-- CAT-H Source Codes with no Customer Offer records
SELECT SC.ixSourceCode, SC.ixCatalog 'Cat', SC.sSourceCodeType 'SCType', SC.sDescription
    , CONVERT(VARCHAR, SC.dtStartDate, 102)  AS 'SCStartDate', COUNT(CO.ixSourceCode) CustOffers
FROM tblSourceCode SC
    LEFT join tblCustomerOffer CO  on CO.ixSourceCode = SC.ixSourceCode
WHERE SC.sSourceCodeType in ('CAT-R') -- 'CAT-H',
    and SC.ixCatalog NOT LIKE '%.%'
GROUP BY SC.ixSourceCode, SC.ixCatalog, SC.sSourceCodeType, SC.sDescription, CONVERT(VARCHAR, SC.dtStartDate, 102)
 HAVING CONVERT(VARCHAR, SC.dtStartDate, 102) >= '2014.01.01' 
 -- and COUNT(CO.ixSourceCode) = 0
 --AND (SC.sDescription like 'PRO%'
 --    OR
 --    SC.sDescription like 'MR%'
 --    )
order by SC.sSourceCodeType, CONVERT(VARCHAR, SC.dtStartDate, 102)





SELECT SC.ixSourceCode, SC.ixCatalog 'Cat'
    , SC.sDescription
    , CONVERT(VARCHAR, SC.dtStartDate, 102)  AS 'SCStartDate', COUNT(CO.ixSourceCode) CustOffers
FROM tblSourceCode SC
    LEFT join tblCustomerOffer CO  on CO.ixSourceCode = SC.ixSourceCode
WHERE SC.sSourceCodeType in ('CAT-H')
    and SC.ixCatalog NOT LIKE '%.%'
GROUP BY SC.ixSourceCode, SC.ixCatalog, SC.sSourceCodeType, SC.sDescription, CONVERT(VARCHAR, SC.dtStartDate, 102)
HAVING CONVERT(VARCHAR, SC.dtStartDate, 102) BETWEEN '2017.01.01' AND '2017.12.31' 
  and (sDescription LIKE 'PRO%' or sDescription LIKE 'MR%')
ORDER BY SC.ixCatalog

/*
ixSource                        SCStart     Cust
Code	Cat	sDescription	    Date	    Offers
======= === =================== ==========  ======
41160	411	PRO RACER DEALERS	2017.01.23	519
41260	412	PRO RACER DEALERS	2017.03.27	537
41360	413	PRO RACER DEALER	2017.05.15	541
41460	414	PRO RACER DEALERS	2017.10.16	560
51460	514	MR ROADSTER DEALERS	2017.01.02	773
51560	515	MR ROADSTER DEALERS	2017.03.13	789
51660	516	MR ROADSTER DEALERS	2017.04.24	796
51760	517	MR ROADSTER DEALERS	2017.06.19	804
51860	518	MR ROADSTER DEALERS	2017.08.28	799
60260	602	PRO RACER DEALERS	2017.02.13	522
*/







select ixSourceCode, ixCatalog, sDescription, dtStartDate
 from tblSourceCode 
where ixSourceCode like '%60'
    and ixStartDate >= 17899 -- 1/1/2017            17533 = 1/1/2016      
order by ixSourceCode
    -- ixStartDate desc
    
SELECT distinct SC.sSourceCodeType
from tblSourceCodeType SCT
FULL OUTER join tblSourceCode SC on SCT.ixSourceCodeType = SC.sSourceCodeType
ORDER BY SC.sSourceCodeType
   
SELECT distinct ixSourceCodeType FROM tblSourceCodeType 
ORDER BY ixSourceCodeType

SELECT distinct sSourceCodeType FROM tblSourceCode
ORDER BY sSourceCodeType

SELECT * FROM tblSourceCode order by dtDateLastSOPUpdate

SELECT COUNT(*) FROM tblSourceCode  -- 3805                     11,206 all records
WHERE dtDateLastSOPUpdate < '09/13/17'

SELECT * FROM tblSourceCode WHERE sSourceCodeType = 'PIP-P' order by dtStartDate desc