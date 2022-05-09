-- SMIHD-13660 - PayPal Canada Orders
/*
Canadian Orders on the web that used PayPal w/ Order amounts over the last year. 
Requesting Order #
    Channel - Web
Order Amount
Payment Type - PayPal
Country - Canada
*/

-- ShipTo = Canada
SELECT sShipToCountry, COUNT(O.ixOrder)
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where sOrderChannel = 'WEB'
   and dtOrderDate between '04/22/2018' and '04/21/2019'
   and sMethodOfPayment = 'PAYPAL'
  -- and sShipToCountry = 'CANADA' -- 823
GROUP BY sShipToCountry

-- Cust MailTo = Canada
SELECT C.sMailToCountry, COUNT(O.ixOrder)
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where sOrderChannel = 'WEB'
   and dtOrderDate between '04/22/2018' and '04/21/2019'
   and sMethodOfPayment = 'PAYPAL'
   and sMailToCountry = 'CANADA' -- 1,350
GROUP BY sMailToCountry


SELECT ixOrder 'Order', sWebOrderID 'WebOrderID', 
    mMerchandise 'Merch', mShipping 'SH', (mCredits *-1)'Credits', 
    (mMerchandise+mShipping-mCredits) 'TotalOrderAmount',
   -- mAmountPaid 'AmountPaid', 
   mMerchandiseCost 'MerchCost'
   --sOrderChannel 'OrderChannel', sMethodOfPayment 'MoP', 
    -- mTax, mDisbursement, mDuty, mVAT, 
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where sOrderChannel = 'WEB'
   and dtOrderDate between '04/22/2018' and '04/21/2019'
   and sMethodOfPayment = 'PAYPAL'
   and sShipToCountry = 'CANADA' -- 823
   and sOrderStatus = 'Shipped'
   --and (mMerchandise+mShipping-mCredits) <> mAmountPaid
   /*and (mTax > 0
       or mDisbursement > 0
       or mDuty > 0
       or mVAT > 0
       )
    */
   -- and mCredits > 0
