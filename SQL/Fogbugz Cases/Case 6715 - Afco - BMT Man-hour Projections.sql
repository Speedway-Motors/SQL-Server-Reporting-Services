select top 10 * from tblBOMSequence

select * from tblBOMSequence where ixFinishedSKU = '16SERPBX'
/*
ixFinishedSKU	iSequenceNumber	ixCreateUser	ixCreateDate	ixUpdateUser	ixUpdateDate	ixUpdateTime	sLaborType	sLaborAmount	sSetupTime	flgActiveFlag	sDepartment	sResource	sOperation
78174330	0	RML	15717	RML	15717	42339	DEPDYNALAB	0.00	0.00	1	AS	AS	AS
78174330	30	RML	15717	SDR	15720	28419	DEPDYNALAB	24.00	0.00	1	FS	GSHLP	CHP
78174330	40	RML	15717	RML	15717	42897	DEPDYNALAB	40.00	0.00	1	FS	GSHLP	409
78174330	10	RML	15717	RML	15717	43155	DEPDYNALAB	20.00	0.00	1	AS	TIG1	TAC
78174330	20	RML	15717	RML	15717	43189	DEPDYNALAB	12.00	0.00	1	AS	TIG1	WEL
78174330	50	RML	15717	RML	15717	42947	DEPDYNALAB	40.00	0.00	1	IN	INSP	INS
*/


select flgActiveFlag, count(iSequenceNumber) CountSeq
from tblBOMSequence
group by flgActiveFlag
/*
flgActiveFlag	CountSeq
0	            2095
1	            16524
*/

select ixFinishedSKU, sDepartment SubDept, sum(dLaborAmount + dSetupTime) TotTime -- sum(sLaborAmount + sSetupTime) TotTime
from tblBOMSequence 
where ixFinishedSKU = '16SERPBX'
group by ixFinishedSKU, sDepartment

SELECT * FROM tblBOMSequence where ixFinishedSKU = '16SERPBX'

/*
ixFinishedSKU	sDepartment	TotTime
78174330	      AS	32.00
78174330	      FS	64.00
78174330	      IN	40.00
*/

select * -- count(*) QTY*,  ixFinishedSKU
from tblBOMTransferMaster
where ixDueDate between 15797 and 15827
   and ixFinishedSKU = '16SERPBX'
group by ixFinishedSKU

having count(*) > 2
order by QTY desc
/*
QTY	ixFinishedSKU
6	16SERPBX
5	19SERPBX
5	23/24SERPBX
5	80110FS
4	21SERPBX
3	16RASERPBX
3	80110RWN
3	T2DAPBX
3	T2NAPBX
*/

select ixFinishedSKU, (sum(iQuantity)-sum(iCompletedQuantity)) AdjQty
from tblBOMTransferMaster
where ixDueDate between 15797 and 15827
   and ixFinishedSKU = '16SERPBX'
group by ixFinishedSKU





select * -- ixDate Date, ixEmployee Emp, ixSKU, ixTransferNumber TrnsfNm, sAction, iCompletedQuantity CompQty,sJob 
from tblJobClock
where sJob like '%20229P*%'
and ixDate between 15808 and 15810

/*
Date	Emp	TrnsfNm	sAction	CompQty	sJob
15719	SDR	48618-1	R	      4	      80-78174330*010
15719	SDR	48618-1	R	      4	      80-78174330*020
15720	5PFS	48618-1	R	      2	      80-78174330*030
15720	5PFS	48618-1	R	      2	      80-78174330*040
15720	5PFS	48618-1	R     	2	      80-78174330*050
15720	SDR	48618-1	R     	4	      80-78174330*020
15751	5JTJ	50965-1	R     	2	      80-78174330*030
15751	5JTJ	50965-1	R	      2	      80-78174330*040
15752	5PFS	50965-1	R	      2	      80-78174330*050
15800	5GDM	55065-1	R	      6	      80-78174330*020
15802	JMB	55065-1	R	      1	      80-78174330*030
15803	5PFS	55065-1	R	      6	      80-78174330*050
15803	JMB	55065-1	R	      6	      80-78174330*030
15803	JMB	55065-1	R	      6	      80-78174330*040
*/


select count(*) QTY, flgActive
from tblBOMSequence
group by flgActive


select distinct sJob from tblJobClock
where ixDate > 15718
order by sJob



select 
   replace(LEFT(substring(sJob,4,99),CHARINDEX('*',substring(sJob,4,99))), '*', ''),
   sum(iCompletedQuantity) CompQty   -- 78174330*010
from tblJobClock
where sJob = '71-20043*010'
group by sJob

