select C.sMailToZip, C.sMailToCountry
from tblCustomer C
where LEN(C.sMailToZip) = 6
and (
sMailToCountry is NULL
     or sMailToCountry <> 'CANADA'
     )
and C.sMailToZip like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'    -- zips exactly 6 characaters long and A#A#A# format  
order by   C.sMailToCountry,   C.sMailToZip 
     



select C.sMailToZip, C.sMailToCountry
from tblCustomer C
where C.sMailToZip like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'   -- zips exactly 6 characaters long and A#A#A# format

select C.sMailToZip, C.sMailToCountry
from tblCustomer C
where C.sMailToCountry = 'CAN'
and C.sMailToZip like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'   -- zips exactly 6 characaters long and A#A#A# format
and 

select C.sMailToCountry, COUNT(*) Qty
from tblCustomer C
where C.sMailToZip like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'   -- zips exactly 6 characaters long and A#A#A# format
group by C.sMailToCountry
order by Qty Desc

-- 7 character postal codes with - or space in 4th position
select ixCustomer, sCustomerType, sMailToCity, sMailToState, sMailToZip, sMailToCountry,
dtAccountCreateDate, sCustomerFirstName, sCustomerLastName, 
sEmailAddress, ixCustomerType, sMailingStatus, sCustomerMarket, dtDateLastSOPUpdate
from tblCustomer
where sMailToZip like '[A-Z][0-9][A-Z][ -][0-9][A-Z][0-9]' -- 7 character postal codes with - or space in 4th position
   -- and sMailToCountry = 'CANADA'
    and flgDeletedFromSOP = 0
order by dtAccountCreateDate    



-- 7 character postal codes with - or space in 4th position
select ixCustomer -- 5,254 INVALID POSTAL CODES
--, sCustomerType, sMailToCity, sMailToState, sMailToZip, sMailToCountry,
--dtAccountCreateDate, sCustomerFirstName, sCustomerLastName, 
--sEmailAddress, ixCustomerType, sMailingStatus, sCustomerMarket, dtDateLastSOPUpdate
from tblCustomer
where sMailToCountry = 'CANADA'
and sMailToZip NOT like '[A-Z][0-9][A-Z][ -][0-9][A-Z][0-9]' -- 7 character postal codes with - or space in 4th position
and sMailToZip NOT like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]' 
   -- and sMailToCountry = 'CANADA'
    and flgDeletedFromSOP = 0
order by dtAccountCreateDate    


select C.sMailToZip,C.dtAccountCreateDate, DATEDIFF(YY,C.dtAccountCreateDate,getdate())  --) --C.dtAccountCreateDate
from tblCustomer C
where C.sMailToCountry = 'CANADA'
ORDER by C.dtAccountCreateDate

