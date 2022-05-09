/*
select * from tblShipMethod

ixShipMethod	sDescription
1	Counter
2	UPS Ground
3	UPS 2 Day (Blue)
4	UPS 1 Day (Red)
5	UPS 3 Day
6	USPS Priority
7	USPS Express
8	Best Way
9	SpeeDee
10	UPS Worldwide Expedited
11	UPS Worldwide Saver
12	UPS Standard

*/



/*******Count # of Orders in DAS Zips********/
select
	(case when DAS.ixZipCode is not NULL then 'DAS'
	else 'Other' end) as 'DAS Zip',
	count(distinct(ixOrder))
from tblOrder
	left join tblMMDeliveryAreaSurcharge as DAS on tblOrder.sShipToZip COLLATE SQL_Latin1_General_CP1_CS_AS = DAS.ixZipCode COLLATE SQL_Latin1_General_CP1_CS_AS 
where
	--(tblOrder.dtShippedDate >= '04/01/11' and tblOrder.dtShippedDate <= '04/30/11')
	(tblOrder.dtShippedDate >= '01/01/10' and tblOrder.dtShippedDate <= '06/19/11')
	and
	tblOrder.iShipMethod in (2,3,4,5,9,10,11,12)
	and
	tblOrder.sShipToCountry in ('US','USA')
	and
	tblOrder.sOrderStatus = 'Shipped'
group by 
	(case when DAS.ixZipCode is not NULL then 'DAS'
	else 'Other' end) 

/*# of Orders in DAS Zips	
April 2011
DAS		17729
Other	19455

01/01/10 to 06/19/11
DAS		204901
Other	236823
*/




/**********************Count # of Packages per Order*******************/
drop view vwTempPackageCount
create view vwTempPackageCount
as
SELECT
	tblOrder.ixOrder,
	count(distinct(tblPackage.sTrackingNumber)) as 'PackageCount'
FROM 
	tblOrder
	left join tblPackage on tblOrder.ixOrder = tblPackage.ixOrder
--WHERE
--	(tblOrder.dtShippedDate >= '04/01/11' and tblOrder.dtShippedDate <= '04/30/11')
--	and
--	tblOrder.iShipMethod in (2,3,4,5,9,10,11,12)
--	and
--	tblOrder.sShipToCountry in ('US','USA')
--	and
--	tblOrder.sOrderStatus = 'Shipped'
GROUP BY
	tblOrder.ixOrder

/*creating multi package variable*/
drop view vwTempPackageCount2
create view vwTempPackageCount2
as
SELECT 
	ixOrder,
	(case when PackageCount > 1 then 1
	 else 0 end) as 'MultiPackage'
FROM vwTempPackageCount
GROUP BY
	ixOrder,
	(case when PackageCount > 1 then 1
	 else 0 end) 
/*********************************************/





/*Pull order and package counts by address type for DAS zips*/
SELECT
--	(case
--		when O.dtShippedDate >= '01/01/10' and O.dtShippedDate <= '03/31/10' then '2010Q1'
--		when O.dtShippedDate >= '04/01/10' and O.dtShippedDate <= '06/30/10' then '2010Q2'
--		when O.dtShippedDate >= '07/01/10' and O.dtShippedDate <= '09/30/10' then '2010Q3'
--		when O.dtShippedDate >= '10/01/10' and O.dtShippedDate <= '12/31/10' then '2010Q4'
--		when O.dtShippedDate >= '01/01/11' and O.dtShippedDate <= '03/31/11' then '2011Q1'
--		when O.dtShippedDate >= '04/01/11' and O.dtShippedDate <= '06/30/11' then '2011Q2'
--	 end) as 'Quarter',
	(case when flgIsResidentialAddress = 1 then 'Residential'
	 else 'Commercial' end) as 'Address Type',
	count(distinct(O.ixOrder)) as '# Orders',
	count(distinct(P.sTrackingNumber)) as '# Packages'
FROM 
	tblOrder as O
	left join tblMMDeliveryAreaSurcharge as DAS on O.sShipToZip COLLATE SQL_Latin1_General_CP1_CS_AS = DAS.ixZipCode COLLATE SQL_Latin1_General_CP1_CS_AS 
	left join tblPackage as P on O.ixOrder COLLATE SQL_Latin1_General_CP1_CS_AS = P.ixOrder COLLATE SQL_Latin1_General_CP1_CS_AS 
WHERE
	(O.dtShippedDate >= '04/01/11' and O.dtShippedDate <= '04/30/11')
	--(O.dtShippedDate >= '01/01/10' and O.dtShippedDate <= '06/19/11')
	and
	O.iShipMethod in (2,3,4,5,9,10,11,12)
	and
	O.sShipToCountry in ('US','USA')
	and
	O.sOrderStatus = 'Shipped'
	and
	--For DAS Zips
	--DAS.ixZipCode is not NULL
	--For non-DAS Zips
	DAS.ixZipCode is NULL
