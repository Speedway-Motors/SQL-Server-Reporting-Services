	
select
	isnull(Sales.iYear, MemoReturns.iYear) as 'Year',
	isnull(Sales.iPeriod, MemoReturns.iPeriod) as 'Period',
	isnull(Sales.sOrderChannel, MemoReturns.sOrderChannel) as 'Channel',
	isnull(Sales.sSourceCodeType, MemoReturns.sSourceCodeType) as 'SourceCodeType',
	isnull(Sales.ixCatalog, MemoReturns.ixCatalog) as 'Catalog',
	isnull(Sales.sOrderType, MemoReturns.sMemoType) as 'Order/Return Type',
	isnull(Sales.mMerchandise, 0) as 'Merch Revenue',
	isnull(Sales.mMerchandiseCost, 0) as 'Merch Cost',
	isnull(Sales.mCredits, 0) as 'Credits',
	isnull(Sales.mShippingBilled, 0) as 'Shipping Billed',
	isnull(Sales.Orders, 0) as 'Orders',
	isnull(MemoReturns.mMerchandise,0) as 'Return Merch Revenue',
	isnull(MemoReturns.mMerchandiseCost,0) as 'Return Merch Cost',
	isnull(MemoReturns.mShipping, 0) as 'Return Shipping',
	isnull(MemoReturns.mRestockFee, 0) as 'Return Restock Fee'
	from	
	
	(
	/* sales by orderchannel, year, period, source code type, catalog */
	(select
		sum(case when O.ixOrder like '%-%' then 0 else 1 end) as 'Orders',
		O.sOrderChannel as 'sOrderChannel',
		SCM.sSourceCodeType as 'sSourceCodeType',
		SCM.ixCatalog as 'ixCatalog',
		O.sOrderType as 'sOrderType',
		SUM(mMerchandise) as 'mMerchandise',
		sum(mMerchandiseCost) as 'mMerchandiseCost',
		sum(mShipping) as 'mShippingBilled',
		sum(mCredits) as 'mCredits',
		D.iYear as 'iYear',
		D.iPeriod as 'iPeriod'
	from
		tblDate D
		left join tblOrder O on D.ixDate = O.ixShippedDate
		left join tblSourceCode SCM on O.sMatchbackSourceCode=SCM.ixSourceCode
	where
		O.dtShippedDate >= '01/01/09' -- and O.dtShippedDate < '10/01/11'
		and  O.sOrderStatus in ('Shipped')

	group by
		O.sOrderChannel,
		SCM.sSourceCodeType,
		SCM.ixCatalog,
		O.sOrderType,
		D.iYear,
		D.iPeriod) Sales

	/* returns - by year, period, sourcecodetype, catalog and memotype */
	full join
	
		(select
			D.iYear as 'iYear',
			D.iPeriod as 'iPeriod',
			SC.sSourceCodeType as 'sSourceCodeType',
			SC.ixCatalog as 'ixCatalog',
			sum(CMM.mMerchandise) as 'mMerchandise',
			sum(CMM.mMerchandiseCost) as 'mMerchandiseCost',
			C.sCustomerType as 'sMemoType',
			isnull(CMM.sOrderChannel, 'PHONE') as 'sOrderChannel',
			sum(isnull(CMM.mShipping, 0)) as 'mShipping',
			sum(isnull(CMM.mTax, 0)) as 'mTax',
			sum(isnull(CMM.mRestockFee, 0)) as 'mRestockFee'
		from
			tblCreditMemoMaster CMM
			left join tblDate D on CMM.ixCreateDate = D.ixDate
			left join tblCustomer C on CMM.ixCustomer = C.ixCustomer
			left join tblOrder O on CMM.ixOrder = O.ixOrder
			left join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
		where
			CMM.flgCanceled = 0
			and CMM.dtCreateDate >= '01/01/2009'
		group by
			D.iYear,
			D.iPeriod,
			SC.sSourceCodeType,
			SC.ixCatalog,
			C.sCustomerType,
			CMM.sOrderChannel) MemoReturns on MemoReturns.iYear = Sales.iYear
				and MemoReturns.iPeriod = Sales.iPeriod
				and MemoReturns.sSourceCodeType = Sales.sSourceCodeType
				and MemoReturns.sMemoType = Sales.sOrderType
				and MemoReturns.sOrderChannel = Sales.sOrderChannel
				and MemoReturns.ixCatalog = Sales.ixCatalog
		) 
	

