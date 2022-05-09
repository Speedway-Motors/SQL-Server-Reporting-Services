-- SMIHD-5417 Gift Card Buyers report

/*list of customers where the only item in their cart was a gift card, broken out between electronic and physical.

Ron pulled a list awhile ago so he may still have the query available.

customer#, 
which gift card, 
possibly location so we could tell if the gift went to the purchaser or was sent to a different recipient.

We would also like to be able to pull a list of customers that purchased products from the Apparel and Gift category as their only products in the cart.

The goal is to generate a list of customers that we can then email to remind them they can purchase gifts again.  Please let me know what questions you may have or thoughts on how to improve this kind of report.

*/



-- Ron's original Query
select gc.dtDateIssued -- 249
    , o.ixCustomer
    , o.ixOrder
    , gc.mAmountIssued, gc.mAmountOutstanding
    , count(1) over( Partition by o.ixCustomer,gc.dtDateIssued ) as QuantityOrdered
    , count(1) over( Partition by o.ixCustomer) as QuantityOrderedDuringReportTimeFrame
    , (case when -- isnull(c.sMailToStreetAddress1,'') <> isnull(o.sShipToStreetAddress1,'')
    -- 	or isnull(c.sMailToStreetAddress2,'') <> isnull(o.sShipToStreetAddress2,'')
    --	or isnull(c.sMailToCity,'')  <> isnull(o.sShipToCity,'')
    --	or isnull(c.sMailToState,'') <> isnull(o.sShipToState,'')
    --	or
    isnull(c.sMailToZip,'') <> isnull(o.sShipToZip,'')
    then 1
    else 0
    end) as 'DifferentShipto'
    -- This is just additional Information so in case it is needed.
    , c.sCustomerFirstName, c.sCustomerLastName, c.sMailToStreetAddress1, c.sMailToStreetAddress2, c.sMailToState,c.sMailToCity, c.sMailToZip
    , o.sShipToName, o.sShipToStreetAddress1, o.sShipToStreetAddress2, o.sShipToCity, o.sShipToState, o.sShipToZip
    ,gc.ixOrder

from tblGiftCardMaster gc
    inner join tblOrder o on gc.ixOrder = o.ixOrder
    inner join tblCustomer c on o.ixCustomer = c.ixCustomer
where c.sMailToState <> o.sShipToState
		and	c.ixCustomer not in ('746028', '2136244','732941','6621734','1857255','1299266') -- Exclude speedwaymotors customers. ALL HAVE ixCustomerType = '45' <-- Employees  6 additional records where employees
		and	gc.dtDateIssued >= '01/01/2015'  -- Date to be supplied from SSRS
		and	gc.dtDateIssued < '01/01/2016' -- Date to be supplied from SSRS
		-- and o.ixOrder = '5940490'
order by gc.dtDateIssued desc

-- SELECT * from tblCustomer where ixCustomer in ('746028', '2136244','732941','6621734','1857255','1299266')







-- PAT'S mods
select   --  C.ixCustomerType,
DISTINCT
    GC.dtDateIssued -- 249
    , O.ixCustomer
    , O.ixOrder
    , OL.ixSKU, OL.iQuantity, OL.mExtendedPrice, S.sDescription 'SKUDescription', S.flgIntangible, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart
    , O.iTotalOrderLines, O.iTotalTangibleLines
    , (case when isnull(C.sMailToStreetAddress1,'') <> isnull(O.sShipToStreetAddress1,'')
        then 1
    else 0
    end) as 'DifShipTo'
    -- This is just additional Information so in case it is needed.
    , (case when isnull(C.sEmailAddress,'') <> isnull(O.sShipToEmailAddress,'')
        then 1
    else 0
    end) as 'DifEmailTo'
    , C.sCustomerFirstName, C.sCustomerLastName, C.sMailToStreetAddress1, C.sMailToStreetAddress2, C.sMailToState,C.sMailToCity, C.sMailToZip
    , O.sShipToName, O.sShipToStreetAddress1, O.sShipToStreetAddress2, O.sShipToCity, O.sShipToState, O.sShipToZip
    ,GC.ixOrder
from tblGiftCardMaster GC
    LEFT join tblOrder O on GC.ixOrder = O.ixOrder
    LEFT join tblCustomer C on O.ixCustomer = C.ixCustomer
    LEFT join tblOrderLine OL on O.ixOrder = OL.ixOrder
    LEFT join tblSKU S on S.ixSKU = OL.ixSKU
