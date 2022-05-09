-- Purchasing analysis based of FIFO for CCC

/* see Teams convo with CCC

5 qty @ start of the month
9 sold during the month
6 qty @ end of the month

then we must have received 10 during the month?


Start 




if inv on 01/01/21 was $1m, and on 02/01/21 it's $3m and we know our out the door was $4m,
then it must be the case that we recieved $Xm inv between 01/01/21 and 02/01/21


1 qty @ start of the month
4 sold during the month
3 qty @ end of the month

then we must have received 6 during the month?

StartINV 1m
EndINV	 3m
INVSold	 4m
INVRcvd  

Start	INV	End	INV
INV  + 	Sold  - INV   = Rcvd
1    +	4     - 3     = 2

Start	INV	End	INV
INV  + 	Sold  - INV   = Rcvd
1    +	4     - 3     = 2


StartINV + INVRcvd - INVSold = EndINV 
1	     6             4     = 3

StartINV + INVRcvd  = EndINV + INVSold
1		6   

INVRcvd  = (EndINV + INVSold) - StartINV 
         = 3 + 4 -1

INVRcvd  = (EndINV + INVSold) - StartINV 

FIFORcvd  = (EndFIFO + FIFOSold) - StartFIFO


  
INVRcvd = EndINV - (StartINV + INVSold)
	= 3 - (1 + 4)
*/


select top 10 * 
from tblFIFODetail
order by ixFIFODate

select distinct ixLocation 
from tblFIFODetail 
where ixDate >= 19360 -- has all locations
/*
20
25
47
85
98
99
*/
SELECT * from tblDate
where iYear = 2021
and iDayOfFiscalPeriod = 1
order by iPeriod
/*
19360	2021-01-01
19391	2021-02-01
19419	2021-03-01
19450	2021-04-01
19480	2021-05-01
19511	2021-06-01
19541	2021-07-01
19572	2021-08-01
19603	2021-09-01
19633	2021-10-01
19664	2021-11-01
19694	2021-12-01
*/



select V.ixVendor, V.sName, D.iPeriod,  --  S.ixSKU,
    FORMAT(SUM(iFIFOQuantity*mFIFOCost),'$###,###') 'FIFOValue',
    SALES.CoGS
from tblVendor V
    left join tblVendorSKU VS on V.ixVendor = VS.ixVendor 
    left join tblSKU S on VS.ixSKU = S.ixSKU
                            and VS.iOrdinality = 1
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU    
                                and SL.ixLocation = 99
    left join tblFIFODetail FD on S.ixSKU = FD.ixSKU
    left join tblDate D on FD.ixDate = D.ixDate
    LEFT JOIN      (-- SALES
                    SELECT D.iPeriod,  --OL.ixSKU,          -- -- SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', 
                    FORMAT(SUM(OL.mExtendedCost),'$###,###') 'CoGS'
                    FROM tblOrderLine OL 
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                        left join tblSKU S on OL.ixSKU = S.ixSKU
                        left join tblVendorSKU VS on VS.ixSKU = OL.ixSKU
                                                    and VS.iOrdinality = 1
                        left join tblVendor V on VS.ixVendor = V.ixVendor
                    WHERE V.ixVendor = '0425' 
                        and D.iYear = 2021
                        and OL.flgLineStatus IN ('Shipped','Dropshipped')
                       -- and D.dtDate between '01/01/2021' and '01/31/2021'

                    GROUP BY --OL.ixSKU, 
                        D.iPeriod
                    ) SALES on D.iPeriod = SALES.iPeriod
WHERE S.flgDeletedFromSOP = 0
    --and S.flgActive = 1
    and V.ixVendor = '0425'
    and D.iYear = 2021
    and D.iDayOfFiscalPeriod = 1
group by V.ixVendor, V.sName, D.iPeriod, SALES.CoGS-- S.ixSKU
order by D.iPeriod

/*
ixVendor	sName	        iPeriod	FIFOValue
0425	HOLLEY PERFORMANCE PROD	1	$1,880,875
0425	HOLLEY PERFORMANCE PROD	2	$1,920,191
0425	HOLLEY PERFORMANCE PROD	3	$2,073,097
0425	HOLLEY PERFORMANCE PROD	4	$2,043,380
0425	HOLLEY PERFORMANCE PROD	5	$2,355,033
0425	HOLLEY PERFORMANCE PROD	6	$3,088,237
0425	HOLLEY PERFORMANCE PROD	7	$3,800,971
0425	HOLLEY PERFORMANCE PROD	8	$4,057,612
0425	HOLLEY PERFORMANCE PROD	9	$3,980,289
*/

                    (-- SALES
                    SELECT D.iPeriod,  --OL.ixSKU,          -- -- SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', 
                    FORMAT(SUM(OL.mExtendedCost),'$###,###') 'CoGS'
                    FROM tblOrderLine OL 
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                        left join tblSKU S on OL.ixSKU = S.ixSKU
                        left join tblVendorSKU VS on VS.ixSKU = OL.ixSKU
                                                    and VS.iOrdinality = 1
                        left join tblVendor V on VS.ixVendor = V.ixVendor
                    WHERE V.ixVendor = '0425' 
                        and D.iYear = 2021
                        and OL.flgLineStatus IN ('Shipped','Dropshipped')
                       -- and D.dtDate between '01/01/2021' and '01/31/2021'

                    GROUP BY --OL.ixSKU, 
                        D.iPeriod
                    ) SALES on SALES.ixSKU = CD.ixSKU  

SELECT * from tblDate
where iYear = 2021
and iDayOfFiscalPeriod = 1
order by iPeriod






-- 1364	DAKOTA DIGITAL	- Has 28 active SKUs with QAV


select V.ixVendor, V.sName,  count(S.ixSKU)
from tblVendor V
    left join tblVendorSKU VS on V.ixVendor = VS.ixVendor 
    left join tblSKU S on VS.ixSKU = S.ixSKU
                            and VS.iOrdinality = 1
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU    
                                and SL.ixLocation = 99
   -- left join tblFIFO
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and SL.iQAV > 0
group by V.ixVendor, V.sName
having count(S.ixSKU) between 25 and 30
order by count(S.ixSKU)

select * from tblVendor where sName like 'HOLLEY%'
-- 0425	HOLLEY PERFORMANCE PROD