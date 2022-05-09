-- SMIHD-22286 - avg total received Merch cost by month 

-- tblSKUTransaction has data from 5/1/19 to present as of 8/13/21

-- Tot Received Merch Cost by OPERATIONAL PERIOD
SELECT D.iOperationalYear, D.iOperationalPeriod, 
    FORMAT(SUM(ST.iQty * POD.mCost),'$###,###,###') 'TotExtCost'
from tblSKUTransaction ST
    left join tblReceiver R on ST.ixReceiver = R.ixReceiver
    left join tblPODetail POD on R.ixPO = POD.ixPO  
                                and POD.ixSKU = ST.ixSKU
    left join tblDate D on ST.ixDate = D.ixDate
where ST.ixDate between 18854 and 19584 -- 08/14/2019 and 08/13/2021
    and sTransactionType = 'R'
group by D.iOperationalYear, D.iOperationalPeriod
order by D.iOperationalYear desc, D.iOperationalPeriod desc

-- Tot Received Merch Cost by FISCAL PERIOD
SELECT D.iPeriodYear, D.iPeriod, FORMAT(SUM(ST.iQty * POD.mCost),'$###,###,###') 'TotExtCost'
from tblSKUTransaction ST
    left join tblReceiver R on ST.ixReceiver = R.ixReceiver
    left join tblPODetail POD on R.ixPO = POD.ixPO  
                                and POD.ixSKU = ST.ixSKU
    left join tblDate D on ST.ixDate = D.ixDate
where ST.ixDate between 18836 and 19571 -- 07/27/2019 and 07/31/2021
    and sTransactionType = 'R'
group by D.iPeriodYear, D.iPeriod
order by D.iPeriodYear desc, D.iPeriod desc

select top 10 * from tblSKUTransaction
order by ixDate

select * from tblDate where ixDate = 18749



-- START AND END DATE RANGES NEEDED
SELECT ixDate, dtDate, 
    iOperationalYear 'OpYr', iOperationalPeriod 'OpPrd', iDayOfFiscalPeriod 'DayOfPrd', 
    iPeriodYear 'PrdYr', iPeriod 'Period', iDayOfOperationalPeriod 'DayOfOPprd'
from tblDate 
where ixDate in (19541,19571,18854,19584,18836,19571)
order by ixDate
/*                          Day            
                        Op  Of              DayOf
ixDate	dtDate	   OpYr	Prd	Prd	PrdYr	Prd	OPprd
18836	2019-07-27 2019	8	1	2019	8	11
18854	2019-08-14 2019	9	19	2019	8	1
19541	2021-07-01 2021	7	1	2021	7	13
19571	2021-07-31 2021	8	31	2021	7	15
19584	2021-08-13 2021	8	13	2021	8	28
*/

select * from tblDate 
where iOperationalYear = 2021
    and iOperationalPeriod = 8
order by ixDate

select * from tblDate 
where iOperationalYear = 2021
    and iOperationalPeriod = 8
order by ixDate


select * from tblDate where iPeriodYear = 2019
and iPeriod = 8

select * from tblReceiver where ixReceiver = 338621 

select sTransactionType, count(*)
from tblSKUTransaction
where ixDate = 19541
group by sTransactionType

select * from tblTransactionType