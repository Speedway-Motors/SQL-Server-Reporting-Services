-- SMIHD-18510 - Speedway Inventory of Active APG SKUs by Location	

select S.ixSKU as 'SKU',
    VS.sVendorSKU 'VendorSKU',
    VS.ixVendor 'PrimaryVendor',
    V.sName 'PVName',
    isnull(S.sWebDescription, S.sDescription) as 'Description',
    LNK.iQAV 'LNKQAV',
    LNK.iQOS 'LNKQOS',
    BVL.iQAV 'BVLQAV',
    BVL.iQOS 'BVLQOS',
    TOL.iQAV 'TOLQAV',
    TOL.iQOS 'TOLQOS',
    FBA.iQAV 'FBAQAV',
    FBA.iQOS 'FBAQOS',
    BOMU.BOM12MoUsage,
   -- BOMYTD.TotalQty 'BOM12MoUsage2',
    isnull(b.sBrandDescription,'Brand Not Assigned') as 'Brand',
    isnull(pl.sTitle,'Product Line Not Assigned') as 'Product Line'
  --  S.sSEMACategory as 'Category',  S.sSEMASubCategory as 'Subcategory', S.sSEMAPart as 'Part Type'
from tblSKU S 
    left join tblBrand b on b.ixBrand=S.ixBrand
    left join tblProductLine pl on pl.ixProductLine=S.ixProductLine
    left join tblPGC pgc on S.ixPGC=pgc.ixPGC
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
    left join tblSKULocation LNK on LNK.ixSKU = S.ixSKU and LNK.ixLocation = 99
    left join tblSKULocation BVL on BVL.ixSKU = S.ixSKU and BVL.ixLocation = 47
    left join tblSKULocation TOL on TOL.ixSKU = S.ixSKU and TOL.ixLocation = 85
    left join tblSKULocation FBA on FBA.ixSKU = S.ixSKU and FBA.ixLocation = 20
    left join (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU) BOMU on BOMU.ixSKU = S.ixSKU
/* THIS IS AFCO's way of doing BOM USAGE
    LEFT JOIN(-- BOM USAGE 12 Months
              SELECT ST.ixSKU AS ixSKU
                   , ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		      FROM tblSKUTransaction ST 
		      LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		      WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		        AND ST.sTransactionType = 'BOM' 
			    AND ST.iQty < 0
	          GROUP BY ST.ixSKU
	          ) BOMYTD ON BOMYTD.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS = S.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS     	
*/
WHERE S.flgDeletedFromSOP = 0
    and b.sBrandDescription in ('AFCO','Dynatech','Longacre','Pro Shocks','DeWitts')  -- 48,820
    and S.flgActive = 1 -- 22,942
    and S.ixSKU NOT LIKE 'UP%'
    and S.ixSKU NOT LIKE 'AUP%' -- 21,835
    and V.ixVendor not in ('0002','0009','0108','0134','0313','0476') --        6,413
    /*Excluded Vendors
    0002	SPEEDWAY KIT ITEMS
    0009    Garage Sale 
    0108	AFCO DROP.SHIP
    0134	DEWITTS RADIATOR DROP.SHIP
    0313	DYNATECH DROP.SHIP
    0476	LONGACRE DROP.SHIP
    */
ORDER BY  S.ixSKU --BOMU.BOM12MoUsage desc,
 



--  select top 50 * from tblSKULocation
/*
select * from tblLocation

20	FBA
47	Boonville
85	Tolleson
99	Lincoln
*/

select * from tblTrailer