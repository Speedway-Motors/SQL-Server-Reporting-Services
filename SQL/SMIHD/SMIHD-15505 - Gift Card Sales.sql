-- SMIHD-15505 - Gift Card Sales


SELECT * FROM tblSKU
where ixSKU like '%GIFT%'
and flgDeletedFromSOP = 0
and flgActive =1


SELECT ixSKU, 
   -- FORMAT(SUM(mExtendedPrice),'$###,###') 'Sales', 
    FORMAT(SUM(iQuantity),'###,###') 'QtySold'
from tblOrderLine
where ixSKU in ('EGIFT','GIFT-RACE','GIFT-SMI','GIFT-SPRINT','GIFT-SR')
    --and ixOrderDate between 18264 and 18628	--1/1/2018-12/31/2018 
    and ixOrderDate between 18629 and 18922	--1/1/2016-12/31/2018 
    and mUnitPrice > 0
    and flgLineStatus = 'Shipped'
GROUP BY ixSKU
ORDER BY ixSKU

select * from tblFIFODetail
where ixSKU like '%HELP%'
and ixDate > 18922

select sFIFOSourceType, count(*)
from tblFIFODetail
where ixDate >= 18566
group by sFIFOSourceType
order by count(*) desc




-- Other GIFT SKUs on the list below had no sales (from customers buying them)
('EGIFT','GIFT-BD','GIFT-HOL','GIFT-RACE','GIFT-SMI','GIFT-SPRINT','GIFT-SR','GIFT-TCGRN','GIFT-TCRED','GIFT-VINT','GIFT.CARD-BDC','GIFT.CARD-SMI','GIFT.CARD-SMIHOL')

