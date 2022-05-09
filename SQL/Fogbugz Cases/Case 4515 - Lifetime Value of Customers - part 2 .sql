select 
    TY.CustCount        TYCustCount,
    TY.OrdCount         TYOrdCount,
    TY.AvgCustAvgOrdAmt TYAvgCustAvgOrdAmt,
    TY.MedCustAvgOrdAmt TYMedCustAvgOrdAmt,
    TY.TotRev           TYTotRev,
    TY.CoGS             TYCoGS,

    LY.CustCount        LYCustCount,
    LY.OrdCount         LYOrdCount,
    LY.AvgCustAvgOrdAmt LYAvgCustAvgOrdAmt,
    LY.MedCustAvgOrdAmt LYMedCustAvgOrdAmt,
    LY.TotRev           LYTotRev,
    LY.CoGS             LYCoGS,

    LY2.CustCount        LY2CustCount,
    LY2.OrdCount         LY2OrdCount,
    LY2.AvgCustAvgOrdAmt LY2AvgCustAvgOrdAmt,
    LY2.MedCustAvgOrdAmt LY2MedCustAvgOrdAmt,
    LY2.TotRev           LY2TotRev,
    LY2.CoGS             LY2CoGS
    -- RC   LYCustCount/LY2CustCount  = Retention Rate          row3
    -- RC   LY2CustCount/LY2CustCount = Avg # Orders per Year   row4
    -- RC   LY2TotRev / LY2OrdCount = Simple Avg Order Amt      row5

    -- RC   LY2TotRev/LY2CustCount TotRevPerCust                row10
    --  LY2TotRev * .1         LY2COFullfillment,               row12
    -- RC   LY2CustCount*(1.75*10) LY2EstCatCosts,              row14
    -- LY2COFullfillment + LY2COGS + LY2EstCatCosts LY2TotCosts,row15

    -- RC   LY2TotRev - LY2TotCosts = LY2GP                     row17
    -- '1' AS                              LY2Discount,     --  row18   provided by Dave Rhoer        1.06 for LY and 1.12 for TY
    -- RC   LY2GP/LY2Discount = LY2NetPV                        row19
    -- LY2NetPV LY2CumNPVProfit                                 row20   previous years Cumulative NPV Profit + current year NPV
    -- RC   LY2CumNPVProfit/LY2CustCount  LY2CustLTV            row21
from 

--  TY = THIS YEAR
(select count(distinct ixCustomer)  CustCount,              --  row2
    count(distinct ixOrder)         OrdCount,
    (select AVG(X.CustAvgOrd)
     from (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
           from PJC_temp_vw_sample
           where YRCat = 'TY'
           group by ixCustomer
         ) X
    )                               AvgCustAvgOrdAmt,       --  row6
    (SELECT MIN(CustAvgOrd)       
     FROM (SELECT TOP 50 PERCENT CustAvgOrd 
           FROM (select ixCustomer, 
                 sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
                 from PJC_temp_vw_sample
                 where YRCat = 'TY'
                 group by ixCustomer) X
          ORDER BY CustAvgOrd DESC) Y
     )                              MedCustAvgOrdAmt,   --  row7
     sum(mExtendedPrice)            TotRev,              --  row8
    (select sum(mExtendedCost)      
     from PJC_temp_vw_sample
     where YRCat = 'TY'
       and flgKitComponent = 0)     CoGS     --                        row13
from PJC_temp_vw_sample
where YRCat = 'TY'
) TY,
-- LY = LAST YEAR
(select count(distinct ixCustomer)  CustCount,              --  row2
    count(distinct ixOrder)         OrdCount,
    (select AVG(X.CustAvgOrd)
     from (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
           from PJC_temp_vw_sample
           where YRCat = 'LY'
           group by ixCustomer
         ) X
    )                               AvgCustAvgOrdAmt,       --  row6
    (SELECT MIN(CustAvgOrd)       
     FROM (SELECT TOP 50 PERCENT CustAvgOrd 
           FROM (select ixCustomer, 
                 sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
                 from PJC_temp_vw_sample
                 where YRCat = 'LY'
                 group by ixCustomer) X
          ORDER BY CustAvgOrd DESC) Y
     )                              MedCustAvgOrdAmt,   --  row7
     sum(mExtendedPrice)            TotRev,              --  row8
    (select sum(mExtendedCost)      
     from PJC_temp_vw_sample
     where YRCat = 'LY'
       and flgKitComponent = 0)     CoGS     --                        row13
from PJC_temp_vw_sample
where YRCat = 'LY'
) LY,
-- LY2 = 2 YEARS AGO
(select count(distinct ixCustomer)  CustCount,              --  row2
    count(distinct ixOrder)         OrdCount,
    (select AVG(X.CustAvgOrd)
     from (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
           from PJC_temp_vw_sample
           where YRCat = 'LY2'
           group by ixCustomer
         ) X
    )                               AvgCustAvgOrdAmt,       --  row6
    (SELECT MIN(CustAvgOrd)       
     FROM (SELECT TOP 50 PERCENT CustAvgOrd 
           FROM (select ixCustomer, 
                 sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
                 from PJC_temp_vw_sample
                 where YRCat = 'LY2'
                 group by ixCustomer) X
          ORDER BY CustAvgOrd DESC) Y
     )                              MedCustAvgOrdAmt,   --  row7
     sum(mExtendedPrice)            TotRev,              --  row8
    (select sum(mExtendedCost)      
     from PJC_temp_vw_sample
     where YRCat = 'LY2'
       and flgKitComponent = 0)     CoGS     --                        row13
from PJC_temp_vw_sample
where YRCat = 'LY2'
) LY2,




















select * from PJC_temp_vw_sample
where YRCat = 'LY2'

/*
select * from PJC_temp_vw_sample order by YRCat
-- drop table PJC_temp_vw_sample
select * 
into PJC_temp_vw_sample
from vwLTVReport 

where YRCat = 'LY2'
*/


select * from PJC_temp_vw_sample
order by YRCat,
ixCustomer

select count(distinct(ixCustomer))
from PJC_temp_vw_sample
where YRCat = 'TY'


select * from PJC_temp_vw_sample
where YRCat = 'LY2'
order by ixCustomer


select * -- ixSKU,sDescription 
from tblSKU
where flgIsKit = 1
    and flgActive = 1
order by newid()
/*
select count(distinct ixCustomer) CustQTY -- 120353
from vwLTVReport
where dtShippedDate >= '11/15/07'
and dtShippedDate < '11/16/08'

*/

--select top 10 * from vwLTVReport
/*
ixCustomer	ixOrder 	mExtendedPrice	mExtendedCost	flgKitComponent	dtShippedDate	        YRCat
597857	    2746793-1	124.99	        92.86	        0	            2007-11-16 00:00:00.000	LY2
957746	    2747445-1	99.99	        21.22	        0	            2007-11-16 00:00:00.000	LY2
944503	    2746273-1	8.99	        1.50	        0	            2007-11-16 00:00:00.000	LY2

*/

select * from tblOrderLine
where ixSKU in ('91637019','91015140','91031049','91034385')
and dtShippedDate > '01/01/10'