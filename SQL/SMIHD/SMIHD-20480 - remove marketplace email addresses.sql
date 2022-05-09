-- SMIHD-20480 - remove marketplace email addresses

SELECT COUNT(1) -- 115,257          83,076 @8:47
from tblCustomer
where flgDeletedFromSOP = 0
and (  UPPER(sEmailAddress) like '%@MEMBERS.EBAY.COM' -- 40,641
    OR UPPER(sEmailAddress) like '%@RELAY.WALMART.COM' --   4,283
    OR UPPER(sEmailAddress) like '%@MARKETPLACE.AMAZON.COM') --  70,333
