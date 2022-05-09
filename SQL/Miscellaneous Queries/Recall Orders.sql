select * from tblOrder where sOrderStatus = 'Recall'

select distinct sOrderStatus from tblOrder


select ixOrder, sOrderStatus
from tblOrder
where dtOrderDate >= '05/01/2014'
and ixOrderTime = 6006

select ixOrder, ixCustomer, ixOrderDate, sShipToCity, sShipToState, sShipToZip, sOrderType, sOrderChannel, sShipToCountry, ixShippedDate, iShipMethod, 
sSourceCodeGiven, sMatchbackSourceCode, sMethodOfPayment, sOrderTaker, mMerchandise, mShipping, mTax, mCredits, sOrderStatus, mMerchandiseCost, dtOrderDate, dtShippedDate, 
 ixOrderTime,  ixOrderType, mPublishedShipping, sOptimalShipOrigination,  mAmountPaid, flgPrinted,  
flgIsResidentialAddress, sWebOrderID, dtDateLastSOPUpdate, ixTimeLastSOPUpdate

from tblOrder where ixOrder in('55076600','5506665','5505667','5505667','5505669','5506660')



select * from tblTableSizeLog where sTableName = 'tblOrderTNT'
select * from tblTableSizeLog where sTableName = 'tblLoanTicketMaster'
select * from tblTableSizeLog where sTableName = 'tblLoanTicketScans'