select *
from tblBOMTransferMaster
where ixDueDate between 15797 and 15827 -- TOTAL ADJ QTY = 58
   and ixFinishedSKU = '16SERPBX'




SELECT isnull(SEQ.SubDept,'Unassigned') Dept, 
         TM.ixFinishedSKU, TM.AdjQty, SEQ.TotTimePerUnit, (TM.AdjQty * SEQ.TotTimePerUnit) TotMins, ((TM.AdjQty * SEQ.TotTimePerUnit)/60) TotHours
FROM
      (select ixFinishedSKU, (sum(iQuantity)-sum(iCompletedQuantity)) AdjQty
      from tblBOMTransferMaster
      where ixDueDate =  15779  -- 03/14/2011   between 15795 and 15795
        --and 
      group by ixFinishedSKU
      ) TM
   LEFT JOIN
      (select ixFinishedSKU, sDepartment SubDept, sum(dLaborAmount + dSetupTime) TotTimePerUnit -- sum(sLaborAmount + sSetupTime) TotTime
      from tblBOMSequence 
      where flgActive = 1
      group by ixFinishedSKU, sDepartment
      ) SEQ on SEQ.ixFinishedSKU = TM.ixFinishedSKU
/*
SubDept	ixFinishedSKU	AdjQty	TotTimePerUnit	TotMins	TotHours
76	      80110SR	      1	      53.00	         53.00	   0.883333
76	      80281FNU	      2	      66.00	         132.00	2.200000
NULL	   GS128	         15	      NULL	         NULL	   NULL
*/

select count(distinct ixFinishedSKU) QTY, ixDueDate
from tblBOMTransferMaster
where ixDueDate = 15779
group by ixDueDate
order by QTY

select *
from tblBOMTransferMaster
where ixDueDate = 15779
/*
ixTransferNumber	ixFinishedSKU	iQuantity	iCompletedQuantity	flgReverseBOM	ixCreateDate	ixDueDate
53098-1	         GS128	         15	         0	                  0	            15779	         15779
52107-1	         80110SR	      1	         0	                  0	            15767	         15779
52058-1	         80281FNU	      2	         0	                  0	            15766	         15779
*/




