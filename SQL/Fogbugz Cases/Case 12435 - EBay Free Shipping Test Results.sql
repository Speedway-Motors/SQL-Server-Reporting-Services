
/* Query to pull base information regarding what was needed before grouping 
aggregate information was added in for NOT DURING promotion period*/

SELECT DISTINCT OL.ixOrder --771 Rows
              , OL.ixSKU
              , OL.mUnitPrice
              , OL.dtOrderDate
              , O.mShipping
              , O.iShipMethod
              , OL.iQuantity
FROM tblOrderLine OL
JOIN tblOrder O ON OL.ixOrder = O.ixOrder
WHERE OL.ixSKU IN ('83526011179', '91010005', '3254025', '91012800', '91064062', '6178510'
                , '91018040', '91089529', '5752200', '91064088', '3003660', '54561755'
                , '91012805', '91089800', '92517480', '91089411', '91028146', '4103196'
                , '4464130', '42737119', '91032506', '10620110', '491104', '3441094'
                , '91081501', '91081075', '91065016', '91332902', '91017157', '91101001'
                , '63089402', '91628910', '91011520', '5631000', '10680159', '56082250'
                , '91122151', '91628908', '5478222', '91011578', '4811004', '4916096'
                , '5475554', '91012804', '4103294', '91032612', '91013106', '4917000'
                , '91065013', '91032339') 
  and OL.dtOrderDate BETWEEN '05/16/11' AND '10/23/11'
  and OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel IN ('AUCTION','EBAY')
 -- and O.iShipMethod NOT IN ('3','4', '15', '10', '8', '6')
  and OL.flgKitComponent = '0'
  and O.ixOrder NOT IN ('4051440', '4329245', '4359249', '4384147', '4367146', '4388145', '4533522')
ORDER BY mShipping, OL.dtOrderDate, OL.ixSKU


/* Query to pull base information regarding what was needed before grouping 
aggregate information was added in for DURING promotion period*/

SELECT DISTINCT OL.ixOrder --825 rows
              , OL.ixSKU
              , OL.mUnitPrice
              , OL.dtOrderDate
              , O.mShipping
              , O.iShipMethod
              , OL.iQuantity
FROM tblOrderLine OL
JOIN tblOrder O ON OL.ixOrder = O.ixOrder
WHERE OL.ixSKU IN ('83526011179', '91010005', '3254025', '91012800', '91064062', '6178510'
                , '91018040', '91089529', '5752200', '91064088', '3003660', '54561755'
                , '91012805', '91089800', '92517480', '91089411', '91028146', '4103196'
                , '4464130', '42737119', '91032506', '10620110', '491104', '3441094'
                , '91081501', '91081075', '91065016', '91332902', '91017157', '91101001'
                , '63089402', '91628910', '91011520', '5631000', '10680159', '56082250'
                , '91122151', '91628908', '5478222', '91011578', '4811004', '4916096'
                , '5475554', '91012804', '4103294', '91032612', '91013106', '4917000'
                , '91065013', '91032339') 
  and OL.dtOrderDate BETWEEN '10/24/11' AND '04/01/12'
  and OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel IN ('AUCTION','EBAY')
  and O.iShipMethod NOT IN ('3','4', '15', '10', '8', '6')
  and OL.flgKitComponent = '0'
  and O.ixOrder NOT IN ('4286650', '4358951', '4183558', '4347546', '4908249'
                        , '4908249', '4321341', '4244961', '4546653', '4546653'
                        , '4630452', '4140266')
ORDER BY OL.dtOrderDate, OL.ixSKU


/* Query to determine the total quantities sold of each SKU per week (for the equal amount of ISO weeks) 
   previous to the aforementioned promotion offering the customers free shipping */ 

SELECT D.iISOWeek --503 Rows
     --, D.iYear
     , OL.ixSKU
     , SUM(OL.iQuantity) AS TotalSold
