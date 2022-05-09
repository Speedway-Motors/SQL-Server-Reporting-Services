-- this should return the month you are running the report in.
-- MAKE SURE LNK-DW1 returns same value below as LNK-DWSTAGING1
select max(iYearMonth) from tblSnapAdjustedMonthlySKUSalesNEW -- 2014-01-15 00:00:00.000 <-- should disply the 15th of the prevous month

select top 10 * from vwAdjustedMonthlySKUSalesNEW
select max(iYearMonth)  from vwAdjustedMonthlySKUSalesNEW

/* if current month row shows then...
    DELETE from tblSnapAdjustedMonthlySKUSalesNEW
    where iYearMonth = '11-15-2013' <-- whatever the current month is
*/

-- use SKU 91003915 to check the "12 Mo Qty Sold" (col.AM) figure.
/*
Rpt                           12 MO
Run      Start       End      QTY
Date     Month       Month    Sold
======   =====       =====    ======
11/1/13  11/15/12    10/15/13
10/1/13  10/15/12    09/15/13 37,614
09/1/13  09/15/12    08/15/13 37,99
08/1/13  08/15/12    07/15/13 37,990
07/1/13  07/15/12    06/15/13 37,447
06/1/13  06/15/12    05/15/13 60,245
05/1/13  05/15/12    04/15/13 37,337
04/1/13
01/1/13  01/15/11    12/15/12 ######
12/1/12  12/15/11    11/15/12 ######
11/1/12  11/15/11    10/15/12 ######
10/1/12  10/15/11    09/15/12 ######
09/1/12  09/15/11    08/15/12 37,131
08/1/12  08/15/11    07/15/12 37,334
07/1/12  07/15/11    06/15/12 38,340
06/1/12  06/15/11    05/15/12 38,686
*/

-- make sure your getting the last 12 Months
select ixSKU, sum(AdjustedQTYSold)        -- 36,152 = total AdjustedQTYSold last 12 Mo     <-- (Column "AR" on latest Excel file)
    , COUNT(iYearMonth) 'Months'
from tblSnapAdjustedMonthlySKUSalesNEW    -- 36,835 Non-KitComp + KitComp sold 
where ixSKU = '91003915'                  --    274 minus RETURNS
and iYearMonth > '10/15/2012'             -- ======
and iYearMonth < '11/01/2013'             -- 37,447 <-- Should be < 100 delta from the Adjusted Sales number
group by ixSKU--, AdjustedQTYSold         
--order by iYearMonth desc                  


/*          VPH
    SQL     Report
    16,576  17,743  Current 12 month QTY sold non-kit (col AP) 
+   21,430  21,510  Current 12 month QTY sold kit (col AQ)
+    1,080   1,080  Current 12 month BOM QTY (col V)
-      289          Returns
    ======  ======
=   38,797  40,333  Adjusted Current 12 month QTY sold (col AR)
*/


-- sales last 12 Mo
select SUM(OL.iQuantity) 'Qty',
        (CASE when OL.flgKitComponent = 1 then 'KitComp'
              else 'Non-KitComp'
         end) as 'Type'
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
where OL.flgLineStatus = 'Shipped'
    and OL.ixSKU = '91003915'
    and O.sOrderStatus = 'Shipped'
   -- and O.sOrderType <> 'Internal'
  --  and O.sOrderChannel <> 'INTERNAL'
    and O.dtShippedDate between '11/01/2012' and '10/31/2013'
group by (CASE when OL.flgKitComponent = 1 then 'KitComp'
               else 'Non-KitComp'
          end)
order by 'Type' desc             
/*
Qty	    Type
21430	KitComp
16576	Non-KitComp
*/


-- RETURNS last 12 mo
select SUM(CMD.iQuantityCredited) -- 289 returned
from tblCreditMemoMaster CMM
    join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
where CMD.ixSKU = '91003915'
    and CMM.flgCanceled = 0
    and CMM.dtCreateDate between '11/01/2012' and '10/31/2013' -- <-- use same date range as query above
    
-- BOM Qty
SELECT SUM(CAST(BOMTD.iQuantity AS INT)* CAST(BOMTM.iCompletedQuantity AS INT)) AS BOMQTY 
           FROM tblBOMTransferMaster BOMTM 
           JOIN tblBOMTransferDetail BOMTD ON BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
           JOIN tblDate D on D.ixDate = BOMTM.ixCreateDate
                         AND D.dtDate BETWEEN '10/01/2012' and '09/30/2013' 
	       WHERE BOMTD.ixSKU = '91003915'
           GROUP BY BOMTD.ixSKU
 
              
