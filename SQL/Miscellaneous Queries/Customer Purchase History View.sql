USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwRefunds]    Script Date: 11/15/2011 14:34:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************
 Created: 11-15-11
 by: PJC
 Purpose: to summarize total merchandise purchased
    & number of orders (with Merch > 0) by customer per year.
    Will be used in Name Flow report and possibly list pulls.
 ******************************************/
CREATE view [dbo].[vwCustomerOrderHistory]
as

delete from PJC_CustomerOrderHistory

insert into PJC_CustomerOrderHistory    
select C.ixCustomer, FO.FirstOrder,
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
    (isnull([2003].[2003Merch],0)+ isnull([2004].[2004Merch],0)+isnull([2005].[2005Merch],0)+isnull([2006].[2006Merch],0)+isnull([2007].[2007Merch],0)+isnull([2008].[2008Merch],0)+isnull([2009].[2009Merch],0)+isnull([2010].[2010Merch],0)+isnull([2011].[2011Merch],0)) [TotMerch],
    (isnull([2003].[2003OrdCount],0)+isnull([2004].[2004OrdCount],0)+isnull([2005].[2005OrdCount],0)+isnull([2006].[2006OrdCount],0)+isnull([2007].[2007OrdCount],0)+isnull([2008].[2008OrdCount],0)+isnull([2009].[2009OrdCount],0)+ isnull([2010].[2010OrdCount],0)+isnull([2011].[2011OrdCount],0)) [TotOrdCount]    
    FROM tblCustomer C
    left join (select ixCustomer,
                min(datepart("yyyy",dtShippedDate)) [FirstOrder]
                 from vwOrderAllHistory
               where sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0
               group by ixCustomer) FO on FO.ixCustomer = C.ixCustomer
    -- 2003
    left join (select ixCustomer,
                sum(mMerchandise) [2003Merch],
                count(ixOrder)     [2003OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtShippedDate between '01/01/2003' and '12/31/2003'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0
               group by ixCustomer 
                ) [2003] on [2003].ixCustomer = C.ixCustomer
    -- 2004
    left join (select ixCustomer,
                sum(mMerchandise) [2004Merch],
                count(ixOrder)     [2004OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtShippedDate between '01/01/2004' and '12/31/2004'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2004] on [2004].ixCustomer = C.ixCustomer
    -- 2005
    left join (select ixCustomer,
                sum(mMerchandise) [2005Merch],
                count(ixOrder)     [2005OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtShippedDate between '01/01/2005' and '12/31/2005'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2005] on [2005].ixCustomer = C.ixCustomer
    -- 2006
    left join (select ixCustomer,
                sum(mMerchandise) [2006Merch],
                count(ixOrder)     [2006OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtShippedDate between '01/01/2006' and '12/31/2006'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2006] on [2006].ixCustomer = C.ixCustomer
    -- 2007
    left join (select ixCustomer,
                sum(mMerchandise) [2007Merch],
                count(ixOrder)     [2007OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtShippedDate between '01/01/2007' and '12/31/2007'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2007] on [2007].ixCustomer = C.ixCustomer
    -- 2008
    left join (select ixCustomer,
                sum(mMerchandise) [2008Merch],
                count(ixOrder)     [2008OrdCount]    
               from [SMIArchive].dbo.tblOrderArchive
               where dtShippedDate between '01/01/2008' and '12/31/2008'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2008] on [2008].ixCustomer = C.ixCustomer   
            
    -- 2009
    left join (select ixCustomer,
                sum(mMerchandise) [2009Merch],
                count(ixOrder)     [2009OrdCount]    
               from tblOrder
               where dtShippedDate between '01/01/2009' and '12/31/2009'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2009] on [2009].ixCustomer = C.ixCustomer
    -- 2010
    left join (select ixCustomer,
                sum(mMerchandise) [2010Merch],
                count(ixOrder)     [2010OrdCount]    
               from tblOrder
               where dtShippedDate between '01/01/2010' and '12/31/2010'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2010] on [2010].ixCustomer = C.ixCustomer
    -- 2011
    left join (select ixCustomer,
                sum(mMerchandise) [2011Merch],
                count(ixOrder)     [2011OrdCount]    
               from tblOrder
               where dtShippedDate between '01/01/2011' and '12/31/2011'
                 and sOrderStatus = 'Shipped'
                 and sOrderType <> 'Internal'
                 and sOrderChannel <> 'INTERNAL'
                 and mMerchandise > 0                 
               group by ixCustomer 
                ) [2011] on [2011].ixCustomer = C.ixCustomer
    -- 2012
    --left join (select ixCustomer,
    --            sum(mMerchandise) [2012Merch],
    --            count(ixOrder)     [2012OrdCount]    
    --           from tblOrder
    --           where dtShippedDate between '01/01/2012' and '12/31/2012'
    --             and sOrderStatus = 'Shipped'
    --             and sOrderType <> 'Internal'
    --             and sOrderChannel <> 'INTERNAL'
    --             and mMerchandise > 0                 
    --           group by ixCustomer 
    --            ) [2012] on [2012].ixCustomer = C.ixCustomer               
                                                                                                                                        
--WHERE C.ixCustomer between '0' and '651400'


select * from vwCustomerOrderHistory




select top 10 * from PJC_CustomerOrderHistory


select count(*) 
from PJC_CustomerOrderHistory -- 79,256    12 Month buyers on 1/1/2006
where [2005OrdCount] > 0 

select count(*) 
from PJC_CustomerOrderHistory -- 43,232   Attrition of 12-month buyers
where [2005OrdCount] > 0 
 and [2006OrdCount] = 0 


select count(*)
from PJC_CustomerOrderHistory -- 32,506  New First time 2006 buyers
where FirstOrder = 2006