FROM tblOrderLine OL
JOIN tblOrder O ON OL.ixOrder = O.ixOrder
JOIN tblDate D ON OL.dtOrderDate = D.dtDate
WHERE OL.ixSKU IN ('83526011179', '91010005', '3254025', '91012800', '91064062', '6178510'
                , '91018040', '91089529', '5752200', '91064088', '3003660', '54561755'
                , '91012805', '91089800', '92517480', '91089411', '91028146', '4103196'
                , '4464130', '42737119', '91032506', '10620110', '491104', '3441094'
                , '91081501', '91081075', '91065016', '91332902', '91017157', '91101001'
                , '63089402', '91628910', '91011520', '5631000', '10680159', '56082250'
                , '91122151', '91628908', '5478222', '91011578', '4811004', '4916096'
                , '5475554', '91012804', '4103294', '91032612', '91013106', '4917000'
                , '91065013', '91032339') 
  and OL.dtOrderDate BETWEEN '05/16/11' AND '10/23/11'
  and OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel IN ('AUCTION','EBAY')
  --and O.iShipMethod NOT IN ('3','4', '15', '10', '8', '6')
  -- This data was excluded as the method of shipping does not reflect a customer's desire to buy
  -- when the promotion was not running
  and OL.flgKitComponent = '0'
  and O.ixOrder NOT IN ('4051440', '4329245', '4359249', '4384147', '4367146', '4388145', '4533522') 
GROUP BY D.iISOWeek, OL.ixSKU--, D.iYear, 
ORDER BY D.iISOWeek DESC


/* Query to determine the total quantities sold of each SKU per week DURING the running 
  promotion offering the customers free shipping */ 

SELECT D.iISOWeek --466 Rows
    -- , D.iYear
     , OL.ixSKU
     , SUM(OL.iQuantity) AS TotalSold
FROM tblOrderLine OL
JOIN tblOrder O ON OL.ixOrder = O.ixOrder
JOIN tblDate D ON OL.dtOrderDate = D.dtDate
WHERE OL.ixSKU IN ('83526011179', '91010005', '3254025', '91012800', '91064062', '6178510'
                , '91018040', '91089529', '5752200', '91064088', '3003660', '54561755'
                , '91012805', '91089800', '92517480', '91089411', '91028146', '4103196'
                , '4464130', '42737119', '91032506', '10620110', '491104', '3441094'
                , '91081501', '91081075', '91065016', '91332902', '91017157', '91101001'
                , '63089402', '91628910', '91011520', '5631000', '10680159', '56082250'
                , '91122151', '91628908', '5478222', '91011578', '4811004', '4916096'
                , '5475554', '91012804', '4103294', '91032612', '91013106', '4917000'
                , '91065013', '91032339') 
  and OL.dtOrderDate BETWEEN '10/24/11' AND '04/01/12'
  and OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel IN ('AUCTION','EBAY')
  and O.iShipMethod NOT IN ('3','4', '15', '10', '8', '6')
  and OL.flgKitComponent = '0'
  and O.ixOrder NOT IN ('4286650', '4358951', '4183558', '4347546', '4908249'
                        , '4908249', '4321341', '4244961', '4546653', '4546653'
                        , '4630452', '4140266')
GROUP BY D.iISOWeek, OL.ixSKU--, D.iYear, 
ORDER BY D.iISOWeek DESC


/* Query to determine sales figures on company wide sales within the same period prior to the 
   shipping promotion to get a baseline for comparison*/

SELECT D.iISOWeek --23 Rows
   --  , D.iYear
     , SUM(O.mMerchandise) AS TotalMerch
     , SUM(O.mMerchandiseCost) AS TotalCost
     , SUM((O.mMerchandise)-(O.mMerchandiseCost)) AS GrossProfit
     , COUNT (O.ixOrder) AS OrderCount
FROM tblOrder O 
JOIN tblDate D ON O.dtOrderDate = D.dtDate
WHERE O.dtOrderDate BETWEEN '05/16/11' AND '10/23/11'
  and O.sOrderStatus = 'Shipped'
  and O.sOrderChannel <> 'INTERNAL'
  and O.sOrderType = 'Retail'
GROUP BY D.iISOWeek--, D.iYear
ORDER BY D.iISOWeek DESC

/* Query to determine sales figures on company wide sales DURING the same period of the 
   shipping promotion to get a baseline for comparison*/

