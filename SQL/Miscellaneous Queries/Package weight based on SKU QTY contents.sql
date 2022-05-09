-- package weight based on SKU QTY contents

-- roll-up at Package Level
select P.sTrackingNumber, P.ixOrder, dBillingWeight, dActualWeight, CS.TotSKUWeight
from tblPackage P
    left join (-- Calculated SKU Weight for Packages based on SKU Quantities x SKU Weight
               select P.sTrackingNumber,P.ixOrder, SUM(OL.iQuantity * S.dWeight) 'TotSKUWeight' 
               from tblPackage P
                    left join tblOrderLine OL on P.ixOrder = OL.ixOrder and P.sTrackingNumber = OL.sTrackingNumber -- must join on both since TRACKING NUMBERS CAN BE RE-USED!
                    left join tblSKU S on OL.ixSKU = S.ixSKU
               where  OL.flgLineStatus = 'Shipped'
                    and S.flgIsKit = 0
                    and S.flgIntangible = 0
                   -- and P.sTrackingNumber = '1Z6353580332404569'
               Group by P.sTrackingNumber,P.ixOrder
              ) CS on P.sTrackingNumber = CS.sTrackingNumber and   P.ixOrder = CS.ixOrder  
where P.ixShipDate = 17277



-- FREIGHT DEV at ORDER level
SELECT O.ixOrder,O.iShipMethod, CONVERT(varchar, O.dtShippedDate, 110) 'ShippedDate', 
O.mPublishedShipping, 
SUM(PRU.dBillingWeight) 'BillingWeight',
SUM(PRU.dActualWeight) 'ActualWeight',
SUM(PRU.TotSKUWeight) 'SumOfSKUWeights'
FROM tblOrder O
left join (-- roll-up at Package Level
            select P.sTrackingNumber, P.ixOrder, dBillingWeight, dActualWeight, CS.TotSKUWeight
            from tblPackage P
                left join (-- Calculated SKU Weight for Packages based on SKU Quantities x SKU Weight
                           select P.sTrackingNumber,P.ixOrder, SUM(OL.iQuantity * S.dWeight) 'TotSKUWeight' 
                           from tblPackage P
                                left join tblOrderLine OL on P.ixOrder = OL.ixOrder and P.sTrackingNumber = OL.sTrackingNumber -- must join on both since TRACKING NUMBERS CAN BE RE-USED!
                                left join tblSKU S on OL.ixSKU = S.ixSKU
                           where  OL.flgLineStatus = 'Shipped'
                                and S.flgIsKit = 0
                                and S.flgIntangible = 0
                               -- and P.sTrackingNumber = '1Z6353580332404569'
                           Group by P.sTrackingNumber,P.ixOrder
                          ) CS on P.sTrackingNumber = CS.sTrackingNumber and   P.ixOrder = CS.ixOrder  
            where P.ixShipDate = 17277
            ) PRU on O.ixOrder = PRU.ixOrder
WHERE O.sOrderStatus = 'Shipped'  
    and O.sOrderType <> 'Internal' 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate = '04/20/2015' -- between '01/01/2012' and '12/31/2012'
    and O.iShipMethod <> 1
GROUP BY O.ixOrder,O.iShipMethod, CONVERT(varchar, O.dtShippedDate, 110), 
O.mPublishedShipping    
ORDER BY O.ixOrder       
            
            
SELECT O.ixOrder,
        O.iShipMethod 'OrderShipMethod', 
        O.dtShippedDate 'OrderShippedDate', 
        O.mPublishedShipping 'OrderPublishedShipping'
        SUM(PRU.dBillingWeight) 'OrderBillingWeight',
        SUM(PRU.dActualWeight) 'OrderActualWeight',
        SUM(PRU.TotSKUWeight) 'OrderSumOfSKUWeight',
        PRU.sTrackingNumber 'PkgTrackingNumber',
        PRU.dBillingWeight 'PkgBillingWeight', 
        PRU.dActualWeight 'PKGActualWeight', 
        PRU.TotSKUWeight 'PKGTotSKUWeight',
        OL.ixSKU,
        OL.iQuantity,
        SKU.sDescription,
        SKU.flgShipAloneStatus,
        SKU.dWeight,
        SKU.iHeight,
        SKU.iWidth,
        SKU.flgORMD
