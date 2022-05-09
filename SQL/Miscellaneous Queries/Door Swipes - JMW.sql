select CONVERT(VARCHAR(10), DE.dtEventTimeDate, 101) AS [MM/DD/YYYY],
    DE.sAction,
    (Case when (DE.dtEventTimeDate > '11/02/10' and  DE.dtEventTimeDate < '11/07/10')
          then dateadd(HH,-1,DE.dtEventTimeDate) 
          else DE.dtEventTimeDate
     End) EventTimeDate 
from tblDoorEvent DE
   join tblCard C on DE.ixCardScanNum = C.ixCardScanNum
   join tblCardUser CU on C.ixCardUser = CU.ixCardUser
where sLastName = 'Mailand'
ORDER BY DE.dtEventTimeDate
