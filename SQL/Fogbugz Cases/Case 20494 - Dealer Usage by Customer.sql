-- Case 20494 - Dealer Usage by Customer

-- !!! Once completed change the SQL in the sister report !!!
-- !!! REPLACE  O.sSourceCodeGiven IN (@DealerType)
-- !!! WITH     O.sOrderType IN (@DealerType) 


DECLARE
    @EndDate datetime
SELECT
    @EndDate = '12/01/13'  
	
	select C.ixCustomer
	    , C.sCustomerFirstName 'FirstName'
	    , C.sCustomerLastName 'LastName'
	    , C.sCustomerType 'CurrentCustType'
	    , C.iPriceLevel 'CurentPriceLevel'
	    ,OL.ixSKU
	    ,SKU.sDescription 'SKUDescription',
	    /* -- from Chris' query on another case
	   OL.ixSKU as 'SKU',
       SKU.sDescription as 'Description',
       O.sOrderType as 'Order Type',
       (PGC.ixPGC + ' - ' + PGC.sDescription) as 'PGC & Market',
       SKU.sSEMACategory as 'SEMA Level1',
       SKU.sSEMASubCategory as 'SEMA Level2',
       SKU.sSEMAPart as 'SEMA Level3',
       */
	    sum(case when OL.dtOrderDate between DATEADD(YY,-1,@EndDate) and @EndDate then (OL.iQuantity) else 0 end) as '0-12 Qty', 
	    sum(case when OL.dtOrderDate between DATEADD(YY,-1,@EndDate) and @EndDate then (OL.mExtendedPrice) else 0 end) as '0-12 Rev',
	    sum(case when OL.dtOrderDate between DATEADD(YY,-1,@EndDate) and @EndDate then (OL.mExtendedCost) else 0 end) as '0-12 Cost',
	    sum(case when OL.dtOrderDate between DATEADD(YY,-2,@EndDate) and DATEADD(YY,-1,@EndDate) then (OL.iQuantity) else 0 end) as '13-24 Qty',
	    sum(case when OL.dtOrderDate between DATEADD(YY,-2,@EndDate) and DATEADD(YY,-1,@EndDate) then (OL.mExtendedPrice) else 0 end) as '13-24 Rev',
	    sum(case when OL.dtOrderDate between DATEADD(YY,-2,@EndDate) and DATEADD(YY,-1,@EndDate) then (OL.mExtendedCost) else 0 end) as '13-24 Cost'	    
	from 
	tblOrderLine OL
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
	join tblCustomer C on O.ixCustomer = C.ixCustomer
where	
	O.sOrderType = 'PRS' --IN ('PRS','MR') --O.sSourceCodeGiven IN (@DealerType) -- = 'PRS' --change to MRR for MrRoadster
	and OL.flgKitComponent = 0
	and OL.flgLineStatus in ('Shipped', 'Open')
	and OL.dtOrderDate between DATEADD(YY,-2,@EndDate) AND @EndDate--DATEADD(YY,-2,@EndDate) and @EndDate
	and SKU.flgIntangible = 0
	and O.sOrderChannel <> 'INTERNAL'
GROUP BY C.ixCustomer
	    ,C.sCustomerFirstName
	    ,C.sCustomerLastName
	    ,C.sCustomerType
	    ,C.iPriceLevel
	    ,OL.ixSKU
	    ,SKU.sDescription
	    /* -- from Chris' query on another case
       OL.ixSKU, SKU.sDescription, O.sOrderType, (PGC.ixPGC + ' - ' + PGC.sDescription), SKU.sSEMACategory, SKU.sSEMASubCategory, SKU.sSEMAPart	 
       */   	
ORDER BY ixSKU, ixCustomer
-- CONFIRMED THE TOTAL SALES for the past two years comes out to =  $16,785,528 	
	
	
	
	
	
	
	
/******* COMPARING DIF when using OrderType vs SourceCodeGiven *******/
	                -- based on sSourceCodeGiven
	                DECLARE
                    @EndDate datetime
                SELECT
                    @EndDate = '11/20/13'  
                    
	                select 
	                --O.ixOrder, 
	                SUM(mExtendedPrice) Sales
	                --O.sSourceCodeGiven, O.sOrderType, OL.mExtendedCost --  $16,006,908
	                --,O.ixOrder--,DATEADD(YY,-2,@EndDate) 'Start', @EndDate 'End'
	                from
	                tblOrder O
	                left join tblOrderLine OL on OL.ixOrder = O.ixOrder
	                left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
                where	
	                O.sSourceCodeGiven IN ('PRS','MR') --O.sSourceCodeGiven IN (@DealerType) -- = 'PRS' --change to MRR for MrRoadster
	                and OL.flgKitComponent = 0
	                and OL.flgLineStatus in ('Shipped', 'Open')
	                and OL.dtOrderDate between DATEADD(YY,-2,@EndDate) AND @EndDate--DATEADD(YY,-2,@EndDate) and @EndDate
	                and SKU.flgIntangible = 0
	                and O.sOrderChannel <> 'INTERNAL'
                --and	O.sSourceCodeGiven <> O.sOrderType
                   GROUP BY 
                ORDER BY O.ixOrder

        -- VS.

                -- based on sOrderType   $298,329,269
                DECLARE
                    @EndDate datetime
                SELECT
                    @EndDate = '11/20/13'  
                	
	                select SUM(mExtendedPrice) Sales                    -- $16,763,056
	                --O.sSourceCodeGiven, O.sOrderType, OL.mExtendedCost
	                from
	                tblOrderLine OL
	                left join tblOrder O on OL.ixOrder = O.ixOrder
	                left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
                where	
	                O.sOrderType IN ('PRS','MR') --O.sSourceCodeGiven IN (@DealerType) -- = 'PRS' --change to MRR for MrRoadster
	                and OL.flgKitComponent = 0
	                and OL.flgLineStatus in ('Shipped', 'Open')
	                and OL.dtOrderDate between DATEADD(YY,-2,@EndDate) AND @EndDate--DATEADD(YY,-2,@EndDate) and @EndDate
	                and SKU.flgIntangible = 0
	                and O.sOrderChannel <> 'INTERNAL'
                --and	O.sSourceCodeGiven <> O.sOrderType
                	
                	


                select SUM(mMerchandise)
                from tblOrder
                where dtOrderDate >= '11/21/2011' -- 195,116,303

	
	
	
