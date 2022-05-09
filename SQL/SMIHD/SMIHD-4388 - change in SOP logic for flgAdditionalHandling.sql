-- SMIHD-4388 - change in SOP logic for flgAdditionalHandling

select  COUNT(*) Qty, flgAdditionalHandling
from tblSKU
where flgDeletedFromSOP = 0
group by flgAdditionalHandling

/*      flg
	    Additional
Qty     Handling
306,770	0           as of 6-6-2016 5:35PM
  4,560	1
*/

-- back-up table prior to Connie applying changes
select ixSKU, flgAdditionalHandling, dtDateLastSOPUpdate
into [SMITemp].dbo.PJC_Temp_SKUsAdditionalHandling
from tblSKU
where flgDeletedFromSOP = 0
    and flgAdditionalHandling = 1
    
select COUNT(*) from [SMITemp].dbo.PJC_Temp_SKUsAdditionalHandling  -- 4,560 SKUs flagged prior to logic change

-- current counts
select ixSKU, flgAdditionalHandling, dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 5,268 @6-7-16 15:13
from tblSKU
where flgDeletedFromSOP = 0
    and flgAdditionalHandling = 1
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate

select ixTime, chTime from tblTime where ixTime = 55250
/*
ixTime	chTime
55250	15:20:50  
54820	15:13:40  
45206	12:33:26  



*/




