-- SMIHD-15299 - incorrect calculatiosn for Marketplace and CC proc fees

/**** PRE & POST TOTALS so Alaina can verify Tableau updated ********/

    -- PaymentProcessingFee
    select sMethodOfPayment, FORMAT(sum(mPaymentProcessingFee),'###,###.##') TotPmtProcFee
    from tblOrder O
        left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    where sMethodOfPayment in ('PP-AUCTION','PAYPAL')
        and dtInvoiceDate between '01/01/2018' and '12/31/2018' --  <-- Change date to previous day
    group by sMethodOfPayment
    order by sMethodOfPayment
    /*
    BEFORE UPDATES
    sMethodOfPayment	TotPmtProcFee
    PAYPAL	            285,656.52
    PP-AUCTION	        232,324.44

    AFTER UPDATES       
                        TotPmtProcFee
    PAYPAL	            298,554.03
    PP-AUCTION	        249,192.29
    */



    -- MarketplaceSellingFee
    select count(O.ixOrder) 'OrderCount', BU.sBusinessUnit, FORMAT(sum(mMarketplaceSellingFee),'###,###.##') TotMPSellingFee
    from tblOrder O
        left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    where dtInvoiceDate between '01/01/2018' and '12/31/2018'--  <-- Change date to previous day
    and (sSourceCodeGiven like '%EBAY%'
         or sSourceCodeGiven like 'AMAZON%'
         or sSourceCodeGiven = 'WALMART')
    and BU.sBusinessUnit = 'MKT'
    group by BU.sBusinessUnit
    order by BU.sBusinessUnit
    /*
    BEFORE UPDATES
    OrderCount	sBusinessUnit	TotMPSellingFee
    160,613	    MKT	            1,351,205.49

    AFTER UPDATES
    OrderCount	sBusinessUnit	TotMPSellingFee
    160613	    MKT	            1,343,307.66

    */


/****   PREP AND TABLE UPDATES  ******/
-- Prep table that the updates will populate from 
-- DROP TABLE [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees
SELECT O.ixOrder, O.sSourceCodeGiven, O.sMethodOfPayment, O.mMarketplaceSellingFee, O.mPaymentProcessingFee, -- 2,139,917
(CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN   -- WHEN fees change update in BOTH locations in this proc
                                          (CASE WHEN sMethodOfPayment= 'VISA' then 0.0207*(mMerchandise+mShipping+mTax-mCredits)  -- Payment Processing fees update 6-20-2019
                                                WHEN sMethodOfPayment= 'AMEX' then 0.0335 *(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'DISCOVER' then 0.0211*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'MASTERCARD' then 0.0207*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PP-AUCTION' then (0.0195*(mMerchandise+mShipping+mTax-mCredits))+.15
                                                WHEN sMethodOfPayment= 'PAYPAL' then (0.0195*(mMerchandise+mShipping+mTax-mCredits))+.15
                                                else 0 
                                                end)
                                ELSE 0
                                end) 'NEWPaymentProcessingFee', -- mPaymentProcessingFee
(CASE WHEN sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping)
                                                        WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping)
                                                        WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end) 'NEWMarketplaceSellingFee' ,  -- mMarketplaceSellingFee,
     O.sOrderStatus
