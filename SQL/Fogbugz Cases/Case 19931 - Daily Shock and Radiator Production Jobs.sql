SELECT O.ixOrder 
     , O.ixCustomer 
     , O.dtOrderDate 
     , T.chTime 
     , O.sOrderTaker 
     , OL.ixSKU 
     , OL.iQuantity
     , SL.iQAV
     , SL.iQC --quantity committed? 
     , O.dtHoldUntilDate 
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblTime T ON T.ixTime = O.ixOrderTime  
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = OL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND ixLocation = '99' 
WHERE O.dtOrderDate = '09/23/13'
  AND O.ixOrder IN (SELECT OL.ixOrder 
                  FROM tblOrderLine OL 
                  WHERE OL.dtOrderDate = '09/23/13'
                    AND OL.ixSKU = @TicketType --'SHOCKTICKET' -- 'RADIATORTICKET'
                 ) 
  AND O.sOrderStatus IN ('Shipped', 'Dropshipped', 'Open')                  
     
