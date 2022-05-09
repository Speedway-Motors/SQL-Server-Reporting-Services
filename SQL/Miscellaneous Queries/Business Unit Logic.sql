-- Business Unit Logic



-- SQL version
SELECT O.ixOrder, O.ixCustomer, O.sOrderChannel, 
        O.sSourceCodeGiven, O.iShipMethod, 
        O.mMerchandise, 
        O.mMerchandiseCost,
    (CASE   WHEN O.ixCustomer IN (1770000, 2672493) then 'ICS'
            WHEN O.sOrderChannel = 'INTERNAL' then 'INTERNAL'
            WHEN O.sSourceCodeGiven like '%EMP%' then 'EMP'
            WHEN O.sSourceCodeGiven like '%PRS%' then 'PRS'
            WHEN O.sSourceCodeGiven like '%MRR%' then 'MRR'
            WHEN (O.sSourceCodeGiven like '%CTR%' 
                  or O.iShipMethod = 1)  
                  then 'RETLINK'
            WHEN O.sSourceCodeGiven in ('2190','2191', 'GGL', 'INET','NET','WEB') then 'WEB'
            WHEN O.sSourceCodeGiven like '%EBAYGS%' then 'GS' -- these are the only orders that qualify as GS orders.
            WHEN (O.sSourceCodeGiven like '%AMAZON%' -- includes AMAZONPRIME
                  or O.sSourceCodeGiven like '%WALMART%'
                  or O.sSourceCodeGiven like '%EBAY%')
                  then 'MKT' 
     ELSE 'PHONE'
     END) 'BusinessUnit'
into #March2019OrderBUs
FROM tblOrder O
where O.dtInvoiceDate between '12/29/2018' and '01/25/2019'
    and O.sOrderStatus = 'Shipped'
order by 'BusinessUnit', O.ixCustomer, O.sSourceCodeGiven, O.sOrderChannel

-- result set analysis
SELECT BusinessUnit, 
    FORMAT(count(*),'###,###') 'OrderCnt', 
    FORMAT(SUM(mMerchandise),'$###,###') 'Sales',
    FORMAT(SUM(mMerchandiseCost),'$###,###') 'CoGs',
    FORMAT(SUM(mMerchandise)-SUM(mMerchandiseCost),'$###,###') 'GP$'
    from #March2019OrderBUs
GROUP BY BusinessUnit
ORDER BY count(*) desc

DROP TABLE #March2019OrderBUs


-- select * from tblSourceCode where ixSourceCode like '%MRR%'


/*
select * from tblSourceCode
where ixSourceCode like '%AMAZON%'
or ixSourceCode like '%WALMART%'
or ixSourceCode like '%EBAY%'

-- these should be classified as WEB BU?        <-- irrelavant.  No orders associated with them.
ixSourceCode	sDescription
21902007	    INTERNET-DIRECT
2190.11	        INTERNET-DIRECT
21912007	    INTERNET RACE
2191.11	        INTERNET RACE

SELECT * FROM tblOrder where sSourceCodeGiven in ('21902007','2190.11','21912007','2191.11')

select distinct sOrderStatus 
from tblOrder

SELECT * FROM tblBusinessUnit
*/









