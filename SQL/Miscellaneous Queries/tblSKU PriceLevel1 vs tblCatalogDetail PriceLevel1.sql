-- tblSKU PriceLevel1 vs tblCatalogDetail PriceLevel1


SELECT TOP 10 * FROM tblCatalogDetail where ixCatalog = 'WEB.17'



SELECT S.ixSKU
    , S.mPriceLevel1 'InventoryPLvl1'  --
    , CD.mPriceLevel1 'WEB.17PLvl1'
    , ABS(S.mPriceLevel1-CD.mPriceLevel1) 'Delta'
    , S.dtCreateDate 
    , S.sSEMACategory 'Category'
    , S.sSEMASubCategory 'Sub-Category'
    , S.sSEMAPart 'Part'
    , SALES.QtySold12Mo
    , BOMU.BOM12MoUsage
/*    
    ,(CASE WHEN TNG.ixSOPSKU IS NOT NULL then 'Y'
      ELSE 'N'
      END
      ) as 'AvailableOnTheWeb'
*/      
    , (CASE WHEN CABOM.ixSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END
       ) AS 'ComponentOfActiveBOM'
    , (CASE WHEN GS.ixSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END
       ) AS 'GarageSaleSKU'       
from tblSKU S
    left join tblCatalogDetail CD on S.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.17' 
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU
    left join (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU) BOMU on BOMU.ixSKU = S.ixSKU
    left join (-- 12 Mo QTY SOLD
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU) SALES on SALES.ixSKU = S.ixSKU     
/*    left join (-- available on the Web
              SELECT TNG.ixSOPSKU
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
*/               
    left join vwComponentSKUsOfActiveBOMs CABOM on CABOM.ixSKU = S.ixSKU                         
where S.flgDeletedFromSOP = 0
    and S.flgActive = 1               --259,386
    and S.flgIntangible = 0           --259,322
    and S.mPriceLevel1 > 0          --242,580
    and ABS(S.mPriceLevel1-CD.mPriceLevel1) > 0 -- has a Delta    
    and GS.ixSKU is NULL -- excludes Garage Sale SKUs

ORDER BY ABS(S.mPriceLevel1-CD.mPriceLevel1) DESC



select * from tblCatalogDetail where ixCatalog = 'WEB.17' -- 274,456