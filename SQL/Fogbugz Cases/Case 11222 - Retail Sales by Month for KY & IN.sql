 

Select O.sShipToState, 
       D.iYearMonth,
       SUM(O.mMerchandise) as 'Monthly Sales' 

FROM tblOrder O
       left join tblDate D on D.ixDate = O.ixShippedDate

WHERE
      O.dtShippedDate between '01/01/2008' and '12/31/2011'
      and O.sOrderStatus = 'Shipped'
      and O.sOrderType = 'Retail' -- NOT IN ('Internal', 'MRR', 'PRS') 
      and O.sOrderChannel <> 'INTERNAL'
      and O.mMerchandise > 0
      and O.sShipToState IN ('KY', 'IN')

GROUP BY O.sShipToState, D.iYearMonth

ORDER BY O.sShipToState, D.iYearMonth

      

     