where -- C.sMailToState <> O.sShipToState
		--and	C.ixCustomer in ('746028', '2136244','732941','6621734','1857255','1299266') -- Exclude speedwaymotors customers ALL HAVE ixCustomerType = '45' <-- Employees
		GC.dtDateIssued between '09/01/2015' and '08/31/2016'
		and C.ixCustomerType = '1'
		-- and C.ixCustomerType NOT IN ('44','45','46') -- EMPLOYEE, FOR SPEEDWAY INVENTORY TRACKING/PROMOS/ETC., SMI INTERNAL - GIFT CARD ACCOUNT   -- 241
		and O.sOrderStatus = 'Shipped' 
		and O.mMerchandise > 0 
        and O.sOrderType <> 'Internal'   -- 166
        and OL.mExtendedPrice > 0
ORDER BY S.flgIntangible, S.sDescription -- OL.ixSKU
-- order by C.ixCustomerType, GC.dtDateIssued desc

select * from tblCustomerType

select C.ixCustomerType, CT.sDescription, CT.sCustomerType, count(*)
from tblCustomer C
 join tblCustomerType CT ON C.ixCustomerType = CT.ixCustomerType
where flgDeletedFromSOP = 0
 --and CT.ixCustomerType is NULL
and C.sMailingStatus not in ('7','8','9')
group by C.ixCustomerType, CT.sDescription, CT.sCustomerType
order by C.ixCustomerType, CT.sCustomerType

select ixCustomerType 'CustomerType', ixCustomer 'Customer', dtDateLastSOPUpdate
from tblCustomer 
where ixCustomerType in ('0','01','5','70','Y')

SELECT * from tblOrder where ixCustomer in ('668241','2870456','347223','166554','2592867','2840047','485729','924405')


select * from tblOrder where ixOrder = '5940490'
select * from tblOrderLine where ixOrder = '5940490'
select * from tblCustomer where ixCustomer = '162265'

select top 10 * from tblGiftCardMaster





/*
DECLARE @StartDate datetime,    @EndDate datetime
SELECT @StartDate = '09/01/2015',    @EndDate = '08/31/2016'
*/
SELECT O.ixCustomer, O.ixOrder, O.dtOrderDate, O.sOrderChannel,
    OL.ixSKU, OL.iQuantity, OL.mUnitPrice, OL.mExtendedPrice, 
   (CASE WHEN isnull(C.sMailToStreetAddress1,'') <> isnull(O.sShipToStreetAddress1,'')
        then 1
    else 0
    end) as 'DifShipTo', 
    C.sEmailAddress 'CurrentCustEmail', --S.sDescription
    O.sShipToEmailAddress 'OrderEmail',
   (CASE WHEN isnull(C.sEmailAddress,'') <> isnull(O.sShipToEmailAddress,'')
        then 1
    else 0
    end) as 'DifOrderEmail'     
    --, COUNT(*) 'OrderLines' -- 4,904 orders contained 1+ GC ordered by the customer    10,009
 --   ,O.dtDateLastSOPUpdate
from tblGiftCardMaster GCM 
    join tblOrderLine OL on GCM.ixOrder = OL.ixOrder
    join tblOrder O on O.ixOrder = OL.ixOrder
--    LEFT join tblSKU S on S.ixSKU = OL.ixSKU
    LEFT join tblCustomer C on O.ixCustomer = C.ixCustomer    
where OL.flgLineStatus = 'Shipped'
    and O.sOrderStatus = 'Shipped'
    and O.ixCustomerType = '1'
    and OL.mExtendedPrice > 0 -- 34,354
    and O.dtOrderDate between @StartDate and @EndDate -- '09/01/2015' and '08/31/2016'
    --and O.iTotalOrderLines >1 -- 2,599 contain only 1 orderline
    and O.ixOrder NOT in (Select distinct O.ixOrder
                          from tblGiftCardMaster GCM 
                            join tblOrderLine OL on GCM.ixOrder = OL.ixOrder
                            join tblOrder O on O.ixOrder = OL.ixOrder
                            join tblSKU SKU on OL.ixSKU = SKU.ixSKU
                          where O.dtOrderDate between @StartDate and @EndDate -- '09/01/2015' and '08/31/2016'
                              and O.sOrderStatus = 'Shipped'
                              and OL.ixSKU NOT IN ('EGIFT','GIFT-SMI','GIFT-SR','GIFT-RACE','GIFT-SPRINT')                              
                              and OL.flgLineStatus = 'Shipped'
                              and SKU.flgIntangible = 0
                            )
    and C.sEmailAddress is NOT NULL    
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
--    and O.sOrderChannel = 'INTERNAL'
    
order by  O.ixCustomer, O.ixOrder, OL.ixSKU -- O.sShipToEmailAddress  --   -- 2,328 no order email  O.dtDateLastSOPUpdate -- 
                     
group by OL.ixSKU
order by  COUNT(*) desc   
    
/*
Order
Lines	ixSKU
1298	EGIFT
1254	GIFT-SMI
730	    GIFT-SR
423	    GIFT-RACE
123	    GIFT-SPRINT
*/    