into [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees
FROM tblOrder O
WHERE dtInvoiceDate between '04/01/2016' and '10/05/2019'
    AND (sMethodOfPayment in ('VISA', 'AMEX', 'DISCOVER', 'MASTERCARD', 'PP-AUCTION', 'PAYPAL')
            OR sSourceCodeGiven LIKE '%EBAY%'
            OR sSourceCodeGiven LIKE  'AMAZON%'
            OR sSourceCodeGiven = 'WALMART')

SELECT * FROM [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees

-- REMOVE records if new calculations don't change the values
BEGIN TRAN

DELETE from [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees
where mPaymentProcessingFee = NEWPaymentProcessingFee -- 149,555
    and mMarketplaceSellingFee = NEWMarketplaceSellingFee

ROLLBACK TRAN


SELECT COUNT(*)
FROM [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees -- 1,990,362



SELECT ixOrder from [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees 
--where ixOrder > '8574922' 
order by ixOrder desc


--Summary of before and after values
-- both totals decrease approx $48k
select FORMAT(count(ixOrder),'###,###.##') 'OrderCount',
      FORMAT(SUM(mPaymentProcessingFee),'###,###.##') 'OrigPPfee',
      FORMAT(SUM(NEWPaymentProcessingFee),'###,###.##') 'NewPPfee',
      FORMAT(SUM(mMarketplaceSellingFee),'###,###.##') 'OrigMPSfee',
      FORMAT(SUM(NEWMarketplaceSellingFee),'###,###.##') 'NewMPSfee'
from [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees
where --ixOrder between '8701329' and '8850445' -- 1
    -- ixOrder between '8562178' and '8701328' -- 2
    -- ixOrder between '8430370' and '8562177' -- 3
    -- ixOrder between '8297171' and '8430367' -- 4
    -- ixOrder between '8164142' and '8297170' -- 5

    -- ixOrder between '8030205' and '8164141' -- 6
    -- ixOrder between '7915075' and '8030204' -- 7
    -- ixOrder between '7805893' and '7915074' -- 8
    -- ixOrder between '7696949' and '7805892' -- 9
    -- ixOrder between '7588104-1' and '7696948' -- 10
     
    -- ixOrder between '7478934' and '7588104' -- 11
    -- ixOrder between '7370103' and '7478933' -- 12
    -- ixOrder between '7261345' and '7370102' -- 13
    -- ixOrder between '7152153' and '7261344' -- 14
    -- ixOrder between '7043143-1' and '7152152' -- 15

    -- ixOrder between '6837690' and '7043143' -- 16
    -- ixOrder between '6568662' and '6837689' -- 17
    -- ixOrder between '6300276' and '6568660' -- 18
    -- ixOrder between '5411396-1' and '6300275' -- 19


/*
OrderCount  OrigPPfee	NewPPfee	OrigMPSfee	NewMPSfee
207,920	    518,095.28	547,861.52  907,859.39  899,895.13


Order 
Count   OrigPPfee	NewPPfee	OrigMPSfee	NewMPSfee
100,000	432,238.79	431,188.87	127,929.96	127,929.67  -- batch 1 BEFORE
                    455,240.6	            298,402.45

*/

     
select FORMAT(SUM(mPaymentProcessingFee),'###,###.##') 'TotPPfee',
     FORMAT(SUM(mMarketplaceSellingFee),'###,###.##') 'TotMPSfee'
from tblOrder
where ixOrder between '8701329' and '8850445'

439,094.08	302,895.91
438,044.34	302,895.61

/*
TotPPfee	    TotMPSfee
21,914,527.15	3,631,607.1  -- batch 1
818,423.21	    556,576.03  -- batch 2
811,568.71	    556,605.38  -- batch 3
454,418.52	    300,360.44  -- batch 4
*/


select ixOrder from [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees
where ixOrder = '8000564'
/*
NEWMarketplaceSellingFee	NEWPaymentProcessingFee
13.999300	4.25455500
*/

select ixOrder, sSourceCodeGiven, sMethodOfPayment, mMarketplaceSellingFee, mPaymentProcessingFee
from tblOrder
where ixOrder = '8000564'
/*  BEFORE UPDATE
ixOrder	sSourceCodeGiven	sMethodOfPayment	mMarketplaceSellingFee	mPaymentProcessingFee
8000564	EBAY	            PP-AUCTION	        14.7343	                5.2623

AFTER 
8000564	EBAY	            PP-AUCTION	        13.9993	                4.2546
*/

-- backup tblOrder
--SELECT * INTO [SMIArchive].dbo.BU_tblOrder_20190829 from tblOrder -- 6,721,632



BEGIN TRAN

    UPDATE O
    set O.mMarketplaceSellingFee = NF.NEWMarketplaceSellingFee,
       mPaymentProcessingFee = NF.NEWPaymentProcessingFee
    from tblOrder O
     join [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees NF on O.ixOrder = NF.ixOrder 
                                                            -- batch (100k ea)
    WHERE NF.ixOrder -- between '8701329' and '8850445' -- 1   
   --   between '8562178' and '8701328' -- 2
    -- between '8430370' and '8562177' -- 3
    -- between '8297171' and '8430367' -- 4
    -- between '8164142' and '8297170' -- 5

    -- between '8030205' and '8164141' -- 6
    -- between '7915075' and '8030204' -- 7
    -- between '7805893' and '7915074' -- 8
    -- between '7696949' and '7805892' -- 9
    -- between '7588104-1' and '7696948' -- 10
     
    -- between '7478934' and '7588104' -- 11
    -- between '7370103' and '7478933' -- 12
    -- between '7261345' and '7370102' -- 13
    -- between '7152153' and '7261344' -- 14
    -- between '7043143-1' and '7152152' -- 15

   --  between '6837690' and '7043143' -- 16
   --  between '6568662' and '6837689' -- 17
    -- between '6300276' and '6568660' -- 18
     between '5411396-1' and '6300275' -- 19

ROLLBACK TRAN


/* single order update test
BEGIN TRAN

    update O
    set O.mMarketplaceSellingFee = 14.7343,
       mPaymentProcessingFee =5.2623
    from tblOrder O
    WHERE O.ixOrder = '8000564'

ROLLBACK TRAN



select * from [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees
where mPaymentProcessingFee = NEWPaymentProcessingFee -- 131,003
and mMarketplaceSellingFee = NEWMarketplaceSellingFee
ORDER BY mPaymentProcessingFee

 -- datatype money goes up to 4 decimal places e.g. 5.1017
select distinct mPaymentProcessingFee
from tblOrder
order by mPaymentProcessingFee


select * from tblBusinessUnit
/*  Business
BU	Unit    Description
=== ===     ============
101	ICS	    Inter-company sale
102	INT	    Intra-company sale
103	EMP	    Employee
104	PRS	    Pro Racer
105	MRR	    Mr Roadster
106	RETLNK	Retail, Lincoln
107	WEB	    Website
108	GS	    Garage Sale
109	MKT	    Marketplaces
110	PHONE	CX Orders
111	RETTOL	Retail, Tolleson
112	UK	    Unknown
*/

*/









-- AWS Queue
-- DROP TABLE #RefillAWSQueue
select ixOrder into #RefillAWSQueue from [SMITemp].dbo.PJC_SMIHD15299_PaymentProcess_and_MPSelling_Fees -- 175,719

INSERT INTO #RefillAWSQueue
select ixOrder from tblOrder    -- 9,075
where dtDateLastSOPUpdate >= '08/27/2019' -- 184,783
AND ixOrder NOT IN (select ixOrder from #RefillAWSQueue)

select count(*) from #RefillAWSQueue

select * from #RefillAWSQueue
order by ixOrder

select count(*) from #RefillAWSQueue
WHERE 
ixOrder between '0' and '8263155' -- 49000
 ixOrder between '8263156' and '8528838' -- 48000
 ixOrder between '8528839' and '8791961' -- 47000
 ixOrder between '8791962' and 'Q1940292' -- 40794

 BEGIN TRAN

update O
set O.ixOrder = RF.ixOrder
from  tblOrder O
 join #RefillAWSQueue RF on O.ixOrder = RF.ixOrder
WHERE RF.ixOrder 
--between '0' and '8263155' --'8263155' -- 2:37
--between '8263156' and '8528838' -- 48000 -- 2:50
-- between '8528839' and '8791961' -- 47000 -- 3:02
between '8791962' and 'Q1940292' -- 40794 -- 3:11


 ROLLBACK TRAN



 update O
set O.ixOrder = RF.ixOrder
from  tblOrder O
 join #RefillAWSQueue RF on O.ixOrder = RF.ixOrder






SELECT *
into [SMIArchive].dbo.BU_tblOrder_20191005 FROM tblOrder