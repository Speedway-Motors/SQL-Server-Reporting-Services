-- Case 21073 - Freq & LTV by Source 
--      based on SQL from case 17784
/*
    1. verify with Marketing that the current list of groups 
       and thier coorisponding SCs are accurate and that there are no new ones to add.
       
    2. run on DW1
    
    3. Globally replace the hardcoded dtAccountCreateDate value with today's date mines 3 years
        
    4. Copy the Old values lower into the new spreadsheet so that you can visually 
       compare to see if the groups and rates appear to be consistant in the new batch.        
*/    

/*****************************************************
 *****   ALL New Customers                      ***** 
 *****   (from the last 36 Months)              *****
 *****************************************************/ 
select COUNT(distinct C.ixCustomer) CustCnt,
       SUM(O.mMerchandise)         Revenue,
       SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) 'OrdCnt'
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '02/28/2011' -- globally swap
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0
    
/*
CustCnt	Revenue	    OrdCnt
216,712	80,277,896	438,759 -- >= 2-28-2011
213,013	79,808,231	440,871 -- >= 8-26-2010
199,339	74,220,003	418,557 -- >= 2-18-2010
182,085	69,715,618	393,568 -- >= 4-9-2009
183,486	70,238,852	396,628 -- >= 4-23-2009


*/



/*****************************************************
 *****   TOTAL UNIVERSE (1+ Orders)             *****
 *****   by Cust source                         ***** 
 *****************************************************/
select (Case
            when C.ixSourceCode in ('35880','347500')                           then '2012 Race Banquets'
            when C.ixSourceCode in ('337600','337601','337602')                 then '2012 Race names'
            when C.ixSourceCode in ('358500')                                   then '2013 Track Sponsorships'  
            when C.ixSourceCode in ('378500')                                   then '2014 Track Sponsorships'       
            when C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB')                 then 'Catalogs.com'            
            when C.ixSourceCode in ('35888')                                    then 'Dataline Test'             
            when C.ixSourceCode in ('34171','34172')                            then 'Datalogix Test'   
            when C.ixSourceCode = 'EBAY'                                        then 'eBay'
            when C.ixSourceCode in ('35012','35480','33842','33843','31743','31744','36180','35480','37385','36180',
                                    '35480','37385')                            then 'Good Guys'        
            when C.ixSourceCode in ('357502','349502','358518','363518','351518','360518','353518','364518','347576','343576',
                                    '346576','339542','335542','334542','324542','318512','325512','332512','346574','355519',
                                    '361519','383519' )                         then 'ILSS'     
            when C.ixSourceCode in ('37881','35884','31536')                    then 'IMCA'
            when C.ixSourceCode in ('338520','335520','36380','362520','33339','36380')             then 'POWRi'                            
            when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801')                   then 'Rod Runs'             
            when C.ixSourceCode in ('346578','343578','338528','336528','333528','324528','362503') then 'URC'  
            when C.ixSourceCode in ('37882')                                    then 'SCCA'
            when C.ixSourceCode in ('37880', '37879','35885','33771','31537')   then 'Wissota' 
            when SC.sSourceCodeType like 'WEB%'                                 then 'Web'             
            when SC.sSourceCodeType like 'CAT-E%'                               then 'Events'
          else 'Other'
        End)                        CustSource,
        COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) 'OrdCnt'
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
where C.dtAccountCreateDate >= '02/28/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0    
group by (Case
            when C.ixSourceCode in ('35880','347500')                           then '2012 Race Banquets'
            when C.ixSourceCode in ('337600','337601','337602')                 then '2012 Race names'
            when C.ixSourceCode in ('358500')                                   then '2013 Track Sponsorships'  
            when C.ixSourceCode in ('378500')                                   then '2014 Track Sponsorships'       
            when C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB')                 then 'Catalogs.com'            
            when C.ixSourceCode in ('35888')                                    then 'Dataline Test'             
            when C.ixSourceCode in ('34171','34172')                            then 'Datalogix Test'   
            when C.ixSourceCode = 'EBAY'                                        then 'eBay'
            when C.ixSourceCode in ('35012','35480','33842','33843','31743','31744','36180','35480','37385','36180',
                                    '35480','37385')                            then 'Good Guys'        
            when C.ixSourceCode in ('357502','349502','358518','363518','351518','360518','353518','364518','347576','343576',
                                    '346576','339542','335542','334542','324542','318512','325512','332512','346574','355519',
                                    '361519','383519' )                         then 'ILSS'     
            when C.ixSourceCode in ('37881','35884','31536')                    then 'IMCA'
            when C.ixSourceCode in ('338520','335520','36380','362520','33339','36380')             then 'POWRi'                            
            when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801')                   then 'Rod Runs'             
            when C.ixSourceCode in ('346578','343578','338528','336528','333528','324528','362503') then 'URC'  
            when C.ixSourceCode in ('37882')                                    then 'SCCA'
            when C.ixSourceCode in ('37880', '37879','35885','33771','31537')   then 'Wissota' 
            when SC.sSourceCodeType like 'WEB%'                                 then 'Web'             
            when SC.sSourceCodeType like 'CAT-E%'                               then 'Events'
          else 'Other'
        End)     
