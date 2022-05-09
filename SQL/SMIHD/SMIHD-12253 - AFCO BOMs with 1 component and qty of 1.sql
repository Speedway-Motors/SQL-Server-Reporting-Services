-- SMIHD-12253 - AFCO BOMs with 1 component and qty of 1

SELECT TM.ixFinishedSKU, ISNULL(S.sWebDescription, S.sDescription) 'FinishedSKUDescription', S.flgIntangible, S.flgActive, 
    S.mPriceLevel1 'PriceLevel1',
    CONVERT(VARCHAR, S.dtCreateDate, 102)  AS 'CreateDate',
    ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
    ISNULL(BOMU.BOMUsage12Mo,0) 'BOMUsage12Mo',
    --ISNULL(S2.sWebDescription, S2.sDescription) 'SKUComponentDescription',
    count(distinct TD.ixSKU)'CompCnt', sum(TD.iQuantity) 'SumCompQty'
FROM tblBOMTemplateMaster TM
    left join tblBOMTemplateDetail TD on TM.ixFinishedSKU = TD.ixFinishedSKU  
    left join tblSKU S on S.ixSKU = TM.ixFinishedSKU
    LEFT JOIN (-- 12 Mo SALES & Quantity Sold
            SELECT OL.ixSKU
                ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
            FROM tblOrderLine OL 
                join tblDate D on D.dtDate = OL.dtOrderDate 
            WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
            GROUP BY OL.ixSKU
            ) SALES on SALES.ixSKU = TM.ixFinishedSKU  
    LEFT JOIN(-- BOM USAGE 12 Months
              SELECT ST.ixSKU AS ixSKU
                   , ISNULL(SUM(ST.iQty),0) * -1 AS BOMUsage12Mo 
		      FROM tblSKUTransaction ST 
		      LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		      WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		        AND ST.sTransactionType = 'BOM' 
			    AND ST.iQty < 0
	          GROUP BY ST.ixSKU
	          ) BOMU on BOMU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = TM.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
WHERE TM.flgDeletedFromSOP = 0  -- 1,269
    --and TD.iQuantity = 1
GROUP BY TM.ixFinishedSKU, ISNULL(S.sWebDescription, S.sDescription), S.flgIntangible, S.flgActive, S.mPriceLevel1,
    CONVERT(VARCHAR, S.dtCreateDate, 102),
    ISNULL(SALES.QtySold12Mo,0), 
    ISNULL(BOMU.BOMUsage12Mo,0)
HAVING count(distinct TD.ixSKU) = 1
    and sum(TD.iQuantity) = 1 -- 622


