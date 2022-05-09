-- SMIHD-6591 - Detailed Revenue Report
--

DECLARE @StartDate DATETIME,  @EndDate DATETIME
SELECT @StartDate='01/03/2015', @EndDate ='01/01/16' -- '01/03/2015' and '01/01/2016'

/******  temp table - orders containing 1+ Engine SKUs    *******/
    SELECT Distinct OL.ixOrder
    into dbo.#EngineOrders    
    from tblOrderLine OL
	    left join tblSnapshotSKU SS WITH (FORCESEEK) on OL.ixOrderDate = (SS.ixDate) -- ixOrderDate is CORRECT.  per KDL, We want to count them when the customer ordered rather than when it was shipped
	                                    AND OL.ixSKU = SS.ixSKU 
	    left join tblSnapshotSKU ND WITH (FORCESEEK) on OL.ixOrderDate = (ND.ixDate-1) -- PGC value from the NEXT DAY in case the SKU was created the day it was sold
	                                    AND OL.ixSKU = ND.ixSKU 	                                	                                	
	    left join tblPGC PGC on ISNULL(SS.ixPGC,ND.ixPGC) = PGC.ixPGC
	    left join tblOrder O on OL.ixOrder = O.ixOrder
    where 	--we want to use SHIPPED date for purposes of what days the sales $ fall into
        O.dtShippedDate between @StartDate and @EndDate 
        and OL.dtShippedDate between @StartDate and @EndDate -- '05/01/2014' and '05/31/2014' -- 
        and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK			
	    and OL.flgLineStatus in ('Shipped', 'Dropshipped')
	    and (O.sOrderType <> 'Internal')
        and isnull(SS.ixPGC,ND.ixPGC)  in ('Rh','eE')

/******   Main Query    *******/
--DECLARE @StartDate DATETIME,  @EndDate DATETIME
--SELECT @StartDate='01/03/2015', @EndDate ='01/01/16' -- '01/03/2015' and '01/01/2016'
    SELECT  -- 505,923 + 40,934
        (Case when O.sShipToState in ('AE','AA','AP') then 'U.S. Military' 
              when O.sShipToState in ('GU','PR','VI') then 'U.S. Territory'
               when (O.sShipToCountry in ('US', 'USA') OR  O.sShipToCountry IS NULL) then 'U.S'
                else 'Non-U.S.' 
                end) 'GeoGlassification',   -- CASE statement for US, US Military, US Territory   <-- include Non-US too?
     C.ixCustomer 'CustNum',
     LTC.sLocalTaxCode 'LocalTaxCode',                 
     C.sCustomerFirstName 'CustFirstName',
     C.sCustomerLastName 'CustLastName,',
     O.ixOrder 'OrderNum',      
     O.dtShippedDate 'DateShipped',
     (CASE WHEN EO.ixOrder is NOT NULL then 'Engine Shop'
           WHEN EMI.ixOrder is NOT NULL then 'Eagle'
           Else '340 Victory Lane'
           END) as 'Location',    -- Eagle / Engine Shop / 340 Victory Lane
     O.sShipToCOLine 'Att: C/O',
     O.sShipToStreetAddress1 'ShipToStreetAddress1',
     O.sShipToStreetAddress2 'ShipToStreetAddress2',
     O.sShipToCity 'ShipToCity',
     O.sShipToState 'ShipToState',                 
     O.sShipToZip 'ShipToZip',
            (Case when (O.sShipToCountry in ('US', 'USA') OR  O.sShipToCountry IS NULL)
                    then 'U.S'
                    else O.sShipToCountry
               end) ShipToCountry,
     O.mMerchandise 'Mdse',
     O.mShipping 'Shipping',
     O.mTax 'Tax',
     O.mMerchandise+O.mShipping+O.mTax 'SalesTotal'
     -- O.sOrderType
     FROM  tblOrder O
        join tblCustomer C on O.ixCustomer = C.ixCustomer
        left join tblLocalTaxCode LTC on O.sShipToZip = LTC.ixZipCode -- Ship to Zip code OR customers mail to zip code!?!
        left join dbo.#EngineOrders EO on O.ixOrder = EO.ixOrder
        left join vwEagleOrder EMI on O.ixOrder = EMI.ixOrder
     WHERE  O.dtShippedDate between @StartDate and @EndDate -- '01/03/2015' and '01/01/2016'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0    
           
DROP TABLE dbo.#EngineOrders   
-- TRYING TO SEND JERRY THE EXAMPLE OUTPUT FILE NOW     
     
     
     

