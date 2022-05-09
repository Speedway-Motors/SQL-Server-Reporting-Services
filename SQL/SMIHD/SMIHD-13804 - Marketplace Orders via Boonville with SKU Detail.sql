/* SMIHD-13804 - Marketplace Orders via Boonville with SKU Detail.rdl
   ver 19.18.1

  base code from Unshipped Marketplace Orders via Boonville.rdl


DECLARE @StartDate datetime,        @EndDate datetime
  --@OrderStatus varchar(15),     @ShowPrintedOnly varchar(1)
  --  ,@AuthorizationStatus varchar(15),  @ShipMethod int,  @ShowSHOPOnly varchar(1)
    
SELECT @StartDate = '01/01/2019',  @EndDate = '04/30/2019'
    --@OrderStatus = 'Open' -- 'Backordered'
    --,@ShowPrintedOnly = 'N'
   -- ,@AuthorizationStatus = 'OK'  ,@ShipMethod = 2, @ShowSHOPOnly = 'Y'
*/
USE [SMI Reporting]
SELECT
    O.sOrderStatus 'OrderStatus', 
    O.ixAuthorizationStatus 'AuthStatus',
    O.sMethodOfPayment,
    D2.dtDate+SUBSTRING(T2.chTime,1,5) 'DateTimeAuthorized',
    D3.dtDate+SUBSTRING(T3.chTime,1,5) 'DateTimeAvailableToPrint',
    (dbo.GetLatestOrderTimePrinted (O.ixOrder)) 'dtTimePrinted',
    O.dtOrderDate 'DateEntered', -- KEEP for cond. formatting
    SUBSTRING(T1.chTime,1,5) 'TimeEntered',-- KEEP for cond. formatting
    O.dtOrderDate+SUBSTRING(T1.chTime,1,5) 'DateTimeEntered',
    O.mMerchandise 'OrderTotal', 
    O.ixOrder 'OrderNum',
    O.sOrderTaker 'OrderTaker',
    (dbo.OrderLineHELP (O.ixOrder)) 'HelpOL',
    (dbo.PickBinSHOP (O.ixOrder)) 'PickBinSHOP',
    isnull(O.ixAccountManager,'Unassigned') ActMgr,
    O.iShipMethod ShipMethod,
 --   ORT.ixCommitmentPrimaryTrailer, -- <-- using this as the "Authorization Primary Trailer" since we don't actually have one. Should be the same the vast majority of the time
 --   ORT.ixVerifyPrimaryTrailer,
    O.ixPrimaryShipLocation,
    O.sOrderType,
    convert(varchar, O.dtGuaranteedDelivery, 101) as 'GuaranteedDeliveryDate',
    flgGuaranteedDeliveryPromised,
   O.sOrderChannel,
   OL.iOrdinality, -- not on final report
   OL.ixSKU,
   OL.iQuantity 'QtyOrdered',
   S.sDescription 'SKUDescription',
   OL.flgLineStatus 'OrderLineStatus'
FROM tblOrder O
    left join tblOrderRouting ORT on ORT.ixOrder = O.ixOrder
    left join tblTime T1 on T1.ixTime = O.ixOrderTime
    left join tblDate D2 on D2.ixDate = O.ixAuthorizationDate
    left join tblTime T2 on T2.ixTime = O.ixAuthorizationTime
    left join tblDate D3 on D3.ixDate = ORT.ixAvailablePrintDate
    left join tblTime T3 on T3.ixTime = ORT.ixAvailablePrintTime
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
WHERE --O.ixOrderDate > 18607 -- '12/10/2018'   periodically reset floor to reduce query time
        O.sOrderStatus in ('Open','Backordered','Shipped', 'Cancelled') -- (@OrderStatus)
    and O.sOrderChannel IN ('AMAZON','AUCTION','WALMART')
    and O.ixPrimaryShipLocation = 47 -- 47 = Booneville
    and O.dtOrderDate between @StartDate and @EndDate -- > '01/01/2019'
--    and O.ixOrder in ('8133431','8212730','8548531','8653437','8789336','8170048','8650549','8761046','8916345','8406254','8519055','8508454','8573450','8660154','8684250') -- = '8212730'   TESTING ONLY
ORDER BY DateEntered, TimeEntered, O.ixOrder, OL.iOrdinality