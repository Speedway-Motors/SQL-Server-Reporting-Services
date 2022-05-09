-- SMIHD-10681 - Extract data from SKUs by Transmission Family Association report and add additional fields for analysis
/* base result from SKUs by Transmission Family Association.rdl (run for all tran families)
then add
Brand, 
SEMA Categorization, 
12 month quantity sold, 
and 12 month $ sales.
*/
SELECT DISTINCT (CASE WHEN T.sTransmissionFamilyName IS NULL THEN 'Unassigned' 
                      ELSE T.sTransmissionFamilyName
                  END) AS TransmissionFamilyName 
     , SV.ixSOPSKU 'SKU'
     , SV.sSKUVariantName 'SKUVariantName'
     --, S.ixBrand
     , B.sBrandDescription 'Brand'
     , S.sSEMACategory 'Category'
     , S.sSEMASubCategory 'SubCategory'
     , S.sSEMAPart 'SemaPart'
     , ISNULL(SALES.Sales12Mo,0) 'Sales12Mo'
     , ISNULL(SALES.QtySold12Mo,0)  'QtySold12Mo'
FROM tngLive.tblskuvariant SV
    LEFT JOIN  tngLive.tblskuvariant_transmission_family_xref TRANS ON TRANS.ixSKUVariant = SV.ixSKUVariant
    LEFT JOIN  tngLive.tbltransmission_family T ON T.ixTransmissionFamily = TRANS.ixTransmissionFamily 
    LEFT JOIN [SmiReportingRawData].Transfer.tblSKU S on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SV.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
    LEFT JOIN [SmiReportingRawData].Transfer.tblBrand B on S.ixBrand = B.ixBrand
	LEFT JOIN (-- 12 Mo Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
				FROM [SmiReportingRawData].Transfer.tblOrderLine OL 
					join [SmiReportingRawData].Transfer.tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
				GROUP BY OL.ixSKU
				) SALES on SALES.ixSKU = S.ixSKU 
WHERE  ((flgBackorderable = 1) 
          OR (flgBackorderable = 0 AND iTotalQAV > 0))
  AND flgPublish = 1
ORDER by SV.ixSOPSKU