/********** SECOND REPORT for Credits ****************/     

DECLARE @StartDate DATETIME,  @EndDate DATETIME
SELECT @StartDate='01/03/2015', @EndDate ='01/01/16' -- '01/03/2015' and '01/01/2016'

/******  temp table - orders containing 1+ Engine SKUs    *******/
    SELECT Distinct OL.ixOrder
    into dbo.#EngineOrders    
    from tblOrderLine OL
	    left join tblSnapshotSKU SS WITH (FORCESEEK) on OL.ixOrderDate = (SS.ixDate) -- ixOrderDate is CORRECT.  per KDL, We want to count them when the customer ordered rather than when it was shipped
	                                    AND OL.ixSKU = SS.ixSKU 
	    left join tblSnapshotSKU ND WITH (FORCESEEK) on OL.ixOrderDate = (ND.ixDate-1) -- PGC value from the NEXT DAY in case the SKU was created the day it was sold
	                                    AND OL.ixSKU = ND.ixSKU 	                                	                                	
	    left join tblPGC PGC on ISNULL(SS.ixPGC,ND.ixPGC) = PGC.ixPGC
	    left join tblOrder O on OL.ixOrder = O.ixOrder
        left join vwEagleOrder EMI on O.ixOrder = EMI.ixOrder	    
    where 	--we want to use SHIPPED date for purposes of what days the sales $ fall into
        O.dtShippedDate between @StartDate and @EndDate 
        and OL.dtShippedDate between @StartDate and @EndDate -- '05/01/2014' and '05/31/2014' -- 
        and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK			
	    and OL.flgLineStatus in ('Shipped', 'Dropshipped')
	    and (O.sOrderType <> 'Internal')
        and isnull(SS.ixPGC,ND.ixPGC)  in ('Rh','eE')
                                
--CREDITS
--DECLARE @StartDate DATETIME,  @EndDate DATETIME
--SELECT @StartDate='01/03/2015', @EndDate ='01/01/16' -- '01/03/2015' and '01/01/2016'
             SELECT 
                 (Case when C.sMailToState in ('AE','AA','AP') then 'U.S. Military' 
                       when C.sMailToState in ('GU','PR','VI') then 'U.S. Territory'
                       when (C.sMailToCountry in ('US', 'USA') OR  C.sMailToCountry IS NULL) then 'U.S'
                       else 'Non-U.S.' 
                  end) 'GeoGlassification',   -- CASE statement for US, US Military, US Territory   <-- include Non-US too?
                CMM.ixCustomer, -- 40,934
                LTC.sLocalTaxCode 'LocalTaxCode',  
                C.sCustomerFirstName,C.sCustomerLastName, 
                C.sMailToCOLine 'MailToCO',
                C.sMailToStreetAddress1 'MailToStreetAddress1',
                C.sMailToStreetAddress2 'MailToStreetAddress1',
                C.sMailToCity 'MailToCity',
                C.sMailToState 'MailToState',
                C.sMailToCountry 'MailToCountry',
                C.sMailToZip 'MailToZip',
                CMM.ixCreditMemo, 
                CMM.dtCreateDate 'CreditMemoCreated',
                CMM.ixOrder 'OrderNum',                   
                 (CASE WHEN EO.ixOrder is NOT NULL then 'Engine Shop'
                       WHEN EMI.ixOrder is NOT NULL then 'Eagle'
                       Else '340 Victory Lane'
                       END) as 'Location',    -- Eagle / Engine Shop / 340 Victory Lane                
                CMM.ixOrder,
                CMM.mMerchandise 'MerchCredit',  
                CMM.mShipping 'ShippingCredit',                  
                CMM.mTax 'SalesTaxCredit',
                CMM.mRestockFee 'RestockFee' 
             FROM tblCreditMemoMaster CMM
                join tblCustomer C on CMM.ixCustomer = C.ixCustomer
                left join dbo.#EngineOrders EO on CMM.ixOrder = EO.ixOrder
                left join vwEagleOrder EMI on CMM.ixOrder = EMI.ixOrder
                left join tblLocalTaxCode LTC on C.sMailToZip = LTC.ixZipCode -- Ship to Zip code OR customers mail to zip code!?!                
             WHERE CMM.dtCreateDate between @StartDate and @EndDate
                AND CMM.flgCanceled = 0
             --ORDER BY 
DROP TABLE dbo.#EngineOrders            
     
     
     
     
  
     
SELECT TOP 10 * FROM tblCreditMemoMaster CMM     












