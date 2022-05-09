-- SMIHD-19450 - AFCO - DeWitts Backorder Report

/*
select *
from tblCatalogMaster
where ixCatalog like 'DW%'
or ixCatalog like '%DW'

/***  DO NOT USE SC to ID DeWitts backorders!!!!  ***/
select distinct ixOrder, sSourceCodeGiven
from tblOrder
where sOrderStatus = 'Backordered'
and sSourceCodeGiven IN ('DW2020') 
and ixOrder NOT IN (select distinct ixOrder 
                        from tblOrderLine 
                        where ixSKU like '32-%'
                        and flgLineStatus= 'Backordered')
*/


/* DeWitts Backorders.rdl
    ver 21.11.1
*/

-- AFCO Dewitts Backorders
select distinct ixOrder
into #DewittsBackorders
from tblOrder
where sOrderStatus = 'Backordered'
        AND ixOrder in (select distinct ixOrder 
                        from tblOrderLine 
                        where ixSKU like '32-%'
                        and flgLineStatus= 'Backordered')

SELECT -- 403
    isnull(O.ixAccountManager,'Unassigned')    ActMgr,
    isnull(C.ixAccountManager2,'Unassigned')    ActMgr2,
    isnull(C.sMailToCountry,'US') MailToCountry,
    O.dtOrderDate         DateEntered,
    SUBSTRING(T.chTime,1,5) TimeEntered,
    O.dtOrderDate+SUBSTRING(T.chTime,1,5) DateTimeEntered,
    D3.dtDate+SUBSTRING(T3.chTime,1,5) 'DateTimeAvailableToPrint',
    (dbo.GetLatestOrderTimePrinted (O.ixOrder)) 'dtTimePrinted',
    O.ixCustomer          CustNum,
    (isnull(C.sCustomerFirstName, '')+ ' ' + isnull(C.sCustomerLastName, ''))   CustName,
    O.sOrderTaker         OrderTaker,
    O.ixOrder                 OrderNum,
    O.mMerchandise        Merch,
    S.ixSKU,
    S.sDescription SKUDescription,
    S.ixABCCode 'ABCCode',
    S.sCycleCode 'CycleCode',
    OL.mExtendedPrice          OLMerch,
    OL.iQuantity,
    --SKU.iQAV,
   (isnull(SKULL.iQAV,0)+isnull(SKULL.iQCB,0)) AdjQAV,
   (isnull(SKUM.iQAV,0)+isnull(SKUM.iQCB,0)) AdjQAVMulti,   
    SKULL.iQOS,
    SKUM.iQOS 'iQOSMulti',
    SC.ixCatalog
FROM tblOrder O
    left join #DewittsBackorders DBO on O.ixOrder = DBO.ixOrder
    left join tblOrderRouting ORT on ORT.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS  = O.ixOrder
    left join tblTime T on T.ixTime = O.ixOrderTime  
    left join tblDate D3 on D3.ixDate = ORT.ixAvailablePrintDate
    left join tblTime T3 on T3.ixTime = ORT.ixAvailablePrintTime
    left join tblCustomer C on C.ixCustomer = O.ixCustomer
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod 
    left join tblOrderLine OL on OL.ixOrder = O.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblSKULocation SKULL on SKULL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = OL.ixSKU  
                                    and SKULL.ixLocation = 99 
    left join vwSKUMultiLocation SKUM on SKUM.ixSKU = OL.ixSKU
   	left join tblSourceCode SC on O.sSourceCodeGiven = SC.ixSourceCode
WHERE O.sOrderStatus = 'Backordered'
    and DBO.ixOrder is NOT NULL -- order is a DeWitts order
---AND ORT.ixOrder is NOT NULL
--and O.ixOrder = '732753-1'
ORDER BY ActMgr, DateTimeEntered, AdjQAV

DROP TABLE #DewittsBackorders