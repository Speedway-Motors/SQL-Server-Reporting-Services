-- SMIHD-1265 - batch up intangible flag for AFCO SKUs

SELECT I.ixSKU, S.flgIntangible
FROM  [AFCOTemp].dbo.PJC_SMIHD_1265_AFCO_SKUs_intangible I
left join [AFCOReporting].dbo.tblSKU S on I.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
ORDER BY flgIntangible desc



SELECT S.flgIntangible, count(S.ixSKU) 'QTY'
FROM  [AFCOTemp].dbo.PJC_SMIHD_1265_AFCO_SKUs_intangible I
left join [AFCOReporting].dbo.tblSKU S on I.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
GROUP BY S.flgIntangible
/*
flgIntangible	QTY
0	            293
*/

SELECT S.flgIntangible, S.ixSKU, S.dtDateLastSOPUpdate, S.ixTimeLastSOPUpdate
FROM  [AFCOTemp].dbo.PJC_SMIHD_1265_AFCO_SKUs_intangible I
left join [AFCOReporting].dbo.tblSKU S on I.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
where flgIntangible = 0



'HOLD''LIT063'


SELECT I.ixSKU, S.flgIntangible
FROM  [AFCOTemp].dbo.PJC_SMIHD_1265_AFCO_SKUs_intangible_but_scan I
left join [AFCOReporting].dbo.tblSKU S on I.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
ORDER BY flgIntangible desc



SELECT S.flgIntangible, count(S.ixSKU) 'QTY'
FROM  [AFCOTemp].dbo.PJC_SMIHD_1265_AFCO_SKUs_intangible_but_scan I
left join [AFCOReporting].dbo.tblSKU S on I.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
GROUP BY S.flgIntangible
/*
flgIntangible	QTY
0	            10
*/
