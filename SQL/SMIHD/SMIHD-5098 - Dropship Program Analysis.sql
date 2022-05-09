-- SMIHD-5098 - Dropship Program Analysis
/*
1) how many new customers we have acquired via dropship. 
    This meaning the # of SMI customers whose first order placed with us contained a dropship item. 
    A- in the past 12 months 4,164 new customers had a dropship item in their first order
    
2) how many customers were reactivated via the program. 
    This being customers who purchased a dropship item in the last 12 months, did not buy anything in the preceding 12 months, but had bought 12 months or more preceding that.
    A- 951 customers ordered 25-36 months ago, had no orders 13-24 months ago, and ordered at least 1 dropship item in the past 12 months.
    
3) the number of pkgs that shipped from SMI and the number of dropship boxes shipped on any order over $99 
    that qualified for free shipping and contained a dropship item in the last 12 months.
    Two examples are order#s 6113355 and 6164554. 
    
    6113355 is a particularly interesting example as it contains dropship items from two separate vendors.
    
Feel free to contact me at ext 3221 with questions.


REVISION 3 8/1/2015 to 7/31/16
REVISION 4 7/1/2015 to 6/30/16
*/


-- 1) NEW CUSTOMERS (first order was a DS)
    select distinct O.ixCustomer --    4,164 First time Customers
    --    SUM(O.mMerchandise)  
    from tblDropship DS
    join tblOrder O on DS.ixOrder = O.ixOrder
    join vwNewCustOrder NC on NC.ixCustomer = O.ixCustomer and NC.dtOrderDate = O.dtOrderDate
    where O.dtOrderDate between '08/01/2015' and '07/31/2016' -- 12,869 
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'             
    


-- 2) REACTIVATED

    -- TEMP TABLE: list of CustS that dropshipped in last 12 months
    select distinct O.ixCustomer 
    -- DROP TABLE [SMITemp].dbo.PJC_SMIHD5098_DropshipCustsLast12Mo
    into [SMITemp].dbo.PJC_SMIHD5098_DropshipCustsLast12Mo 
    from tblDropship DS
        join tblOrder O on DS.ixOrder = O.ixOrder
    where O.dtOrderDate between '07/01/2015' and '06/30/2016' -- 12,546 Rev4            12,869  Rev3
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'              -- 12,869
        
select Distinct DS.ixCustomer
from [SMITemp].dbo.PJC_SMIHD5098_DropshipCustsLast12Mo DS -- <- dropshipped last 12 Mo
join (-- Customers active 25-36 Months ago
    select distinct ixCustomer    
     from tblOrder O 
     where O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '07/01/2010' and '06/30/2014'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered
     ) PREVCUSTS on DS.ixCustomer = PREVCUSTS.ixCustomer
LEFT join (-- Customers innactive 13-24 Months ago
    select distinct ixCustomer   -- 951
     from tblOrder O 
     where O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '07/01/2014' and '06/30/2015'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered
     ) INACTIVE on DS.ixCustomer = INACTIVE.ixCustomer    
where INACTIVE.ixCustomer is NULL     
     

     

select * from tblOrderLine where flgLineStatus = 'Dropshipped'
and sTrackingNumber is NOT NULL -- only 8 out of 50K dropshipped line items have a tracking #

select DS.ixDropship, ixSpecialOrder, DS.ixOrder, DS.mPrice, O.mMerchandise
from tblDropship DS -- 43949
join tblOrder O on DS.ixOrder = O.ixOrder
order by O.ixOrder

select DS.sTrackingNumber--, COUNT(DS.ixDropship) 
from tblDropship DS
    join tblOrder O on DS.ixOrder = O.ixOrder
    join tblPackage P on O.ixOrder = P.ixOrder
where O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '7/1/2015' and '06/30/2014'
        and O.mMerchandise > 99 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered    



select O.ixOrder, OL.sTrackingNumber, DS.sTrackingNumber--, COUNT(DS.ixDropship) 
from tblDropship DS
    join tblOrder O on DS.ixOrder = O.ixOrder
    join tblOrderLine OL on OL.ixOrder = O.ixOrder
where O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '07/01/2010' and '06/30/2014'
        and O.mMerchandise > 99 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered 
