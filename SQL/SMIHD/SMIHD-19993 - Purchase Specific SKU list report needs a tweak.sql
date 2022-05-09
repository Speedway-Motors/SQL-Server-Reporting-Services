--  SMIHD-19993	- Purchase Specific SKU list report needs a tweak
/*      ver 20.50.1
DECLARE @SKU varchar(30), @StartDate datetime,  @EndDate datetime
SELECT @SKU = '91064022', @StartDate = '04/04/2020',    @EndDate = '07/03/2020'
*/
select DISTINCT OL.ixSKU, O.ixCustomer, TNG.sEmailAddress 'OrderEmail',
    S.sBaseIndex --C.sEmailAddress 'CUSTemail', 
from tblOrder O
    Left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    Left join tblCreditMemoMaster CMM on CMM.ixOrder = O.ixOrder
    Left join tblCreditMemoDetail CMD on CMD.ixCreditMemo = CMM.ixCreditMemo and CMD.ixSKU = OL.ixSKU
    Left join tblCustomer C on O.ixCustomer = C.ixCustomer
    Left join tng.tblorder TNG on TNG.ixSopOrderNumber = O.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS
    left join tblSKU S on OL.ixSKU = S.ixSKU
where O.dtOrderDate between @StartDate and @EndDate
    and O.ixBusinessUnit <> 109 -- exclude Marketplaces
    and (OL.ixSKU like @SKUBASE+'%'-- ALL SKUs with that BASE
            or 
         OL.ixSKU in (@SKU) -- List of SKUs (or single SKU)
        )
    and OL.flgLineStatus in ('Shipped','Open') -- Dropshipped too?
    and CMD.ixSKU is NULL -- exclude returns
    and TNG.sEmailAddress NOT IN ('DECLINED','')
    and TNG.sEmailAddress is NOT NULL
--and C.sEmailAddress <> TNG.sEmailAddress COLLATE SQL_Latin1_General_CP1_CI_AS -- match 591 out of 675   88%
order by TNG.sEmailAddress


select ixSKU, sBaseIndex
from tblSKU
where ixSKU in ('91734710','91734700-SS','917347-31','917347-28','917347-22','917347-31')

select ixSKU, sBaseIndex
from tblSKU
where ixSKU in ('91734710','91734700-SS')

--,'917347-31','917347-28','917347-22','917347-31')