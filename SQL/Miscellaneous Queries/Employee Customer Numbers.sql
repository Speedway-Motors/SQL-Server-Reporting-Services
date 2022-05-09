-- Employee Customer Numbers
select * from tblCustomer
where ixCustomer in ('982876','1554623','1341213','1170307','782720','636603')
/*
ixCustomer	sCustomerType	sCustomerFirstName	sCustomerLastName
636603	   Retail	      CAROL	               JOHNSON
782720	   Retail	      CHRIS	               CHANCE
982876	   Other	         RYAN	               EBKE
1170307  	Other	         AL	                  BREDTHAUER
1341213	   Retail	      JENNIFER	            GORDON
1554623	   Retail	      PATRICK	            CREWS
*/



select sCustomerType, count(*) QTY
from tblCustomer where sEmailAddress like '%afcoracing.com' --'%@SPEEDWAYMOTORS.COM'
group by sCustomerType
/*
QTY	sCustomerType
1	   MRR
72	   Other
248	Retail
*/