--5567 11/17/10 - # Open backorders on file @ EOM 2008 to date
select
	'01/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '01/31/08' and (O.dtShippedDate is null or O.dtShippedDate >= '02/01/08'))
union
select
	'02/28/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '02/28/08' and (O.dtShippedDate is null or O.dtShippedDate >= '03/01/08'))
union
select
	'03/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '03/31/08' and (O.dtShippedDate is null or O.dtShippedDate >= '04/01/08'))
union
select
	'04/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '04/30/08' and (O.dtShippedDate is null or O.dtShippedDate >= '05/01/08'))
union
select
	'05/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '05/31/08' and (O.dtShippedDate is null or O.dtShippedDate >= '06/01/08'))

union
select
	'06/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '06/30/08' and (O.dtShippedDate is null or O.dtShippedDate >= '07/01/08'))

union
select
	'07/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '07/31/08' and (O.dtShippedDate is null or O.dtShippedDate >= '08/01/08'))
	
union
select
	'08/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '08/31/08' and (O.dtShippedDate is null or O.dtShippedDate >= '09/01/08'))

union
select
	'09/30/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '09/30/08' and (O.dtShippedDate is null or O.dtShippedDate >= '10/01/08'))

union
select
	'10/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '10/31/08' and (O.dtShippedDate is null or O.dtShippedDate >= '11/01/08'))

union
select
	'11/30/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '11/30/08' and (O.dtShippedDate is null or O.dtShippedDate >= '12/01/08'))

union
select
	'12/31/08',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '12/31/08' and (O.dtShippedDate is null or O.dtShippedDate >= '01/01/09'))

union
-- 2009

select
	'01/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '01/31/09' and (O.dtShippedDate is null or O.dtShippedDate >= '02/01/09'))
union
select
	'02/28/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '02/28/09' and (O.dtShippedDate is null or O.dtShippedDate >= '03/01/09'))
union
select
	'03/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '03/31/09' and (O.dtShippedDate is null or O.dtShippedDate >= '04/01/09'))
union
select
	'04/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '04/30/09' and (O.dtShippedDate is null or O.dtShippedDate >= '05/01/09'))
union
select
	'05/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '05/31/09' and (O.dtShippedDate is null or O.dtShippedDate >= '06/01/09'))

union
select
	'06/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '06/30/09' and (O.dtShippedDate is null or O.dtShippedDate >= '07/01/09'))

union
select
	'07/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '07/31/09' and (O.dtShippedDate is null or O.dtShippedDate >= '09/01/09'))
	
union
select
	'09/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '08/31/09' and (O.dtShippedDate is null or O.dtShippedDate >= '09/01/09'))

union
select
	'09/30/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '09/30/09' and (O.dtShippedDate is null or O.dtShippedDate >= '10/01/09'))

union
select
	'10/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '10/31/09' and (O.dtShippedDate is null or O.dtShippedDate >= '11/01/09'))

union
select
	'11/30/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '11/30/09' and (O.dtShippedDate is null or O.dtShippedDate >= '12/01/09'))

union
select
	'12/31/09',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '12/31/09' and (O.dtShippedDate is null or O.dtShippedDate >= '01/01/10'))
	
union
-- 2010

select
	'01/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '01/31/10' and (O.dtShippedDate is null or O.dtShippedDate >= '02/01/10'))
union
select
	'02/28/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '02/28/10' and (O.dtShippedDate is null or O.dtShippedDate >= '03/01/10'))
union
select
	'03/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '03/31/10' and (O.dtShippedDate is null or O.dtShippedDate >= '04/01/10'))
union
select
	'04/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '04/30/10' and (O.dtShippedDate is null or O.dtShippedDate >= '05/01/10'))
union
select
	'05/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '05/31/10' and (O.dtShippedDate is null or O.dtShippedDate >= '06/01/10'))

union
select
	'06/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '06/30/10' and (O.dtShippedDate is null or O.dtShippedDate >= '07/01/10'))

union
select
	'07/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '07/31/10' and (O.dtShippedDate is null or O.dtShippedDate >= '08/01/10'))
	
union
select
	'08/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '08/31/10' and (O.dtShippedDate is null or O.dtShippedDate >= '09/01/10'))

union
select
	'09/30/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '09/30/10' and (O.dtShippedDate is null or O.dtShippedDate >= '10/01/10'))

union
select
	'10/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '10/31/10' and (O.dtShippedDate is null or O.dtShippedDate >= '11/01/10'))

union
select
	'11/30/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '11/30/10' and (O.dtShippedDate is null or O.dtShippedDate >= '12/01/10'))

union
select
	'12/31/10',
	count(1),
	sum(mMerchandise)
from 
	tblOrder O
where 
	O.ixOrder like '%-%'
	and O.sOrderStatus = 'Shipped'
	and (O.dtOrderDate <= '12/31/10' and (O.dtShippedDate is null or O.dtShippedDate >= '01/01/11'))



