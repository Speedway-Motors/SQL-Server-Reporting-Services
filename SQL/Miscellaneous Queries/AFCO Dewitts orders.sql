
/*select *
from tblCatalogMaster
where ixCatalog like 'DW%'
or ixCatalog like '%DW'
*/


-- AFCO Dewitts Backorders
select distinct ixOrder
into #DewittsBackorders
from tblOrder
where sOrderStatus = 'Backordered'
        AND ixOrder in (select distinct ixOrder 
                        from tblOrderLine 
                        where ixSKU like '32-%'
                        and flgLineStatus= 'Backordered')
        --OR 
        --sSourceCodeGiven in
        --                    (select ixSourceCode
        --                    from tblSourceCode
        --                    where ixCatalog in (
        --                                        select ixCatalog
        --                                        from tblCatalogMaster
        --                                        where ixCatalog like 'DW%'
        --                                            or ixCatalog like '%DW'
        --                                        )
        --                    )
        -- )
        --and sSourceCodeGiven NOT IN ('DW2020') -- 34 backorders
order by sSourceCodeGiven



select distinct ixOrder, sSourceCodeGiven
from tblOrder
where sOrderStatus = 'Backordered'
and sSourceCodeGiven IN ('DW2020') 
and ixOrder NOT IN (select distinct ixOrder 
                        from tblOrderLine 
                        where ixSKU like '32-%'
                        and flgLineStatus= 'Backordered')

