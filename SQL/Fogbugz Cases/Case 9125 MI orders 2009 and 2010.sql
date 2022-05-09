SELECT 
   isNULL(GS.ixCustomer,CREDITS.ixCustomer)  CustNum,
   isNULL(GS.FirstName,CREDITS.FirstName)    FirstName,
   isNULL(GS.LastName,CREDITS.LastName)      LastName,
   isNULL(GS.ixOrder,CREDITS.ixOrder)        OrderNum,
   isNULL(GS.GrossSales,0)                   GrossSales,
   isNULL(CREDITS.TotalCredited,0)           Credits,
   (isNULL(GS.GrossSales,0) - isNULL(CREDITS.TotalCredited,0)) NetSales
FROM 
			 /****** GROSS SALES *********/	
         (select 
            O.ixCustomer,        
            O.ixOrder,
            C.sCustomerFirstName FirstName,
            C.sCustomerLastName  LastName,
	         SUM(O.mMerchandise)  GrossSales
	       from tblOrder O 
            join tblCustomer C on O.ixCustomer = C.ixCustomer
	       where O.sShipToState = 'MI'
            and O.sOrderChannel <> 'INTERNAL'
            and O.sOrderStatus = 'Shipped'
            and O.dtShippedDate between '01/01/2009' and '12/31/2009' -- AFTER TESTING CHANGE TO '01/01/2007'
	       group by 
            O.ixCustomer,
            O.ixOrder,
            C.sCustomerFirstName,
            C.sCustomerLastName
			) GS
	    full outer join
			/****** RETURNS/CREDITS *********/	
			(select CMM.ixCustomer,
              CMM.ixOrder,
              C.sCustomerFirstName FirstName,
              C.sCustomerLastName LastName,
				  SUM(CMM.mMerchandise+mShipping+mTax-mRestockFee) TotalCredited
			from tblCreditMemoMaster CMM 
            join tblCustomer C on C.ixCustomer = CMM.ixCustomer
			where
				CMM.dtCreateDate between '01/01/2009' and '12/31/2009'  -- AFTER TESTING CHANGE TO '01/01/2007'
				and CMM.dtCreateDate < GETDATE()+1 
            and CMM.flgCanceled = 0
            and C.sMailToState = 'MI'
		    group by 
            CMM.ixCustomer,
            CMM.ixOrder,
            C.sCustomerFirstName,
            C.sCustomerLastName
			) CREDITS on GS.ixOrder = CREDITS.ixOrder
