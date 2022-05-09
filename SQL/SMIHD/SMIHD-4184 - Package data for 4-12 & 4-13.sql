-- SMIHD-4184 - Package data for 4-12 & 4-13
select sTrackingNumber,	ixOrder, D1.dtDate 'ShippedDate',ixPacker,	ixVerifier,	ixShipper, ixTrailer
 from tblPackage P
 left join tblDate D1 on P.ixShipDate = D1.ixDate
where ixShipDate in (17636,17635)
order by ixTrailer


select * from tblTrailer

select * from tblShipMethod

