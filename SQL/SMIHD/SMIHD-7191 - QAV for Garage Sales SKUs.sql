-- SMIHD-7191 - QAV for Garage Sales SKUs


SELECT L.ixSKU, SL.iQAV 
FROM PJC_SMIHD7191_GS_SKUs L
left JOIN [SMI Reporting].dbo.tblSKULocation SL on L.ixSKU = SL.ixSKU and ixLocation = 99
ORDER BY ixSKU
