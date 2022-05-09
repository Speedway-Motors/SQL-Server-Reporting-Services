-- SMIHD-11604 - differences in 12 month sales qty

SELECT SKU.ixSKU AS SKU
     , SKU.sDescription AS Description
     , SKU.ixPGC
     , ISNULL(SL.iQAV,0) AS QtyOnHand
     , ISNULL(YTD.YTDQTYSold,0) AS '12MO Sales' 
     , isnull(BOM.TotalQty,0) AS '12MO BOM' 
FROM tblSKU SKU
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND ixLocation = '99' 
LEFT JOIN -- 12 Month Sales
          (SELECT AMS.ixSKU
                , SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
               FROM vwAdjDailySKUSalesIncEXTOrdChan AMS
           WHERE AMS.dtDate BETWEEN '8-2-17' and '8-2-18'
           GROUP BY AMS.ixSKU
          ) YTD ON YTD.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT JOIN -- 12 Month BOM 
             ( SELECT ST.ixSKU AS ixSKU, ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
   FROM tblSKUTransaction ST 
           LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
   WHERE D.dtDate BETWEEN '8-2-17' and '8-2-18'
       and ST.sTransactionType = 'BOM' 
and ST.iQty < 0
   GROUP BY ST.ixSKU) BOM ON BOM.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SKU.ixSKU in ('34502','24250CR') -- Enter SKU between single quotes and remove all -- 
GROUP BY SKU.ixSKU 
       , SKU.sDescription 
       , SKU.ixPGC
       , ISNULL(SL.iQAV,0) 
       , ISNULL(YTD.YTDQTYSold,0) 
       , ISNULL(BOM.TotalQty,0)
/*                                                                                                                  QTY SOLD                SOP         USAGE
SKU	    Description	                    ixPGC	QtyOnHand	12MO Sales	12MO BOM                                    Sales by SKU rpt        SCREEN      DATA
24250CR	SPRING-14IN 250 C/O CHROME	    ID	    79	        550	        0                                           -50                     695         550
34502	IMCA METRIC SPINDLE W/O ARM	    AC	    26	        91	        0                                           -1                       83          91
*/
select ixSKU, flgKitComponent, sum(iQuantity) 'QtySold'
from tblOrderLine OL
where OL.ixSKU in ('24250CR','34502')
    and OL.dtShippedDate between '8-2-17' and '8-2-18'
    and flgLineStatus in ('Shipped')
GROUP BY ixSKU, flgKitComponent
ORDER BY ixSKU, flgKitComponent

        flgKit
ixSKU	Component	QtySold     Returns
24250CR	0	        77          227
24250CR	1	        745

34502	0	        1
34502	1	        92



select sum(CMD.iQuantityCredited) 'QtyReturned'
from tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
where CMD.ixSKU = '24250CR'
and CMM.dtCreateDate between '8-2-17' and '8-2-18'

select *
from tblVendorSKU
where ixSKU in  ('24250CR','34502')
and iOrdinality = 1

select * from tblVendor where ixVendor = 5302