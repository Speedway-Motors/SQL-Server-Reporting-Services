SELECT O.ixCustomer, 
SUM(O.mMerchandise)            GrossMerch, 
SUM(O.mShipping)               GrossFreight,    
SUM(O.mTax)                    GrossTax,
R.ReturnsMerch,
R.ReturnsFreight,
R.ReturnsTax,
(SUM(O.mMerchandise)-R.ReturnsMerch) NetMerch,
(SUM(O.mShipping)-R.ReturnsFreight) NetFreight,
(SUM(O.mTax)-R.ReturnsTax) NetTax
FROM tblOrder O
    -- RETURNS
    left join(select ixCustomer,
                    SUM(mMerchandise) ReturnsMerch, 
                    SUM(mShipping)    ReturnsFreight,   
                    SUM(mTax)         ReturnsTax
                from tblCreditMemoMaster CMM
                where dtCreateDate >= '02/01/2011'
                    and dtCreateDate < '03/01/2011'
                    and flgCanceled = 0
                    and ixCustomer = '1347437'
                group by ixCustomer
              ) R on R.ixCustomer = O.ixCustomer
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate >= '02/01/2011'
    and O.dtShippedDate < '03/01/2011'
    and O.ixCustomer = '1347437' 
GROUP BY O.ixCustomer ,
R.ReturnsMerch,
R.ReturnsFreight,
R.ReturnsTax




/*
SALES
ixCustomer	GrossSales	Shipping	Tax
1347437	    1600.00	    0.00	    0.00
1347437	    188.34	    0.00	    0.00
1347437	    1649.99	    21.36	    116.99
            =========   ======      ======
1347437	    3438.33	    21.36	    116.99

RETURNS
ixCustomer	GrossSales	Shipping	Tax
1347437	    1600.00	    0.00	    0.00
1347437	    188.34	    0.00	    0.00
            =========   ====        ====
1347437	    1788.34	    0.00	    0.00






select * from tblCustomer where ixCustomer = '9999'













select top 1 * from tblOrder

ixOrder	ixCustomer	ixOrderDate	sShipToCity	sShipToState	sShipToZip	sOrderType	sOrderChannel	sShipToCountry	ixShippedDate	iShipMethod	sSourceCodeGiven	sMatchbackSourceCode	sMethodOfPayment	sOrderTaker	sPromoApplied	mMerchandise	mShipping	mTax	mCredits	sOrderStatus	flgIsBackorder	mMerchandiseCost	dtOrderDate	dtShippedDate	ixAccountManager	ixOrderTime	mPromoDiscount	ixAuthorizationStatus	ixOrderType	mPublishedShipping	sOptimalShipOrigination
0	56651	14163	LINCOLN	NE	68506	Retail	PHONE	NULL	NULL	2	NULL	NULL	VISA	TOP	NULL	0.00	8.54	0.60	0.00	Cancelled	0	0.00	2006-10-10 00:00:00.000	NULL	NULL	0	NULL	NULL	NULL	NULL	NULL



select O.ixCustomer, count(O.ixOrder) QTY, count(CMM.ixCreditMemo) CMs
from tblOrder O
    join tblCreditMemoMaster CMM on CMM.ixCustomer = O.ixCustomer
WHERE O.sOrderStatus = 'Shipped'
and O.dtShippedDate >= '02/01/2011'
and O.dtShippedDate < '03/01/2011'
--and ixCustomer = '1087436'
and O.mTax > 0
and O.mCredits > 0
and CMM.dtCreateDate >= '02/01/2011'
				and CMM.dtCreateDate < '03/01/2011'
group by O.ixCustomer
order by QTY desc


1594604

*/
