-- SMIHD-2126 - SKU Data for Orders with single orderline

time range last 6 months


SELECT S.ixSKU, S.sDescription,
    S.dWeight, S.iLength, S.iWidth, S.iHeight,
    S.flgIntangible,
FROM tblSKU S
    join
    
    
    
    
SELECT X.ixSKU,
    SUM(X.iQuantity) 'TotQty',
    S.sDescription,
    S.dWeight, S.iLength, S.iWidth, S.iHeight,
    S.flgIntangible
FROM   (-- Orders with one line item  
         SELECT OL.ixOrder, 
            OL.iQuantity, 
            S.ixSKU, S.sDescription,
            S.dWeight, S.iLength, S.iWidth, S.iHeight,
            S.flgIntangible,
           (OL.iQuantity * S.dWeight) 'ExtWeight'
         FROM tblOrderLine OL --on O.ixOrder = OL.ixOrder
            join tblOrder O on O.ixOrder = OL.ixOrder and O.iTotalTangibleLines = 1
            left join tblSKU S on S.ixSKU = OL.ixSKU
         WHERE 
             O.sOrderStatus = 'Shipped'
            and O.dtShippedDate between '09/01/2014' and '08/31/2015'
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.sOrderType <> 'Internal'   -- USUALLY filtered
            and S.flgIntangible = 0   
            and S.flgDeletedFromSOP = 0                          -- 181,563
        GROUP BY OL.ixOrder, 
            OL.iQuantity, 
            S.ixSKU,S.sDescription,    
            S.dWeight, S.iLength, S.iWidth, S.iHeight,
            S.flgIntangible
        HAVING  (OL.iQuantity * S.dWeight) < 4                  -- 114,738 
        --ORDER BY OL.ixOrder
        --ORDER BY (OL.iQuantity * S.dWeight)  
        )X
    left join tblSKU S on S.ixSKU = X.ixSKU
GROUP BY   X.ixSKU,
    S.sDescription,
    S.dWeight, S.iLength, S.iWidth, S.iHeight,
    S.flgIntangible     
-- SUM OF OL qty = 172,496 


SELECT * from tblShipMethod        
/*
ixShip
Method	sDescription	            ixCarrier	sTransportMethod
1	    Counter	                    SMI	        Pickup
2	    UPS Ground	                UPS	        Ground
3	    UPS 2 Day (Blue)	        UPS	        Air
4	    UPS 1 Day (Red)	            UPS	        Air
5	    UPS 3 Day	                UPS	        Air
6	    USPS Priority	            USPS	    Ground
7	    USPS Express	            USPS	    Ground
8	    Best Way	                Misc	    Misc
9	    SpeeDee	                    SpeeDee	    Ground
10	    UPS Worldwide Expedited	    UPS	        Air
11	    UPS Worldwide Saver	        UPS	        Air
12	    UPS Standard	            UPS	        Air/Ground
13	    FedEx Ground	            FedEx	    Ground
14	    FedEx Home Delivery	        FedEx	    Ground
15	    FedEx SmartPost	            FedEx	    Ground
18	    UPS SurePost	            UPS	        Ground
19	    Canada Post	                UPS	        Ground
26	    USPS Priority International	USPS	    Air
27	    USPS Express International	USPS	    Air
32	    UPS 2 Day Economy	        UPS	        Air/Ground
*/



-- SKUS with a NULL dimension
-- 11,047
--  3,621 are active
SELECT ixSKU, mPriceLevel1, ixPGC, sDescription, flgUnitOfMeasure, dtCreateDate, dtDiscontinuedDate, flgActive, 
dWeight, flgAdditionalHandling, ixBrand, flgIsKit, iLength, iWidth, iHeight,  flgShipAloneStatus, flgIntangible, ixCreator, 
sSEMACategory, sSEMASubCategory, sSEMAPart, 
flgMadeToOrder, flgDeletedFromSOP,  sCountryOfOrigin, flgBackorderAccepted, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, sHandlingCode, ixProductLine, mMSRP, ixCAHTC, flgORMD, dDimWeight, mZone4Rate
FROM tblSKU
where flgDeletedFromSOP = 0 
and flgIntangible = 0
and flgActive = 1
and (iLength is NULL
    or iWidth is NULL
    or iHeight is NULL)
order by dtDateLastSOPUpdate