FROM tblOrder O
left join tblOrderLine OL on O.ixOrder = OL.ixOrder
left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
left join (-- roll-up at Package Level
            select P.sTrackingNumber, P.ixOrder, dBillingWeight, dActualWeight, CS.TotSKUWeight
            from tblPackage P
                left join (-- Calculated SKU Weight for Packages based on SKU Quantities x SKU Weight
                           select P.sTrackingNumber,P.ixOrder, SUM(OL.iQuantity * S.dWeight) 'TotSKUWeight' 
                           from tblPackage P
                                left join tblOrderLine OL on P.ixOrder = OL.ixOrder and P.sTrackingNumber = OL.sTrackingNumber -- must join on both since TRACKING NUMBERS CAN BE RE-USED!
                                left join tblSKU S on OL.ixSKU = S.ixSKU
                           where  OL.flgLineStatus = 'Shipped'
                                and S.flgIsKit = 0
                                and S.flgIntangible = 0
                               -- and P.sTrackingNumber = '1Z6353580332404569'
                           Group by P.sTrackingNumber,P.ixOrder
                          ) CS on P.sTrackingNumber = CS.sTrackingNumber and   P.ixOrder = CS.ixOrder  
           -- where P.ixShipDate = 17277
            ) PRU on O.ixOrder = PRU.ixOrder
WHERE O.sOrderStatus = 'Shipped'  
    and O.sOrderType <> 'Internal' 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
  --  and O.dtShippedDate = '04/20/2015' -- between '01/01/2012' and '12/31/2012'
    and O.iShipMethod <> 1
    and OL.flgLineStatus = 'Shipped'
GROUP BY O.ixOrder,O.iShipMethod, O.dtShippedDate, O.mPublishedShipping, 
    PRU.sTrackingNumber, PRU.dBillingWeight, PRU.dActualWeight,PRU.TotSKUWeight,
    OL.ixSKU,
    OL.iQuantity,
    SKU.sDescription,
    SKU.flgShipAloneStatus,
    SKU.dWeight,
    SKU.iHeight,
    SKU.iWidth,
    SKU.flgORMD
ORDER BY O.ixOrder       
            
            
            
                        

            
            
            
select COUNT(*) from tblOrder O
where O.sOrderStatus = 'Shipped'  
    and O.sOrderType <> 'Internal' 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate = '04/20/2015' -- between '01/01/2012' and '12/31/2012'
    and O.iShipMethod <> 1





-- Total Package Weight based on SKU Quantities
select SUM(OL.iQuantity * S.dWeight) 'TotSKUWeight' 
from tblPackage P
left join tblOrderLine OL on P.ixOrder = OL.ixOrder and P.sTrackingNumber = OL.sTrackingNumber
left join tblSKU S on OL.ixSKU = S.ixSKU
where P.sTrackingNumber = '1Z6353580332404569'
    and OL.flgLineStatus = 'Shipped'
    and S.flgIsKit = 0
    and S.flgIntangible = 0




91.569

-- should return 27.495



select * from tblPackage
where sTrackingNumber = '1Z6353580332404569'
/*
dBillingWeight	dActualWeight
28.000	        28.400
*/

select OL.ixOrder, OL.ixSKU, iQuantity, S.dWeight
from tblOrderLine OL
    left join tblSKU S on OL.ixSKU = S.ixSKU
where sTrackingNumber = '1Z6353580332404569'
order by ixSKU
/*
ixSKU	 iQuantity	dWeight
6173513	    1	0.011
6178568	    1	0.501
8352300542	4	0.190
91031045-L	1	7.661
91031045-R	1	7.661
91031071	1	0.161
91031311	1	0.161
910616005	1	0.251
912S18543	2	0.051
912TLM11949	2	0.151
912TLM67048	2	0.201
91631931	1	6.121
9193381	    1	3.401
*/

select * from tblOrderLine OL
where ixOrder = '6112612'
and OL.ixSKU in ('91031974','91065390')