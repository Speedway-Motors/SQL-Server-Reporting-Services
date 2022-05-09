-- SMIHD-5290 - Analyze change in Fed Ex & UPS shipping percentages
--              since Connectship update on 8/18/16

/****   SHIPPING > 0  *****/
select count(*) from tblOrder where iShipMethod in ('13','14')
    and dtOrderDate between '08/11/16' and '08/16/16'
    and sOrderStatus = 'Shipped'
    and mShipping > 0
    and sOrderType <> 'Internal'
    and mMerchandise > 0 
    
select count(*) from tblOrder where iShipMethod not in ('13','14')
    and dtOrderDate between '08/11/16' and '08/16/16'
    and sOrderStatus = 'Shipped'
    and mShipping > 0
    and sOrderType <> 'Internal'
    and mMerchandise > 0 



/****   FREE SHIPPING *****/    
select count(*) from tblOrder where iShipMethod in ('13','14')
    and dtOrderDate between '08/11/16' and '08/16/16'
    and sOrderStatus = 'Shipped'
    and mShipping = 0
    and sOrderType <> 'Internal'
    and mMerchandise > 0 
    
select count(*) from tblOrder where iShipMethod not in ('13','14')
    and dtOrderDate between '08/11/16' and '08/16/16'
    and sOrderStatus = 'Shipped'
    and mShipping = 0
    and sOrderType <> 'Internal'
    and mMerchandise > 0 



select * from tblShipMethod where ixCarrier like 'F%'
/*
ixShip
Method	sDescription	    ixCarrier	sTransportMethod
13	    FedEx Ground	    FedEx	    Ground
14	    FedEx Home Delivery	FedEx	    Ground
15	    FedEx SmartPost	    FedEx	    Ground              <-- should this be included in analysis?
*/