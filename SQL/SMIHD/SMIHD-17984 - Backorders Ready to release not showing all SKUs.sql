-- SMIHD-17984 - Backorders Ready to release not showing all SKUs
/*   ver 20.21.1
*/
DECLARE @SingleSKU varchar(25)
SELECT @SingleSKU = ' ' --'91015172'--  instead of NULL --'35519212593' 
    -- 35519212593 has 4 orders    9542107-1 9569405-1 9673208-1 9921006-1              9426102-1 is missing
    -- 2823022706KIT has 2 orders v
    -- 715BP15121 has 3 orders v
    
SELECT DISTINCT 
    O.ixOrder 'Order_#', 
    O.dtOrderDate 'Order_Date',
    O.ixCustomer,
    O.ixAuthorizationStatus  'AuthStatus',
    OL.ixSKU 'SKU',
    OL.iOrdinality,
    OL.flgLineStatus,
    ISNULL(S.sWebDescription, S.sDescription) 'SKU_Description',
    OL.mUnitPrice 'Unit_Price',
    (CASE WHEN S.flgIsKit = 1 THEN 'Y'
     ELSE ''
     END) 'Kit',
    (CASE WHEN OL.flgKitComponent = 1 THEN 'Y'
     ELSE ''
     END) 'KitComponent',
    OL.iQuantity 'Qty_Ordered',
    ISNULL(TOTQAV.TotQAV,0) 'TotQAV',
    ISNULL(TOTQOS.TotQOS,0) 'TotQOS',
    (CASE WHEN S.flgMadeToOrder = 1 THEN 'Y'
     ELSE ''
     END) 'MadeToOrder',
     --SL.sPickingBin 'PickingBin',
     BS.ixBin 'Bin',
     B.flgAvailablePicking
FROM   (-- FILLABLE ORDERS
                     SELECT ixOrder
                    --INTO #FILLABLE
                     FROM (SELECT O.ixOrder, OL.ixSKU, flgMadeToOrder,-- 2,272 orders     12,948 orderlines
                            CASE WHEN S.flgIsKit = 1 or S.flgMadeToOrder = 1 THEN 0
                                 WHEN ALLQTY.TotQOS< OL.iQuantity  THEN 1 -- need to use QOS because QAV subtracts out the backordered qty
        /*REMOVE if TEST fails*/ WHEN B.ixBin is NULL THEN 1 -- will be there if at least one bin is flagged as available for orders
                                 ELSE 0
                            END AS 'UNFILLABLE'
                            FROM tblOrder O 
                                left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                                left join tblSKU S on S.ixSKU = OL.ixSKU
                                left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation = 99 --NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
                                left join (-- Total QAV / QOS from all Locations
                                           select ixSKU, SUM(iQAV) 'TotQAV', SUM(iQOS) 'TotQOS'
                                           from tblSKULocation
                                           WHERE ixLocation = 99
                                           group by ixSKU) ALLQTY on ALLQTY.ixSKU = S.ixSKU
       /*REMOVE if TEST fails*/ left join tblBinSku  BS on BS.ixSKU = SL.ixSKU and BS.ixLocation = SL.ixLocation and BS.sPickingBin = SL.sPickingBin
       /*REMOVE if TEST fails*/ left join tblBin B on B.ixBin = BS.ixBin and B.ixLocation = BS.ixLocation and B.flgAvailableOrders = 1 
                                -- remove o
                            WHERE O.sOrderStatus = 'Backordered' -- 5,708
                               AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
                               AND S.ixSKU NOT LIKE 'TECHELP-%'

                              -- AND S.ixSKU in ('91048343-620-STD','91048343-683-STD','91048345-28-350','91048345-31-350','91048345-31-370','91049345-28-350','91049345-28-370','91049345-28-389','91049345-31-350','91049345-31-370','91049345-31-389','91049345-31-411','91049345-31-456')
                               ) FILLABLE
                     GROUP BY ixOrder
                     HAVING SUM(UNFILLABLE) = 0
        ) FBO
    left join tblOrder O on O.ixOrder = FBO.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBinSku BS on OL.ixSKU = BS.ixSKU and BS.ixLocation = 99
    left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation = 99 -- NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
    left join tblBin B on BS.ixBin = B.ixBin
    left join tblSKU S on S.ixSKU = OL.ixSKU
    --left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join (select ixSKU, SUM(iQAV) 'TotQAV' 
               from tblSKULocation
               where iQAV > 0
                    and ixLocation NOT IN (47,96)
               group by ixSKU) TOTQAV on TOTQAV.ixSKU = S.ixSKU
    left join (select ixSKU, SUM(iQOS) 'TotQOS' 
               from tblSKULocation
               where iQOS > 0
                    and ixLocation = 99 --NOT IN (47,96)
               group by ixSKU) TOTQOS on TOTQOS.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Backordered' -- 5,708
   --AND S.flgIsKit = 0-- exclude Kits on this version
   --AND OL.flgKitComponent = 0 --  exclude Kit components on this version
   AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
   AND S.ixSKU NOT LIKE 'TECHELP-%'
   AND O.ixAuthorizationStatus <> 'OK'
   AND (@SingleSKU = ' ' 
           OR O.ixOrder in (select distinct ixOrder from tblOrderLine OL where OL.ixSKU = @SingleSKU and flgLineStatus = 'Backordered')
        )
   -- AND S.ixSKU = '91015172'