SELECT isNull(SALES.ShipToState,RBS.MailToState) 'State/Country',
       isNull(SALES.SortOrd,RBS.SortOrd) SortOrd,
       SALES.Sales,
       SALES.Shipping,
       RBS.RetMerch,
       RBS.RetShipping
FROM
         -- US ORDERS BY STATE
         (SELECT   O.sShipToState            ShipToState,
                  (Case when O.sShipToState in ('AE','AA','AP') then 'U.S. Military' 
                            when O.sShipToState in ('GU','PR','VI') then 'U.S. Territory'
                   else 'U.S.' 
                   end) SortOrd,
                  sum(O.mMerchandise)        Sales,
                  sum(O.mShipping)           Shipping
         FROM  tblOrder O
         WHERE  O.dtShippedDate >= @StartDate
            and O.dtShippedDate < (@EndDate +1)
            and (O.sShipToCountry in ('US', 'USA') 
                    OR (O.sShipToCountry IS NULL AND O.sShipToState in (select ixState from tblStates)))
            and O.sOrderStatus = 'Shipped'
         GROUP BY O.sShipToState
   UNION ALL
         -- FOREIGN ORDERS BY COUNTRY
         SELECT   O.sShipToCountry           ShipToState,
                  'Non U.S.' as                     SortOrd,
                  sum(O.mMerchandise)        Sales,
                  sum(O.mShipping)           Shipping
         FROM  tblOrder O
         WHERE  O.dtShippedDate >= @StartDate
            and O.dtShippedDate < (@EndDate +1)
            and ((O.sShipToCountry NOT in ('US', 'USA') AND O.sShipToCountry IS NOT NULL)
                            OR  (O.sShipToCountry IS NULL AND O.sShipToState NOT in (select ixState from tblStates)))
            and O.sOrderStatus = 'Shipped'
         GROUP BY O.sShipToCountry
         ) SALES
FULL OUTER JOIN
         -- RETURNS BY STATE
         (select CUST.sMailToState MailToState,
                  (Case when CUST.sMailToState  in ('AE','AA','AP') then 'U.S. Military' 
                            when CUST.sMailToState  in ('GU','PR','VI') then 'U.S. Territory'
                   else 'U.S.' 
                   end) SortOrd,
               SUM(CMM.mMerchandise) RetMerch,
               SUM(CMM.mShipping)    RetShipping
         from    tblCreditMemoMaster CMM 
            join tblCustomer CUST on CUST.ixCustomer = CMM.ixCustomer
         where  CMM.flgCanceled = 0
            and CMM.dtCreateDate >= @StartDate
            and CMM.dtCreateDate < (@EndDate +1)

           and (CUST.sMailToCountry in ('US', 'USA') 
                    OR (CUST.sMailToCountry IS NULL AND CUST.sMailToState in (select ixState from tblStates)))
         group by CUST.sMailToState
   UNION ALL
         -- FOREIGN RETURNS
         select CUST.sMailToCountry MailToState,
                  'Non U.S.' as             SortOrd,
               SUM(CMM.mMerchandise) RetMerch,
               SUM(CMM.mShipping)    RetShipping
         from    tblCreditMemoMaster CMM 
            join tblCustomer CUST on CUST.ixCustomer = CMM.ixCustomer
         where  CMM.flgCanceled = 0
            and CMM.dtCreateDate >= @StartDate
            and CMM.dtCreateDate <  (@EndDate +1)
            and ((CUST.sMailToCountry NOT in ('US', 'USA') AND  CUST.sMailToCountry IS NOT NULL)
                            OR (CUST.sMailToCountry IS NULL AND CUST.sMailToState NOT in (select ixState from tblStates)))
         group by CUST.sMailToCountry
         ) RBS ON RBS.MailToState = SALES.ShipToState
                 AND RBS.SortOrd = SALES.SortOrd
   ORDER BY SortOrd desc , 'State/Country'
   
   
 (--ALL customers with 1+ orders or credit memos in the date range provided
      SELECT DISTINCT C.ixCustomer
        FROM  tblOrder O
            join tblCustomer C on O.ixCustomer = C.ixCustomer    
        WHERE O.dtShippedDate between @StartDate and @EndDate
            and O.sOrderStatus = 'Shipped'
            and O.mMerchandise > 0
      UNION 
        SELECT DISTINCT CMM.ixCustomer
        FROM  tblCreditMemoMaster CMM
            join tblCustomer C on CMM.ixCustomer = C.ixCustomer    
        WHERE CMM.dtCreateDate between @StartDate and @EndDate
          AND CMM.flgCanceled = 0
    ) AC   