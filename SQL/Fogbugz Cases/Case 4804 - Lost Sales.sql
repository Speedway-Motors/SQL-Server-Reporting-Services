/* Description:  Lost Sales by Period by Year 
*/

select
	distinct(D.iPeriod),
	-- this year
    TY.YearGroup                TY_Year,
	TY.Lines                    TY_Lines,
	TY.LostLines                TY_LostLines,
	TY.MerchandiseRevenue       TY_MerchandiseRevenue,
	TY.LostMerchandiseRevenue   TY_LostMerchandiseRevenue,
	TY.MerchandiseCost          TY_MerchandiseCost,
	TY.LostMerchandiseCost      TY_LostMerchandiseCost,

	-- last year
    LY.YearGroup                LY_Year,
	LY.Lines                    LY_Lines,
	LY.LostLines                LY_LostLines,

	LY.MerchandiseRevenue       LY_MerchandiseRevenue,
	LY.LostMerchandiseRevenue   LY_LostMerchandiseRevenue,
	LY.MerchandiseCost          LY_MerchandiseCost,
	LY.LostMerchandiseCost      LY_LostMerchandiseCost,
	
    -- 2 years ago
    LY2.YearGroup               LY2_Year,
	LY2.Lines                   LY2_Lines,
	LY2.LostLines               LY2_LostLines,
	LY2.MerchandiseRevenue      LY2_MerchandiseRevenue,
	LY2.LostMerchandiseRevenue  LY2_LostMerchandiseRevenue,
	LY2.MerchandiseCost         LY2_MerchandiseCost,
	LY2.LostMerchandiseCost     LY2_LostMerchandiseCost
	
from
	tblDate D
        -- current year
		left join (select 
                        datepart("yyyy",getdate()) YearGroup, -- current year
						tblDate.iPeriod as ThisYearPeriod,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then 1 else 0 end) as Lines,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then mExtendedPrice else 0 end) as MerchandiseRevenue,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then mExtendedCost else 0 end) as MerchandiseCost,
						sum(case when flgLineStatus in ('Lost') then 1 else 0 end) as LostLines,
						sum(case when flgLineStatus in ('Lost') then SKU.mPriceLevel1 else 0 end) as LostMerchandiseRevenue,
						sum(case when flgLineStatus in ('Lost') then mExtendedCost else 0 end) as LostMerchandiseCost
					from
						tblOrderLine OL
						left join tblOrder O on OL.ixOrder = O.ixOrder
						left join tblDate on O.ixOrderDate = tblDate.ixDate
						left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
					where
						not(OL.ixOrder like '%-%')
						and tblDate.iPeriodYear = datepart("yyyy",getdate()) -- current year
						and O.sOrderStatus in ('Open', 'Shipped')
						and OL.flgKitComponent = 0
					group by
                        tblDate.iPeriod
					) TY on TY.ThisYearPeriod = D.iPeriod 
        -- last year
		left join (select 
                        datepart("yyyy",getdate()) YearGroup, -- last year
						tblDate.iPeriod as ThisYearPeriod,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then 1 else 0 end) as Lines,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then mExtendedPrice else 0 end) as MerchandiseRevenue,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then mExtendedCost else 0 end) as MerchandiseCost,
						sum(case when flgLineStatus in ('Lost') then 1 else 0 end) as LostLines,
						sum(case when flgLineStatus in ('Lost') then SKU.mPriceLevel1 else 0 end) as LostMerchandiseRevenue,
						sum(case when flgLineStatus in ('Lost') then mExtendedCost else 0 end) as LostMerchandiseCost
					from
						tblOrderLine OL
						left join tblOrder O on OL.ixOrder = O.ixOrder
						left join tblDate on O.ixOrderDate = tblDate.ixDate
						left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
					where
						not(OL.ixOrder like '%-%')
						and tblDate.iPeriodYear = datepart("yyyy",DATEADD(yy, -1, getdate()) ) -- current year
						and O.sOrderStatus in ('Open', 'Shipped')
						and OL.flgKitComponent = 0
					group by
						tblDate.iPeriod
					) LY on LY.ThisYearPeriod = D.iPeriod 
        -- 2 years ago
		left join (select 
                        datepart("yyyy",getdate()) YearGroup, -- 2 years ago
						tblDate.iPeriod as ThisYearPeriod,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then 1 else 0 end) as Lines,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then mExtendedPrice else 0 end) as MerchandiseRevenue,
						sum(case when flgLineStatus in ('Open', 'Shipped', 'Backordered') then mExtendedCost else 0 end) as MerchandiseCost,
						sum(case when flgLineStatus in ('Lost') then 1 else 0 end) as LostLines,
						sum(case when flgLineStatus in ('Lost') then SKU.mPriceLevel1 else 0 end) as LostMerchandiseRevenue,
						sum(case when flgLineStatus in ('Lost') then mExtendedCost else 0 end) as LostMerchandiseCost
					from
						tblOrderLine OL
						left join tblOrder O on OL.ixOrder = O.ixOrder
						left join tblDate on O.ixOrderDate = tblDate.ixDate
						left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
					where
						not(OL.ixOrder like '%-%')
						and tblDate.iPeriodYear = datepart("yyyy",DATEADD(yy, -2, getdate()) ) -- 2 years ago
						and O.sOrderStatus in ('Open', 'Shipped')
						and OL.flgKitComponent = 0
					group by
						tblDate.iPeriod
					) LY2 on LY2.ThisYearPeriod = D.iPeriod 
order by
	D.iPeriod 

