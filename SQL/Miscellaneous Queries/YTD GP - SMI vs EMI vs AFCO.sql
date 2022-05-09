-- YTD GP - SMI vs EMI vs AFCO

    -- SMI
    SELECT 'SMI ' as 'Source',
        CONVERT(INT, ROUND(SUM(mMerchandise), -3)) 'Sales',    
        CONVERT(INT, ROUND(SUM(mMerchandiseCost), -3)) 'MerchCost',
        (CONVERT(INT, ROUND(SUM(mMerchandise), -3))   - CONVERT(INT, ROUND(SUM(mMerchandiseCost), -3))) 'GP'
    FROM [SMI Reporting].dbo.tblOrder O
    WHERE O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '01/02/2016' and '09/06/2016'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders  -- 86,974,552
        and O.sOrderType <> 'Internal'   -- USUALLY filtered       -- 12,680,814
        
UNION ALL
    -- EAGLE
    SELECT  'EMI ' as 'Source',
        CONVERT(INT, ROUND(SUM(mMerchandise), -3)) 'Sales',   
        CONVERT(INT, ROUND(SUM(mMerchandiseCost), -3)) 'MerchCost',
        (CONVERT(INT, ROUND(SUM(mMerchandise), -3))   - CONVERT(INT, ROUND(SUM(mMerchandiseCost), -3))) 'GP'
    FROM [SMI Reporting].dbo.vwEagleOrder O
    WHERE O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '01/02/2016' and '09/06/2016'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders  -- 1,249,655
        and O.sOrderType <> 'Internal'   -- USUALLY filtered  
     
UNION ALL      
    -- AFCO
    SELECT  'AFCO' as 'Source',
        CONVERT(INT, ROUND(SUM(mMerchandise), -3)) 'Sales',   
        CONVERT(INT, ROUND(SUM(mMerchandiseCost), -3)) 'MerchCost',
        (CONVERT(INT, ROUND(SUM(mMerchandise), -3))   - CONVERT(INT, ROUND(SUM(mMerchandiseCost), -3))) 'GP'
    FROM [AFCOReporting].dbo.tblOrder O
    WHERE O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between '01/02/2016' and '09/06/2016'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders  -- 86,974,552
        and O.sOrderType <> 'Internal'   -- USUALLY filtered       -- 12,680,814

/*
Source	Sales	    MerchCost	GP
======  ==========  ==========  ==========
SMI 	86,719,000	49,244,000	37,475,000
EMI 	 1,248,000     750,000	   498,000 <-- subset of SMI (1.3% of GP)

AFCO	12,670,000	 6,435,000	 6,235,000
                                ==========
                                43,710,000 SMI + AFCO
                                           SMI -  85.7%
                                           AFCO - 14.3%
                                           EMI -   1.1%
                                
*/
