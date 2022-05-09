-- SMIHD-5964 - 12 Month sales for SKUs with warnings and or notes

/* 
    Received multiple files on the ticket and directly from Al with wrong format.  It turns out they were telling Al the wrong field and most of them contained customer #'s.
    Final file received looks to be a mix of SKUs, Base SKUs and garbage.. approx 90%, 5%, 5% respectively.
*/    

-- manually deduped the file provided
select COUNT(ixSKU) from [SMITemp].dbo.PJC_SMIHD5964_SKUsWithWarningsOrNotes -- 15,916
select COUNT(DISTINCT ixSKU) from [SMITemp].dbo.PJC_SMIHD5964_SKUsWithWarningsOrNotes -- 15,916

-- dupes have been removed
SELECT ixSKU, COUNT(*)
from [SMITemp].dbo.PJC_SMIHD5964_SKUsWithWarningsOrNotes
group by ixSKU
having COUNT(*) > 1



-- valid SKUs
select DISTINCT ixSKU -- 15,178
into [SMITemp].dbo.PJC_SMIHD5964_SKUs
from [SMITemp].dbo.PJC_SMIHD5964_SKUsWithWarningsOrNotes
where ixSKU IN (SELECT ixSKU from tblSKU where flgDeletedFromSOP = 0) 

-- SKU bases
select DISTINCT ixSKU -- 418
into [SMITemp].dbo.PJC_SMIHD5964_SKUBases
-- DROP TABLE [SMITemp].dbo.PJC_SMIHD5964_SKUBases
from [SMITemp].dbo.PJC_SMIHD5964_SKUsWithWarningsOrNotes
where ixSKU IN (SELECT ixBaseSKU from tblSKUIndex ) 

-- assorted junk (neither SKU or SKU base)
select DISTINCT ixSKU -- 320
into [SMITemp].dbo.PJC_SMIHD5964_UnknownSKUs
from [SMITemp].dbo.PJC_SMIHD5964_SKUsWithWarningsOrNotes
where ixSKU NOT IN (SELECT ixSKU from tblSKU where flgDeletedFromSOP = 0) 
and ixSKU NOT IN (SELECT ixBaseSKU from tblSKUIndex ) 



-- 12 Month sales for SKUs
SELECT TS.ixSKU,
    ISNULL(SALES.[12MoSales],0) '12MoSales'
FROM [SMITemp].dbo.PJC_SMIHD5964_SKUs TS
    left join (-- 12 MONTH SALES
               SELECT ixSKU, ISNULL(sum(OL.mExtendedPrice),0) '12MoSales'
               FROM tblOrderLine OL                               
                join tblOrder O on O.ixOrder = OL.ixOrder 
                            and O.sOrderStatus = 'Shipped'  
                            and O.sOrderType <> 'Internal'  
                            and O.mMerchandise > 0 
                            and O.dtShippedDate between '11/21/2015' and '11/20/2016'
                WHERE OL.flgLineStatus in ('Shipped','Dropshipped')
                GROUP BY ixSKU                            
                ) SALES on TS.ixSKU = SALES.ixSKU
ORDER BY ISNULL(SALES.[12MoSales],0) DESC



-- 12 Month sales for SKUs
SELECT TS.ixSKU,
    ISNULL(SALES.[12MoSales],0) '12MoSales'
FROM [SMITemp].dbo.PJC_SMIHD5964_SKUBases TS
    left join (-- 12 MONTH SALES
               SELECT SI.ixBaseSKU, ISNULL(sum(OL.mExtendedPrice),0) '12MoSales'
               FROM tblOrderLine OL   
                join tblSKUIndex SI on OL.ixSKU = SI.ixSKU  
                join tblSKU S on OL.ixSKU = S.ixSKU                          
                join tblOrder O on O.ixOrder = OL.ixOrder 
                            and O.sOrderStatus = 'Shipped'  
                            and O.sOrderType <> 'Internal'  
                            and O.mMerchandise > 0 
                            and O.dtShippedDate between '11/21/2015' and '11/20/2016'
                WHERE OL.flgLineStatus in ('Shipped','Dropshipped')
                GROUP BY SI.ixBaseSKU                            
                ) SALES on TS.ixSKU = SALES.ixBaseSKU
ORDER BY ISNULL(SALES.[12MoSales],0) DESC


select * from tblSKUIndex where ixBaseSKU = '70174'

               SELECT ixSKU, ISNULL(sum(OL.mExtendedPrice),0) '12MoSales'
               FROM tblOrderLine OL                               
                join tblOrder O on O.ixOrder = OL.ixOrder 
                            and O.sOrderStatus = 'Shipped'  
                            and O.sOrderType <> 'Internal'  
                            and O.mMerchandise > 0 
                            and O.dtShippedDate between '11/21/2015' and '11/20/2016'
                WHERE OL.flgLineStatus in ('Shipped','Dropshipped')
                  and OL.ixSKU in ('70174-100','70174-100GS','70174-1125','70174-1125GS','70174-625','70174-625GS','70174-750','70174-8125','70174-875','70174-875GS')
                GROUP BY ixSKU  
                
                
SELECT * FROM [SMITemp].dbo.PJC_SMIHD5964_UnknownSKUs


