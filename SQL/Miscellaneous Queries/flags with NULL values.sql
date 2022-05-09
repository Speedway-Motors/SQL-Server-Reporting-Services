select ixSKU, flgActive, flgShipAloneStatus, flgAdditionalHandling
from tblSKU 
--join vwOrphanedSKUs OS on OS.ixSKU = tblSKU.ixSKU
where flgActive is NULL
    or flgAdditionalHandling is NUll
    or flgShipAloneStatus is NULL
/*
ixSKU           flgActive   flgShipAloneStatus  flgAdditionalHandling
330955-1250     NULL        NULL                NULL
3733933         NULL        NULL                NULL
45873002        NULL        NULL                NULL
5829560         NULL        NULL                NULL
91015152        1           NULL                0
91031897-3      NULL        NULL                NULL
91062154-BLU    NULL        NULL                NULL
91099570GS      1           NULL                0
91639036-46     NULL        NULL                NULL
91657060-PLN    NULL        NULL                NULL
*/

update tblSKU
set flgShipAloneStatus = 0 
where ixSKU in ('1061340-350',
'91013860',
'91013865',
'91013866',
'91013867',
'91015165',
'91013862',
'91013861',
'91013864',
'1061350',
'1061340-400',
'1061330-450',
'91013863')

select count(*) QTY, flgShipAloneStatus
from tblSKU
group by flgShipAloneStatus