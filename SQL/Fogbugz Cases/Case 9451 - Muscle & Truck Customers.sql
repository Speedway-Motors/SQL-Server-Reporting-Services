select distinct OL.ixCustomer
from tblOrder O
   join tblOrderLine OL on O.ixOrder = OL.ixOrder
   join PJC_truck_muscle_SKUs TM on OL.ixSKU = TM.ixSKU
where OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel <> 'Internal'
  and O.sOrderType <> 'Internal'



select distinct OL.ixCustomer
from tblOrder O
   join tblOrderLine OL on O.ixOrder = OL.ixOrder
   join PJC_FudgesList FL on OL.ixSKU = FL.ixSKU
where OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel <> 'Internal'
  and O.sOrderType <> 'Internal'



select distinct ixSKU
into PJC_FudgesList
from PJC_temp_Fudges

drop table PJC_temp_Fudges


select I think 