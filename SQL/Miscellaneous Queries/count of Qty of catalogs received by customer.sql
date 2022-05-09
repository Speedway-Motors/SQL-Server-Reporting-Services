-- count of # of catalogs received by customer
SELECT CatalogsSent, COUNT(ixCustomer) CustCnt
FROM (
        SELECT SP.ixCustomer, COUNT(DISTINCT CO.ixCatalog) AS CatalogsSent
        FROM (-- Starting Pool
              SELECT DISTINCT ixCustomer -- 198,509 
              FROM tblOrder O 
              WHERE dtOrderDate BETWEEN '10/20/12' AND '10/19/13' 
                AND sOrderChannel <> 'INTERNAL' 
                AND sOrderStatus = 'Shipped'  -- what about merged customers???  is "AND flgDeletedFromSOP = 0" needed?
                AND mMerchandise > 1 
                AND sOrderType = 'Retail' 
                ) SP --Starting Pool
        LEFT JOIN 
            (-- each Cat & SC per Customer
             SELECT DISTINCT CO.ixSourceCode 
                    , SC.ixCatalog
                    , ixCustomer 
             FROM tblCustomerOffer CO
                    LEFT JOIN tblSourceCode SC ON SC.ixSourceCode = CO.ixSourceCode
             WHERE CO.dtCreateDate BETWEEN '10/20/13' AND '10/19/14' 
               AND sType = 'OFFER'
             ) CO ON CO.ixCustomer = SP.ixCustomer
        GROUP BY SP.ixCustomer
      ) CatsPerCust
group by  CatalogsSent
order by CatalogsSent desc     

SELECT DISTINCT CO.ixCustomer, SC.ixCatalog 
            FROM tblCustomerOffer CO
            LEFT JOIN tblSourceCode SC ON SC.ixSourceCode = CO.ixSourceCode
            WHERE CO.dtCreateDate BETWEEN '10/20/13' AND '10/19/14' 
            AND sType = 'OFFER'
            
/* as of 10-22-14
21	1
20	18
19	1680
18	1319
17	5108
16	9110
15	6921
14	13700
13	11337
12	11624
11	10522
10	13753
9	13421
8	31459
7	15422
6	13077
5	10178
4	9774
3	7879
2	2054
1	3215
0	6937            



