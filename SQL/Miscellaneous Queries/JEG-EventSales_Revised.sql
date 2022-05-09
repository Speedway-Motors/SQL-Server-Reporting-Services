select       
      tblOrder.sMatchbackSourceCode,
      tblOrder.sPromoApplied,
      count(distinct vwNewCustOrder.ixOrder) as '# New Custs',
      count(distinct tblOrder.ixCustomer) as '# Customers',
      sum(tblOrder.mMerchandise) as 'Merch Total',
      sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
      sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
	  sum(tblOrder.mPromoDiscount) as 'Promo Discount'
from tblOrder       
      left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where      
     (tblOrder.dtOrderDate >= '01/01/10' and tblOrder.dtOrderDate <= '09/18/11')
	 and 
     tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
     and
     (tblOrder.sMatchbackSourceCode in (
	  /*street source codes*/
	  '317LMS','314LMS','312LMS','304LMS','317HRR','314HRR','311HRR','317WW','314WW',
	  '311WW',
	  '317SSRN','312SSRN','314SSRN','305SSRN',
	  '317WSRN','312WSRN','314WSRN','305WSRN',
      '317SRNS','312SRNS','314SRNS','305SRNS',
	  '318WCK',
	  '318GG33','312GG33','314GG33','305GG33','310GG33',
	  '318NSRA','312NSRA','314NSRA','305NSRA','310NSRA',
      '318RR','318DRAGS','315DRAGS',
	  '318HRN','314HRN','312HRN','305HRN',
      '318GG34','314GG34','312GG34','305GG34','318STR',
	  '318B50','314B50','312B50','305B50',
      '305TBN','318TBN','314TBN','318RSRN','314RSRN','312RSRN','305RSRN', '318GG35','314GG35','312GG35','305GG35', 
	  '318GG36','314GG36','312GG36','305GG36',
	  '318GD','318KCN','314KCN','304KCN','318SN','314SN','312SN','305SN','318CCSN','314CCSN','312CCSN','305CCSN',
	  '319SRN','316SRN','312SRN','305SRN',
	  '319GG37','316GG37','313GG37','305GG37','319GG38','316GG38','313GG38','305GG38','319GG39','316GG39','313GG39','305GG39',
	  '319GG40','316GG40','313GG40','305GG40','319SP',
	  '32020','32021',

	  /*race source codes*/
	  '311CB','314CB','294CB','311CB2','304CB','290CB','311WR','314WR',
      '312PWR','318PWR','316PWR','313HH','318HH','316HH','314KART',
	  '313KN360','319KN360','316KN360','307KN360','313KN410','319KN410','316KN410','307KN410',
	  '316001','319001','322001','307001',
      '316BSN','319BSN','313BSN','316002','316W100','319W100'
      )
	  OR
     tblOrder.sPromoApplied in ('1546C','1546CH','RM0311','WOW0311',
       'NSRA415','NSRA429','NSRA56','GG52011','NSRA527','GG6311','GG6311H','BT50617','BT50617H','NTBA11','NTBA11H',
	   'NSRA624','NSRA624H','GG7111','GG7111H','GG7811','GG7811H','CNK714','CNK714H','SYNAT11','SYNAT11H','CCNAT11','CCNAT11H',
	   'SN2011','CC2011','NSRA84','NSRA84H','GG81211','GG81211H','GG819HH','GG81911H','GG82611','GG82611H','GG9211','GG9211H',
	   'SCCA2011','SCCA2011H','SP2011','SP2011H','GG91611','GG91611H','IMCA9511','IMCA9511H','WIS91411','WIS91411H'
       ))
group by
      tblOrder.sMatchbackSourceCode,
      tblOrder.sPromoApplied


