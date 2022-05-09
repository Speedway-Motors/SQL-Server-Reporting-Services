   select CUST.sMailToState,
            'Non U.S.' as             SortOrd,
         SUM(CMM.mMerchandise) RetMerch,
         SUM(CMM.mShipping)    RetShipping
   from    tblCreditMemoMaster CMM 
      join tblCustomer CUST on CUST.ixCustomer = CMM.ixCustomer
   where  CMM.flgCanceled = 0
      and CMM.dtCreateDate >= '01/01/2010'
      and CMM.dtCreateDate <  '01/01/2011'
      and CUST.sMailToCountry is NOT null
      and CUST.sMailToCountry NOT in ('US', 'USA')
   group by CUST.sMailToState
order by CUST.sMailToState


select top 10 * from tblCustomer -- sMailToState / sMailToCountry 
select top 10 * from tblOrder    -- sShipToState / sShipToCountry