ORDER BY O.dtOrderDate, O.ixOrder, OL.iOrdinality, OL.ixSKU--, SL.ixLocation desc


















-- Backorders Ready to Release
/*   ver 20.21.1
*/
DECLARE @SingleSKU varchar(25)
SELECT @SingleSKU = ' ' --'91015172'--  instead of NULL --'35519212593' 
    -- 35519212593 has 4 orders    9542107-1 9569405-1 9673208-1 9921006-1              9426102-1 is missing
    -- 2823022706KIT has 2 orders v
    -- 715BP15121 has 3 orders v
    
SELECT DISTINCT 
    O.ixOrder 'Order_#', 
    O.dtOrderDate 'Order_Date',
    O.ixCustomer,
    O.ixAuthorizationStatus  'AuthStatus',
    OL.ixSKU 'SKU',
    OL.iOrdinality,
    OL.flgLineStatus,
    ISNULL(S.sWebDescription, S.sDescription) 'SKU_Description',
    OL.mUnitPrice 'Unit_Price',
    (CASE WHEN S.flgIsKit = 1 THEN 'Y'
     ELSE ''
     END) 'Kit',
    (CASE WHEN OL.flgKitComponent = 1 THEN 'Y'
     ELSE ''
     END) 'KitComponent',
    OL.iQuantity 'Qty_Ordered',
    ISNULL(TOTQAV.TotQAV,0) 'TotQAV',
    ISNULL(TOTQOS.TotQOS,0) 'TotQOS',
    (CASE WHEN S.flgMadeToOrder = 1 THEN 'Y'
     ELSE ''
     END) 'MadeToOrder',
     --SL.sPickingBin 'PickingBin',
     BS.ixBin 'Bin',
     B.flgAvailablePicking
FROM   (-- FILLABLE ORDERS
                     SELECT ixOrder
                    --INTO #FILLABLE
                     FROM (SELECT O.ixOrder, OL.ixSKU, flgMadeToOrder,-- 2,272 orders     12,948 orderlines
                            CASE WHEN S.flgIsKit = 1 or S.flgMadeToOrder = 1 THEN 0
                                 WHEN ALLQTY.TotQOS< OL.iQuantity THEN 1 -- need to use QOS because QAV subtracts out the backordered qty
        /*REMOVE if TEST fails*/ WHEN B.ixBin is NULL THEN 1 -- will be there if at least one bin is flagged as available for orders
                                 ELSE 0
                            END AS 'UNFILLABLE'
                            FROM tblOrder O 
                                left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                                left join tblSKU S on S.ixSKU = OL.ixSKU
                                left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation = 99 --NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
                                left join (-- Total QAV / QOS from all Locations
                                           select ixSKU, SUM(iQAV) 'TotQAV', SUM(iQOS) 'TotQOS'
                                           from tblSKULocation
                                           WHERE ixLocation = 99
                                           group by ixSKU) ALLQTY on ALLQTY.ixSKU = S.ixSKU
       /*REMOVE if TEST fails*/ left join tblBinSku  BS on BS.ixSKU = SL.ixSKU and BS.ixLocation = SL.ixLocation and BS.sPickingBin = SL.sPickingBin
       /*REMOVE if TEST fails*/ left join tblBin B on B.ixBin = BS.ixBin and B.ixLocation = BS.ixLocation and B.flgAvailableOrders = 1 
                                -- remove o
                            WHERE O.sOrderStatus = 'Backordered' -- 5,708
                               AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
                               AND S.ixSKU NOT LIKE 'TECHELP-%'
                              -- AND S.ixSKU in ('91048343-620-STD','91048343-683-STD','91048345-28-350','91048345-31-350','91048345-31-370','91049345-28-350','91049345-28-370','91049345-28-389','91049345-31-350','91049345-31-370','91049345-31-389','91049345-31-411','91049345-31-456')
                               ) FILLABLE
                     GROUP BY ixOrder
                     HAVING SUM(UNFILLABLE) = 0
        ) FBO
    left join tblOrder O on O.ixOrder = FBO.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBinSku BS on OL.ixSKU = BS.ixSKU and BS.ixLocation = 99
    left join tblSKULocation SL on OL.ixSKU = SL.ixSKU and SL.ixLocation = 99 -- NOT IN (47,96)-- include all lcoations EXCEPT 47 Boonville & 96 CSI per FWG
    left join tblBin B on BS.ixBin = B.ixBin
    left join tblSKU S on S.ixSKU = OL.ixSKU
    --left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join (select ixSKU, SUM(iQAV) 'TotQAV' 
               from tblSKULocation
               where iQAV > 0
                    and ixLocation NOT IN (47,96)
               group by ixSKU) TOTQAV on TOTQAV.ixSKU = S.ixSKU
    left join (select ixSKU, SUM(iQOS) 'TotQOS' 
               from tblSKULocation
               where iQOS > 0
                    and ixLocation = 99 --NOT IN (47,96)
               group by ixSKU) TOTQOS on TOTQOS.ixSKU = S.ixSKU
