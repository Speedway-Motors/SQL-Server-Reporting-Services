-- Case 16249 - change GS sales logic on Daily Orders Taken Report
-- to be used to replace GS logic currently in VIEW vwDailyOrdersTakenGSShock
    SELECT 
        D.dtDate,D.iPeriod,D.iPeriodYear,
        sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) GSDailyNumOrds,  -- COUNT BACKORDERS MERCH, but DON'T COUNT BACKORDERS as a new order!!!!!!
        sum(OL.mExtendedPrice) GSDailySales
    FROM  tblOrder O
          join tblOrderLine OL  on O.ixOrder = OL.ixOrder
         -- join tblSKU SKU       on SKU.ixSKU = OL.ixSKU
          join tblSnapshotSKU SKU on SKU.ixSKU = OL.ixSKU AND SKU.ixDate = OL.ixOrderDate
          join tblDate D        on O.ixOrderDate = D.ixDate
    WHERE 
          D.dtDate >= '01/01/2010'    -- otherwise view will go back to beginning of tblDate
          and O.sOrderChannel <> 'INTERNAL'
          and O.sOrderType <> 'Internal'      
          and O.sOrderStatus NOT in ('Pick Ticket','Cancelled')
          and OL.flgLineStatus in ('Shipped', 'Dropshipped','Open','Backordered' ) -- excludes status: Cancelled,fail,Lost,unknown
          and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK
--and OL.ixSKU = '7211022-RH'  -- REMOVE after testing
and D.dtDate >= '01/01/2012'  -- REMOVE after testing      
          and (substring(SKU.ixPGC,2,1) in ('a','b','c','d','e','q','r','s','z')  -- all the lower case values for the 2nd char of ixPGC      
               OR SKU.ixSKU like 'UP%') -- THIS WASN'T IN ORIGINAL VIEW....should it be included NOW??????
    GROUP BY
        D.dtDate,D.iPeriod,D.iPeriodYear
order by dtDate   -- REMOVE after testing
     
/*
dtDate	iPeriod	iPeriodYear	GSDailyNumOrds	GSDailySales
2012-02-12 00:00:00.000	2	2012	1	39.99
2012-04-28 00:00:00.000	5	2012	1	263.92
2012-09-07 00:00:00.000	9	2012	1	131.96
2012-09-11 00:00:00.000	9	2012	1	131.96
*/        
       
       
       
        
-- adding UP% parts--  query using tblSnapshotSKU
select * from tblSKU SKU
where ixSKU like 'UP%'   -- 26,612
  and substring(SKU.ixPGC,2,1) NOT in ('a','b','c','d','e','q','r','s','z')
  and dtCreateDate >= '01/01/2012'
  and flgDeletedFromSOP = 0
        
        
        
-- UP parts not currently assigned to a GS PGC        
select --ixPGC, 
    (case when substring(SKU.ixPGC,2,1) in ('a','b','c','d','e','q','r','s','z') then 'GS'
     else 'NON-GS'
     end
     ) as 'PGC Type',
     COUNT(ixSKU) SKUcount
from tblSKU SKU
where ixSKU like 'UP%'
group by --ixPGC, 
    (case when substring(SKU.ixPGC,2,1) in ('a','b','c','d','e','q','r','s','z') then 'GS'
     else 'NON-GS'
     end
     )







    
        
        
        
        
        
        
        
        
        
        
        
select ixSKU,COUNT(distinct ixPGC) PGCQty
from (        
        select ixSKU, ixPGC,ixDate
        from tblSnapshotSKU
        where substring(ixPGC,2,1) in ('a','b','c','d','e','q','r','s','z') 
            and ixDate between 16377 and 16407
        --order by ixSKU, ixPGC, ixDate
        ) LASER
group by ixSKU
having COUNT(distinct ixPGC) > 1


select * from tblSnapshotSKU
where ixSKU in ('9104754GS')-- ','','','29000435','91058780-1GS')
            and ixDate between 16377 and 16407
order by ixSKU                



select distinct ixSKU from tblSnapshotSKU
 where substring(ixPGC,2,1) in ('a','b','c','d','e','q','r','s','z') 
 and ixSKU in (select distinct ixSKU from tblSnapshotSKU
                where substring(ixPGC,2,1) NOT in ('a','b','c','d','e','q','r','s','z')
                )
and ixSKU NOT like 'UP%'     


-- TEST SKU
-- was NOT assigned to a GS PGC at one point in 2012 but then was later
-- there are sales before and after the switch date
select *
from tblSnapshotSKU
where ixSKU = '7211022-RH'    
AND ixDate between 16114 and 16190 -- switched on 16330  

select ixSKU, dtOrderDate, ixOrderDate, iQuantity, mExtendedPrice, flgLineStatus
from tblOrderLine
where ixSKU = '7211022-RH'
and ixOrderDate between  16071 and 16326 -- 1-1-12 and 09-11-12 -- switched on 16330
order by dtOrderDate
/*
ixSKU	    dtOrderDate	ixOrderDate	iQuantity	mExtendedPrice	flgLineStatus   SnapshotPGC
7211022-RH	2012-02-12 	16114	    1	        39.99	        Shipped         NULL

7211022-RH	2012-04-28 	16190	    8	        263.92	        Shipped         Hc
7211022-RH	2012-09-07 	16322	    4	        131.96	        Shipped         Hc
7211022-RH	2012-09-11 	16326	    4	        131.96	        Shipped         Hc
*/

