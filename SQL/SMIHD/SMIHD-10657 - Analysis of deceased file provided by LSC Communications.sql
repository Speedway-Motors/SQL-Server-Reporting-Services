-- SMIHD-10657 - Analysis of deceased file provided by LSC Communications

SELECT * FROM PJC_SMIHD10657_LSCDeceasedFile
/*
We select as deceased any records with the following combinations of Deceased Type and Deceased Confidence Codes:

     Deceased Type
B1 = exact match on first_name, last_name and address
C1 = exact match on address and near-exact match on first_name and last_name    

     Deceased Confidence Code
V = Death confirmed by relative
P = Certificate of death     

Other available Deceased Types:

Deceased Footnotes:

Deceased Confidence Codes:

Although customers listed in the deceased matches may be placing orders, we have found that many times a surviving spouse or child will continue to place orders under the deceased names.  If you would like us to change any of our deceased drops based on your requirements, we can set up a different template for deceased drops for all of your jobs.

*/
SELECT COUNT(*) FROM PJC_SMIHD10657_LSCDeceasedFile             -- 2458
SELECT COUNT(DISTINCT CUST) FROM PJC_SMIHD10657_LSCDeceasedFile -- 2458



SELECT C.ixCustomer, C.flgDeceasedMailingStatusExempt, D.YrOfDeath, D.ANC_DECEASED_MATCH_TYPE, D.ANC_DECEASED_DATE_OF_DEATH, D.ANC_DECEASED_CONF_CODE,  MR.LatestOrder, DATEPART(yyyy,MR.LatestOrder) 'YrLatestOrder'
FROM PJC_SMIHD10657_LSCDeceasedFile D
    JOIN [SMI Reporting].dbo.tblCustomer C on D.CUST = C.ixCustomer -- 2458
    -- JOIN vwCSTStartingPool CST on C.ixCustomer = CST.ixCustomer     -- 2448 ALL CURRENTLY IN CST STARTING PULL
    LEFT JOIN (-- MOST recent order
               SELECT ixCustomer, MAX(dtOrderDate) 'LatestOrder'
               FROM tblOrder 
               WHERE sOrderStatus in ('Shipped','Open','Dropshipped')
               GROUP BY ixCustomer) MR on MR.ixCustomer = C.ixCustomer
WHERE C.flgDeletedFromSOP = 0   -- 2458
-- and flgDeceasedMailingStatusExempt = 1 -- 186 already marked as deceased exempt
 AND D.YrOfDeath > DATEPART(yyyy,MR.LatestOrder)
 --AND D.ANC_DECEASED_CONF_CODE = 'P'
 AND D.ANC_DECEASED_MATCH_TYPE = 'B1'
-- and D.ANC_DECEASED_DATE_OF_DEATH is NULL
ORDER BY D.ANC_DECEASED_MATCH_TYPE, D.YrOfDeath, MR.LatestOrder desc



/* RESULTS

2,458 Customers in LSC's Deceased file
   
1,522 placed orders AFTER their deceased date
   67 show a deceased > than their Most Recent Order Date (so that status is POTENTIALLY valid)
  869 do not have a deceased date and can not be evaluated (based on the accuracy of the 2 groups above I would estimate that <5% of this group are truly deceased)

=====
*/

SELECT COUNT(*) QTY, D.ANC_DECEASED_CONF_CODE
FROM PJC_SMIHD10657_LSCDeceasedFile D
GROUP BY D.ANC_DECEASED_CONF_CODE
ORDER BY  COUNT(*) DESC
/*
QTY	    ANC_DECEASED_CONF_CODE
1,106	V
  580 	P
  508 	NULL
  264 	O
*/
SELECT COUNT(*) QTY, D.ANC_DECEASED_FTNOTE
FROM PJC_SMIHD10657_LSCDeceasedFile D
GROUP BY D.ANC_DECEASED_FTNOTE
ORDER BY  COUNT(*) DESC
/*
QTY	    ANC_DECEASED_FTNOTE
1,593	NULL
  732	M
   61	3
   31	1
   26	G
    7	4
    6	I
    2	2
*/
SELECT COUNT(*) QTY, D.ANC_DECEASED_MATCH_TYPE
FROM PJC_SMIHD10657_LSCDeceasedFile D
GROUP BY D.ANC_DECEASED_MATCH_TYPE
ORDER BY  COUNT(*) DESC
/*
QTY	    ANC_DECEASED_MATCH_TYPE
1,229	C1
1,229	B1
*/



        SELECT count(distinct O.ixCustomer) CustCnt, --C.ixCustomer, 
            sum(O.mMerchandise) Sales 
        from [SMI Reporting].dbo.tblOrder O
            join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
            JOIN PJC_SMIHD10657_LSCDeceasedFile D ON D.CUST = C.ixCustomer
        where C.flgDeletedFromSOP = 0  
            and O.sOrderStatus = 'Shipped'
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.dtShippedDate >= '07/15/2017'


            450947.98