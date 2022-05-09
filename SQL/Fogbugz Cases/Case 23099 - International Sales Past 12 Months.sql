-- Case 23099 - International Sales Past 12 Months

-- ORDER COUNT
SELECT (case when O.sShipToCountry IS NULL then 'US'
            when O.sShipToCountry = 'US' then 'US'
            when O.sShipToCountry = 'CANADA' THEN 'CA'
            when O.sShipToCountry = 'AUSTRALIA' THEN 'AU'
            ELSE 'OTHER'
            end
       )
       , COUNT(distinct ixOrder) -- 207 orders
FROM tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.ixOrder not like '%-%'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.ixShippedDate between 16613 and 16977 -- 06/25/2013 and 06/24/2014
    and O.sOrderType in ('MRR','PRS') --  'Retail'
GROUP BY (case when O.sShipToCountry IS NULL then 'US'
            when O.sShipToCountry = 'US' then 'US'
            when O.sShipToCountry = 'CANADA' THEN 'CA'
            when O.sShipToCountry = 'AUSTRALIA' THEN 'AU'
            ELSE 'OTHER'
            end
       )
ORDER BY COUNT(distinct ixOrder) desc      



-- sales
SELECT (case when O.sShipToCountry IS NULL then 'US'
            when O.sShipToCountry = 'US' then 'US'
            when O.sShipToCountry = 'CANADA' THEN 'CA'
            when O.sShipToCountry = 'AUSTRALIA' THEN 'AU'
            ELSE 'OTHER'
            end
       )
       , sum(O.mMerchandise) -- 207 orders
FROM tblOrder O
WHERE O.sOrderStatus = 'Shipped'
   -- and O.ixOrder not like '%-%'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.ixShippedDate between 16613 and 16977 -- 06/25/2013 and 06/24/2014
    and O.sOrderType in ('MRR','PRS')  --  'Retail'
GROUP BY (case when O.sShipToCountry IS NULL then 'US'
            when O.sShipToCountry = 'US' then 'US'
            when O.sShipToCountry = 'CANADA' THEN 'CA'
            when O.sShipToCountry = 'AUSTRALIA' THEN 'AU'
            ELSE 'OTHER'
            end
       )
ORDER BY  COUNT(distinct ixOrder) desc 



select