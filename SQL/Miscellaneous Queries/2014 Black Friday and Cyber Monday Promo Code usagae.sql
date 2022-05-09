-- 2014 Black Friday and Cyber Monday Promo Code usagae
select * from tblPromoCodeMaster 
where UPPER(sDescription) like 'BLACK%'
order by dtStartDate desc
/*
ixPromoId	ixPromoCode	sDescription	                            dtStartDate
658	        BLACK14	    Black Friday FREE Shipping $62+ Web	        2014-11-26
659	        BLACK14E	Black Friday FREE Shipping $62+ Email	    2014-11-26
660	        BLACK14F	Black Friday FREE Shipping $62+ Social	    2014-11-24
657	        BLACK14H	Black Friday FREE Shipping $62+ Call Center	2014-11-24
*/

select COUNT(*) from where



select PCM.ixPromoCode, PCM.sDescription, COUNT(PCX.ixOrder) OrderCount
from tblPromoCodeMaster PCM 
  left join tblOrderPromoCodeXref PCX on PCM.ixPromoId = PCX.ixPromoId
  left join tblOrder O on O.ixOrder = PCX.ixOrder
where PCM.ixPromoId in ('657','659','660','658')
group by PCM.ixPromoCode, PCM.sDescription
/*
OrderCount	ixPromoCode	sDescription
46	        BLACK14H	Black Friday FREE Shipping $62+ Call Center
518	        BLACK14E	Black Friday FREE Shipping $62+ Email
4	        BLACK14F	Black Friday FREE Shipping $62+ Social
683	        BLACK14	    Black Friday FREE Shipping $62+ Web
*/


select * from tblEmployee where ixDepartment = 26