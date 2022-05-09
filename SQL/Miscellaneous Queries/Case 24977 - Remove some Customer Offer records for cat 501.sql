Case 24977 - Remove some Customer Offer records for cat 501

/* SOP UNMARKING the 30,484 Customer Offers

                Rec                 Rec/
FILE    Time    Processed   Sec     Sec     ETA   
====    =====   =========   =====   ====    ===
1       11:08   0           
        12:03   3400        3300    1.0     1:55
        12:57   6500        3240     .96    2:02
         FINAL  10000       10475    .95
                
2       11:11   0           
        12:03   1900        3120    0.6     3:48 
        12:57   4000        3240    0.6     3:48
         2:02   6200        3900    0.56    3:10-3:55
         3:12               4200
                           
3       11:??
        12:03    700         
        12:57   2900        3240    0.7     4:00
         2:02   5200        3900    0.59    3:40-4:32
         3:12   9000        4200     .90    
         3:23  10100        

*/


/************ DELETING the above offers from LNK-DWSTAGING1 ************/

select count(*) from [SMITemp].dbo.PJC_24872_CustomersOffersToDelete --  30484

select CO.* from tblCustomerOffer CO
join [SMITemp].dbo.PJC_24872_CustomersOffersToDelete COD on CO.ixCustomer = COD.ixCustomer -- 30,478 rows in @37 sec
                                                    and CO.ixSourceCode = COD.ixSourceCode
where CO.ixSourceCode like '501%'

/* Back da sh*t up
select * into [SMIArchive].dbo.BU_tblCustomerOfferBU_12302014 -- 18,252,527 rows @56 sec
from tblCustomerOffer
*/



 select CO.* 
 -- DELETE
 from tblCustomerOffer
 where ixCustomer in (select ixCustomer from [SMITemp].dbo.PJC_24872_CustomersOffersToDelete) -- 36 sec to run the SELECT      the DELETE FINISHED IN 10 sec
 and ixSourceCode like '501%'
 
 
 
 /* old SC's to test on Newton
 
 select top 10 * from tblCustomerOffer
 
 select ixSourceCode, dtActiveStartDate, count(*) OfferQty
 from tblCustomerOffer
 where dtActiveStartDate < '12/28/2013'
 group by ixSourceCode, dtActiveStartDate
 having count(*) between 1000 and 1200
 order by dtActiveStartDate
 
 select count(*) from tblCustomerOffer
 
 
 
 select * from tblSourceCode where ixSourceCode = '1019CAT' --'27614'
 
 select -- *
 ixCustomer, ixSourceCode
 from tblCustomerOffer
 where ixSourceCode = '27614'