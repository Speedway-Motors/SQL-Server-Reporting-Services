-- Order Takers with percent of source code given of BUDY

SELECT sOrderTaker,  
    SUM(CASE When sSourceCodeGiven = 'BUDY' then 1  else 0 end) 'BUDY',
    SUM(CASE When sSourceCodeGiven <> 'BUDY' then 1 else 0 end) 'Non-BUDY'
FROM tblOrder O
    join tblEmployee E on O.sOrderTaker = E.ixEmployee
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '05/23/2016' and '05/22/2017'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderChannel = 'PHONE' --NOT IN ('AMAZON','AUCTION','COUNTER','E-MAIL','FAX','INTERNAL','MAIL','WEB')
    and E.flgCurrentEmployee = 1
    and E.ixDepartment <> 15 -- some IT test orders
GROUP BY sOrderTaker
ORDER BY  sOrderTaker