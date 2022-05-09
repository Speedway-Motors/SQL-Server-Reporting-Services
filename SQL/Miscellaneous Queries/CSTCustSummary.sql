-- ROLL-UP table that will be populated nightly to speed up the spCSTSegmentPull Proc

-- TRUNCATE TABLE [SMI Reporting].dbo.tblCSTCustSummary_Rollup
-- ML = Monetary Lifetime

insert into [SMI Reporting].dbo.tblCSTCustSummary_Rollup
select                                              -- 566,158 @12-03-2014
    CST.*,                                          -- 570,689 @01-08-2015
    C.dtAccountCreateDate,                          -- 571,612 @01-22-2015
    R.Recency,                          -- how many months old is their most recent order?
    isnull(F.LFrequency,0) 'Frequency', -- Lifetime Frequency
    ISNULL(ML.Monetary,0) 'MLTotal', 
    (ISNULL(ML.Monetary,0) / isnull(F.LFrequency,9999)) 'AOV', -- set the isnull value on LFrequency high to avoid DIV/0 errors       
    isnull(MLR.Monetary,0)  'MLRace',
    isnull(MLSR.Monetary,0) 'MLStreet',
    isnull(MLB.Monetary,0)  'MLBoth',
    isnull(ML2B.Monetary,0) 'MLTBucket',
    isnull(MLSM.Monetary,0) 'MLSprintMidget',    
    ISNULL(MLPC.Monetary,0) 'MLPedalCar',
    ISNULL(MLSC.Monetary,0) 'MLSportCompact',
    ISNULL(MLSE.Monetary,0) 'MLSafetyEquip',
    ISNULL(MLTE.Monetary,0) 'MLToolsAndEquip',
    MOIR.sOptInStatus   'OptInRace',
    MOISR.sOptInStatus  'OptInStreet',
    MOISM.sOptInStatus  'OptInSprintMidget',
    MOI2B.sOptInStatus  'OptInTBucket',
    MRO.LatestOrder,
    isnull(CR.CatsSinceLastOrder,0) 'CatsSinceLastOrder'

