select
	D.iYear as 'Year',
	sum(case when O.sOrderChannel = 'PHONE' THEN 1 ELSE 0 END) as 'Phone',
	sum(case when O.sOrderChannel = 'E-MAIL' THEN 1 ELSE 0 END) as 'E-Mail',
	sum(case when O.sOrderChannel = 'COUNTER' THEN 1 ELSE 0 END) as 'Counter',
	sum(case when O.sOrderChannel = 'AUCTION' THEN 1 ELSE 0 END) as 'Auction',
	sum(case when O.sOrderChannel = 'EBAY' THEN 1 ELSE 0 END) as 'EBay',
	sum(case when O.sOrderChannel = 'FAX' THEN 1 ELSE 0 END) as 'Fax',
	sum(case when O.sOrderChannel = 'INTERNAL' THEN 1 ELSE 0 END) as 'Internal',
	sum(case when O.sOrderChannel = 'MAIL' THEN 1 ELSE 0 END) as 'Mail',
	sum(case when O.sOrderChannel = 'TRADESHOW' THEN 1 ELSE 0 END) as 'Tradeshow',
	sum(case when O.sOrderChannel = 'WEB' THEN 1 ELSE 0 END) as 'Web'
from
	tblOrder O
	left join tblDate D on O.ixOrderDate = D.ixDate
where
	not(O.flgIsBackorder = 1)
	and O.sOrderStatus in ('Shipped', 'Open')
	and not(O.ixOrder like '%-%')
group by
	D.iYear
order by
	D.iYear