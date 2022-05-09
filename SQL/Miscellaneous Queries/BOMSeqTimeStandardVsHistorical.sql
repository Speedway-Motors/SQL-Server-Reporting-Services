select top 10 * from tblBOMSequence
SET ROWCOUNT 0

SELECT ixFinishedSKU ixFinSKU,iSequenceNumber SeqNum, sLaborType, 
   --dLaborAmount LaborAmt, 
   CAST((60/dLaborAmount) AS dec(12,2)) StdMins, 
   ISNULL(CAST((60/NULLIF(dSetupTime,0))AS int),0) SetupMins, sDepartment Dept, sResource, sOperation
FROM tblBOMSequence
WHERE flgActive = 1
and ixFinishedSKU = '20140'
ORDER BY SeqNum
/*
ixFinSKU	SeqNum	sLaborType	StdMins	SetupMins	Dept	sResource	sOperation
20140	   100	   DEP70LAB	   0.33	   0	         70	   ASAW1	      SAW
20140	   105	   DEP70LAB	   7.50	   0	         70	   BMILL	      MIL
20140	   110	   DEP70LAB	   0.46	   0	         70	   SAN	      SAN
20140	   120	   DEP70LAB	   0.46	   0	         70	   DRILL	      CHM
20140	   130	   DEP70LAB 	5.00	   181	      70	   TWD01	      TAC
20140	   140	   DEP70LAB	   6.00	   0	         70	   FWD01	      WLD
20140	   145	   DEP70LAB	   2.00	   240	      70	   TRTL	      REM
20140	   150	   DEP70LAB	   4.00	   0	         70	   TWD01	      TAC
20140	   155	   DEP70LAB	   6.67	   0	         70	   FWD01	      WLD
20140	   157	   DEP70LAB	   4.00	   285	      70	   MSAW	      SAW
20140	   160	   DEP70LAB	   0.78	   0	         70	   SAN	      SAN
20140	   170	   DEP70LAB	   1.50	   0	         70	   DRILL	      CHM
20140	   180	   DEP70LAB	   2.00	   0	         70	   WIRE	      WIR
20140	   190	   DEP70LAB	   6.67	   0	         70	   LABOR	      CLN
20140	   210	   DEP71LAB	   2.00	   0	         71	   AS	         ASY

SELECT ISNULL(CAST((60/NULLIF(dSetupTime,0))AS int),0) SetupMins
from tblBOMSequence
where ISNULL(CAST((60/NULLIF(dSetupTime,0))AS dec(12,1)),0) <> 0
order by SetupMins desc



select * from tblJobClock
where replace(LEFT(substring(sJob,4,99),CHARINDEX('*',substring(sJob,4,99))), '*', '') = '20140'






select ixSKU, count(distinct sJob) jobs
from tblJobClock
group by ixSKU
order by jobs desc
*/



SELECT 
   BTM.ixFinishedSKU, 
   RCT.Seq,
   --sum(seconds)/sum(RCT.CompQty) SecondsPerSeq,
   ISNULL(CAST((60/NULLIF(BS.dLaborAmount,0)) AS dec(12,2)),0)                StanMinsPerSeq, -- Estimated time to complete a sequence
   CAST(((CAST(sum(seconds)AS dec(12,2))/sum(RCT.CompQty))/60)AS dec(12,2))   HistMinsPerSeq  -- Actual time taken to complete a sequence
FROM tblBOMTransferMaster BTM
       -- How to get only 3 newest completed transfers per SEQ?
 left join (select Transfers.* 
            from  -- all transfers
                  (SELECT ixTransferNumber, ixSKU, sJob, 
                     RIGHT(sJob,len(sJob)-charindex('*',sJob)) Seq, -- extracts sequence from sJob
                     sum(iCompletedQuantity) CompQty,
                     sum(iStopTime - iStartTime) as seconds
                  FROM tblJobClock JC 
                  WHERE ixTransferNumber is not null 
                  GROUP BY ixTransferNumber, ixSKU, sJob, RIGHT(sJob,len(sJob)-charindex('*',sJob))
                  HAVING sum(iCompletedQuantity) > 0
                  ) Transfers
               join tblBOMTransferMaster BTM 
                     on BTM.ixTransferNumber COLLATE SQL_Latin1_General_CP1_CS_AS = Transfers.ixTransferNumber COLLATE SQL_Latin1_General_CP1_CS_AS
            where BTM.iCompletedQuantity >= BTM.iQuantity
            ) RCT /*recently completed transfers */ on RCT.ixSKU = BTM.ixFinishedSKU
    left join tblBOMSequence BS on BS.ixFinishedSKU = RCT.ixSKU
         and BS.iSequenceNumber = RCT.Seq 
WHERE BS.flgActive = 1
GROUP BY BTM.ixFinishedSKU, RCT.Seq, ISNULL(CAST((60/NULLIF(BS.dLaborAmount,0)) AS dec(12,2)),0) 
HAVING RCT.Seq <> 0
order by BTM.ixFinishedSKU, RCT.Seq

select * from tblJobClock



select ixFinishedSKU from tblBOMSequence where ixFinishedSKU is NULL




select distinct ixFinishedSKU, iSequenceNumber from tblBOMSequence where flgActive = 1


select * from tblBOMSequence
where iSequenceNumber is NULL


select * from tblBOMTransferMaster
where ixTransferNumber in ('35272-1','28045-1','37688-1','21851-1')

/*
dtDate	               ixSKU	ixTransferNumber	sJob	         iCompletedQuantity	seconds	mins
2010-12-02 00:00:00.000	20140	37688-1	         80-20140*130	25	                  4643	3.00
2010-07-15 00:00:00.000	20140	35272-1	         80-20140*130	10	                  2333	3.00
2010-03-04 00:00:00.000	20140	28045-1	         30-20140*130	15	                  1035	1.00
2010-01-28 00:00:00.000	20140	21851-1	         80-20140*130	20	                  3865	3.00
*/

/*




*/


select *
from tblJobClock
where sJob like '%*%*%'

select sJob, ixSKU, replace(LEFT(substring(sJob,4,99),CHARINDEX('*',substring(sJob,4,99))), '*', '') 
 from tblJobClock
where ixSKU is not null
and ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS <> replace(LEFT(substring(sJob,4,99),CHARINDEX('*',substring(sJob,4,99))), '*', '') COLLATE SQL_Latin1_General_CP1_CS_AS 


/*
iCompletedQuantity	seconds
20	3865
15	1035
10	2333
25	4643
*/

select sJob,RIGHT(sJob,len(sJob)-charindex('*',sJob)) Seq


 --right((len(sJob)-charindex('*',sJob)),sJob) adj
from tblJobClock
where sJob = '80-20140*130'


