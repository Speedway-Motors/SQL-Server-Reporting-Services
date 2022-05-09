-- SMIHD-17058 - 2019 AFCO Sales to Hoerr Motor - State - GoFast

-- SMIHD-17054 - 2019 Sales to Racers Speedshop and Motorstate

/*
select ixCustomer, 
    sCustomerFirstName, 
    sCustomerLastName, sMailToCity, sMailToState 
from tblCustomer 
where UPPER(sCustomerFirstName) LIKE '%MOTOR%STATE%'    OR UPPER(sCustomerLastName) LIKE '%MOTOR%STATE%' -- (10164, 10704, 34799, 52106, 53012, 66663, 70092)
     -- UPPER(sCustomerFirstName) LIKE '%HOERR%' OR UPPER(sCustomerLastName) LIKE '%HOERR%' -- (13147,52893)
    -- UPPER(sCustomerFirstName) LIKE '%GO%FAST%' OR UPPER(sCustomerLastName) LIKE '%GO%FAST%'  -- 52815  --, 60772, 63588, 64459)

ixCustr	FirstName	LastName	                    City	State
52815	NULL	    GOFAST SOLUTIONS LLC (LA)	    MADISON	CT
60772	GO FAST	    SOLUTIONS (CSI)	                MADISON	CT
63588	NULL	    GOFAST SOLUTIONS LLC (AFCO/DT)	MADISON	CT
64459	NULL	    GOFAST SOLUTIONS LLC (PRO)	    MADISON	CT

13147	NULL	    HOERR RACING PRODUCTS	        EDWARDS	IL
52893	NULL	    HOERR RACING PRODUCTS (LA)	    EDWARDS	IL

10164	NULL	    MOTOR STATE (AFCO)	            WATERVLIET	MI
10704	NULL	    MOTOR STATE (DT)	            WATERVLIET	MI
34799	NULL	    MOTOR STATE DIST. (PRO)	        WATERVLIET	MI
52106	D/S MOTORSTATE	LONGACRE RACING PRODUCTS	MONROE	    WA
53012	NULL	    MOTOR STATE DISTRIBUTORS (LA)	WATERVLIET	MI
66663	NULL	    MOTOR STATE (DEW)	            WATERVLIET	MI
70092	NULL	    MOTORSTATE (LA-HAZ)	            WATERVLIET	MI
*/

-- GO FAST 2019
SELECT OL.ixSKU 'SKU', ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    SUM(OL.iQuantity) 'QtyOrdered', S.mAverageCost 'AvgUnitCost'
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.ixCustomer in (52815) -- RACER'S SPEEDSHOP
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- normally filtered
    and O.dtOrderDate between '01/01/2019' and '12/31/2019'
    and OL.flgLineStatus in ('Dropshipped','Shipped')
GROUP BY OL.ixSKU, ISNULL(S.sWebDescription, S.sDescription), S.mAverageCost
ORDER BY SUM(OL.iQuantity) DESC

-- HOERR 2019
SELECT OL.ixSKU 'SKU', ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    SUM(OL.iQuantity) 'QtyOrdered', S.mAverageCost 'AvgUnitCost'
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.ixCustomer in (13147,52893) -- RACER'S SPEEDSHOP
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- normally filtered
    and O.dtOrderDate between '01/01/2019' and '12/31/2019'
    and OL.flgLineStatus in ('Dropshipped','Shipped')
GROUP BY OL.ixSKU, ISNULL(S.sWebDescription, S.sDescription), S.mAverageCost
ORDER BY SUM(OL.iQuantity) DESC

-- MOTOR STATE 2019
SELECT OL.ixSKU 'SKU', ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    SUM(OL.iQuantity) 'QtyOrdered', S.mAverageCost 'AvgUnitCost'
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.ixCustomer in (10164, 10704, 34799, 53012, 66663, 70092) --  52106
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- normally filtered
    and O.dtOrderDate between '01/01/2019' and '12/31/2019'
    and OL.flgLineStatus in ('Dropshipped','Shipped')
GROUP BY OL.ixSKU, ISNULL(S.sWebDescription, S.sDescription), S.mAverageCost
ORDER BY SUM(OL.iQuantity) DESC




