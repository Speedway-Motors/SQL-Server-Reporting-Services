select COUNT(*)
from tblCustomer C
where C.dtAccountCreateDate >= '04/04/2010' -- 168,157
  and sEmailAddress is not NULL			    -- 122,345
  and (flgMarketingEmailSubscription is NULL-- 122,186
    or flgMarketingEmailSubscription = 'Y')
  and sMailToCountry = 'CANADA'


select flgMarketingEmailSubscription from tblCustomer
where ixCustomer = '####'
where flgMarketingEmailSubscription = 'Y'



