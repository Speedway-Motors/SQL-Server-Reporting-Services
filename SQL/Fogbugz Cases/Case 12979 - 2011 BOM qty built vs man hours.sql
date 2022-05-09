select top 10 * from tblJobClock
where dtDate = '03-23-2012'

/*
sJob	    ixTransferNumber	ixSKU	sAction	iCompletedQuantity	iScrappedQuantity
72-PBX*700	73848-1	            PBX	    R	    16	                0
72-PBX*765	73848-1	            PBX	    R	    6	                0
72-PBX*765	73848-1	            PBX	    R	    48	                0
72-PBX*770	73848-1	            PBX	    R	    4	                0
*/

--select * from tblSKU where ixSKU = 'PBX'

select JC.ixSKU, 
        sum(JC.iCompletedQuantity) CompQty, 
    sum(JC.iStopTime-JC.iStartTime) TotSecondsWorked 
    --(sum(JC.iStopTime-JC.iStartTime)/3600) TotHoursWorked -- always rounds DOWN to the nearest hour
from tblJobClock JC
    join tblBOMTemplateMaster TM on TM.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CS_AS = JC.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
    join tblSKU SKU on JC.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
where JC.dtDate between '01/01/2011' and '12/31/2011'
    and JC.ixSKU is not NULL
    and SKU.ixPGC like 'Z%'    
group by JC.ixSKU
order by sum(JC.iCompletedQuantity) desc

/* 

-- 1,884 SKUs for 2011
Comp	ixSKU
296651	PBX
73234	000BEND
52101	CTFMSTUBE
45813	CUTMSTUBE
23701	A550100095X
13778	A550100139X
11798	A550010106X
9645	CTFSSTUBE
8933	INSPECTHDR
8050	CUTSSTUBE
6494	180BEND
6266	WASHHDR
5767	20131AXX
5563	DEBURMSHDR
*/



