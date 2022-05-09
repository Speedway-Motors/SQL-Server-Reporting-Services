SELECT R.flgStatus              RecStatus,
    CONVERT(VARCHAR, D.dtDate, 101)+' '+CONVERT(VARCHAR(5), T.chTime) Received,
    CONVERT(VARCHAR, D2.dtDate, 101)+' '+CONVERT(VARCHAR(5), T2.chTime) Closed,
-- between current timestamp and timestamp on dock)
    ((DATEDIFF(HH,(D2.dtDate+T2.chTime),(D.dtDate+T.chTime))*-1)/24.0) TotProcessingTime, -- determining the total hour dif first then converting to days       
    V.ixVendor                          VendorNum,
    V.sName                             VendorName,
    R.ixPO                              PO,
    R.ixReceiver                        Receiver
FROM
    tblReceiver R
    left join tblVendor V   on V.ixVendor = R.ixVendor
    join tblDate D          on R.ixOnDockDate = D.ixDate
    join tblTime T          on R.ixOnDockTime = T.ixTime
    join tblDate D2         on R.ixCloseDate = D2.ixDate -- change to ixClosedDate
    join tblTime T2         on R.ixCloseTime = T2.ixTime -- change to ixCloseTime
where R.flgStatus in ('Closed','Posted')
--and D2.Date > @StartDate
--and D2.Date <= @EndDate +1
and D.dtDate >'12/14/2010'
    -- R.ixReceiver in ('85196','85184')
order by ((DATEDIFF(HH,(D2.dtDate+T2.chTime),(D.dtDate+T.chTime))*-1)/24.0) desc,T.chTime


select top 10 * from tblReceiver where ixReceiver = '85196'

