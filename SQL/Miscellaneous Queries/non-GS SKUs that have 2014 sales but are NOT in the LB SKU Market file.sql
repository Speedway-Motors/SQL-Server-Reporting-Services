-- non- GS SKUs that have 2014 sales but are NOT in the LB SKU Market file
select distinct OL.ixSKU 'SKUSOP', S.sDescription 'SKUDescriptionSOP', S.sSEMACategory 'SEMACategorySOP', S.flgActive 'ActiveSOP',
    S.ixPGC 'PGC',  
    M.sDescription 'SOPMarket',
    NULL 'tngMarket',
    SUM(OL.mExtendedPrice) '12MoSales', 
    SUM(OL.iQuantity) QtySold
 from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    join [SMITemp].dbo.[PJC_SKUsWithNoTNGMarketsAssigned] TNG on OL.ixSKU = TNG.ixSKU 
    left join tblPGC PGC on S.ixPGC = PGC.ixPGC
    left join tblMarket M on M.ixMarket = PGC.ixMarket
  --  join vwCSTStartingPool CST on CST.ixCustomer = O.ixCustomer        ONLY add this condition if you want to filter out the ones LB doesn't need
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2014' and '12/31/2014'
    and OL.mUnitPrice > 0
    and OL.flgKitComponent = 0
    and S.flgIntangible = 0
    AND SUBSTRING(S.ixPGC,2,1) = UPPER(SUBSTRING(S.ixPGC,2,1)) -- 2nd char of ixPGC is UPPER CASE and therefore NOT CURRENTLY a Garage Sale SKU
group by  OL.ixSKU, S.sDescription , S.sSEMACategory, S.ixPGC , S.flgActive
, M.sDescription 
order by SUM(OL.mExtendedPrice) desc 