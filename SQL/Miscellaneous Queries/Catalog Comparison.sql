/* compare Catalogs 293 & 302 */

select
    SKU.ixPGC               as 'SKU Product Group Code',
    SKU.ixSKU               as 'SKU',
    SKU.sDescription        as 'SKU Description',
    SKU.mPriceLevel1        as 'Retail',
    sum(OL.iQuantity)       as '12 Mo Actual Units Sold',
    sum(OL.mExtendedPrice)  as '12 Mo Sales',
    sum(OL.mExtendedCost)   as '12 Mo Cost of Goods',
    'Y'                     as 'OrigCat',
    null                    as 'NewCat'
from
    tblCatalogMaster CM
    join tblCatalogDetail CD    on CM.ixCatalog = CD.ixCatalog
    left join tblOrderLine OL   on OL.ixSKU = CD.ixSKU
    join tblSKU SKU             on CD.ixSKU = SKU.ixSKU
    left join tblOrder O        on OL.ixOrder = O.ixOrder
where CM.ixCatalog = '293' -- @OrigCat
    and OL.flgLineStatus in ('Shipped', 'Dropshipped')               
    and OL.dtShippedDate >= DATEADD(yy, -1, getdate())  --  1 year ago to date
    and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK
group by
    SKU.ixSKU,
    SKU.sDescription,
    SKU.mPriceLevel1,
    SKU.ixPGC





SELECT isnull(OldCat.ixSKU,NewCat.ixSKU) as ixSKU,
        (case when OldCat.Cat = 'Y' and NewCat.Cat = 'Y' then 'Same'
              when OldCat.Cat = 'Y' and NewCat.Cat is null then 'Dropped'
              when OldCat.Cat is null and NewCat.Cat = 'Y' then 'Added'
              else 'WTH?'
         end) SKUStatus   
FROM
    (select distinct CD.ixSKU,
        'Y' as 'Cat'
    from tblCatalogDetail CD
    where CD.ixCatalog = '293' --10100
    ) OldCat
FULL OUTER JOIN
    (select distinct CD.ixSKU,
         'Y' as 'Cat'
    from tblCatalogDetail CD
    where CD.ixCatalog = '302' -- 8259
    ) NewCat on OldCat.ixSKU = NewCat.ixSKU

-- summary
SELECT SKUStatus, count(*) QTY
from PJC_DualCatSKUStatus
group by SKUStatus


select * from PJC_DualCatSKUStatus
order by ixSKU