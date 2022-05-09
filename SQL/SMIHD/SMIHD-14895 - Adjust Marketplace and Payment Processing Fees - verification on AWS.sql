SMIHD-14895 - Adjust Marketplace and Payment Processing Fees - verification on AWS


select FORMAT(SUM(mPaymentProcessingFee),'###,###.##') 'TotPPfee',
     FORMAT(SUM(mMarketplaceSellingFee),'###,###.##') 'TotMPSfee',
     FORMAT(getdate(),'yyyy.MM.dd HH:mm') 'AsOf'
from tblOrder
where ixOrder between '7000071' and '7427595' -- batch 1 42k
    -- ixOrder between '7427596'   and '7783785' -- batch 2 42k
    -- ixOrder between '7783786' and '8138905' -- batch 3 42k
    -- ixOrder between '8138906' and '8574922' -- batch 4 42k
  --  ixOrder between '8574923' and '8999929' -- batch 5of5 39,920
/*
TotPPfee	TotMPSfee
21,914,527.15	3,631,607.1-- batch1  SQL-SERVER-LIVE-1
21,914,539.77	3,631,618.35	2019.08.29 16:50

818,423.21	    556,576.03  -- batch 2 expected	
818,423.21v	    556,576.03v 	2019.08.29 16:50 -- 100% match

811,568.71	    556,605.38  -- batch 3 expected
811,568.71v	    556,605.38v	2019.08.29 17:07 -- 100% match

454,418.52	    300,360.44  -- batch 4 expected
454,418.52v	    300,360.44v	2019.08.29 17:23 -- 100% match


select min(ixTimeLastSOPUpdate)
from tblOrder
where dtInvoiceDate = '08/29/2019'
or dtShippedDate = '08/29/2019' -- 45183


select * from tblOrder
where dtDateLastSOPUpdate >= '08/27/2019'



SELECT FORMAT(getdate(),'yyyy.MM.dd HH:mm') 'AsOf',
    date_add(hour,-5,getdate())

    date_add(hour,-5.<DateField>)

*/

    select count(O.ixOrder) 'OrderCount', BU.sBusinessUnit, FORMAT(sum(mMarketplaceSellingFee),'###,###.##') TotMPSellingFee
    from tblOrder O
        left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    where dtInvoiceDate between '01/01/2018' and '12/31/2018'--  <-- Change date to previous day
    and (sSourceCodeGiven like '%EBAY%'
         or sSourceCodeGiven like 'AMAZON%'
         or sSourceCodeGiven = 'WALMART')
    and BU.sBusinessUnit = 'MKT'
    group by BU.sBusinessUnit
    order by BU.sBusinessUnit

    -- MKT	1,272,949.28 Target
    -- MKT	1,021,068.09 @8/29/19 5:20p
    /*
    OrderCount	sBusinessUnit	TotMPSellingFee/*
    160,613	    MKT	            1,343,307.66       -- Target  100% match

    */

    -- PaymentProcessingFee
    select sMethodOfPayment, FORMAT(sum(mPaymentProcessingFee),'###,###.##') TotPmtProcFee
    from tblOrder O
        left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    where sMethodOfPayment in ('PP-AUCTION','PAYPAL')
        and dtInvoiceDate between '01/01/2018' and '12/31/2018' --  <-- Change date to previous day
    group by sMethodOfPayment
    order by sMethodOfPayment
/*  sMethodOfPayment	TotPmtProcFee
    PAYPAL	            298,554.03v
    PP-AUCTION	        249,192.29v    TARGETS   100% match
