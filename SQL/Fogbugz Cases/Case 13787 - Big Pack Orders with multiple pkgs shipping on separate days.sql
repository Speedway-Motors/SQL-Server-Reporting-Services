select O.ixOrder,O.sOrderStatus,
       O.sShipToCity,O.sShipToState,O.sShipToZip, 
        P.sTrackingNumber,P.ixShipper, 
        D3.dtDate+SUBSTRING(T3.chTime,1,5) 'AvailableToPrint',
        P.ixVerifier,
        D.dtDate as 'ShippedDate',
        D2.dtDate as 'VerifiedDate',
        T.chTime as 'VerifiedTime'
from tblOrder O
    join tblPackage P on P.ixOrder = O.ixOrder
    join tblDate D on P.ixShipDate = D.ixDate
    left join tblDate D2 on P.ixVerificationDate = D2.ixDate
    left join tblTime T on T.ixTime = P.ixVerificationTime
    left join tblOrderRouting ORT on O.ixOrder = ORT.ixOrder
    left join tblDate D3            on D3.ixDate = ORT.ixAvailablePrintDate
    left join tblTime T3            on T3.ixTime = ORT.ixAvailablePrintTime    
WHERE O.dtShippedDate >= '05/07/2012'
  and O.ixOrder in (select ixOrder--, Min(ixShipDate), Max(ixShipDate), COUNT(sTrackingNumber) PkgCnt
                  from tblPackage
                  where ixShipDate >= 16190 -- 04/28/2012   16072 = 1/1/12   YTD about 5 order a day avg
                  group by ixOrder
                  having COUNT(sTrackingNumber) > 1
                    and Min(ixShipDate) <> Max(ixShipDate)) -- 3098
ORDER BY O.ixOrder,D.dtDate             
                  
                  
select top 10 * from tblPackage