order by CustSource       
                

select ixSourceCode, sDescription, sSourceCodeType
from tblSourceCode
where ixSourceCode in ('337600','337601','337602') --('35880','347500',
'337600','337601','337602',
'358500',        
'CCR','CCSM','CCSR','CCTB',
'35888',      
'34171','34172',
'EBAY',
'35012','35480','33842','33843','31743',
'31744',
'360518','353518','364518','347576','343576',
'346576','339542','335542','334542','324542',
'318512','325512','332512','346574',
'35884','31536',
'338520','335520','36380','362520',
'33339',
'RR2011','RR10','RR9','RB10','RCB9',
'338801',
'346578','343578','338528','336528','333528',
'324528','362503',
'35885','33771','31537')      
order by sSourceCodeType
      
/*****************************************************    
 *****   REPEAT CUSTOMERS (2+ Orders)           *****
 *****   by Cust source                         *****
  *****************************************************/
select (Case
            when C.ixSourceCode in ('35880','347500')                           then '2012 Race Banquets'
            when C.ixSourceCode in ('337600','337601','337602')                 then '2012 Race names'
            when C.ixSourceCode in ('358500')                                   then '2013 Track Sponsorships'  
            when C.ixSourceCode in ('378500')                                   then '2014 Track Sponsorships'       
            when C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB')                 then 'Catalogs.com'            
            when C.ixSourceCode in ('35888')                                    then 'Dataline Test'             
            when C.ixSourceCode in ('34171','34172')                            then 'Datalogix Test'   
            when C.ixSourceCode = 'EBAY'                                        then 'eBay'
            when C.ixSourceCode in ('35012','35480','33842','33843','31743','31744','36180','35480','37385','36180',
                                    '35480','37385')                            then 'Good Guys'        
            when C.ixSourceCode in ('357502','349502','358518','363518','351518','360518','353518','364518','347576','343576',
                                    '346576','339542','335542','334542','324542','318512','325512','332512','346574','355519',
                                    '361519','383519' )                         then 'ILSS'     
            when C.ixSourceCode in ('37881','35884','31536')                    then 'IMCA'
            when C.ixSourceCode in ('338520','335520','36380','362520','33339','36380')             then 'POWRi'                            
            when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801')                   then 'Rod Runs'             
            when C.ixSourceCode in ('346578','343578','338528','336528','333528','324528','362503') then 'URC'  
            when C.ixSourceCode in ('37882')                                    then 'SCCA'
            when C.ixSourceCode in ('37880', '37879','35885','33771','31537')   then 'Wissota' 
            when SC.sSourceCodeType like 'WEB%'                                 then 'Web'             
            when SC.sSourceCodeType like 'CAT-E%'                               then 'Events'
          else 'Other'
        End)                          CustSource,
        COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) 'OrdCnt'
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode    
    -- Customers with 2 or more orders
    join (select O.ixCustomer, COUNT(O.ixOrder) OrdCnt
          from tblOrder O
          where O.dtShippedDate >=  '02/28/2011'
            and O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 
          group by ixCustomer
          having SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) > 1) RC on RC.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '02/28/2011'
    and C.flgDeletedFromSOP = 0
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
group by (Case
            when C.ixSourceCode in ('35880','347500')                           then '2012 Race Banquets'
            when C.ixSourceCode in ('337600','337601','337602')                 then '2012 Race names'
            when C.ixSourceCode in ('358500')                                   then '2013 Track Sponsorships'  
            when C.ixSourceCode in ('378500')                                   then '2014 Track Sponsorships'       
            when C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB')                 then 'Catalogs.com'            
            when C.ixSourceCode in ('35888')                                    then 'Dataline Test'             
            when C.ixSourceCode in ('34171','34172')                            then 'Datalogix Test'   
            when C.ixSourceCode = 'EBAY'                                        then 'eBay'
            when C.ixSourceCode in ('35012','35480','33842','33843','31743','31744','36180','35480','37385','36180',
                                    '35480','37385')                            then 'Good Guys'        
            when C.ixSourceCode in ('357502','349502','358518','363518','351518','360518','353518','364518','347576','343576',
                                    '346576','339542','335542','334542','324542','318512','325512','332512','346574','355519',
                                    '361519','383519' )                         then 'ILSS'     
            when C.ixSourceCode in ('37881','35884','31536')                    then 'IMCA'
            when C.ixSourceCode in ('338520','335520','36380','362520','33339','36380')             then 'POWRi'                            
            when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801')                   then 'Rod Runs'             
            when C.ixSourceCode in ('346578','343578','338528','336528','333528','324528','362503') then 'URC'  
            when C.ixSourceCode in ('37882')                                    then 'SCCA'
            when C.ixSourceCode in ('37880', '37879','35885','33771','31537')   then 'Wissota' 
            when SC.sSourceCodeType like 'WEB%'                                 then 'Web'             
            when SC.sSourceCodeType like 'CAT-E%'                               then 'Events'
          else 'Other'
        End)            
