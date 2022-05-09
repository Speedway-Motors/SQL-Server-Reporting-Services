select O.ixOrder, T.ixTrailer, O.sShipToZip, O.dtShippedDate 
from tblOrder O
    join (select distinct ixOrder, ixTrailer
          from tblPackage
          where ixShipDate >= 16142) T on O.ixOrder = T.ixOrder -- '03/11/2012'
where O.dtShippedDate >= '03/11/2012'
and O.iShipMethod = 2
and O.sShipToState = 'AZ'
and O.sOrderStatus = 'Shipped'
order by ixTrailer


