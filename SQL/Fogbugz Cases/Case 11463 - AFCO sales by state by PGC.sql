 /****** SALES *********/   
SELECT O.sShipToState                                               'State',
       SUBSTRING(S.ixPGC, 2,1)                                      'MarketCode',
        SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money))              'Sales',
        SUM(OL.mExtendedCost)                                       'Cost',
        SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money))  'GP'
 FROM tblOrder O 
    join tblOrderLine OL on OL.ixOrder = O.ixOrder 
    left join tblSKU S on S.ixSKU = OL.ixSKU 
 WHERE OL.flgLineStatus = 'Shipped' 
    and OL.dtShippedDate between '01/01/2011' and '12/13/2011'
    and OL.flgKitComponent = 0
 -- INCLUDES internal orders
 GROUP BY O.sShipToState,
         SUBSTRING(S.ixPGC, 2,1)
 ORDER BY 'State','MarketCode'         



 /****** SALES *********/   
SELECT O.sShipToState                                               'State',
       SUBSTRING(S.ixPGC, 2,1)                                      'MarketCode',
        SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money))              'Sales',
        SUM(OL.mExtendedCost)                                       'Cost',
        SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money))  'GP'
 FROM tblOrder O 
    join tblOrderLine OL on OL.ixOrder = O.ixOrder 
    left join tblSKU S on S.ixSKU = OL.ixSKU 
 WHERE OL.flgLineStatus = 'Shipped' 
    and OL.dtShippedDate between '01/01/2011' and '12/13/2011'
    and OL.flgKitComponent = 0
 -- INCLUDES internal orders
 GROUP BY O.sShipToState,
         SUBSTRING(S.ixPGC, 2,1)
 ORDER BY 'State','MarketCode'      


