-- Case 25716 - 12 Month Sales by Vendor state



-- refed all vendors... 100% refed

-- vendors with no state
select * from tblVendor
where -- dtDateLastSOPUpdate < '03/12/15' all updated
sState is NULL

-- SKUs belonging to vendors with no state
select ixSKU from tblVendorSKU
where ixVendor in ('0240','0390','0405','0695','0919')

-- above SKUs that are active or we have Qty on Hand
select ixSKU, sDescription, iQOS
from vwSKUMultiLocation 
where ixSKU in ('2403075','91010501','2403027','2409123','919107A','919107B','919107C','919107G','919107H','919107I','919107J','919107K','919107L')
and flgDeletedFromSOP = 0
and (flgActive = 1 
     OR iQOS > 1)
/*
ixSKU	sDescription	iQOS
919107A	28-31 3:54R&P TAPER SHAFT	0
919107I	35-48 5.86:1 RING-PINION	45
919107J	35-48 6.17:1 RING-PINION	2
*/

select * from tblVendorSKU where ixSKU in ('919107A','919107I','919107J')


select * from tblVendor where ixVendor in ('0919','0013')

select * from tblPOMaster where ixVendor = '0919'

--
select
      V.ixVendor                       VendorNum,
      V.sName                          VendorName,
      V.sSalesRep                      SalesRep,
     V.sInsideSalesContact      InsideSalesContact,
      V.sOwner                         [Owner],
      V.sAddress1                      AddressL1,
      V.sAddress2                      AddressL2,
      V.sCity                          City,
      V.sState                         [State],
      V.sZip                           ZIP,
      dbo.DisplayPhone(V.s800Number)   s800Num,
      dbo.DisplayPhone(V.sPhone)       Phone,
      V.sEmailAddress                  Email,
      V.ixBuyer
from tblVendor V
    join tblStates S on V.sState = S.ixState
where V.sState = 'TX'
order by V.sName



SELECT 
/*********** section 1 **********************/
      V.ixVendor
    , V.sName AS PrimaryVendor
    , V.sState
    ,  V.sSalesRep                      SalesRep,
      V.sInsideSalesContact      InsideSalesContact,
      V.sOwner                         [Owner],
      V.sAddress1                      AddressL1,
      V.sAddress2                      AddressL2,
      V.sCity                          City,
      V.sState                         [State],
      V.sZip                           ZIP,
      dbo.DisplayPhone(V.s800Number)   s800Num,
      dbo.DisplayPhone(V.sPhone)       Phone,
      V.sEmailAddress                  Email,
      V.ixBuyer    
    , SUM (ISNULL(YTD.YTDSales,0)) AS Sales12Mo -- (adjusted)
FROM tblSKU SKU
LEFT JOIN tblDate D ON D.ixDate = SKU.ixCreateDate
LEFT JOIN tblVendorSKU VSKU ON VSKU.ixSKU = SKU.ixSKU 
LEFT JOIN tblVendor V ON V.ixVendor = VSKU.ixVendor
    JOIN tblStates S on V.sState = S.ixState
LEFT JOIN (SELECT AMS.ixSKU
				, SUM(AMS.AdjustedSales) AS	YTDSales
				, SUM(AMS.AdjustedNonKCSales) AS YTDNonKCSales -- New
				, SUM(AMS.KCSales) AS YTDKCSales -- New
				, SUM(AMS.AdjustedGP) AS YTDGP
				, SUM(AMS.AdjustedNonKCGP) AS YTDNonKCGP -- New 
				, SUM(AMS.KCGP) AS YTDKCGP -- New 
				, SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
				, SUM(AMS.AdjustedNonKCQtySold) AS YTDNonKCQtySold -- New 
				, SUM(AMS.KCQtySold) AS YTDKCQtySold -- New 
				, AVG(AMS.AVGInvCost) AS AVGInvCost
		   FROM tblSnapAdjustedMonthlySKUSalesNEW AMS
           WHERE AMS.iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,GETDATE())-12, 0)    -- 12 months ago
		   GROUP BY AMS.ixSKU
		  ) YTD ON YTD.ixSKU = SKU.ixSKU
WHERE VSKU.iOrdinality = 1
GROUP BY V.ixVendor
    , V.sName,
     V.sState,
      V.sSalesRep,
      V.sInsideSalesContact,
      V.sOwner,
      V.sAddress1,
      V.sAddress2,
      V.sCity,
      V.sState,
      V.sZip,
      dbo.DisplayPhone(V.s800Number),
      dbo.DisplayPhone(V.sPhone),
      V.sEmailAddress,
      V.ixBuyer 
HAVING  SUM (ISNULL(YTD.YTDSales,0)) > 10000        
ORDER BY V.sState, Sales12Mo DESC


select * from tblSnapAdjustedMonthlySKUSalesNEW

select top 10 * from tblBrand


select ixState from tblStates
where flgContiguous =1
or flgNonContiguous =1
order by ixState