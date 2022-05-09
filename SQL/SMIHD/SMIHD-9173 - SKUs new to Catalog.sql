-- SMIHD-9173 - SKUs new to Catalog
/*
DECLARE @NewCatalog varchar(10),  @ComparisonCatalog varchar(10)
SELECT @NewCatalog = '519',  @ComparisonCatalog = '518'
*/
SELECT CD.ixSKU 'SKU'
    , S.sBaseIndex 'BaseIndex'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , CD.i1stPage 
    , CD.mPriceLevel1 'CatalogPriceLevel1' 
    , S.dtCreateDate 'CreateDate'
    , B.sBrandDescription 'Brand'    
    , PL.sTitle 'ProductLine'    
    , (CASE WHEN PC.ixSKU IS NULL then 'Y'
       ELSE 'N'
       END
       ) 'FirstTimeSKU'
    , S.sSEMACategory 'Category'
    , S.sSEMASubCategory 'SubCategory'    
    , S.sSEMAPart 'Part'
FROM tblCatalogDetail CD
    left join tblSKU S on CD.ixSKU = S.ixSKU
    left join (-- SKUs from PREVIOUS CATALOG
                SELECT distinct CD.ixSKU -- 
                FROM tblCatalogDetail CD
                    join tblCatalogMaster CM on CD.ixCatalog = CM.ixCatalog
                WHERE CM.dtStartDate < GETDATE()
                    and CM.ixInHomeDate is NOT NULL
                    and CM.iQuantityPrinted > 0 
                    and CM.ixCatalog NOT LIKE @NewCatalog+'%' -- @NewCatalog
               ) PC on CD.ixSKU = PC.ixSKU
    left join tblBrand B on S.ixBrand = B.ixBrand    
    left join tblProductLine PL on S.ixProductLine = PL.ixProductLine                 
WHERE CD.ixCatalog = @NewCatalog
    AND CD.ixSKU NOT IN (-- SKUs in Comparison Catalog
                          SELECT ixSKU 
                          FROM tblCatalogDetail
                          WHERE ixCatalog = @ComparisonCatalog)
ORDER BY B.sBrandDescription, CD.ixSKU
--S.dtCreateDate                  
                  
    
    
    
    





DECLARE @NewCatalog varchar(10),  @ComparisonCatalog varchar(10)
SELECT @NewCatalog = '519',  @ComparisonCatalog = '518'
select * from tblCatalogMaster where ixCatalog like  @NewCatalog+'%'   
    
    
    
    
SELECT distinct ixCatalog
from tblCatalogDetail where ixSKU IN ('9152187-B-040','9302003','9302004','9302005','9302006','9302007','9302008','9302009','9302010','91140424','910807HP-X001','91667917-RAW','91667918-RAW','91667919-RAW','91667922-RAW','91667923-RAW','91667924-RAW','91119391-STD','911235-08','911235-09','91131050-BLU','91131050-WHT','91131052-BLU','91131052-WHT','910824-L','910824-M','910824-S','910824-XL','910828-L','910828-M','910828-S','910828-XL','91066416','91064330','9106434','9106523','9106565','9107816-L','9107816-M','9107816-S','9107816-XL','9107816-XS','9107816-XXL','9107816-XXXL','9107816-XXXXL','9107820-BLK-L/XL','9107820-BLK-S/M','9107820-STN-L/XL','9107820-STN-S/M','91032482','91034212-23','910110','757R1663H-X001','757R663H-X001','91018033-MOP','91019691','91019696','910204','910309','91031315-1/2','910695-L','910695-M','910695-S','910695-XL','910695-XXL','910695-XXXL','910696-L','910696-M','910696-S','910696-XL','910696-XXL','910696-XXXL','91076269','91048345-28-300','91048345-28-325','91048345-31-300','91048345-31-325','910509HP-X001','910557HP-X001','910573','910577','9106306','9106311','9106373','757M1038H-X001','72650716','72650730','72650747','72650754','574617','199160','1992015','1992115','4655951','665838154-2XL','665838154-3XL','665838154-L','665838154-M','665838154-S','665838154-XL','665838155-2XL','665838155-3XL','665838155-L','665838155-M','665838155-S','665838155-XL','665838156-2XL','665838156-3XL','665838156-L','665838156-M','665838156-S','665838156-XL','665838157-2XL','665838157-3XL','665838157-L','665838157-M','665838157-S','665838157-XL','665838160','4251282020','2751056-TAN','32201214','32201217','32201220','32201235','32210027','32211011','32211020','32211033','32211040','32211044','32211048','32211055','32211066','32211081','32211088','32211201','32211203','32211204','32211205','32211206','32211207','32211209','32211310','32211312','32211314','32211480','32266309','32266319','32299004','270R3646120-GRY','270R3646120-POL','270R3646520-GRY','270R3646520-POL','270R3648520-GRY','270R3648520-POL','270R3666135-GRY','270R3666135-POL','270R3666535-GRY','270R3666535-POL','270R3667335-POL','270R3668535-GRY','270R3668535-POL','10680137-F-NA-N','10680137-F-NA-Y','270R3566135-GRY','270R3566135-POL','270R3566535-GRY','270R3566535-POL','270R3567335-POL','270R3576142-GRY','270R3576142-POL','270R3576542-GRY','270R3576542-POL','270R3577342-POL','1412060','1413506','1413605','1414535','1415712','1415715','1415716','1415717','1416672','1418580','1418581','1418582','1418585','1418586','1418587','1419514','142002','10680167-F-NA-N')-- '91066416'    
AND ixCatalog NOT IN ('519','519N','519P')
and ixCatalog NOT LIKE '%.%'
                  
SELECT * FROM tblCatalogMaster where ixCatalog in ('HLY16','HLY17','HOLLEYMSD','MRR13','MRR15','MRR16','PRS13','PRS15','PRS16')

                  
SELECT distinct CD.ixSKU -- 
FROM tblCatalogDetail CD
join tblCatalogMaster CM on CD.ixCatalog = CM.ixCatalog
WHERE CM.dtStartDate < GETDATE()
and CM.ixInHomeDate is NOT NULL
and iQuantityPrinted > 0   


SELECT * FROM tblCatalogMaster 
where ixInHomeDate is NOT NULL
and iQuantityPrinted > 0         
order by ixCatalog
                 
SELECT * FROM tblCatalogMaster 
where ixInHomeDate is NULL
and iQuantityPrinted > 0         
order by ixCatalog
                 
                 