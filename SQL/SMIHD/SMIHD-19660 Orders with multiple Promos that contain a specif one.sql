-- SMIHD-19660 Orders with multiple Promos that contain a specif one
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '12/12/20',    @EndDate = '01/03/21' 

    SELECT SP.ixOrder, O.mMerchandise, SP.ixPromoId as 'ixPromoId',
        sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount'
    FROM tblSKUPromo SP 
        left join tblOrder O on O.ixOrder = SP.ixOrder  
    WHERE O.dtOrderDate between @StartDate and @EndDate               
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0
        and len(SP.ixPromoId) > 4 -- hack to avoid contactinated promos (2 or 3 applies to same order!)
        and SP.ixPromoId LIKE '%2049%'
    GROUP BY SP.ixOrder,O.mMerchandise, SP.ixPromoId




/* how many orders had multiple promos applied

DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/01/20',    @EndDate = '12/31/20' 

SELECT distinct O.ixOrder
FROM tblSKUPromo SP 
    left join tblOrder O on O.ixOrder = SP.ixOrder  
WHERE O.dtOrderDate between @StartDate and @EndDate               
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- 54,738
    and len(SP.ixPromoId) > 4 --259          hack to avoid contactinated promos (2 or 3 applies to same order!)

    -- 259 orders out of 54,738 had more than 1 promo applied (0.47%)
*/
