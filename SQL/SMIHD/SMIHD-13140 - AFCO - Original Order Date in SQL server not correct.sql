-- SMIHD-13140 - AFCO - Original Order Date in SQL server not correct

-- backup tables
select * into BU_tblOrder_20190227 from [SMI Reporting].dbo.tblOrder      --   6,286,381
select * into [SMIArchive].dbo.BU_AFCO_tblOrder_20190227 from [AFCOReporting].dbo.tblOrder --     394,610


SELECT ixOrder, ixOrderDate, dtOrderDate, ixOrderTime
from [SMIArchive].dbo.BU_tblOrder_20190227
where ixOrder = '8143848'

SELECT ixOrder, ixOrderDate, dtOrderDate, ixOrderTime
from tblOrder
where ixOrder = '8143848'

-- SMI # of Days dif between original OE date and current OE date
SELECT O.ixOrder, O.ixOrderDate 'Orig', BU.ixOrderDate 'Altered', (BU.ixOrderDate-O.ixOrderDate) 'DaysChanged'
FROM [SMIArchive].dbo.BU_tblOrder_20190227 BU
left join tblOrder O on BU.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS = O.ixOrder
WHERE BU.ixOrderDate <> O.ixOrderDate


-- AFCO # of Days dif between original OE date and current OE date
SELECT O.ixOrder, O.ixOrderDate 'Orig', BU.ixOrderDate 'Altered', (BU.ixOrderDate-O.ixOrderDate) 'DaysChanged'
FROM [SMIArchive].dbo.BU_AFCO_tblOrder_20190227 BU
left join tblOrder O on BU.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS = O.ixOrder
WHERE BU.ixOrderDate <> O.ixOrderDate


/*
18264	01/01/2018
17899	01/01/2017
17533	01/01/2016
17168	01/01/2015
16803	01/01/2014
16438	01/01/2013
16072	01/01/2012
15707	01/01/2011
15342	01/01/2010
14977	01/01/2009
14611	01/01/2008
14246	01/01/2007
13881	01/01/2006
*/



SELECT * FROM tblOrder 
where sOrderStatus = 'Open' --946 FED

SELECT * FROM tblOrder 
where sOrderStatus = 'Backordered'-- 2686 FEEDING

-- AFCO
SELECT * FROM tblOrder 
where sOrderStatus = 'Open' --440 FED

SELECT * FROM tblOrder 
where sOrderStatus = 'Backordered'-- 446 FEEDING






