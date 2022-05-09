-- SMIHD-5230 - EC Source Code Orders entered by Shock Department
/*
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/01/16',    @EndDate = '07/31/16'  
*/    
SELECT ixOrder, O.mMerchandise, O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, O.sOrderTaker, O.ixCustomerType
from tblOrder O
    join tblCustomer C on O.ixCustomer = C.ixCustomer
where sOrderTaker in ('KRV','MAK1','KDL','AJE')
and dtShippedDate between @StartDate and @EndDate
and sSourceCodeGiven = 'EC'
and sOrderStatus = 'Shipped'
    and mMerchandise > 0 -- > 1 if looking at non-US orders
    and sOrderType <> 'Internal'   -- USUALLY filtered
ORDER BY   C.sCustomerLastName, C.sCustomerFirstName  
    

-- SKUs that RON will be editing Brand value in tng    
SELECT S.ixSKU, S.ixBrand, B.sBrandDescription, ixPGC
from tblSKU S
join tblBrand B on S.ixBrand = B.ixBrand
where ixSKU in ('96016600','96016606','96016611','96016612','96016621','96016622','96016631','96016632','96016641','96016642','96016061','96016062','96016063','96016064','96016065','96063000','96063051','96063052','96063053','96063054','96063055','97016600','97016606','97016611','97016612','97016621','97016622','97016631','97016632','97016641','97016642','97016072','97016062','97016073','97016074','97016075','97063000','97063051','97063062','97063063','97063064','97063065','94016600','94016606','940A800','940AR400','582GA400','94063000','94016711','94016712','94016071','940A711','940A712','940AAR71','582GA061','94063061','94016721','94016722','94016072','940A721','940A722','940AAR72','582GA062','94063062','94016831','94016832','94016083','940A831','940A832','940AAR83','582GA073','94063073','94016941','94016942','94016094','94016095','940A941','940A942','940AAR94','582GA084','582GA085','94063084','94063085')    
order by ixPGC

select * from tblBrand
where UPPER(sBrandDescription) like '%DYNA%'

select ixPGC, COUNT(*) SKUcount -- 1,511 SKUs
from tblSKU where ixBrand = 10066
group by ixPGC
order by ixPGC