WHERE O.sOrderStatus = 'Backordered' -- 5,708
   --AND S.flgIsKit = 0-- exclude Kits on this version
   --AND OL.flgKitComponent = 0 --  exclude Kit components on this version
   AND S.ixSKU NOT IN ('ADDPART','COMINVOICE','DROPSHIP','HELP','NCSHIP','NOEMAIL','PLONLY','READNOTE','XMAS') -- exclude per FWG
   AND S.ixSKU NOT LIKE 'TECHELP-%'
   AND O.ixAuthorizationStatus <> 'OK'
   AND (@SingleSKU = ' ' 
           OR O.ixOrder in (select distinct ixOrder from tblOrderLine OL where OL.ixSKU = @SingleSKU and flgLineStatus = 'Backordered')
        )
   -- AND S.ixSKU = '91015172'
ORDER BY O.dtOrderDate, O.ixOrder, OL.iOrdinality, OL.ixSKU--, SL.ixLocation desc




select * from tblBin where ixBin in ('4E12K2','IOJAC5','IOWOODS','CTRQUAR')

select * from tblSKULocation
where ixSKU = '91015172'

SELECT * FROM tblBinSku
where ixSKU = '91015172'

/*                      iSKU
ixBin	ixSKU	        Qty	sPickingBin	ixLocation
======= ============    === =========== ==========
TEMPSMI	91668042-RAW	0	TEMPSMI	    47
UQ06A5	91668042-RAW	0	UQ06A5	    85
X00A1	91668042-RAW	4	X31AF5	    99
X31AF5	91668042-RAW	1	X31AF5	    99
*/
SELECT * FROM tblSKULocation
where ixSKU = '91668042-RAW'

select ixLocation, count(*)
from tblBinSku group by ixLocation
/*
20	32
47	329468
85	195817
99	507199
*/

select ixLocation, count(*) 
from tblSKULocation
group by ixLocation

select ixLocation, ixSKU, count(sPickingBin)
from tblSKULocation
where ixLocation = 99
group by ixLocation, ixSKU
order by count(sPickingBin) desc

select * from tblSKULocation
where UPPER(sPickingBin) like '%QUAR%'
and ixLocation = 99


select BS.ixBin 'Bin',
 BS.sPickingBin 'PickingBin', BS.ixSKU 'SKU', SL.iQAV 'QAV', SL.iQOS 'QOS'
 from tblBinSku BS
    left join tblSKULocation SL on BS.ixSKU = SL.ixSKU and BS.ixLocation = 99 and SL.ixLocation = 99
where UPPER(ixBin)  like '%QUAR%'
and BS.ixLocation = 99
and BS.sPickingBin NOT IN ('BOM','BOX')
--and BS.ixSKU like '916%'
and SL.iQAV = 0
and SL.iQOS > 0


select flgAvailableOrders ixBin, FORMAT(count(distinct ixBin),'###,###') 'BinCount'
from tblBin 
where flgDeletedFromSOP = 0
group by flgAvailableOrders
order by ixBin





select distinct sPickingBin -- 73,162
from tblSKULocation
order by sPickingBin

select distinct sPickingBin -- 73,149
from tblBinSku
order by sPickingBin

