select * from tblPOMaster where ixPO like '%89899%' -- Carol's test job
select * from tblPOMaster where ixPO like '%88889%' -- My test job

select * from tblPODetail where ixPO like '89899%' -- Carol's test job
select * from tblPODetail where ixPO like '88889%' -- My test job


select flgBlanket, count(*) QTY
from tblPOMaster
group by flgBlanket

select * from tblPOMaster where flgBlanket = 1

