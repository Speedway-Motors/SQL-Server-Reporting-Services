-- SMIHD-5392 - New Report - Catalog SKU Performance
/*
Parameters:
@Catalog
@StartDate
@EndDate
We do not currently store the in-home data in SMI Reporting. Also, John would like the ability to enter the date range manually so they can run various sets 
(e.g. compare the catalog SKU performance for the first 2 weeks after in-home vs catalog performance from weeks 3 to 4)
ALL SKUs in the catalog need to be listed in the report even if they have no sales.
*/

SELECT CS.ixSKU 'SpeedwaySKU', 
    VS.sVendorSKU 'PVSKU',
    V.ixVendor 'PVNum',
    V.sName 'PrimaryVendor',
    SKU.sDescription 'SKUDescription',
    SKU.flgUnitOfMeasure 'SellUM',
    SKU.mPriceLevel1 'Price',
    ISNULL(CSPSales.QtySold,0) 'QtySold',
    ISNULL(CSPSales.Sales,0) 'Sales'
FROM (-- Catalog SKUs - need to list ALL SKUs in the designated catalog even if they had no sales
      select distinct ixSKU -- distinct ixSKU -- 7,666
      from tblCatalogDetail
      where ixCatalog = '800'--'@Catalog'     Cat#800 has 6,701 SKUs
      ) CS
    left join tblSKU SKU on CS.ixSKU = SKU.ixSKU
    left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
    left join (--CUST STARTING POOL SALES
             -- Custs that received ANY customer offers tied to the catalog
             SELECT OL.ixSKU,
                    SUM(OL.iQuantity) 'QtySold',
                    SUM(OL.mExtendedPrice) 'Sales'
             FROM tblCustomer C
                join tblCustomerOffer CO on C.ixCustomer = CO.ixCustomer
                join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                join tblCatalogMaster CM on SC.ixCatalog = CM.ixCatalog
                join tblOrder O on O.ixCustomer = C.ixCustomer
                join tblOrderLine OL on OL.ixOrder = O.ixOrder           
             WHERE CM.ixCatalog = '800'--'@Catalog' 
                    and O.sOrderStatus = 'Shipped'
                    and O.dtShippedDate between '09/01/2016' and '09/2/2016' -- @StartDate and @EndDate
                    and O.mMerchandise > 0 
                    and O.sOrderType <> 'Internal'
                    and OL.flgKitComponent = 0  
             GROUP BY OL.ixSKU               
         ) CSPSales on CS.ixSKU = CSPSales.ixSKU
ORDER BY CS.ixSKU

SELECT * from tblSKU where ixSKU = '92616334'

select * from tblSKU where sDescription like '"%'
order by dtCreateDate


-- Run Merchandising > "SKUs loaded per Catalog" to see which catalogs don't have SKUs loaded yet

/*

SELECT top 10 * FROM tblCatalogMaster WHERE   ixCatalog = '801'     


select CM.ixCatalog, COUNT(CD.ixSKU) 'iSKUCount'
from tblCatalogMaster CM
    left join tblCatalogDetail CD on CM.ixCatalog = CD.ixCatalog
where dtEndDate >= '01/01/2016'    
group by CM.ixCatalog
order by COUNT(CD.ixSKU)
    


select * from tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
and (sSourceCodeGiven like '900%'
or sSourceCodeGiven like '905%'
or sSourceCodeGiven like '901%'
or sSourceCodeGiven like '906%'
or sSourceCodeGiven like '902%'
)

select sSourceCodeGiven from tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and sSourceCodeGiven <> sMatchbackSourceCode
and (sMatchbackSourceCode like '900%'
or sMatchbackSourceCode like '905%'
or sMatchbackSourceCode like '901%'
or sMatchbackSourceCode like '906%'
or sMatchbackSourceCode like '902%'
)
order by sSourceCodeGiven

*/

select * from tblSKU
where len(sDescription) > 60