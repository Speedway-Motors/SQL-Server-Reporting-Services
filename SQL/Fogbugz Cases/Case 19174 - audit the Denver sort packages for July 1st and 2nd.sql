-- Case - 19174 audit the Denver sort packages for July 1st and 2nd

-- Al wrote the query and sent the excel file to Korth

select sTrackingNumber, P.ixOrder, ixTrailer, sMethodOfPayment, mMerchandise, mShipping, dtShippedDate from tblPackage P
	join tblOrder O on O.ixOrder = P.ixOrder
	where P.ixTrailer = 'DEN'
	and P.ixShipDate in ('16619', '16620')
	and O.sOrderStatus = 'Shipped'