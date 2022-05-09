    -- SMIHD-19189 - Counter Order Piece Counts

/*
Average Lines per Order 
Average items per order for LNK. 

Ranges:
9.5.20-10.2.20 
10.3.20-10.30.20
10.31.20 to 12.2.20
*/
-- select * from tblLocation

/* Counter Order Piece Counts.rdl
    ver 49.1.1
DECLARE @StartDate datetime,        @EndDate datetime,      @Location as int
SELECT  @StartDate = '12/31/2020',    @EndDate = '12/02/2020',  @Location = 99
*/
SELECT count(distinct OL.ixOrder) 'OrderCount', 
    count(OL.ixSKU) 'OLineCount', 
    SUM(OL.iQuantity) 'TotSKUQty'
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
WHERE O.ixBusinessUnit = (CASE WHEN  @Location = 99 THEN 106 -- RETLNK
                                WHEN @Location = 85 THEN 111 -- RETTOL
                          ELSE 112 -- Uknown
                          END)
    and O.dtInvoiceDate between @StartDate and @EndDate -- '10/03/2020' and '10/30/2020' 
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'
    --and OL.flgKitComponent = 0  -- count kit component lines per JJ
    and S.flgIntangible = 0
    and S.ixSKU NOT like '%HELP%'
    and O.iShipMethod = 1
    --and O.ixPrimaryShipLocation = 99
/*
Order   OLine   Tot
Count	Count	SKUQty
912	    2751	6921
*/

-- 10.31.20 to 12.2.20

SELECT * FROM tblBusinessUnit


SELECT S.ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription' , S.flgIntangible, OL.flgKitComponent
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
where O.ixBusinessUnit = 106 -- RETLNK
    and O.dtInvoiceDate between '09/05/2020' and '10/02/2020'
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'
    and S.flgIntangible = 0
    and S.ixSKU NOT like '%HELP%'
    and OL.flgKitComponent = 0
    and S.mPriceLevel1 = 0
    and O.ixPrimaryShipLocation = 99





select * from tblBusinessUnit
 */

