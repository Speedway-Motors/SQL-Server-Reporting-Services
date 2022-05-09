/*All Channels Combined*/
select
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
    count(distinct(tblOrder.ixCustomer)) as '# Customers',
    count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'	  
from
	tblOrder
    left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where
	/*Benchmark*/
    --(tblOrder.dtOrderDate >= '01/01/10' and tblOrder.dtOrderDate <= '12/31/10')
    /*YTD 12mo Buyers*/
    (tblOrder.dtOrderDate >= '07/01/10' and tblOrder.dtOrderDate <= '06/30/11')
    /*YTD Buyers*/
--    (tblOrder.dtOrderDate >= '01/01/11' and tblOrder.dtOrderDate <= '06/30/11')
	and 
	tblOrder.sOrderStatus = 'Shipped'
    and
    tblOrder.sOrderChannel <> 'INTERNAL'
	and
	tblOrder.sMatchbackSourceCode <> 'INTERNAL'
    and
    tblOrder.mMerchandise > 1
  



/*Catalog & Web Combined*/
select
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
    count(distinct(tblOrder.ixCustomer)) as '# Customers',
    count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'	  
from
	tblOrder
    left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where
    /*YTD 12mo Buyers*/
    (tblOrder.dtOrderDate >= '07/01/10' and tblOrder.dtOrderDate <= '06/30/11')
    /*YTD Buyers*/
    --(tblOrder.dtOrderDate >= '01/01/11' and tblOrder.dtOrderDate <= '06/30/11')
	and 
	tblOrder.sOrderStatus = 'Shipped'
	and
	tblCustomer.sCustomerType not in ('MRR','PRS')
    and
    tblOrder.sOrderChannel not in ('INTERNAL','COUNTER')
	and
	tblOrder.sMatchbackSourceCode not in ('INTERNAL','CTR')
    and
    tblOrder.mMerchandise > 1
  
    
/*Catalog Only*/
select
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
    count(distinct(tblOrder.ixCustomer)) as '# Customers',
    count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'	  
from
	tblOrder
    left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where
    /*YTD 12mo Buyers*/
    (tblOrder.dtOrderDate >= '07/01/10' and tblOrder.dtOrderDate <= '06/30/11')
    /*YTD Buyers*/
    --(tblOrder.dtOrderDate >= '01/01/11' and tblOrder.dtOrderDate <= '06/30/11')
	and 
	tblOrder.sOrderStatus = 'Shipped'
	and
	tblCustomer.sCustomerType not in ('MRR','PRS')
    and
    tblOrder.sOrderChannel not in ('INTERNAL','COUNTER','WEB','EBAY','AUCTION')
	and
	tblOrder.sMatchbackSourceCode not in ('INTERNAL','CTR')
    and
    tblOrder.mMerchandise > 1    
 

/*Web Only*/
select
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
    count(distinct(tblOrder.ixCustomer)) as '# Customers',
    count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'	  
from
	tblOrder
    left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where
    /*YTD 12mo Buyers*/
    (tblOrder.dtOrderDate >= '07/01/10' and tblOrder.dtOrderDate <= '06/30/11')
    /*YTD Buyers*/
    --(tblOrder.dtOrderDate >= '01/01/11' and tblOrder.dtOrderDate <= '06/30/11')
	and 
	tblOrder.sOrderStatus = 'Shipped'
	and
	tblCustomer.sCustomerType not in ('MRR','PRS')
    and
    tblOrder.sOrderChannel in ('WEB','AUCTION','EBAY')
	and
	tblOrder.sMatchbackSourceCode not in ('INTERNAL','CTR')
    and
    tblOrder.mMerchandise > 1    
  

/*Counter Only*/  
select
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
    count(distinct(tblOrder.ixCustomer)) as '# Customers',
    count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'	  
from
	tblOrder
    left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where
    /*YTD 12mo Buyers*/
    (tblOrder.dtOrderDate >= '07/01/10' and tblOrder.dtOrderDate <= '06/30/11')
    /*YTD Buyers*/
    --(tblOrder.dtOrderDate >= '01/01/11' and tblOrder.dtOrderDate <= '06/30/11')
	and 
	tblOrder.sOrderStatus = 'Shipped'
	and
	tblCustomer.sCustomerType not in ('MRR','PRS')
    and
    tblOrder.sOrderChannel = 'COUNTER'
	and
	tblOrder.sMatchbackSourceCode <> 'INTERNAL'
    and
    tblOrder.mMerchandise > 1    
   
   
/*Wholesale Only*/  
select
	tblCustomer.sCustomerType,
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
    count(distinct(tblOrder.ixCustomer)) as '# Customers',
    count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'	  
from
	tblOrder
    left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where
    /*YTD 12mo Buyers*/
    (tblOrder.dtOrderDate >= '07/01/10' and tblOrder.dtOrderDate <= '06/30/11')
    /*YTD Buyers*/
    --(tblOrder.dtOrderDate >= '01/01/11' and tblOrder.dtOrderDate <= '06/30/11')
	and 
	tblOrder.sOrderStatus = 'Shipped'
	and
	tblCustomer.sCustomerType in ('MRR','PRS')
	and
	tblOrder.sMatchbackSourceCode <> 'INTERNAL'
    and
    tblOrder.mMerchandise > 1   
group by
	tblCustomer.sCustomerType     
      