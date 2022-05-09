-- SMIHD-4858 - Guaranteed Delivery Success Rate
select dtGuaranteedDelivery, 
SUM(CASE WHEN flgDeliveryPromiseMet = 1 THEN 1 ELSE 0 END) 'Met',
SUM(CASE WHEN flgDeliveryPromiseMet = 0 THEN 1 ELSE 0 END) 'NotMet',
SUM(CASE WHEN flgDeliveryPromiseMet IS NULL THEN 1 ELSE 0 END) 'UK'
from tblOrder
where flgGuaranteedDeliveryPromised = 1 -- is NOT NULL
and dtGuaranteedDelivery <=  DATEADD(dd, -2, getdate()) 
and ixOrder NOT LIKE 'Q%'
group by  dtGuaranteedDelivery
order by dtGuaranteedDelivery desc

-- SUM(CASE WHEN flgBackorder = 1 THEN '1' ELSE '0' END)


/*
Guaranteed      Not
Delivery	Met	Met	UK
==========  === === ===
2016-08-13  51	1	0
2016-08-12  379	5	6
2016-08-11  463	15	6
2016-08-10  608	14	7
2016-08-09  327	4	5
2016-08-08  127	3	1
2016-08-06  72	8	0
2016-08-05  392	9	4
2016-08-04  350	6	8
2016-08-03  95	3	0
*/

SELECT * -- ixOrder, flgGuaranteedDeliveryPromised, flgDeliveryPromiseMet, dtGuaranteedDelivery, dtDateLastSOPUpdate
from tblOrder
where flgGuaranteedDeliveryPromised = 1 -- is NOT NULL
    AND dtGuaranteedDelivery <= '08/12/2016'
    AND flgDeliveryPromiseMet IS NULL  -- 37
    AND ixOrder not like 'Q%'
    AND sOrderStatus NOT IN ('Cancelled')
order by dtDateLastSOPUpdate


