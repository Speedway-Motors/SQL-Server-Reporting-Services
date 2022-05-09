/*
select top 10 * from tblCreditMemoMaster
select top * from tblCreditMemoDetail

*/




select sum(CMD.iQuantityCredited) QTYCredited,
   CMD.sReasonCode
   ,CMD.sReturnType
from tblCreditMemoDetail CMD
   join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
where dtCreateDate > '06/06/2010'
 and  dtCreateDate < '06/07/2011'
group by   CMD.sReturnType,
   sReasonCode
order by 
CMD.sReturnType,
   sReasonCode



select CMD.sReturnType, sum(CMD.iQuantityCredited) QTYCredited
from tblCreditMemoDetail CMD
   join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
where dtCreateDate = '06/07/2011'
group by sReturnType
order by QTYCredited desc




select sum(iQuantity)
from tblOrderLine
where flgLineStatus = 'Shipped'
and dtShippedDate = '06/07/2011'