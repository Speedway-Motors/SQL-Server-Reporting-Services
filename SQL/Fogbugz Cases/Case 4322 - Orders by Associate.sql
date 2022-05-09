SELECT O.sOrderTaker	Associate,
        ICE.QTY         Shipped,		
		XORD.QTY        Cancelled,
        PIC.QTY         Opened

FROM (select distinct sOrderTaker
		from tblOrder
		WHERE sOrderChannel = 'PHONE'
		and dtOrderDate >= '07/26/2010'
		and dtOrderDate < '07/29/2010') O
		
	left join (select sOrderTaker, count(ixOrder) QTY 
				 FROM tblOrder
				 WHERE sOrderChannel = 'PHONE'
					and dtOrderDate >= '07/26/2010'
					and dtOrderDate < '07/29/2010'
					and sOrderStatus = 'Cancelled'  
				 GROUP by sOrderTaker	
		       ) XORD on XORD.sOrderTaker = O.sOrderTaker
	left join (select sOrderTaker, count(ixOrder) QTY 
				 FROM tblOrder
				 WHERE sOrderChannel = 'PHONE'
					and dtOrderDate >= '07/26/2010'
					and dtOrderDate < '07/29/2010'
					and sOrderStatus = 'Open'  
				 GROUP by sOrderTaker	
		       ) PIC on PIC.sOrderTaker = O.sOrderTaker
	left join (select sOrderTaker, count(ixOrder) QTY 
				 FROM tblOrder
				 WHERE sOrderChannel = 'PHONE'
					and dtOrderDate >= '07/26/2010'
					and dtOrderDate < '07/29/2010'
					and sOrderStatus = 'Shipped'  
				 GROUP by sOrderTaker	
		       ) ICE on ICE.sOrderTaker = O.sOrderTaker

      		       		       		

/*				
Group by sOrderTaker, dtOrderDate
order by sOrderTaker, dtOrderDate


(4:06 PM) Al: ICE = completed and on the truck
(4:06 PM) Al: PIC = order taken but not filled
(4:06 PM) Al: XORD = cancelled order
(4:07 PM) Al: BKR = backordered



sOrderStatus = 'Backordered' then count(ixOrder) else 0 end) Backordered,
				   (case when  then count(ixOrder) else 0 end) Cancelled,
				   (case when sOrderStatus = '' then count(ixOrder) else 0 end) Opened,
				   (case when sOrderStatus = 'Shipped'
				   
				   
				   


select sOrderTaker	Associate,
       dbo.DisplayDate(dtOrderDate)		Date,
	count(ixOrder)  PhoneOrdersQTY
FROM tblOrder
WHERE sOrderChannel = 'PHONE'
  and dtOrderDate >= '07/26/2010'
  and dtOrderDate < '07/29/2010'
Group by sOrderTaker, dtOrderDate
order by sOrderTaker, dtOrderDate



*/