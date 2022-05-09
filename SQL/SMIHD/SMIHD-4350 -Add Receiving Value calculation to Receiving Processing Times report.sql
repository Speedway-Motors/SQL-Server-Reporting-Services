-- SMIHD-4350 -Add Receiving Value calculation to Receiving Processing Times report
SELECT count(*) from tblOrder
where sOrderStatus = 'Open'


select * from tblSKUTransaction


SELECT *
FROM tblReceiver
where ixCreateDate >= 17654 -- 05/01/16   262 receivers

-- status of receivers created YTD
select COUNT(*) 'RecvrCnt', flgStatus
FROM tblReceiver
where ixCreateDate >= 17533 -- 05/01/16   262 receivers
group by flgStatus
/*
Recvr   flg
Cnt	    Status
=====   ======
6	    Open
6560	Posted
34	    Closed

*/


SELECT *
FROM tblReceiver
where ixCreateDate = 17655 -- 05/02/16   89 receivers created Mon

SELECT *
FROM tblReceivingWorksheet
where ixCreateDate = 17655 -- 05/02/16   91 receivering worksheets created Mon


select * from tblPOMaster
where ixPO = '112151'

select * from tblPODetail
where ixPO = '112151'

-- POs with 2-3 line items that had a receiver Mon
select ixPO, COUNT(iOrdinality)
from tblPODetail
where ixPO in (select distinct ixPO
                FROM tblReceiver
                where ixCreateDate = 17655 -- 05/01/16   89 receivers for 85 distinct POs
                )
group by ixPO
HAVING  COUNT(iOrdinality) between 2 and 3              
order by ixPO            
/*
111564
111702
111725
111749
112292
112338
112372
112422
*/


select * -- distinct ixSKU
from tblPODetail
where ixPO in ('111564','111702','111725','111749','112292','112338','112372','112422')




SELECT * FROM tblReceiver
where ixPO = '112338'

/* TEST PO
    - 1 receiver, created and closed Mon
    -- 3 SKUs all fully received on Mon

ixPO	ixSKU	    iQuantity
112338	9161002	    10
112338	9161090	    20
112338	91649058	5
*/


select * from tblSKUTransaction 
where ixDate = 17655
and ixSKU in ('9161002','9161090','91649058')
order by ixSKU, iSeq


SELECT * FROM tblSKUTransaction
where ixReceiver = '190776'
ixSKU	    iQty	mAverageCost    ExtCost
9161002	    10	    33.48           334.80 
9161090	    5	    46.37           231.85
9161090	    5	    46.37           231.85
9161090	    5	    46.37           231.85
9161090	    5	    46.37           231.85
91649058	5	    252.40        1,262.00
                                  =========
                                  2,524.20

select ixSKU, mAverageCost, mLatestCost from tblSKU
where ixSKU in ('9161002','9161090','91649058')

ixSKU	    mAvgCost	mLatestCost
9161002	    33.48	    33.48
9161090	    46.37	    46.37
91649058	252.40	    252.40

select ixReceiver, D.dtDate 'Date', SUM(iQty*mAverageCost) 'ExtCost'
FROM tblSKUTransaction ST
join tblDate D on ST.ixDate = D.ixDate
where ixReceiver in (select ixReceiver from  tblReceiver where ixPO = '106441')
--where ixReceiver = '190776'
group by ixReceiver, D.dtDate 
order by D.dtDate 


-- dbo.GetPOTotalQuantityReceived

select distinct sTransactionType
from tblSKUTransaction
where ixReceiver is NOT NULL

select COUNT(distinct ixReceiver)
from tblSKUTransaction
where sTransactionType = 'R' -- 32151
and ixReceiver is NULL

select distinct ixReceiver
from tblSKUTransaction
where sTransactionType = 'R'
order by ixReceiver

select *
from tblSKUTransaction
where sTransactionType = 'R' 
and mAverageCost <= 0
and ixDate >= 17533


SELECT ixSKU, sDescription
from tblSKU where ixSKU in (
                            select distinct ixSKU
                            from tblSKUTransaction
                            where sTransactionType = 'R' 
                            and mAverageCost <= 0
                            and ixDate >= 17533
                            and sDescription NOT LIKE '%CATALOG%'
                            and sDescription NOT LIKE '%SHIRT%'
                            and flgIntangible = 0
                            )


    7,400,000,000
-   3,700,000,000 immediate -- 2,960,000,000 inj
-     592,000,000 compl from wnd
-     311,000,000 sui
-     311,000,000 exp
-     621,000,000 post v 1st Mo
    =============
    1,865,000,000
    
    
SELECT * FROM tblReceiver
where ixPO in ('108193','106441','102209','105816')
order by ixCreateDate

SELECT * FROM tblReceiver
where ixPO in ('106441')
order by ixCreateDate

SELECT ixPO, COUNT(iOrdinality)
 from tblPODetail
 where ixPO in ('108193','106441','102209','105816')
group by ixPO 
order by ixPO 

select * from tblPODetail where ixPO in ('106441')

select * from tblSKUTransaction where ixReceiver in ('181888','182176','183349','188544')




select ST.ixReceiver, ST.mAverageCost, POD.mCost
FROM tblSKUTransaction ST
--join tblDate D on ST.ixDate = D.ixDate
join tblReceiver R on ST.ixReceiver = R.ixReceiver
join tblPODetail POD on POD.ixPO = R.ixPO
where ST.ixReceiver in (select ixReceiver from  tblReceiver where ixPO = '106441')
--where ixReceiver = '190776'
group by ixReceiver, D.dtDate 
order by D.dtDate 

select ST.ixReceiver, ST.ixSKU, ST.mAverageCost 'RcvrCost' , POD.mCost 'POCost', POD.ixPO
FROM tblSKUTransaction ST
--join tblDate D on ST.ixDate = D.ixDate
join tblReceiver R on ST.ixReceiver = R.ixReceiver
join tblPODetail POD on R.ixPO = POD.ixPO and POD.ixSKU = ST.ixSKU
--join tblPODetail POD on POD.ixPO = R.ixPO
where ST.ixDate >= 17533
and ST.sTransactionType = 'R' 
--ST.ixReceiver in (select ixReceiver from  tblReceiver where ixPO = '106441')
and ST.mAverageCost <> POD.mCost -- YTD 187 costs out of 70,937 don't match the PO cost -- 99.8% match!

-- POs YTD where some of the costs are not matching the receiver costs
108932
109167
109798
108529
110549
111176
112101
109323
109645
109693
110043
110346
109437
109636
105816
110363
99390
112198
112373
109622
110042
111235
110271
110272
108572
109520
110294
109993

SELECT * from tblPOMaster
where ixPO in ('108932','109167','109798','108529','110549','111176','112101','109323','109645','109693','110043','110346','109437','109636','105816','110363','99390','112198','112373','109622','110042','111235','110271','110272','108572','109520','110294','109993')

SELECT * from tblPODetail
where ixPO in ('108932','109167','109798','108529','110549','111176','112101','109323','109645','109693','110043','110346','109437','109636','105816','110363','99390','112198','112373','109622','110042','111235','110271','110272','108572','109520','110294','109993')

SELECT * FROM tblPOMaster
where ixPODate = 17657