order by CustSource       
     

select * from tblSourceCode where ixSourceCode = '378500'        
        
        
/*****************************************************        
 *****   ADVOCATE CUSTOMERS (3+ orders)         *****
 *****   by customer source                     *****
 *****************************************************/ 
select (Case
            when C.ixSourceCode in ('35880','347500')                           then '2012 Race Banquets'
            when C.ixSourceCode in ('337600','337601','337602')                 then '2012 Race names'
            when C.ixSourceCode in ('358500')                                   then '2013 Track Sponsorships'  
            when C.ixSourceCode in ('378500')                                   then '2014 Track Sponsorships'       
            when C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB')                 then 'Catalogs.com'            
            when C.ixSourceCode in ('35888')                                    then 'Dataline Test'             
            when C.ixSourceCode in ('34171','34172')                            then 'Datalogix Test'   
            when C.ixSourceCode = 'EBAY'                                        then 'eBay'
            when C.ixSourceCode in ('35012','35480','33842','33843','31743','31744','36180','35480','37385','36180',
                                    '35480','37385')                            then 'Good Guys'        
            when C.ixSourceCode in ('357502','349502','358518','363518','351518','360518','353518','364518','347576','343576',
                                    '346576','339542','335542','334542','324542','318512','325512','332512','346574','355519',
                                    '361519','383519' )                         then 'ILSS'     
            when C.ixSourceCode in ('37881','35884','31536')                    then 'IMCA'
            when C.ixSourceCode in ('338520','335520','36380','362520','33339','36380')             then 'POWRi'                            
            when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801')                   then 'Rod Runs'             
            when C.ixSourceCode in ('346578','343578','338528','336528','333528','324528','362503') then 'URC'  
            when C.ixSourceCode in ('37882')                                    then 'SCCA'
            when C.ixSourceCode in ('37880', '37879','35885','33771','31537')   then 'Wissota' 
            when SC.sSourceCodeType like 'WEB%'                                 then 'Web'             
            when SC.sSourceCodeType like 'CAT-E%'                               then 'Events'
          else 'Other'
        End)                         CustSource,
        COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) 'OrdCnt'
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode       
    -- CUSTOMERS with 3 or more orders
    join (select O.ixCustomer, COUNT(O.ixOrder) OrdCnt
          from tblOrder O
          where O.dtShippedDate >=  '02/28/2011'
            and O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 
          group by ixCustomer
          having SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) > 2) RC on RC.ixCustomer = O.ixCustomer
where C.dtAccountCreateDate >= '02/28/2011'
    and C.flgDeletedFromSOP = 0
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 2 
group by(Case
            when C.ixSourceCode in ('35880','347500')                           then '2012 Race Banquets'
            when C.ixSourceCode in ('337600','337601','337602')                 then '2012 Race names'
            when C.ixSourceCode in ('358500')                                   then '2013 Track Sponsorships'  
            when C.ixSourceCode in ('378500')                                   then '2014 Track Sponsorships'       
            when C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB')                 then 'Catalogs.com'            
            when C.ixSourceCode in ('35888')                                    then 'Dataline Test'             
            when C.ixSourceCode in ('34171','34172')                            then 'Datalogix Test'   
            when C.ixSourceCode = 'EBAY'                                        then 'eBay'
            when C.ixSourceCode in ('35012','35480','33842','33843','31743','31744','36180','35480','37385','36180',
                                    '35480','37385')                            then 'Good Guys'        
            when C.ixSourceCode in ('357502','349502','358518','363518','351518','360518','353518','364518','347576','343576',
                                    '346576','339542','335542','334542','324542','318512','325512','332512','346574','355519',
                                    '361519','383519' )                         then 'ILSS'     
            when C.ixSourceCode in ('37881','35884','31536')                    then 'IMCA'
            when C.ixSourceCode in ('338520','335520','36380','362520','33339','36380')             then 'POWRi'                            
            when C.ixSourceCode in ('RR2011','RR10','RR9','RB10','RCB9','338801')                   then 'Rod Runs'             
            when C.ixSourceCode in ('346578','343578','338528','336528','333528','324528','362503') then 'URC'  
            when C.ixSourceCode in ('37882')                                    then 'SCCA'
            when C.ixSourceCode in ('37880', '37879','35885','33771','31537')   then 'Wissota' 
            when SC.sSourceCodeType like 'WEB%'                                 then 'Web'             
            when SC.sSourceCodeType like 'CAT-E%'                               then 'Events'
          else 'Other'
        End)     
