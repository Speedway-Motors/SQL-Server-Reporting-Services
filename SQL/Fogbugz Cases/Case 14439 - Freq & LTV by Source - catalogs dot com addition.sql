/*****************************************************
 *****   ALL New Customers                      ***** 
 *****   (from the last 36 Months)              *****
 *****************************************************/ 
select COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        COUNT(distinct O.ixOrder)   OrdCnt        
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '06/19/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0
/*
CustCnt	Revenue	    OrdCnt
182,085	69,715,618	393,568 -- >= 4-9-2009
183,486	70,238,852	396,628 -- >= 4-23-2009
*/



-- VERIFY SC's being added match the description
select * from tblSourceCode
where ixSourceCode in ('CCTB','CCR','CCSM','CCSR')

select * from tblSourceCode
where sDescription like 'Cat.com%'


/*****************************************************
 *****   TOTAL UNIVERSE (1+ Orders)             *****
 *****   by Cust source                         ***** 
 *****************************************************/
select (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9') then 'Rod Runs' 
              when C.ixSourceCode in ('CCTB','CCR','CCSM','CCSR') then 'Catalogs.com'               
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              else 'Other'
        End)                        CustSource,
        COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        COUNT(distinct O.ixOrder)   OrdCnt
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
where C.dtAccountCreateDate >= '04/23/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0    
group by (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9') then 'Rod Runs' 
              when C.ixSourceCode in ('CCTB','CCR','CCSM','CCSR') then 'Catalogs.com'               
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              else 'Other'
        End) 
order by CustSource       
                
      
      
/*****************************************************    
 *****   REPEAT CUSTOMERS (2+ Orders)           *****
 *****   by Cust source                         *****
  *****************************************************/
select (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9') then 'Rod Runs' 
              when C.ixSourceCode in ('CCTB','CCR','CCSM','CCSR') then 'Catalogs.com'               
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              else 'Other'
        End)                        CustSource,
        COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        COUNT(distinct O.ixOrder)   OrdCnt
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode    
    -- Customers with 2 or more orders
    join (select O.ixCustomer, COUNT(O.ixOrder) OrdCnt
          from tblOrder O
          where O.dtShippedDate >=  '04/23/2009'
            and O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 
          group by ixCustomer
          having COUNT(ixOrder) > 1) RC on RC.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '04/23/2009'
    and C.flgDeletedFromSOP = 0
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
group by (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9') then 'Rod Runs' 
              when C.ixSourceCode in ('CCTB','CCR','CCSM','CCSR') then 'Catalogs.com'               
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              else 'Other'
        End)         
order by CustSource       
        
        
        
/*****************************************************        
 *****   ADVOCATE CUSTOMERS (3+ orders)         *****
 *****   by customer source                     *****
 *****************************************************/ 
select (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9') then 'Rod Runs' 
              when C.ixSourceCode in ('CCTB','CCR','CCSM','CCSR') then 'Catalogs.com'               
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              else 'Other'
        End)                        CustSource,
        COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        COUNT(distinct O.ixOrder)   OrdCnt
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode       
    -- CUSTOMERS with 3 or more orders
    join (select O.ixCustomer, COUNT(O.ixOrder) OrdCnt
          from tblOrder O
          where O.dtShippedDate >=  '04/23/2009'
            and O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 
          group by ixCustomer
          having COUNT(ixOrder) > 2) RC on RC.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '04/23/2009'
    and C.flgDeletedFromSOP = 0
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 2 
group by (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9') then 'Rod Runs' 
              when C.ixSourceCode in ('CCTB','CCR','CCSM','CCSR') then 'Catalogs.com'               
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              else 'Other'
        End)     
order by CustSource       
        
        
        
            

-- checks    
--info for ALL customers regardless of their create date
select COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        COUNT(distinct O.ixOrder)   OrdCnt
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
where O.dtShippedDate >= '04/23/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0        

/*
CustCnt	Revenue	        OrdCnt
334843	215006970.75	1099220
*/
    
    
    
select SUM(mMerchandise), 
COUNT(distinct O.ixOrder) 
from tblOrder O
where O.dtShippedDate >= '04/23/2009'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0       
    
    

select C.ixSourceCode, 
    SC.sSourceCodeType, 
    SCT.sDescription SCTypeDesc, 
    COUNT(C.ixCustomer) CustCnt
from tblCustomer C
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
    left join tblSourceCodeType SCT on SC.sSourceCodeType = SCT.ixSourceCodeType
where C.dtAccountCreateDate >= '04/23/2009'  
    and C.flgDeletedFromSOP = 0
group by C.ixSourceCode, SC.sSourceCodeType, SCT.sDescription 
having  COUNT(C.ixCustomer) > 100 -- just showing the most common Source Codes
order by COUNT(C.ixCustomer) desc -- ixSourceCode


select * from tblSourceCode where ixSourceCode like 'W%'

select * from tblSourceCodeType


select 
    SC.sSourceCodeType, 
    SCT.sDescription SCTypeDesc, 
    COUNT(C.ixCustomer) CustCnt
from tblCustomer C
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
    left join tblSourceCodeType SCT on SC.sSourceCodeType = SCT.ixSourceCodeType
where C.dtAccountCreateDate >= '01/11/2012'  
    and C.flgDeletedFromSOP = 0
group by SC.sSourceCodeType, SCT.sDescription 
--having  COUNT(C.ixCustomer) > 100 -- just showing the most common Source Codes
order by COUNT(C.ixCustomer) desc -- ixSourceCode

       
    