from [SMI Reporting].dbo.vwCSTStartingPool CST
    LEFT JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    LEFT JOIN (-- RECENCY (Regardless of Market)           
                select SP.ixCustomer, 
                    DATEDIFF(M,MAX(O.dtOrderDate),GETDATE()) 'Recency' -- how many months old is their most recent order?
                from [SMI Reporting].dbo.vwCSTStartingPool SP
                    join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = SP.ixCustomer                                 
                where  O.dtOrderDate >= DATEADD(MM, -72, getdate())  -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus = 'Shipped'
                   and O.mMerchandise > 1
                group by SP.ixCustomer
              ) R on CST.ixCustomer = R.ixCustomer 
    LEFT JOIN (-- FREQUENCY (within LIFETIME)   
                select CST.ixCustomer,
                 COUNT(O.ixOrder) AS 'LFrequency'
                 -- SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 ELSE 1 END) AS 'LFrequency' -- 564,996
                from [SMI Reporting].dbo.vwCSTStartingPool CST
                    join [SMI Reporting].dbo.tblOrder O on CST.ixCustomer = O.ixCustomer
                    join (-- OrderLine Summary 
                          select ixOrder, SUM(OL.mExtendedPrice) OLmExtendedPrice
                          from tblOrderLine OL
                          where flgLineStatus in ('Shipped', 'Dropshipped', 'Backordered') -- Backordered IS needed.. we still want to count them in the Qty regardless if they get filled or not.
                          group by ixOrder 
                          ) OLS on O.ixOrder COLLATE SQL_Latin1_General_CP1_CS_AS = OLS.ixOrder COLLATE SQL_Latin1_General_CP1_CS_AS                   
                where  O.dtOrderDate >= DATEADD(MM, -72, getdate())  -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus = 'Shipped'
                   and OLS.OLmExtendedPrice >= 1
                   AND O.ixOrder NOT LIKE '%-%'
                group by CST.ixCustomer   
              ) F on CST.ixCustomer = F.ixCustomer
    LEFT JOIN (-- TOTAL Lifetime $ regardless of Market
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where  O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) ML on CST.ixCustomer = ML.ixCustomer           
    /**** MONETARY for each of the 5 MAIN markets *****/            
    LEFT JOIN (-- Monetary Lifetime RACE
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'R' 
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLR on CST.ixCustomer = MLR.ixCustomer 
    LEFT JOIN (-- Monetary Lifetime STREET
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'SR'
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLSR on CST.ixCustomer = MLSR.ixCustomer 
    LEFT JOIN (-- Monetary Lifetime BOTH
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'B' 
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLB on CST.ixCustomer = MLB.ixCustomer           
    LEFT JOIN (-- Monetary Lifetime SPRINT/MIDGET
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'SM' --in ('2B') -- <-- the 5 markets used by CST
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLSM on CST.ixCustomer = MLSM.ixCustomer    
    LEFT JOIN (-- Monetary Lifetime TBUCKET
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = '2B' 
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) ML2B on CST.ixCustomer = ML2B.ixCustomer    
    LEFT JOIN (-- Monetary Lifetime PC
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'PC' 
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLPC on CST.ixCustomer = MLPC.ixCustomer    
    LEFT JOIN (-- Monetary Lifetime SC
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'SC' 
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLSC on CST.ixCustomer = MLSC.ixCustomer    
    LEFT JOIN (-- Monetary Lifetime SE
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'SE' 
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLSE on CST.ixCustomer = MLSE.ixCustomer    
    LEFT JOIN (-- Monetary Lifetime TE
                select O.ixCustomer, 
                    SUM(isNULL(OL.mExtendedPrice,0))    'Monetary' 
                from [SMI Reporting].dbo.tblMarket M
                    left join [SMI Reporting].dbo.tblPGC PGC on M.ixMarket = PGC.ixMarket
                    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixPGC = PGC.ixPGC    
                    left join [SMI Reporting].dbo.tblOrderLine OL on OL.ixSKU = SKU.ixSKU
                    left join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OL.ixOrder
                where M.ixMarket = 'TE' 
                   and O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%'                   
                group by M.ixMarket,O.ixCustomer
                having SUM(OL.mExtendedPrice) >= 1
              ) MLTE on CST.ixCustomer = MLTE.ixCustomer     
                                                                      
    /**** OPT-IN STATUS FOR EACH OF THE 5 MARKETS *****/           
    LEFT JOIN [SMI Reporting].dbo.tblMailingOptIn MOIR on CST.ixCustomer = MOIR.ixCustomer and MOIR.ixMarket = 'R'  
    LEFT JOIN [SMI Reporting].dbo.tblMailingOptIn MOISR on CST.ixCustomer = MOISR.ixCustomer and MOISR.ixMarket = 'SR'  
    LEFT JOIN [SMI Reporting].dbo.tblMailingOptIn MOISM on CST.ixCustomer = MOISM.ixCustomer and MOISM.ixMarket = 'SM'  
    LEFT JOIN [SMI Reporting].dbo.tblMailingOptIn MOI2B on CST.ixCustomer = MOI2B.ixCustomer and MOI2B.ixMarket = '2B'   
    -- "BOTH" isn't used as a campaign type
    LEFT JOIN (-- most recent order date
               select ixCustomer, MAX(dtOrderDate) LatestOrder
               from tblOrder O
               where sOrderStatus in ('Shipped','Backordered')
               group by ixCustomer) MRO on MRO.ixCustomer = CST.ixCustomer
    LEFT JOIN (-- how many catalogs received since customer's last order
               select CO.ixCustomer,MRO.LatestOrder, 
               --COUNT(distinct CO.ixSourceCode) CatsSinceLastOrder           <-- INCORRECT some customers where marked with multiple SCs for the Same Catalog.  Need to count distinct Catalogs instead of SCs.
               COUNT(distinct SC.ixCatalog) CatsSinceLastOrder
               from tblCustomerOffer CO
                  join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                  left join (-- most recent order date
                               select ixCustomer, MAX(dtOrderDate) LatestOrder
                               from tblOrder O
                               where sOrderStatus in ('Shipped','Backordered')
                               group by ixCustomer
                              ) MRO on CO.ixCustomer = MRO.ixCustomer
               where SC.sSourceCodeType like 'CAT%'
                 and SC.dtStartDate > MRO.LatestOrder 
               group by CO.ixCustomer,MRO.LatestOrder
                ) CR on CR.ixCustomer = CST.ixCustomer


