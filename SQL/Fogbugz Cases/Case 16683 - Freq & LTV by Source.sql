-- Case 16683 - Freq & LTV by Source 

/*
    1. verify with Philip that the current groups 
       listed in the Case statements are the ones
       he wants to use AND that there are no new source codes to add.
       
       Also verify the order he wants them to display in
       (consider adding a sort field based on CustSource
        to make it easier to dump the results straight into
        the spreadsheet)
         
    2. run on DW1
    
    3. Globally replace the hardcoded dtAccountCreateDate value 
        with today's date mines 3 years
        
    4. Copy the Old values lower into the new spreadsheet so that
        you can visually check to see if the groups and rates appear
        to be consistant in the new batch.        
*/    

/*****************************************************
 *****   ALL New Customers                      ***** 
 *****   (from the last 36 Months)              *****
 *****************************************************/ 
select COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        COUNT(distinct O.ixOrder)   OrdCnt        
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '02/17/2010'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0
/*
CustCnt	Revenue	    OrdCnt
199,339	74,220,003	418,557 -- >= 2-18-2010
199,143	74,174,855	418,265 -- >= 2-13-2010
182,085	69,715,618	393,568 -- >= 4-9-2009
183,486	70,238,852	396,628 -- >= 4-23-2009
*/

338801

/*****************************************************
 *****   TOTAL UNIVERSE (1+ Orders)             *****
 *****   by Cust source                         ***** 
 *****************************************************/
select (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801') then 'Rod Runs'              
              when C.ixSourceCode in ('CCR', 'CCSM', 'CCSR', 'CCTB') then 'Catalogs.com'
              else 'Other'
        End)                        CustSource,
        COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        COUNT(distinct O.ixOrder)   OrdCnt
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
where C.dtAccountCreateDate >= '02/17/2010'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0    
group by (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801') then 'Rod Runs'              
              when C.ixSourceCode in ('CCR', 'CCSM', 'CCSR', 'CCTB') then 'Catalogs.com'
              else 'Other'
        End) 
order by CustSource       
                
      
      
/*****************************************************    
 *****   REPEAT CUSTOMERS (2+ Orders)           *****
 *****   by Cust source                         *****
  *****************************************************/
select (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801') then 'Rod Runs'              
              when C.ixSourceCode in ('CCR', 'CCSM', 'CCSR', 'CCTB') then 'Catalogs.com'
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
          where O.dtShippedDate >=  '02/17/2010'
            and O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 
          group by ixCustomer
          having COUNT(ixOrder) > 1) RC on RC.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '02/17/2010'
    and C.flgDeletedFromSOP = 0
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
group by (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801') then 'Rod Runs'              
              when C.ixSourceCode in ('CCR', 'CCSM', 'CCSR', 'CCTB') then 'Catalogs.com'
              else 'Other'
        End)         
order by CustSource       
     

select * from tblSourceCode where ixSourceCode = '338801'        
        
        
/*****************************************************        
 *****   ADVOCATE CUSTOMERS (3+ orders)         *****
 *****   by customer source                     *****
 *****************************************************/ 
select (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801') then 'Rod Runs'              
              when C.ixSourceCode in ('CCR', 'CCSM', 'CCSR', 'CCTB') then 'Catalogs.com'
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
          where O.dtShippedDate >=  '02/17/2010'
            and O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 
          group by ixCustomer
          having COUNT(ixOrder) > 2) RC on RC.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '02/17/2010'
    and C.flgDeletedFromSOP = 0
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 2 
group by (Case when C.ixSourceCode = 'EBAY' then 'eBay'
              when SC.sSourceCodeType like 'WEB%' then 'Web' 
              when C.ixSourceCode in ('33842','33843','31743','31744') then 'Good Guys'
              when C.ixSourceCode = '31536' then 'IMCA'
              when C.ixSourceCode = '31537' then 'Wissota' 
              when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801') then 'Rod Runs'              
              when C.ixSourceCode in ('CCR', 'CCSM', 'CCSR', 'CCTB') then 'Catalogs.com'
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
where O.dtShippedDate >= '02/17/2010'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0        

/*
CustCnt	Revenue	        OrdCnt
367036	235685974.85	1199362
334843	215006970.75	1099220
*/
    
    
    
select SUM(mMerchandise), 
COUNT(distinct O.ixOrder) 
from tblOrder O
where O.dtShippedDate >= '02/17/2010'
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
where C.dtAccountCreateDate >= '02/17/2010'  
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
where C.dtAccountCreateDate >= '02/13/2012'  
    and C.flgDeletedFromSOP = 0
group by SC.sSourceCodeType, SCT.sDescription 
--having  COUNT(C.ixCustomer) > 100 -- just showing the most common Source Codes
order by COUNT(C.ixCustomer) desc -- ixSourceCode

       
    
