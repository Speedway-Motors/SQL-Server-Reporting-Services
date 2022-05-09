-- SMIHD-8928 - New Report - Dangling BOM Components   

/*
generate a report with 

SKU, QTY, Short Desc and Cost 

for all items which are part of a BOM; where the BOM has been discontinued and for which there is no other use for the component?  

For instance, we have sku XYZ which is a BOM with components XYZ.1 and XYZ.2.  sku XYZ has been discontinued.  XYZ.1 has QTY 0, XYZ.2 has QTY 230,320.  
XYZ.2 is not used in any other BOM or sold individually.  

*/

-- MAIN REPORT QUERY                   
SELECT distinct TD.ixSKU 'SKU',                 -- 606
    S.sDescription 'SKUDescription',
    CONVERT(VARCHAR,S.dtDiscontinuedDate, 102)  AS 'DiscontinuedDate',
    S.dtDiscontinuedDate,
    SKUM.iQAV 'QAV', SKUM.iQOS 'QOS', 
    S.mPriceLevel1 'PriceLvl1', S.mAverageCost 'AvgCost', S.mLatestCost 'LatestCost',
    S.sSEMACategory 'Category', S.sSEMASubCategory 'Sub-Cat', S.sSEMAPart 'Part',
    /*(CASE WHEN TNG.ixSOPSKU IS NOT NULL THEN 'Y'
      ELSE 'N'
      END) 'AvailOnWeb'
     , S.flgIntangible, S.flgIsKit
     */
    CONVERT(VARCHAR, LS.LastSold, 102)  AS 'LastSold'
FROM tblBOMTemplateDetail TD
    JOIN tblSKU S on TD.ixSKU = S.ixSKU
    JOIN vwSKUMultiLocation SKUM on S.ixSKU = SKUM.ixSKU
    LEFT JOIN (-- available on the Web
              SELECT ixSOPSKU
               FROM openquery([TNGREADREPLICA], '
                            select s.ixSOPSKU 
                            from tblskubase AS b
                                inner JOIN tblskuvariant s ON b.ixSKUBase = s.ixSKUBase
                                inner JOIN tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
                                inner JOIN tblproductpage AS pp ON ppsb.ixProductPage = pp.ixProductPage
                            WHERE b.flgWebPublish = 1
                                AND s.flgPublish = 1
                                AND pp.flgActive = 1
                                AND fn_isProductSaleable(s.flgFactoryShip, s.flgDiscontinued, s.flgBackorderable, s.iTotalQAV, s.flgMTO) = 1
                             '
                                ) TNG 
               ) TNG on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN (SELECT OL.ixSKU, max(dtShippedDate) 'LastSold'            
               FROM tblOrderLine OL
               WHERE OL.flgLineStatus in ('Shipped','Dropshipped')
               GROUP BY OL.ixSKU
               ) LS on LS.ixSKU = S.ixSKU
    LEFT JOIN (-- SKUs in Active Print Catalogs
                SELECT distinct ixSKU
                from tblCatalogDetail CD
                join vwActivePrintCatalogs APC on CD.ixCatalog = APC.ixCatalog
               ) APC ON APC.ixSKU = S.ixSKU
WHERE ixFinishedSKU in (-- BOM's that are discontinued
                        SELECT ixFinishedSKU
                        FROM tblBOMTemplateMaster TM -- 782
                           join tblSKU S on TM.ixFinishedSKU = S.ixSKU and S.flgDeletedFromSOP = 0  and S.flgActive = 0
                        WHERE TM.flgDeletedFromSOP = 0
                        )
   and TD.ixSKU NOT IN  (-- BOM components that are NOT in Active BOMs
                        SELECT TD.ixSKU
                        FROM tblBOMTemplateDetail TD -- 10,031
                           join tblSKU S on TD.ixFinishedSKU = S.ixSKU and S.flgDeletedFromSOP = 0  and S.flgActive = 1
                        WHERE TD.flgDeletedFromSOP = 0
                        ) 
    and TNG.ixSOPSKU is NULL -- NOT available on the Web 
    and APC.ixSKU is NULL -- NOT in an active print catalog 
    and S.flgActive = 1
ORDER BY CONVERT(VARCHAR, LS.LastSold, 102) desc


/*
generate a report with 

SKU, QTY, Short Desc and Cost 

for all items which are part of a BOM; where the BOM has been discontinued and for which there is no other use for the component?  

For instance, we have sku XYZ which is a BOM with components XYZ.1 and XYZ.2.  sku XYZ has been discontinued.  XYZ.1 has QTY 0, XYZ.2 has QTY 230,320.  
XYZ.2 is not used in any other BOM or sold individually.  

*/

select * from tblBOMTemplateDetail
where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate



-- BOM's that are discontinued
SELECT ixFinishedSKU
FROM tblBOMTemplateMaster TM
WHERE TM.flgDeletedFromSOP = 0
and ixFinishedSKU in (SELECT ixSKU from tblSKU
                      Where flgDeletedFromSOP = 0
                      and flgActive = 0)
                      
                      
                      
                      
SELECT * from tblBOMTemplateDetail
where flgDeletedFromSOP = 0
and ixSKU like 'UP%'       



SELECT OC.*, CD.ixCatalog
FROM [SMITemp].dbo.PJC_SMIHD8928_PossibleOrphanedBOMComponents OC
    join tblCatalogDetail CD on CD.ixSKU = OC.ixSKU 
WHERE CD.ixCatalog in ('410','411','412','413','414','513','514','515','516','517','518','602','603','802','803','804')



select * from vwActivePrintCatalogs    