-- Parse Domain from email address

select top 100 ixCustomer
    , sEmailAddress
    ,RIGHT(sEmailAddress, LEN(sEmailAddress) - CHARINDEX('@', sEmailAddress)) Domain
from tblCustomer
where sEmailAddress is NOT NULL