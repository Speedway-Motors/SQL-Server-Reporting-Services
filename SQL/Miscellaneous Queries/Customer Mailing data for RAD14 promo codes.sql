-- Customer Mailing data for RAD14 promo codes

-- RACER OPEN HOUSE

CUST #, MAILING ADDRESS



select PCM.ixPromoCode, PCM.sDescription, COUNT(PCX.ixOrder) OrderCount
from tblPromoCodeMaster PCM 
  left join tblOrderPromoCodeXref PCX on PCM.ixPromoId = PCX.ixPromoId
  left join tblOrder O on O.ixOrder = PCX.ixOrder
where PCM.ixPromoId in ('469','463','424','462')
group by PCM.ixPromoCode, PCM.sDescription
/*
ixPromo
Code	sDescription	                            OrderCount
RAD14E	EXTENDED RAD 2014 10% Discount	            0
RAD14H	Haggle for RAD 2014 10% Discount	        2
RAD14H	Haggle for RAD 2014 10% Discount Extended	3
RAD14	RAD 2014 10% Discount	                    257
                                                    ===
                                                    262 
                                                    258 Shipped orders for 213 customers
*/

SELECT distinct C.ixCustomer CustomerNumber
    , C.sCustomerFirstName 'FirstName'
    , C.sCustomerLastName 'LastName'
    , C.sMailToCOLine 'MailToLine'
    , C.sMailToStreetAddress1 'MailToAddress1'
    , C.sMailToStreetAddress2 'MailToAddress2'
    , C.sMailToCity 'MailToCity'
    , C.sMailToState 'MailToState'
    , C.sMailToZip 'MailToZip'
    , C.sMailToZipFour 'MailToZipPlus4'
from tblOrder O
    join tblOrderPromoCodeXref PCX on O.ixOrder = PCX.ixOrder
    join tblCustomer C on O.ixCustomer = C.ixCustomer
where PCX.ixPromoId in  ('469','463','424','462')   
and O.sOrderStatus = 'Shipped'





















select * from tblEmployee where ixDepartment = 26


RAD14


select * from tblPromoCodeMaster 
where UPPER(sDescription) like '%RAD%14%'
order by dtStartDate desc