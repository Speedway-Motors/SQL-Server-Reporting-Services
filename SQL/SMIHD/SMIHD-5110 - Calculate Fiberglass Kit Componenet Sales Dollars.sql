-- SMIHD-5110 - Calculate Fiberglass Kit Componenet Sales Dollars

/*
1) refresh and clean up all Kit SKU data (tblKIT)
    DONE

2) ID all Kit SKUs that contain 1+ fiberglass SKUs
    DONE vwKitsContainingFiberglassSKUs
    
*/        

select COUNT (distinct ixKitSKU) -- 30,356 Kit SKUs
from tblKit

select COUNT (distinct KitSKU) -- 30,356 Kit SKUs
from vwKitSKUDetail

select COUNT (distinct ixKitSKU) -- 129 Kits contain 1+ FG SKUs
from vwKitsContainingFiberglassSKUs

select  * from vwKitsContainingFGSKUsDetails -- 129 Kits with 362 detail lines


select distinct ixKitSKU
from tblKit
where dtDateLastSOPUpdate < '5-8-16' -- 0



select top 10 * from tblKit
/*
ixKitSKU,ixSKU,    iQtyRequired,ixCreateDate,ixCreator,ixChangeDate,ixChanger,flgIndexedChoice,dtDateLastSOPUpdate,    ixTimeLastSOPUpdate
106100042,10680094,1,            16084,        KDL,        16087,        JMC1,    0,                2016-05-02 00:00:00.000,49396
*/

select COUNT (distinct ixKitSKU) -- 459 Kits have indexed choices
from tblKit
where flgIndexedChoice = 1


SELECT top 1 * from vwKitSKUDetail
/*                                                      Component                                   Component                       Component       Component           Component       Component
KitSKU,    ComponentSKU,Description,                SKUDescription,            KitSKURetail,SKURetail,        AverageCost,SKUQtyRequired,SKUExtendedRetail,SKUExtendedCost SKUExtendedGP
102713504,102713000,    KWIK CHANGE ECON BLEED KIT,KWIK CHANGE SCHRADER VALVE,199.99,        10.99,            7.30,    1,            10.99,            7.30,        3.69
*/

SELECT top 1 * from vwKitsContainingFiberglassSKUs
/*                                                      Component                                   Component                       Component       Component           Component       Component
ixKitSKU
7151800
*/

SELECT top 1 * from vwKitsContainingFGSKUsDetails
/*
ixKitSKU,ComponentSKU,Description,                ComponentSKUDescription,KitSKURetail,ComponentSKURetail,AverageCost,ComponentSKUQtyRequired,ComponentSKUExtendedRetail,ComponentSKUExtendedCost,ComponentSKUExtendedGP
7151800,    7022930-ZINC,TRIBUTE T FRAME & BODY KIT,CORVAIR PITMAN ARM,    3999.99,        49.99,            5.70,    1,                    49.99,                    5.70,                    44.29
*/

