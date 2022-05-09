/* STEP 1 */ truncate table PJC_CustomerOrderHistory   -- Drop table PJC_CustomerOrderHistory

/* STEP 2 - ADD THE NEXT YEAR IF NEEDED 
            and POPULATE THE TABLE
            about 10 mins runtime */
insert into PJC_CustomerOrderHistory    
select C.ixCustomer, FO.FirstOrder,
    isnull([2000].[2000Merch],0)    [2000Merch],    isnull([2000].[2000OrdCount],0) [2000OrdCount],
    isnull([2001].[2001Merch],0)    [2001Merch],    isnull([2001].[2001OrdCount],0) [2001OrdCount],
    isnull([2002].[2002Merch],0)    [2002Merch],    isnull([2002].[2002OrdCount],0) [2002OrdCount],
    isnull([2003].[2003Merch],0)    [2003Merch],    isnull([2003].[2003OrdCount],0) [2003OrdCount],
    isnull([2004].[2004Merch],0)    [2004Merch],    isnull([2004].[2004OrdCount],0) [2004OrdCount],
    isnull([2005].[2005Merch],0)    [2005Merch],    isnull([2005].[2005OrdCount],0) [2005OrdCount],
    isnull([2006].[2006Merch],0)    [2006Merch],    isnull([2006].[2006OrdCount],0) [2006OrdCount],
    isnull([2007].[2007Merch],0)    [2007Merch],    isnull([2007].[2007OrdCount],0) [2007OrdCount],
    isnull([2008].[2008Merch],0)    [2008Merch],    isnull([2008].[2008OrdCount],0) [2008OrdCount],
    isnull([2009].[2009Merch],0)    [2009Merch],    isnull([2009].[2009OrdCount],0) [2009OrdCount],
    isnull( [2010].[2010Merch],0)   [2010Merch],    isnull([2010].[2010OrdCount],0) [2010OrdCount],
    isnull([2011].[2011Merch],0)    [2011Merch],    isnull([2011].[2011OrdCount],0) [2011OrdCount],
    --isnull([2012].[2012Merch],0)  [2012Merch],    isnull([2003].[2003OrdCount],0) [2003OrdCount],
    (isnull([2000].[2000Merch],0)+isnull([2001].[2001Merch],0)+isnull([2002].[2002Merch],0)+isnull([2003].[2003Merch],0)+ isnull([2004].[2004Merch],0)+isnull([2005].[2005Merch],0)+isnull([2006].[2006Merch],0)+isnull([2007].[2007Merch],0)+isnull([2008].[2008Merch],0)+isnull([2009].[2009Merch],0)+isnull([2010].[2010Merch],0)+isnull([2011].[2011Merch],0)) [TotMerch],
    (isnull([2000].[2000OrdCount],0)+isnull([2001].[2001OrdCount],0)+isnull([2002].[2002OrdCount],0)+isnull([2003].[2003OrdCount],0)+isnull([2004].[2004OrdCount],0)+isnull([2005].[2005OrdCount],0)+isnull([2006].[2006OrdCount],0)+isnull([2007].[2007OrdCount],0)+isnull([2008].[2008OrdCount],0)+isnull([2009].[2009OrdCount],0)+ isnull([2010].[2010OrdCount],0)+isnull([2011].[2011OrdCount],0)) [TotOrdCount]    
