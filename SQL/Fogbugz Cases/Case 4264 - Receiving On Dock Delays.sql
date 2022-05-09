SELECT R.ixReceiver,
			--	O.sOrderStatus,POM.flgOpen,POM.flgIssued,
			--	POD.iQuantityPosted,POD.iQuantity,(POD.iQuantityPosted - POD.iQuantity) dif, SKU.iQAV,
			   min(case when SKU.iQAV < 0 then 1
					 when SKU.iQAV = 0  then 2
					 else 3
			    end) sortpriority,
			   (case when SKU.iQAV < 0 then 'Hot'
					 when SKU.iQAV = 0  then 'Warm'
					 else 'Cold'
			    end) priority			    
FROM tblReceiver R 
	left join tblPODetail POD on POD.ixPO = R.ixPO
	left join tblPOMaster POM on POM.ixPO = POD.ixPO
	left join tblOrderLine OL on OL.ixSKU = POD.ixSKU
	left join tblOrder O on O.ixOrder = OL.ixOrder
	left join tblSKU SKU on SKU.ixSKU = POD.ixSKU
WHERE R.flgStatus = 'Open'
 and OL.flgLineStatus = 'Backordered'
 and POM.flgOpen = '1'
 and POM.flgIssued = '1'
GROUP BY  R.ixReceiver,
		(case when SKU.iQAV < 0 then 'Hot'
					 when SKU.iQAV = 0  then 'Warm'
					 else 'Cold'
			    end)
			    
/*			    
ORDER BY R.ixReceiver,
(case when SKU.iQAV < 0 then 1
					 when SKU.iQAV = 0  then 2
					 else 3
			    end),
			   (case when SKU.iQAV < 0 then 'Hot'
					 when SKU.iQAV = 0  then 'Warm'
					 else 'Cold'
			    end)	
						    
select * from tblReceiver
where ixReceiver in 	('79367','80102','80210','80234','80236','80242')				    

select * from tblPODetail where ixPO in ('66304','B0057','66430','65665-1','66430','66430')
select * from tblPOMaster where ixPO in ('66304','B0057','66430','65665-1','66430','66430')

*/

						    
						    
						    
						    
						    
						    
						    
						    
						    
						    
						    
						    
		    