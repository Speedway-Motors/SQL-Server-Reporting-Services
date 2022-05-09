select
      tblSourceCode.ixCatalog,
      tblOrder.sMatchbackSourceCode,      
      sum(tblOrder.mMerchandise) as 'Merch Total',
      sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
      count(distinct(SUBSTRING(tblOrder.ixOrder, 1, 7))) as '# Orders',
      count(distinct(tblOrder.ixCustomer)) as '# Customers'
     -- count(distinct(NewCust.ixCustomer)) as '# New Customers'
from
      tblOrder
      left join tblSourceCode on tblOrder.sMatchbackSourceCode = tblSourceCode.ixSourceCode
      left join (select ixCustomer
              from vwNewCustOrder
            where vwNewCustOrder.dtOrderDate >= '08/30/2010'
         )NewCust on tblOrder.ixCustomer = NewCust.ixCustomer  
      join PJC_PrintAdSourceCodes PA on PA.ixSourceCode  COLLATE SQL_Latin1_General_CP1_CS_AS = tblOrder.sMatchbackSourceCode  COLLATE SQL_Latin1_General_CP1_CS_AS
where
     tblOrder.sMatchbackSourceCode  COLLATE SQL_Latin1_General_CP1_CS_AS in (select ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS from PJC_PrintAdSourceCodes)
     and tblOrder.sOrderStatus not in ('Cancelled', 'Pick Ticket')
     and tblOrder.sOrderChannel <> 'INTERNAL'
     --and tblOrder.mMerchandise > 0
     and tblSourceCode.ixSourceCode in ('6150',
'6151',
'6152',
'6154',
'6155',
'6156',
'6157',
'6158',
'6159',
'6160',
'6161',
'6162',
'6163',
'6164',
'CK02',
'SR60')
group by
     tblSourceCode.ixCatalog,
     tblOrder.sMatchbackSourceCode
order by
    tblSourceCode.ixCatalog,
    tblOrder.sMatchbackSourceCode
/*
ixCatalog       sMatchbackSourceCode           Merch Total            Merch Cost    # Orders # Customers
--------------- -------------------- --------------------- --------------------- ----------- -----------
295             DR45                                 19.98                 14.04           1           1
295             GG59                                 39.99                  7.40           1           1
295             GG60                               2767.95              1590.179           4           4
295             GG61                                231.97                108.62           3           3
295             RC51                                  2.00                  0.00           4           4
295             RC53                                261.20                151.49           5           5
295             SR53                                703.91                287.99           5           5
295             SR55                               1077.91                529.21           5           5
295             STS50                              1014.95               465.026           1           1
295             STS52                               265.93               123.748           3           3
295             STS53                              1280.43                891.43           4           4
314             CT54                                 59.99                27.001           1           1
318             RC56                                219.97                125.26           1           1
318             SR58                               1129.07               578.863           4           4
WEB.11          WCR5                               6363.02               1845.89          49          42
WEB.11          WCR6                                864.57               398.598          11           8
*/

select * from tblSourceCode where ixCatalog = 'WEB.11'


select distinct SC.ixSourceCode
from PJC_PrintAdSourceCodes PA
   join tblSourceCode SC on SC.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS = PA.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS


select count



select count(ixOrder)
from tblOrder
where sMatchbackSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS in (select ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS from PJC_PrintAdSourceCodes)





select top 10 * from tblSourceCode


select min(dtStartDate) Start
from PJC_PrintAdSourceCodes PA
   join tblSourceCode SC on  PA.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS = SC.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS



select *
from tblSourceCode
where dtStartDate >= '07/13/2010'
and sSourceCodeType = 'MAG AD'
and ixSourceCode COLLATE SQL_Latin1_General_CP1_CI_AS NOT in (select ixSourceCode from PJC_PrintAdSourceCodes)
order by dtStartDate


-- Backorders shipped 09/01/10-03/01/11

select * from tblOrder 
where sOrderStatus = 'Shipped'
   and ixOrder like '%-%'
   and dtShippedDate between '09/01/10' and '03/01/11'