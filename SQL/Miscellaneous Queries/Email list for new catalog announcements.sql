select count(C.ixCustomer) -- 204,899
from tblCustomer C
   join tblCustomerOffer CO on C.ixCustomer = CO.ixCustomer
   join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '336'
and SC.sSourceCodeType = 'CAT-H'




select count(distinct C.sEmailAddress)
from tblCustomer C
   join tblCustomerOffer CO on C.ixCustomer = CO.ixCustomer
   join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '336'
and SC.sSourceCodeType = 'CAT-H'
and sEmailAddress is not NULL

 -- 204,899 customers will receive the Catalog
 -- 150,003 DISTINCT email addresses there were approx 5,000 dupes
