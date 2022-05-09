-- Case 5440 - count of borrowed pick tickets by day
select                      -- 15,402 NULL tblSKUTransaction
    D.dtDate,
    T.chTime,
    ST.ixSKU, 
    ST.iQty,
    SKU.sDescription,
    ST.sTransactionInfo,
    ST.sTransactionType,
    ST.sBin 'FromBin',
    ST.sToBin 'ToBin',
    ST.ixJob 'Job',
    ST.dtDateLastSOPUpdate
    --, ST.*
from tblSKUTransaction ST
    left join tblSKU SKU on SKU.ixSKU = ST.ixSKU
    left join tblDate D on D.ixDate = ST.ixDate
    left join tblTime T on ST.ixTime = T.ixTime
where sToBin like 'IO%'
    and sToBin <> 'IOIT'
    and D.dtDate between @StartDate and @EndDate -- per KDL, there is never a pick ticket TO this bin 
 --   and ST.ixDate >= 16071 -- 01/01/2012          between 16071 and 16284 
  --  and ST.sTransactionInfo is NULL
    
    --and ST.ixDate between 16371 and 16377
    -- 
  ORDER BY      D.dtDate, T.chTime  
--order by sTransactionInfo, sBin
    
select MIN(ixDate)
from tblSKUTransaction
where sTransactionInfo is NOT NULL


/*
select COUNT(*) from tblSKUTransaction where ixDate >= 16013
and sToBin like 'IO%'
    and sToBin <> 'IOIT'
    
*/    
-- Borrowed Part Requests by Day

SELECT            
    D.dtDate,
    ST.sUser            as 'User',
    T.chTime            as 'Time',
    ST.ixSKU            as 'SKU',
    ST.iQty             as 'Qty',
    SKU.sDescription    as 'SKU Description',
    ST.sTransactionInfo as 'Transaction Description',
    ST.sTransactionType as 'Trans Type',
    ST.sBin             as 'FromBin',
    ST.sToBin           as 'ToBin',   
    ST.ixJob            as 'Job'
FROM tblSKUTransaction ST
    left join tblSKU SKU on SKU.ixSKU = ST.ixSKU
    left join tblDate D on D.ixDate = ST.ixDate
    left join tblTime T on ST.ixTime = T.ixTime
WHERE sToBin like 'IO%'
    and sToBin <> 'IOIT'
    and D.dtDate between @StartDate and @EndDate -- per KDL, there is never a pick ticket TO this bin 
ORDER BY      D.dtDate, T.chTime  
  
      
    
    select                      -- 15,402 NULL tblSKUTransaction
    D.dtDate,
    T.chTime,
    ST.ixSKU, 
    ST.iQty,
    SKU.sDescription,
    ST.sTransactionInfo,
    -- ST.sTransactionType, -- ALL T
    ST.sBin 'FromBin',
    ST.sToBin 'ToBin',
    ST.sUser
    -- ST.ixJob 'Job',
    -- ST.dtDateLastSOPUpdate
    --, ST.*
from tblSKUTransaction ST
    left join tblSKU SKU on SKU.ixSKU = ST.ixSKU
    left join tblDate D on D.ixDate = ST.ixDate
    left join tblTime T on ST.ixTime = T.ixTime
where sToBin like 'IO%'
    and sToBin <> 'IOIT' -- per KDL, there is never a pick ticket TO this bin 
    and ST.ixDate >= 16349 -- last 90 days
    --and ST.sTransactionInfo is NULL
    
    --and ST.ixDate between 16371 and 16377
    -- 
  ORDER BY  dtDate, T.chTime  
    
    
    
select sBinType, COUNT(*)
from tblBin
group by sBinType    
    
    
    
    