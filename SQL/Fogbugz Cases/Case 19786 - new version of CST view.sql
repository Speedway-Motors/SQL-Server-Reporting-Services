-- Case 19786 - new version of CST view

SELECT C.ixCustomer
    ,C.sMailToState
    ,C.ixSourceCode 'ixOrigCustSourceCode'
    ,(Case 
          when SC.ixSourceCode like 'EBAY%' then 'EBAY'--  ,'CustGroup' -- currently based solely on the Customers Original SC and a manual list provided by Marketing
          when SC.sSourceCodeType like 'WEB%' then 'WEB'
          else 'OTHER'
      end    
     ) 'CustGroup'
FROM tblCustomer C-- 443,566 as of 6-1-12
                 -- 517,772 as of 9-3-13 @10:00   5 seconds
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
    
WHERE (sMailingStatus is NULL OR sMailingStatus = '0')      
/* REMOVED PER CASE # 15975
    and ixCustomerType < '90'
    and (ixCustomerType NOT like '%.%' 
        OR ixCustomerType is NULL)
    and (ISNUMERIC(ixCustomerType) = 1 -- eliminates types with chars
      OR ixCustomerType is NULL)
      */
  and sCustomerType = 'Retail'
  and flgDeletedFromSOP = 0
  --  and sMarket <>''   -- customer market (street, race etc)      add 65.2 to tblCustomer
  and ixCustomer in (select distinct ixCustomer  -- checking to see if customer has placed an order
                     from tblOrder
                     where sOrderStatus = 'Shipped'
                     and dtShippedDate >= DATEADD(yy, -6, getdate()) 
                     )  
                     -- 425K for past 72 months
                     -- 698K for entire Order History
                    
  and sMailToZip BETWEEN '01000' AND '99999'
  and (sMailToCountry = 'USA'    
       OR sMailToCountry is NULL OR sMailToCountry = '') -- says USA only in SOP
  -- excluding special military zips     
  and sMailToZip not like '962%' -- APO/FPO AP
  and sMailToZip not like '963%' -- APO/FPO AP
  and sMailToZip not like '964%' -- APO/FPO AP
  and sMailToZip not like '965%' -- APO/FPO AP
  and sMailToZip not like '966%' -- FPO AP
  and sMailToZip not like '09%' -- ALL are APO/FPO, AE     