SELECT *
into [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits
from vwKitsContainingFGSKUsDetails


SELECT top 1 * from PJC_SMIHD5110_FiberglassKits

/*
update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX
*/


-- Combined Kit Cost
UPDATE A
SET CombinedKitCost = RU.CombCost
FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits A
    JOIN (SELECT ixKitSKU, SUM(ComponentSKUExtendedCost) CombCost
          FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits
          GROUP BY ixKitSKU
          ) RU ON A.ixKitSKU = RU.ixKitSKU
          
ROLLBACK TRAN       



/**** TABLE UPDATES *******/
    -- Combined Kit Cost
    UPDATE A
    SET CombinedKitCost = RU.CombCost
    FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits A
        JOIN (SELECT ixKitSKU, SUM(ComponentSKUExtendedCost) CombCost
              FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits
              GROUP BY ixKitSKU
              ) RU ON A.ixKitSKU = RU.ixKitSKU

    -- Component Percent Cost
    UPDATE A
    SET ComponentPercentCost = RU.ComponentPercentCost
    FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits A
        JOIN (SELECT ixKitSKU, ComponentSKU, (ComponentSKUExtendedCost/(CombinedKitCost+0.001)) ComponentPercentCost
              FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits
              ) RU ON A.ixKitSKU = RU.ixKitSKU AND A.ComponentSKU = RU.ComponentSKU

    -- WeightedComponentMerch
    UPDATE A
    SET WeightedComponentMerch = RU.WeightedComponentMerch
    FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits A
        JOIN (SELECT ixKitSKU, ComponentSKU, (KitSKURetail*ComponentPercentCost) WeightedComponentMerch
              FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits
              ) RU ON A.ixKitSKU = RU.ixKitSKU AND A.ComponentSKU = RU.ComponentSKU              


SELECT * FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits   order by ComponentPercentCost      

select ixKitSKU, COUNT(*)
from [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits 
group by ixKitSKU
having COUNT(*) = 1
    
SELECT * FROM tblKit
WHERE ixKitSKU in ('9002030','9002031','9002040','9002041','9003929')
         
select ixKitSKU, SUM(ComponentPercentCost)
from [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits
group by ixKitSKU
order by SUM(ComponentPercentCost)         

SELECT * FROM tblKit
WHERE ixKitSKU in ('9006947','9007137','97493113')

SELECT * FROM [SMITemp].dbo.PJC_SMIHD5110_FiberglassKits
WHERE ixKitSKU in ('9006947','9007137','97493113')

SELECT * FROM tblSKU
where ixSKU in ('9006947','9007137','97493113')

SELECT * FROM tblOrderLine
where ixSKU in ('9006947','9007137','97493113')










ROLLBACK TRAN 





select VW.KitSKU, SKU.mPriceLevel1, SKU.ixPGC, SUM(ComponentSKUExtendedCost) TotExtCost
from vwKitSKUDetail VW
join tblSKU SKU on VW.KitSKU = SKU.ixSKU
group by VW.KitSKU, SKU.mPriceLevel1, SKU.ixPGC
HAVING SUM(ComponentSKUExtendedCost) > SKU.mPriceLevel1
order by KitSKU

select VW.KitSKU, SKU.mPriceLevel1, SKU.ixPGC, SUM(ComponentSKUExtendedCost) TotExtCost
from vwKitSKUDetail VW
join tblSKU SKU on VW.KitSKU = SKU.ixSKU
join vwKitsContainingFiberglassSKUs FG on FG.ixKitSKU = VW.KitSKU
group by VW.KitSKU, SKU.mPriceLevel1, SKU.ixPGC
HAVING SUM(ComponentSKUExtendedCost) > SKU.mPriceLevel1
order by KitSKU


select distinct
from vwKitSKUDetail KSD
join vwKitsContainingFiberglassSKUs FGKits on FGKits.ixKitSKU = KSD.KitSKU
order by KitSKU

select 

select distinct ixKitSKU -- 129 Fiberglass Kits
from tblKit
where ixSKU in (select distinct ixSKU 
                from tblSKU 
                where ixPGC = 'fG'
                )
                
                
SELECT OL.* 
from tblOrderLine OL
   -- join tblOrder O on OL.ixOrder = O.ixOrder
    join vwKitsContainingFiberglassSKUs FBKits on  FBKits.ixKitSKU = OL.ixSKU
where OL.flgLineStatus = 'Shipped'
and OL.dtShippedDate >= '08/05/2015'



    O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2015' and '12/31/2015'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                      
                      
                      
-- EXAMPLE order that has two kits
SELECT ixOrder, iOrdinality, ixSKU, flgKitComponent, iKitOrdinality, 
    iQuantity, mExtendedPrice, mExtendedCost, mCost, mUnitPrice, mSystemUnitPrice, mExtendedSystemPrice, flgLineStatus
FROM tblOrderLine
where ixOrder = '6626086'
order by iOrdinality

SELECT * from tblOrderLine where mUnitPrice <> mSystemUnitPrice


select count(*)
from tblOR