--into PJC_CustomerOrderHistory       
    FROM tblCustomer C
    left join (select ixCustomer,
                min(datepart("yyyy",dtOrderDate)) [FirstOrder]
                 from vwOrderAllHistory
               where sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer) FO on FO.ixCustomer = C.ixCustomer
    -- 2000
    left join (select ixCustomer,
                sum(mMerchandise) [2000Merch],
                --case backorder 0 else 1
                sum(case when ixOrder like '%-%' then 0 else 1 end) [2000OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2000' and '12/31/2000'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
          
                ) [2000] on [2000].ixCustomer = C.ixCustomer    
    -- 2001
    left join (select ixCustomer,
                sum(mMerchandise) [2001Merch],
                --case backorder 0 else 1
                sum(case when ixOrder like '%-%' then 0 else 1 end) [2001OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2001' and '12/31/2001'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
          
                ) [2001] on [2001].ixCustomer = C.ixCustomer                     
    -- 2002
    left join (select ixCustomer,
                sum(mMerchandise) [2002Merch],
                --case backorder 0 else 1
                sum(case when ixOrder like '%-%' then 0 else 1 end) [2002OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2002' and '12/31/2002'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
          
                ) [2002] on [2002].ixCustomer = C.ixCustomer               
    -- 2003
    left join (select ixCustomer,
                sum(mMerchandise) [2003Merch],
                --case backorder 0 else 1
                sum(case when ixOrder like '%-%' then 0 else 1 end) [2003OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2003' and '12/31/2003'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
          
                ) [2003] on [2003].ixCustomer = C.ixCustomer
    -- 2004
    left join (select ixCustomer,
                sum(mMerchandise) [2004Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2004OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2004' and '12/31/2004'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2004] on [2004].ixCustomer = C.ixCustomer
    -- 2005
    left join (select ixCustomer,
                sum(mMerchandise) [2005Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2005OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2005' and '12/31/2005'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2005] on [2005].ixCustomer = C.ixCustomer
    -- 2006
    left join (select ixCustomer,
                sum(mMerchandise) [2006Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2006OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2006' and '12/31/2006'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2006] on [2006].ixCustomer = C.ixCustomer
    -- 2007
    left join (select ixCustomer,
                sum(mMerchandise) [2007Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2007OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtOrderDate between '01/01/2007' and '12/31/2007'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2007] on [2007].ixCustomer = C.ixCustomer
    -- 2008
    left join (select ixCustomer,
                sum(mMerchandise) [2008Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2008OrdCount]    
               from tblOrder
               where dtOrderDate between '01/01/2008' and '12/31/2008'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2008] on [2008].ixCustomer = C.ixCustomer   
            
    -- 2009
    left join (select ixCustomer,
                sum(mMerchandise) [2009Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2009OrdCount]    
               from tblOrder
               where dtOrderDate between '01/01/2009' and '12/31/2009'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2009] on [2009].ixCustomer = C.ixCustomer
    -- 2010
    left join (select ixCustomer,
                sum(mMerchandise) [2010Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2010OrdCount]    
               from tblOrder
               where dtOrderDate between '01/01/2010' and '12/31/2010'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2010] on [2010].ixCustomer = C.ixCustomer
    -- 2011
    left join (select ixCustomer,
                sum(mMerchandise) [2011Merch],
                sum(case when ixOrder like '%-%' then 0 else 1 end)     [2011OrdCount]    
               from tblOrder
               where dtOrderDate between '01/01/2011' and '12/31/2011'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
               group by ixCustomer 
                ) [2011] on [2011].ixCustomer = C.ixCustomer
    -- 2012
    --left join (select ixCustomer,
    --            sum(mMerchandise) [2012Merch],
    --            sum(case when ixOrder like '%-%' then 0 else 1 end)     [2012OrdCount]    
    --           from tblOrder
    --           where dtOrderDate between '01/01/2012' and '12/31/2012'
    --             and sOrderStatus = 'Shipped'
    --             and sOrderType <> 'Internal'
    --             and sOrderChannel <> 'INTERNAL'
    --             and mMerchandise > 0                 
    --           group by ixCustomer 
    --            ) [2012] on [2012].ixCustomer = C.ixCustomer               





/* STEP 3 - Extract the results & populate spreadsheet */

/**** 2011 NAME FLOW ****/
SELECT
    '2011 NAME FLOW',
    --12 Month buyers on 1/1/2011
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [2010OrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [2010OrdCount] > 0 
     and [2011OrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = 2011
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [2011OrdCount] > 0 
    and [2010OrdCount] = 0 
    and ([2009OrdCount] > 0 
          or [2008OrdCount] > 0
          or [2007OrdCount] > 0
          or [2006OrdCount] > 0
          or [2005OrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers]

GO

/**** 2010 NAME FLOW ****/
SELECT
    '2010 NAME FLOW',
    --12 Month buyers on 1/1/2010
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [2009OrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [2009OrdCount] > 0 
     and [2010OrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = 2010
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [2010OrdCount] > 0 
    and [2009OrdCount] = 0 
    and ([2008OrdCount] > 0 
          or [2007OrdCount] > 0
          or [2006OrdCount] > 0
          or [2005OrdCount] > 0
          or [2004OrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers]     

GO

/**** 2009 NAME FLOW ****/
SELECT
    '2009 NAME FLOW',
    --12 Month buyers on 1/1/2009
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [2008OrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [2008OrdCount] > 0 
     and [2009OrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = 2009
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [2009OrdCount] > 0 
    and [2008OrdCount] = 0 
    and ([2007OrdCount] > 0 
          or [2006OrdCount] > 0
          or [2005OrdCount] > 0
          or [2004OrdCount] > 0
          or [2003OrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers]    
 
 GO    
     
/**** 2008 NAME FLOW ****/
SELECT
    '2008 NAME FLOW',
    --12 Month buyers on 1/1/2008
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [2007OrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [2007OrdCount] > 0 
     and [2008OrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = 2008
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [2008OrdCount] > 0 
    and [2007OrdCount] = 0 
    and ([2006OrdCount] > 0 
          or [2005OrdCount] > 0
          or [2004OrdCount] > 0
          or [2003OrdCount] > 0
          or [2002OrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers]      
     
 GO
     
/**** 2007 NAME FLOW ****/
SELECT
    '2007 NAME FLOW',
    --12 Month buyers on 1/1/2007
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [2006OrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [2006OrdCount] > 0 
     and [2007OrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = 2007
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [2007OrdCount] > 0 
    and [2006OrdCount] = 0 
    and ([2005OrdCount] > 0 
          or [2004OrdCount] > 0
          or [2003OrdCount] > 0
          or [2002OrdCount] > 0
          or [2001OrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers]          
     
     
GO

/**** 2006 NAME FLOW ****/
SELECT
    '2006 NAME FLOW',
    --12 Month buyers on 1/1/2006
    (select count(*)
    from PJC_CustomerOrderHistory -- 149,428    
    where [2005OrdCount] > 0
    ) [12-Month Buyers],

    -- Attrition of 12-month buyers
    (select count(*) 
    from PJC_CustomerOrderHistory -- 75,132   
    where [2005OrdCount] > 0 
     and [2006OrdCount] = 0   
     ) [Attrition of 12-month Buyers],
    

    -- New First time buyers
    (select count(*)
    from PJC_CustomerOrderHistory -- 68,901
    where FirstOrder = 2006
    ) [First Time Buyers],
    
    -- Reactivation of 12-72 month buyers 
    (select count(*) 
    from PJC_CustomerOrderHistory -- 22,382  
    where [2006OrdCount] > 0 
    and [2005OrdCount] = 0 
    and ([2004OrdCount] > 0 
          or [2003OrdCount] > 0
          or [2002OrdCount] > 0
          or [2001OrdCount] > 0
          or [2000OrdCount] > 0
         )
     ) [Reactivation of 12-72 month buyers]          
     