order by DS.sTrackingNumber          


select DS.ixOrder, SUM(mPrice)
from tblDropship DS
    join tblOrder O on DS.ixOrder = O.ixOrder
where O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '07/01/2010' and '06/30/2014'
        --and O.mMerchandise > 99 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered   
group by DS.ixOrder   
having SUM(mPrice) > 99
order by DS.ixOrder  

select DS.ixOrder, COUNT(distinct sTrackingNumber)
from tblDropship DS
where sTrackingNumber is NOT NULL
group by DS.ixOrder


-- TO POPULATE "SMIHD-5098 packages SMI shipped vs DSs - REVISION ###.xlsx"
select O.ixOrder, O.dtOrderDate, O.dtShippedDate, OLP.SMIpkgs, DS.DSpkgs,  O.mMerchandise, O.mShipping, O.sOrderType --  6964 rows in REVISION 6 @8/30/16
from tblOrder O 
    join (-- DS pkg counts
            select DS.ixOrder, SUM(DS.mPrice) 'DSMerch', COUNT(distinct DS.sTrackingNumber) 'DSpkgs'
            from tblDropship DS
            where --sTrackingNumber is NOT NULL
                sTrackingNumber IS NULL
                OR (
                    DS.sTrackingNumber NOT LIKE '%CUST%'
                and DS.sTrackingNumber NOT LIKE '%CANCEL%'
                and DS.sTrackingNumber NOT LIKE '%ZERO%'
                and DS.sTrackingNumber NOT LIKE '%GROUND%'
                and DS.sTrackingNumber NOT LIKE '%TRACK%'
                and DS.sTrackingNumber NOT LIKE '%NOT%'
                and DS.sTrackingNumber NOT LIKE '%SHIP%'
                and DS.sTrackingNumber NOT LIKE '%PACK%'
                )
            group by DS.ixOrder
            --having SUM(DS.mPrice) > 99
            -- order by COUNT(distinct DS.sTrackingNumber) desc
            ) DS on DS.ixOrder = O.ixOrder
     left join (-- SMI pkg counts
               select OL.ixOrder, COUNT ( distinct sTrackingNumber) 'SMIpkgs'
               from tblOrderLine OL 
               group by OL.ixOrder) OLP on OLP.ixOrder = O.ixOrder
where O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '7/1/2015' and '6/30/16'
        and O.mMerchandise > 99 -- 
        and O.sOrderType <> 'Internal'   -- USUALLY filtered   
       -- AND DS.ixOrder in ('6419341','6420652','6927248','6007664','6000174')
order by  O.mMerchandise, O.ixOrder


select sOrderType, D.iYear, COUNT(O.ixOrder), SUM(O.mMerchandise) Sales
from tblOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
Where    O.sOrderStatus = 'Shipped'
    and O.dtShippedDate >= '01/01/2015'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
group by   sOrderType, D.iYear  
order by  D.iYear, sOrderType
    


select * from tblDropship where ixOrder in ('6419341','6420652','6927248','6007664','6000174')

ixOrder	DSMerch 
6419341	52.99
6420652	52.99
6927248	52.99

select * from tblOrder where ixOrder in ('6419341','6420652','6927248','6007664','6000174')

select * from tblOrder where ixOrder in ('6007664','6000174')
select * from tblOrderLine where ixOrder in ('6007664','6000174')



            select DS.ixOrder,DS.sTrackingNumber
            from tblDropship DS
            where 
            /*sTrackingNumber is NOT NULL
                and DS.sTrackingNumber NOT LIKE '%CUST%'
                and DS.sTrackingNumber NOT LIKE '%CANCEL%'
                and DS.sTrackingNumber NOT LIKE '%ZERO%'
                and DS.sTrackingNumber NOT LIKE '%GROUND%'
                and DS.sTrackingNumber NOT LIKE '%TRACK%'
                and DS.sTrackingNumber NOT LIKE '%NOT%'
                and DS.sTrackingNumber NOT LIKE '%SHIP%'
                and DS.sTrackingNumber NOT LIKE '%PACK%'
                AND */
                    ixOrder in ('6419341','6420652','6927248','6007664','6000174')
            group by DS.ixOrder