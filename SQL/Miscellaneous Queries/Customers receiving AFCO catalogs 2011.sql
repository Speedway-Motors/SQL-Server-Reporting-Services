/* Customers receiving all three AFCO/Dynatech Customers - 2011 */
select
	count(1) as 'Customers Receiving 307,309,310 Catalogs'
from
	tblCustomer C
	left join tblCustomerOffer CO on C.ixCustomer = CO.ixCustomer
	left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where
	SC.ixCatalog = '307'
	and	
		C.ixCustomer in (
			select
				C1.ixCustomer
			from
				tblCustomer C1
					left join tblCustomerOffer CO1 on C1.ixCustomer = CO1.ixCustomer
					left join tblSourceCode SC1 on CO1.ixSourceCode = SC1.ixSourceCode
			where
				SC1.ixCatalog = '309'
				and
					C1.ixCustomer in (
						select
							C2.ixCustomer
						from
							tblCustomer C2
							left join tblCustomerOffer CO2 on C2.ixCustomer = CO2.ixCustomer
							left join tblSourceCode SC2 on CO2.ixSourceCode = SC2.ixSourceCode
						where
							SC2.ixCatalog = '310'
				)
					)