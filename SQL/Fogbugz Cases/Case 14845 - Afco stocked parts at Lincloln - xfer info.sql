-- Case 14845 Afco stocked parts at Lincoln - xfer info

/*
INV...	12MO	MAX.	RST	    BIN#..	PER MTH	    MIN QTY
1080	4	    55	    5	    X23DE5	0.40	    0.20
10632	14	    9	    2	    AL05AD	1.40	    0.70
*/



SELECT SKU.ixSKU,
       SKUSALES.[12MoQtySold]   as '12 Mo Sales',
       SL.iPickingBinMax        as 'Max',
       SKU.iRestockPoint        as 'Restock',
       SL.sPickingBin           as 'Picking Bin',
       AfcoQOSatLNK.iQOS        as 'AfcoQOSatLNK',
       VS.sVendorSKU            as 'AfcoSKU'
       --'Per Mo Calc = 12 Mo Sales/12',
       --'Min Qty Calc?',
FROM tblSKU SKU
    left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
    left join tblBinSku BS on SKU.ixSKU = BS.ixSKU and BS.ixLocation = '99' -- only LNK bins
    left join tblSKULocation SL on SL.ixSKU = BS.ixSKU
                                and SL.ixLocation = BS.ixLocation
                                and BS.ixLocation = '99'
                                            --and SL.ixBin = SKU.ixBin
-- Afco QTY stored at LNK                                                
    left join (SELECT ixSKU,iQOS 
               FROM [AFCOReporting].dbo.tblSKULocation
               WHERE ixLocation = '68') AfcoQOSatLNK on AfcoQOSatLNK.ixSKU = VS.sVendorSKU                                         
-- 12 MO. SKU SALES 
    left join (SELECT OL.ixSKU 
				, SUM(OL.iQuantity) AS '12MoQtySold'
		       FROM tblOrderLine OL 
		       WHERE OL.flgLineStatus = 'Shipped' 
			     and OL.dtShippedDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		       GROUP BY OL.ixSKU
		       ) AS SKUSALES ON SKUSALES.ixSKU = SKU.ixSKU                                                
WHERE 
    SKU.flgDeletedFromSOP = 0
    and VS.ixVendor in ('0106','0311') --,'0108','0313')           
    and VS.iOrdinality = 1 --(Only where those two are prim vendors)?
--and SKU.ixSKU in ('1080','10632')  
    and SKUSALES.[12MoQtySold] > 0


--1900 in file 1400 in query


