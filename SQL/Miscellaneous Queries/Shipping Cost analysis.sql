select top 10 * from tblPackage
where ixShipDate = 17277 -- '04/20/2015'
order by newid()
/*
sTrackingNumber	    ixOrder	ixVerificationDate	ixVerificationTime	ixShipDate	ixShipTime	ixPacker	ixVerifier	ixShipper	dBillingWeight	dActualWeight	ixTrailer	mPublishedFreight	mShippingCost	ixVerificationIP	ixShippingIP	dtDateLastSOPUpdate	ixTimeLastSOPUpdate	ixShipTNT	flgMetals	flgCanceled
1Z6353580332404505	6126618	17277	            34715	            17277	    39649	    BDB	        CLM	        LEB	        40.000	        41.300	        KC	        NULL	            NULL	        192.168.240.33	    192.168.240.34	2015-04-20 	        39666	            3	        0	        0
1Z6353580232420794	6172714	17277	            57221	            17277	    61263	    EMT	        NAP	        CAK	        1.000	        1.300	        NULL	    NULL	            NULL	        192.168.240.35	    192.168.240.36	2015-04-20 	        61277	            2	        0	        0
1Z6353580332407717	6146611	17277	            40993	            17277	    47568	    SEG	        CJS6	    TCD	        3.000	        2.420	        OMH	        NULL	            NULL	        192.168.240.29	    192.168.240.36	2015-04-20 	        47594	            2	        0	        0
1Z6353580332422049	6197716	17277	            58809	            17277	    59392	    SEG	        KDC     	CAK	        8.000	        7.720	        LNK	        NULL	            NULL	        192.168.240.27	    192.168.240.36	2015-04-20 	        59395	            1	        0	        0
*/

select OL.ixOrder,OL.ixSKU, S.sDescription, S.dWeight, OL.iQuantity, (S.dWeight * OL.iQuantity) 'ExtendedWeight'
from tblOrderLine OL
    left join tblSKU S on OL.ixSKU = S.ixSKU
where sTrackingNumber = '1Z6353580332407717'

select * from tblPackage
where ixOrder = '6146611'


select ixOrder, COUNT(*) Pkgs
from tblPackage
where ixShipDate = 17277
group by ixOrder
order by COUNT(*) desc

SELECT ixOrder, COUNT(*)
from tblOrderLine
where ixOrder in ('6112612','6116512','6110710','6110810','6110813','6110819','6107710','6105617')
    and flgLineStatus = 'Shipped'
group by ixOrder
/*
ixOrder	(No column name)
6105617	10
6107710	3
6110710	7
6110810	3
6110813	8
6110819	5
6112612	16
6116512	29
*/


select * 
from tblOrderLine
where ixOrder = '6112612'
order by sTrackingNumber

select * from tblSKU
where ixSKU = '91031911'








/***** EXAMPLE orders from Kevin ****/
select * from tblOrder where ixOrder = '6101811'

select * from tblPackage where ixOrder = '6101811'
/*
dBillingWeight	dActualWeight
46.000	47.500
64.000	63.300
60.000	61.800
======= ======



170	172.6

*/



select * from tblOrder where ixOrder = '6761405' -- 6718201

select * from tblPackage where ixOrder = '6761405'






select O.ixOrder,sOrderType, iShipMethod, dtShippedDate, sOrderStatus, mMerchandise, 
    mShipping, mPublishedShipping, dbo.EstShippingCost(iShipMethod,mPublishedShipping) 'EstShippingCost',
    mMerchandiseCost
from tblOrder O
where ixOrder = '6718201' -- 6718201

-- Shipping Cost analysis

select --*
 ixOrder, sTrackingNumber, dBillingWeight, dActualWeight 
from tblPackage 
where ixOrder = '6718201'


select OL.ixSKU, S.dWeight
from tblOrderLine OL
    join tblSKU S on OL.ixSKU = S.ixSKU
where OL.ixOrder = '6718201'    




select O.ixOrder,sOrderType, iShipMethod, dtShippedDate, sOrderStatus, mMerchandise, 
    mShipping, mPublishedShipping, dbo.EstShippingCost(iShipMethod,mPublishedShipping) 'EstShippingCost',
    mMerchandiseCost
from tblOrder O
where ixOrder = '6761405' -- 

select --*
 ixOrder, sTrackingNumber, dBillingWeight, dActualWeight 
from tblPackage 
where ixOrder = '6761405'


select OL.ixSKU, S.dWeight
from tblOrderLine OL
    join tblSKU S on OL.ixSKU = S.ixSKU
where OL.ixOrder = '6761405'   

select * from tblOrder
where ixOrder = '6761405'   
 