order by CustSource       



/******************************************         
   CHECKS FOR SC's with no activity
******************************************/   
select * from tblOrder
where ixCustomer in (select ixCustomer from tblCustomer where ixSourceCode in ('378500'))
        
select * from tblSourceCode
where ixSourceCode in ('337600','337601','337602')     

select * from tblOrder
where sSourceCodeGiven in ('337600','337601','337602')   

select * from tblOrder
where sMatchbackSourceCode in ('337600','337601','337602')  
   
            

-- checks    
--info for ALL customers regardless of their create date
select COUNT(distinct C.ixCustomer) CustCnt,
        SUM(O.mMerchandise)         Revenue, -- 182,094
        SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) 'OrdCnt'
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
where O.dtShippedDate >= '02/28/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and C.flgDeletedFromSOP = 0        

/*
CustCnt	Revenue	        OrdCnt
402768	261964631.33	1283460 @ 02/28/2014
388666	251674589.82	1243220 @ 08/26/2013
367036	235685974.85	1199362
334843	215006970.75	1099220
*/
    
    
    
select SUM(mMerchandise) 'Sales', 
SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 ELSE 1 END) 'OrdCount'
from tblOrder O
where O.dtShippedDate >= '02/28/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0       
/*
Sales	    OrdCount
253,004,696	1,249,610 @9-11-13
261,967,292	1,283,470 @2-28-14
*/    
   
    
-- most used Source Codes on orders
select C.ixSourceCode, 
    SC.sSourceCodeType, 
    SCT.sDescription SCTypeDesc, 
    COUNT(C.ixCustomer) CustCnt
from tblCustomer C
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
    left join tblSourceCodeType SCT on SC.sSourceCodeType = SCT.ixSourceCodeType
where C.dtAccountCreateDate >= '02/28/2011'  
    and C.flgDeletedFromSOP = 0
group by C.ixSourceCode, SC.sSourceCodeType, SCT.sDescription 
having  COUNT(C.ixCustomer) > 100 
order by COUNT(C.ixCustomer) desc 



select * from tblSourceCodeType
/*
ixSourceCodeType	sDescription
AD-PRINT	Print Ad
CAT-E	Catalog @ Event
CAT-H	Catalog House
CAT-P	Catalog Prospect
CAT-R	Catalog Request
EMAIL-E	Email @ Event
EMAIL-H	Email House
EMAIL-P	Email Prospect
FLY-E	Flyer Email
FLY-H	Flyer House
FLY-P	Flyer Prospect
OTHER	Other
PIP-H	Package Insert
PIP-P	Package Insert Prospect
WEB-H	Web House
WEB-P	Web Prospect
*/

-- SC type of customers created in the past 12 Months
select 
    SC.sSourceCodeType 'SC Type   ', 
    SCT.sDescription 'SC Type Desc', 
    COUNT(C.ixCustomer) 'CustCnt'
from tblCustomer C
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
    left join tblSourceCodeType SCT on SC.sSourceCodeType = SCT.ixSourceCodeType
where C.dtAccountCreateDate >= '02/28/2013'  
    and C.flgDeletedFromSOP = 0
group by SC.sSourceCodeType, SCT.sDescription 
order by COUNT(C.ixCustomer) desc -- ixSourceCode

/*
SC Type	    SC Type Desc	CustCnt
=========   =============== =======
WEB-H	    Web House	    63463
OTHER	    Other	        36548
CAT-E	    Catalog @ Event	4712
AD-PRINT	Print Ad	    4096
FLY-P	    Flyer Prospect	4017
CAT-H	    Catalog House	2764
NULL	    NULL	        1106
CAT-R	    Catalog Request	1091
CAT-P	    Catalog Prospect797
WEB-P	    Web Prospect	49
PIP-H	    Package Insert	8
UNKNOWN	    NULL	        6
*/
       
    

