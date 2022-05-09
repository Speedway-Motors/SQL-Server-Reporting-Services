/*DAILY*/

SELECT OC.OrdChan,
	   TY.DAILY_NumOrds TY_Daily_NumOrds,
	   TY.DAILY_Sales   TY_Daily_Sales,
	   LY.DAILY_NumOrds LY_Daily_NumOrds,
	   LY.DAILY_Sales   LY_Daily_Sales
FROM
	(select distinct
		(case
			when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Web'
			when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Counter'
		--	when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Ebay'
			when CUST.sCustomerType in ('MRR','PRS') then 'Wholesale'
			else 'Catalog'
		 end) OrdChan
	  from	  tblOrder O
			  left join tblCustomer CUST on O.ixCustomer = CUST.ixCustomer) OC
LEFT JOIN 		  	   
		(select
			(case
				when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Web'
				when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Counter'
				--when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Ebay'
				when CUST.sCustomerType in ('MRR','PRS') then 'Wholesale'
				else 'Catalog'
			 end) OrdChan,
			  sum(case when O.flgIsBackorder = '1' THEN 0 ELSE 1 END) DAILY_NumOrds,
			  sum(O.mMerchandise) DAILY_Sales
		from
			  tblOrder O
			  left join tblDate D on O.ixOrderDate = D.ixDate
			  left join tblCustomer CUST on O.ixCustomer = CUST.ixCustomer            
		where 
			  D.dtDate in (@Date)-- INPUT DATE PARAMETER
			  and
			  O.sOrderChannel not in ('INTERNAL','AUCTION') -- exclude EBAY from daily view
		group by
			(case
				when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Web'
				when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Counter'
				--when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Ebay'
				when CUST.sCustomerType in ('MRR','PRS') then 'Wholesale'
				else 'Catalog'
			 end)) TY
ON OC.OrdChan = TY.OrdChan		 
LEFT JOIN 		  	   
		(select
			(case
				when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Web'
				when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Counter'
				--when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Ebay'
				when CUST.sCustomerType in ('MRR','PRS') then 'Wholesale'
				else 'Catalog'
			 end) OrdChan,
			  sum(case when O.flgIsBackorder = '1' THEN 0 ELSE 1 END) DAILY_NumOrds,
			  sum(O.mMerchandise) DAILY_Sales
		from
			  tblOrder O
			  left join tblDate D on O.ixOrderDate = D.ixDate
			  left join tblCustomer CUST on O.ixCustomer = CUST.ixCustomer            
		where 
			  D.dtDate in (dbo.PrevYrsEquivDate(@Date,1)) -- equivalent day of previous year  
			  and
			  O.sOrderChannel not in ('INTERNAL','AUCTION') -- exclude EBAY from daily view
		group by
			(case
				when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Web'
				when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Counter'
				--when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Ebay'
				when CUST.sCustomerType in ('MRR','PRS') then 'Wholesale'
				else 'Catalog'
			 end)) LY
ON OC.OrdChan = LY.OrdChan	