select * from tblBin where ixBin in ('BG37B6','BG37C1','BG78B4','CBOM','Y27C6','SHOCK','BJ71AC','BM51B1','5B38G2','AH09C2','AP00A1','4E40F2','AM03E2','RCV','Z25A1','Z25A2','BJ03A2','A KIT','BH85AA','BH85AB','BG33C1','BG35A2','V63DC2','5D09A2','AF23B2','5B26B2','AM11D2','4B09G1','V03BB1','BG09B1','5D10C4','AG06CA','5D07C1','BP/SH','BL13A2','Z13C3','4B03C1','5D22J1','5B19H1','BN21A1','5C41B4','BL70A2','AM51D2','V22JA4','AE08H1','AG02B2','X11CA3','BM75A1','BM70A1','4A15B2','V03DD6','4E35B1','AE29G2','X11EB5','Y11A5','AE46G2','AG31G2','X01BG3','5C41B3','4B27E4','AK08EB','4C10B1','TRK','4D29C1','BK35B3','BL60B2','BL59B2','V67CD5','5B04C1','AK01DA','5D29H1','AL14E2','4C41F4','5E29G2','5F17F3','5D28G1','BL71A1','5E35A1','SDOCK','V44HA2','Z05A1','Z04A2','AM19BB','V01HD4','AH01A2','AH18H2','V01BC1','V03FC1','V03FC4','5A11G3','AM19F1','V50AA1','AH29G2','X29BD2','3D29C3','V52AA1','4A09H2','AH04G2','X00A1','X03CF1','4F17G4','BL56A2','X12GC4','V24DA3','5F28B1','Z35AC','BM60AA','AM15EA','V05FC3','5E21A2','AG28H2','AH23J1','X26AF1','AF27F1','AG09EA','AK08DA','AK19CB','AK20B1','AM49C1','AM54D2','Z13B5','5B16H1','AL45C1','BK00A1','BK70B4','BK72E1','BN14G2','BN15G2','BN19F2','BN31F1','BQ12D4','5F40A3','LOST','V02FD7','5C41B2','AK48G2','X34AF3','BD12B1','Z74L6','3D25K1','BM05A1','AE03CA','Y05D7','BM44AG','BM42AC','V04JD3','AJ10A1','AJ11A1','Z.NEW','BG72B2','BM69A2','BM63C2','BM63D2','BM68AB','BM59C1','BM72AB','BF51AF','QC-SHOP','BF50A2','BN31AA','BM31AB','BM18AB','4B37E2','BM18AA','BA27B1','5D15G1','BF51A5','LOSTNC','4B05J2','WOODS','BL76A3','BM25AD','4C27D2','BM07B1','BF74AB','BF86A3','V04EC2','AF11DA','AL00A2','BQ05D3','4D31G2','BM20AB','5C08F2','V01JC7','BH51A1','BH51A2','V04JC1','BM09A2','BC67A3','3E17K2','5F07B1','4A26C2','AM06DA','5A06A1','5C27F1','BK78AC','V04AB1','Y23C1','5E38B1','AK22A1','SR01A1','3A04C1','BF50AC','BF49AD','BF50AB','BF50AA','BF50AF','BD76B5','V77EC3','5E40F1','AJ19J1','3C14D4','AH49G1','X14FF1','3A00A1','3C16B1','V05HD3','BF52A5','AG99A1','BL19AB','V04CC5','4C17D1','X18DD1','BK13B1','5F06A1','AK23E1','AL48F2','BF86A2','BL63A2','BF49A1','V49BB5','BB04B1','BF51A6','V04ED4','X31AF5','5F05C4','3E07J4','4B08F2','4D29H1','BC55B1','BF63AD','Y23A4','BL64A1','Z63A1','Z56D1','4B16F2','AL12B1','5B42G2','4E08E1','AK17F2','AL15G1','3B07F2','BQ28A1','Y07A5','Z05B2','5D26D4','BH02A1','BK60A1','BJ52AB','BJ52AA','BF51AA','BH01B2','BH01D2','BH03D2','BH39F1','BH39F2','BH47G2','BH52D1','BH67D1','BH69D2','3D32G4','BH02B2','BH06F2','BH08D2','BH18D2','BH48C1','BH48E2','BH48F1','BH50D2','BH50F1','BH53H2','BH56F2','BH58F1','BH61C2','BH66H2','BH68G1','BH74G2','BH78C1','BH83F2','Z17B3','ADVER','AM06C1','V02BC2','AM43A2','V03HB3','4F28A2','5C34B1','BL64A6','V46AC3','3E39B1','BJ61A1','BJ59A3','V02FB6','BF90AC','BM03C1','BM09F1','4F15C3','AM41B2','R06RA','R51A08','SHOP-N','SHOP-F','BQ06B7','Z19D4','4B10H1','V56KC7','4A21C3','BP03A1','BF49AA','5C32E3')
and flgDeletedFromSOP = 0 and ixLocation = 99
order by flgAvailableOrders
