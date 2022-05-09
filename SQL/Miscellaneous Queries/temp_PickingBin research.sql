    
    
-- PICKING BIN.... tblSKULocation vs tblBinSku
select distinct ixSKU, ixLocation, sPickingBin -- 202,628
from tblBinSku


select distinct ixSKU, ixLocation, sPickingBin -- 270,997
from tblSKULocation







select count(*) from tblBinSku

select ixLocation, count(ixSKU+sPickingBin) cntSKUPickBinCombo-- 202,628
from tblBinSku
group by ixLocation
/*
47	95359
99	133832
*/

select ixLocation, count(ixSKU+sPickingBin) cntSKUPickBinCombo -- 270,997
from tblSKULocation
group by ixLocation
/*
47	99685
99	107866
*/


-- PICKING BIN.... tblSKULocation vs tblBinSku
select distinct ixSKU, ixLocation, sPickingBin -- 202,628
from tblBinSku
where sPickingBin is NOT NULL

select * from tblBinSku where ixLocation NOT IN (47,99)


select distinct ixSKU, ixLocation, sPickingBin -- 270,997
from tblSKULocation
where sPickingBin is NOT NULL

select * from tblSKULocation where ixLocation NOT IN (47,99)







select count(*) from tblBinSku -- 233,474

-- PICKING BIN.... tblSKULocation vs tblBinSku
select distinct ixSKU, ixLocation, sPickingBin, dtDateLastSOPUpdate -- 202,586
from tblBinSku


select sCustomerType, COUNT(*)
from tblCustomer 
group by sCustomerType


SELECT * FROM tblHighMaintenanceEndUser
/*
ixEmployee
JEF
PRG
JMR
KDL
*/

select ixEmployee from tblEmployee where ixEmployee in ('JEF','PRG','JMR','KDL')
union 
select ixEmployee from [SMIAfco].dbo.tblEmployee where ixEmployee = 'JMR'


select * from tblEmployee