/*************************************************************
                                            TOTAL
                                   mins     Current        
                     MB            Render   12 Mo 
Month/Yr    Parts   Size    rows   Time     NON-Kit Sales(col Z)
====        =====   =====  ======  ======   ===========
NOV '13     1       96.1  44,944   11          
OCT '13     1       97.5  45,434   22       $89,705,102

AUG '13     1      115.2  44,423   8        $88,230,343 ^605K
JUL '13     1      113.7  43,862   16       $87,625,245 ^360K
JUN '13     1      112.5  43,345   7        $87,265,625 ^571K
MAY '13     1      111.3  42,837   9        $86,694,362 ^1.27M
APR '13     1      110.4  42,397   8        $85,419,085 ^276K
MAR '13     1      118.5  41,940   7        $85,143,079 ^ 26K
FEB '13     1      117.1  41,520   7        $85,116,693 ^778K  
JAN '13     1      115.7  41,041   11       $84,338,299 ^914K
DEC '12     1      114.6  40,666   12       $83,424,541 ^453K
NOV '12     1      113.2  40,228   7        $82,971,209 ^1.52M
OCT '12     1      108.9  37,743   11       $81,752,527 ^472K
SEP '12     1      108.1  39,452   11       $81,280,619 ^546K
AUG '12     1       95.3  39,165   8        $80,734,254 ^1.08M
JUL '12     1       94.3  38,735   ?        $79,654,607 ^788K
JUN '12*    1       93.3  38,320            $78,866,993        <-- re-ran 6-11 to include dropship sales
JUN '12     1       90.9  37,247   7        $77,844,334        <-- original run
MAY '12     1       89.5  36,679   6        $76,744,907 ^1.1M
APR '12     1       87.7  36,161   6        $75,413,700 ^881K
MAR '12     1       86.2  35,528   7        $74,533,127 ^1.89M
FEB '12     1       84.7  34,884   ?        $72,642,282 ^882K
JAN '12     1       81.6  34,425   ?        $71,760,462 ^470K
DEC '11     1       82.5  33,960   5        $71,290,759 ^509K
NOV '11     1       81.5  33,552   5        $70,781,775 ^499K
OCT '11		1		78.9  33,238   20		$70,282,428 ^407K
SEP '11     6      133.6  32,937   37       $69,875,751 ^1.0M
AUG '11     6      129.0  32,687   23       $68,840,982 ^499K
JUL '11     6      122.9  32,356   44       $68,342,057 ^559K
JUN '11     6      123.9  31,832   19       $67,783,297 ^886K
MAY '11     6      122.1  31,535   410      $66,896,851 ^528K 
APR '11     5      120.7  31,118   209      $66,368,668 ^418K
MAR '11     5      114.9  30,280   41       $65,950,617 ^443K
FEB '11     5      113.3  29,944   132      $65,507,850 ^863K  
JAN '11     5      111.3  29,338   132      $64,644,548 ^414K
DEC '10     5      109.3  28,778   138  	$64,230,205 ^227K
NOV '10     5      108.4  28,287   130  	$64,003,250
**************************************************************/

select * from tblVendor where ixVendor NOT between '0' and '9999'  -- ixVendor of "JUNK" is the only result returned

-- exec [spUpdateSnapAdjustedMonthlySKUSales] -- ABOUT 5 MINS TO RUN
select top 10 * from tblSnapAdjustedMonthlySKUSalesNEW

select iYearMonth, count(*)
--delete from tblSnapAdjustedMonthlySKUSalesNEW
where iYearMonth = '2013-02-15'


select sum(mMerchandise) as Sales
from tblOrder O
    join tblOrderLine OL on OL.ixOrder = O.ixOrder
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '11/01/2012' and '10/31/2013'
    and SKU.flgIntangible = 0
   
   90,964,7479.56
   
select sOrderChannel, count(*)
from tblOrder
where dtOrderDate >= '01/01/2013'
 group by   sOrderChannel
  
  
  
 select *
from tblOrder O
where dtOrderDate >= '11/01/2013'
and sOrderChannel = 'MAIL'
and sOrderStatus = 'Shipped'
and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
and O.mMerchandise > 0 -- > 1 if looking at non-US orders


 group by   sOrderChannel