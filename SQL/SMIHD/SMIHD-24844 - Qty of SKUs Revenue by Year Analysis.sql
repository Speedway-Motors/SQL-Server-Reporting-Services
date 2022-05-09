-- SMIHD-24844 - Qty of SKUs Revenue by Year Analysis
-- percentage of sales by year

SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo',  -- 89,019
    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
FROM tblOrderLine OL 
    left join tblDate D on D.dtDate = OL.dtOrderDate 
WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
GROUP BY OL.ixSKU
--) SALES on SALES.ixSKU = CD.ixSKU  
/*
ixSKU		QtySold12Mo	Sales12Mo	CoGS12Mo
91031977	91			6656.20		4804.45
275881		11			387.55		463.90
120HE891012	5			1429.99		672.00
91137033	113			14287.56	4955.05
91012720	2			609.98		172.376
*/

SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo',  -- 88,264 2020		91,446 2021				114,642 combined
    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
FROM tblOrderLine OL 
    left join tblDate D on D.dtDate = OL.dtOrderDate 
WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
    and D.dtDate between '01/01/2020' and '12/31/2021' --DATEADD(yy, -2, getdate()) and getdate() -- 1 YR AGO and TODAY
GROUP BY OL.ixSKU
/*
I usually always exclude inter and intra and employee

Then whether marketplaces or wholesale obviously depends on the request

I don’t usually exclude garage sale… or tradeshow or unknown but mostly because those are such tiny segments
*/

-- Yearly SKU Sales 2012-2021
SELECT D.iYear, OL.ixSKU,
	SUM(OL.iQuantity) AS 'QtySold',  -- 597,838
    SUM(OL.mExtendedPrice) 'Sales', 
	SUM(OL.mExtendedCost) 'CoGS'
INTO #SKUSalesByYear -- DROP TABLE #SKUSalesByYear
FROM tblOrderLine OL 
	left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblDate D on D.ixDate = OL.ixOrderDate 
	left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
    and D.ixDate between 16072 and 19724	--	01/01/2012 to 12/31/2021
	and OL.ixSKU NOT LIKE 'NS%' -- excluding No Sale SKUs
	and O.ixBusinessUnit in ('104','105','106','107','109','110','111','112','113')  -- excluding 101,102,103,108   	ICS,INT,EMP,GS
	and S.flgIntangible = 0
GROUP BY D.iYear,OL.ixSKU
HAVING SUM(OL.mExtendedPrice) > 0
ORDER BY-- D.iYear,OL.ixSKU
	SUM(OL.mExtendedPrice)


SELECT FORMAT(SUM(Sales),'$###,###') Sales
from #SKUSalesByYear -- $1,269,651,521

SELECT iYear, count(ixSKU) 'SKUs', SUM(Sales) 'Rev'
FROM #SKUSalesByYear
GROUP BY iYear
ORDER BY iYear

SELECT iYear, ixSKU, QtySold, Sales
FROM #SKUSalesByYear
WHERE iYear = 2021
ORDER BY Sales desc


SELECT TOP 100
	ixSKU, FORMAT(SUM(Sales),'$###,###') 'TotSales'
from #SKUSalesByYear
group by ixSKU
order by SUM(Sales) desc




SELECT TOP 1000 * 
FROM #SKUSalesByYear
WHERE ixSKU like 'NS%'
order by Sales 

SELECT TOP 1000 * 
FROM #SKUSalesByYear
WHERE ixSKU like 'UP%'
order by Sales 


SELECT * FROM tblBusinessUnit
/*
ixBusinessUnit	sBusinessUnit	sDescription
	101	ICS	Inter-company sale
	102	INT	Intra-company sale
	103	EMP	Employee
104	PRS	Pro Racer
105	MRR	Mr Roadster
106	RETLNK	Retail, Lincoln
107	WEB	Website
	108	GS	Garage Sale
109	MKT	Marketplaces
110	PHONE	CX Orders
111	RETTOL	Retail, Tolleson
112	UK	Unknown
113	TRD	Trade Show
*/



