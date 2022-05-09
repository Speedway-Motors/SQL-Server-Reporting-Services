SELECT ixSKU from tblSKU where iLeadTime = 0
order by ixSKU -- 16359



select ixOrder, count(*) OLs
from tblOrderLine
where iOrdinality is NULL
group by ixOrder
having  count(*) > 100
order by OLs desc


-- TEST TABLE
-- drop table PJC_tblOrderLine_UpdateTest
select * into PJC_tblOrderLine_UpdateTest   -- 597    9,827 rows
from tblOrderLine
where ixOrder in ('788909','792362','559043','734715','1131131','806068','1348908','672814','672810','670372','1330679','229581','1962743','532765','3314871','2309099','151016','1349001','546682','2201610','1937480','2051988','667024','2231723','907976','2388217','666929','1659948','2091749','2496129','2056592','228804','267526','1365921','1349235','1366539','559901','538182','537719','730191','2070943','935753','3444070','2070943-1','188416','355573','2149735','356361','356208','462371','462299','2224554','3555272','3375777','451499','1575104','1576150','934972','218331','437939','218464','283180','767104','1258502','433528','248907','416187','472926','935016','559909','1421635','571547','1421757','1421388','2239150')
order by newid()




select count(distinct ixOrder) -- 1,711,321
from tblOrderLine
where iOrdinality is NULL

select ixSKU, iLeadTime from tblSKU where ixSKU in ('91645150-PLN','91048342-600-MEGA','610606')