SELECT D.iISOWeek --23 Rows
    -- , D.iYear
     , SUM(O.mMerchandise) AS TotalMerch
     , SUM(O.mMerchandiseCost) AS TotalCost
     , SUM((O.mMerchandise)-(O.mMerchandiseCost)) AS GrossProfit
     , COUNT (O.ixOrder) AS OrderCount
FROM tblOrder O 
JOIN tblDate D ON O.dtOrderDate = D.dtDate
WHERE O.dtOrderDate BETWEEN '10/24/11' AND '04/01/12'
  and O.sOrderStatus = 'Shipped'
  and O.sOrderChannel <> 'INTERNAL'
  and O.sOrderType = 'Retail'
GROUP BY D.iISOWeek--, D.iYear
ORDER BY D.iISOWeek DESC


/* Query to determine the total quantities sold of each SKU prior to the running 
  promotion offering the customers free shipping (independent of week) */ 

SELECT OL.ixSKU --50 Rows
     , SUM(OL.iQuantity) AS TotalSold
FROM tblOrderLine OL
JOIN tblOrder O ON OL.ixOrder = O.ixOrder
WHERE OL.ixSKU IN ('83526011179', '91010005', '3254025', '91012800', '91064062', '6178510'
                , '91018040', '91089529', '5752200', '91064088', '3003660', '54561755'
                , '91012805', '91089800', '92517480', '91089411', '91028146', '4103196'
                , '4464130', '42737119', '91032506', '10620110', '491104', '3441094'
                , '91081501', '91081075', '91065016', '91332902', '91017157', '91101001'
                , '63089402', '91628910', '91011520', '5631000', '10680159', '56082250'
                , '91122151', '91628908', '5478222', '91011578', '4811004', '4916096'
                , '5475554', '91012804', '4103294', '91032612', '91013106', '4917000'
                , '91065013', '91032339') 
  and OL.dtOrderDate BETWEEN '05/16/11' AND '10/23/11'
  and OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel IN ('AUCTION','EBAY')
  --and O.iShipMethod NOT IN ('3','4', '15', '10', '8', '6')
  -- This data was excluded as the method of shipping does not reflect a customer's desire to buy
  -- when the promotion was not running
  and OL.flgKitComponent = '0'
  and O.ixOrder NOT IN ('4051440', '4329245', '4359249', '4384147', '4367146', '4388145', '4533522') 
  and O.sOrderType = 'Retail' 
GROUP BY OL.ixSKU
ORDER BY OL.ixSKU


/* Query to determine the total quantities sold of each SKU DURING the running 
  promotion offering the customers free shipping (independent of week) */ 

SELECT OL.ixSKU --50 Rows
     , SUM(OL.iQuantity) AS TotalSold
FROM tblOrderLine OL
JOIN tblOrder O ON OL.ixOrder = O.ixOrder
WHERE OL.ixSKU IN ('83526011179', '91010005', '3254025', '91012800', '91064062', '6178510'
                , '91018040', '91089529', '5752200', '91064088', '3003660', '54561755'
                , '91012805', '91089800', '92517480', '91089411', '91028146', '4103196'
                , '4464130', '42737119', '91032506', '10620110', '491104', '3441094'
                , '91081501', '91081075', '91065016', '91332902', '91017157', '91101001'
                , '63089402', '91628910', '91011520', '5631000', '10680159', '56082250'
                , '91122151', '91628908', '5478222', '91011578', '4811004', '4916096'
                , '5475554', '91012804', '4103294', '91032612', '91013106', '4917000'
                , '91065013', '91032339') 
  and OL.dtOrderDate BETWEEN '10/24/11' AND '04/01/12'
  and OL.flgLineStatus = 'Shipped'
  and O.sOrderChannel IN ('AUCTION','EBAY')
  and O.iShipMethod NOT IN ('3','4', '15', '10', '8', '6')
  and OL.flgKitComponent = '0'
  and O.ixOrder NOT IN ('4286650', '4358951', '4183558', '4347546', '4908249'
                        , '4908249', '4321341', '4244961', '4546653', '4546653'
                        , '4630452', '4140266')
  and O.sOrderType = 'Retail' 
GROUP BY OL.ixSKU
ORDER BY OL.ixSKU