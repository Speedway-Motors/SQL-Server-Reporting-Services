-- Case 16872 - Analysis of Speedee orders more profitable by giving FRS promo

/*  Eligible orders 
    that had no Promo Applied
*/
select sPromoApplied,
        (Case when mMerchandise < 125 then 'LT125'
        else 'GT125'
        end
        ) MerchAmount,
         count(ixOrder) OrdersEligible, 
         avg(mShipping) AvgShipping, 
         avg(mMerchandise) AvgMerch                 
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where iShipMethod = '9'
    and sOrderStatus = 'Shipped'
    and dtOrderDate between '01/01/2011' and '12/31/2011' -->= '01/01/12'  
    and C.ixCustomerType = '1'
   -- and mShipping between .01 and 7.98
   -- and mMerchandise >= 125
   --  and mShipping > 0
group by    sPromoApplied, 
(Case when mMerchandise < 125 then 'LT125'
        else 'GT125'
        end
        )
order by MerchAmount, sPromoApplied   
    
    

/*  Eligible orders 
    that had no Promo Applied
    and received free shipping
*/

select   count(ixOrder) OrdersEligible, 
         avg(mShipping) AvgShipping, 
         avg(mMerchandise) AvgMerch                
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where iShipMethod = '9'
    and sOrderStatus = 'Shipped'
    and dtOrderDate between '01/01/2011' and '12/31/2011' -->= '01/01/12'
   and mShipping = 0 
   and mMerchandise >= 125
   and sPromoApplied is NULL
    and C.ixCustomerType = '1'   
 


/*  Eligible orders 
    that had no Promo Applied
    and did NOT receive free shipping 
    and paid less than $7.99 for shipping 
*/

select   count(ixOrder) OrdersEligible, 
         avg(mShipping) AvgShipping, 
         avg(mMerchandise) AvgMerch 
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where iShipMethod = '9'
    and sOrderStatus = 'Shipped'
    and dtOrderDate between '01/01/2011' and '12/31/2011' -->= '01/01/12'
   and mShipping between .01 and 7.98
   and mMerchandise >= 125
   and sPromoApplied is NULL 
     and C.ixCustomerType = '1'   
   
 






             
             
             