GROUP BY
--	(case 
--		when O.dtShippedDate >= '01/01/10' and O.dtShippedDate <= '03/31/10' then '2010Q1'
--		when O.dtShippedDate >= '04/01/10' and O.dtShippedDate <= '06/30/10' then '2010Q2'
--		when O.dtShippedDate >= '07/01/10' and O.dtShippedDate <= '09/30/10' then '2010Q3'
--		when O.dtShippedDate >= '10/01/10' and O.dtShippedDate <= '12/31/10' then '2010Q4'
--		when O.dtShippedDate >= '01/01/11' and O.dtShippedDate <= '03/31/11' then '2011Q1'
--		when O.dtShippedDate >= '04/01/11' and O.dtShippedDate <= '06/30/11' then '2011Q2'
--	 end),
	(case when flgIsResidentialAddress = 1 then 'Residential'
	 else 'Commercial' end)




/*Pull count of Multi Package Orders in DAS Zips*/
SELECT
--	(case 
--		when O.dtShippedDate >= '01/01/10' and O.dtShippedDate <= '03/31/10' then '2010Q1'
--		when O.dtShippedDate >= '04/01/10' and O.dtShippedDate <= '06/30/10' then '2010Q2'
--		when O.dtShippedDate >= '07/01/10' and O.dtShippedDate <= '09/30/10' then '2010Q3'
--		when O.dtShippedDate >= '10/01/10' and O.dtShippedDate <= '12/31/10' then '2010Q4'
--		when O.dtShippedDate >= '01/01/11' and O.dtShippedDate <= '03/31/11' then '2011Q1'
--		when O.dtShippedDate >= '04/01/11' and O.dtShippedDate <= '06/30/11' then '2011Q2'
--	 end) as 'Quarter',
	(case when flgIsResidentialAddress = 1 then 'Residential'
	 else 'Commercial' end) as 'Address Type',
	sum(VW.MultiPackage) as 'MultiPackage'
FROM 
	tblOrder as O
	left join tblMMDeliveryAreaSurcharge as DAS on O.sShipToZip COLLATE SQL_Latin1_General_CP1_CS_AS = DAS.ixZipCode COLLATE SQL_Latin1_General_CP1_CS_AS 
	left join vwTempPackageCount2 as VW on O.ixOrder = VW.ixOrder
WHERE
	(O.dtShippedDate >= '04/01/11' and O.dtShippedDate <= '04/30/11')
	--(O.dtShippedDate >= '01/01/09' and O.dtShippedDate <= '06/19/11')
	and
	O.iShipMethod in (2,3,4,5,9,10,11,12)
	and
	O.sShipToCountry in ('US','USA')
	and
	O.sOrderStatus = 'Shipped'
	and
	--For DAS Zips
	--DAS.ixZipCode is not NULL
	--For non-DAS Zips
	DAS.ixZipCode is NULL
GROUP BY
--	(case 
--		when O.dtShippedDate >= '01/01/10' and O.dtShippedDate <= '03/31/10' then '2010Q1'
--		when O.dtShippedDate >= '04/01/10' and O.dtShippedDate <= '06/30/10' then '2010Q2'
--		when O.dtShippedDate >= '07/01/10' and O.dtShippedDate <= '09/30/10' then '2010Q3'
--		when O.dtShippedDate >= '10/01/10' and O.dtShippedDate <= '12/31/10' then '2010Q4'
--		when O.dtShippedDate >= '01/01/11' and O.dtShippedDate <= '03/31/11' then '2011Q1'
--		when O.dtShippedDate >= '04/01/11' and O.dtShippedDate <= '06/30/11' then '2011Q2'
--	 end),
	(case when flgIsResidentialAddress = 1 then 'Residential'
	 else 'Commercial' end)




/********for QA purposes**********/
SELECT
	tblOrder.ixOrder,
	sum(tblOrder.flgIsResidentialAddress) as 'ResAddress',
	sum(vwTempZips.DASZip) as 'DASZips',
	sum(vwTempPackageCount2.MultiPackage) as 'MultiPackage'
FROM 
	tblOrder 
	left join vwTempZips on tblOrder.ixOrder = vwTempZips.ixOrder 
	left join vwTempPackageCount2 on tblOrder.ixOrder = vwTempPackageCount2.ixOrder
WHERE
	(tblOrder.dtShippedDate >= '04/01/11' and tblOrder.dtShippedDate <= '04/30/11')
	and
	tblOrder.iShipMethod in (2,3,4,5,9,10,11,12)
	and
	tblOrder.sShipToCountry in ('US','USA')
	and
	tblOrder.sOrderStatus = 'Shipped'
GROUP BY
	tblOrder.ixOrder





