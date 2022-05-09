-- SMIHD-18149 - Amazon Prime Orders On BEL Trailer

Orders Shipped TOL yesterday		
BEL trailer 		
source code = AMAZONPRIME		



SELECT O.ixOrder, sSourceCodeGiven, P.sTrackingNumber, P.ixTrailer, P.flgCanceled, P.flgReplaced
FROM tblOrder O
    left join tblPackage P on O.ixOrder = P.ixOrder
WHERE ixPrimaryShipLocation = 85
    and dtShippedDate = '07/16/2020'
    and O.sSourceCodeGiven = 'AMAZONPRIME' -- 20 orders regardless of trailer
    and P.flgReplaced = 0
ORDER BY sSourceCodeGiven, ixTrailer, ixOrder, sTrackingNumber












