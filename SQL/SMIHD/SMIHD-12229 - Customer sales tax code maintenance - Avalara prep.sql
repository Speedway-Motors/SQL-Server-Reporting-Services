-- SMIHD-12229 - Customer sales tax code maintenance - Avalara prep 

/*excel spreadsheet generated (for the customers that were converted) 
with the following columns: 
Customer #
$Sales for the last 365 days
Customer Flag
Current Tax code (all on the list should be equal to “1”)
*/


SELECT C.ixCustomer, S.Sales12Mo, C.ixCustomerType, C.flgTaxable
FROM tblCustomer C
LEFT join (-- 12 Month Sales
            SELECT O.ixCustomer, SUM(O.mMerchandise) 'Sales12Mo'
            FROM tblOrder O
            WHERE O.sOrderStatus = 'Shipped'
            and O.dtShippedDate between '10/29/2017' and '10/28/2018'
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.sOrderType <> 'Internal'   -- USUALLY filtered
           GROUP BY O.ixCustomer
           ) S ON C.ixCustomer = S.ixCustomer
WHERE C.flgTaxable = 0



SELECT ixCustomer
into [SMITemp].dbo.PJC_SMIHD12229_SMI_NonTaxableCustomers_20181029
FROM tblCustomer C
WHERE flgDeletedFromSOP = 0 -- 1,349
and flgTaxable = 0

SELECT ixCustomer
into [SMITemp].dbo.PJC_SMIHD12229_AFCO_NonTaxableCustomers_20181029
FROM [AFCOReporting].dbo.tblCustomer C
WHERE flgDeletedFromSOP = 0 -- 501  
and flgTaxable = 0