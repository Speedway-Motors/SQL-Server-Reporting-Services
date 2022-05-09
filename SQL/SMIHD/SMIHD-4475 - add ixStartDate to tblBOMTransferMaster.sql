-- SMIHD-4960 - add flgDeliveryPromiseMet to tblOrder

-- Scripts to add field to tables

-- run on DWSTAGING ONLY!!!!
BEGIN TRAN

    ALTER TABLE [SMI Reporting].dbo.tblOrder
         ADD flgDeliveryPromiseMet tinyint NULL
         
ROLLBACK TRAN

BEGIN TRAN
    ALTER TABLE [AFCOReporting].dbo.tblOrder
         ADD flgDeliveryPromiseMet tinyint NULL
ROLLBACK TRAN



-- 6020882	07/13/2016	14:51:17  	Open	2016-07-13 00:00:00.000	14:51:58  

/* TESTING

-- SMI
    SELECT TOP 10 * FROM [SMI Reporting].dbo.tblOrder 
    
    select * from [SMI Reporting].dbo.tblOrder 
    where dtDateLastSOPUpdate => '07/13/2016' -- 50 ixTransfers

    select * from [SMI Reporting].dbo.tblOrder 
    WHERE ixTransferNumber in ('60940-1','61121-1','61589-1','63124-1','63509-1','64321-1','64977-1','65303-1','65370-1','65396-1','65567-1','65664-1','65685-1','65987-1','66085-1','66097-1','66149-1','66415-1','66518-1','66523-1','66637-1','66731-1','66749-1','66754-1','66783-1','66821-1','66871-1','66873-1','66874-1','66875-1','66876-1','66877-1','66878-1','66880-1','66881-1','66882-1','66883-1','66884-1','66887-1','66889-1','66891-1','66892-1','66895-1','66897-1','66898-1','66899-1','66901-1','66904-1','66906-1','66908-1')
    order by dtDateLastSOPUpdate 

    SELECT count(*) 'Qty',
        flgDeliveryPromiseMet
    FROM [SMI Reporting].dbo.tblOrder 
    GROUP BY flgDeliveryPromiseMet
    ORDER BY flgDeliveryPromiseMet
    
    /*

    */

 
-- AFCO
    SELECT TOP 10 * FROM [AFCOReporting].dbo.tblOrder 
    
    select dtDateLastSOPUpdate, count(*)
    from [AFCOReporting].dbo.tblOrder 
    where dtDateLastSOPUpdate >= '01/01/2016'
    group by dtDateLastSOPUpdate
    having count(*) < 120
    order by count(*)
    
    select * from [AFCOReporting].dbo.tblOrder 
    where dtDateLastSOPUpdate = '04/02/2016' -- 37 ixTransfers

    select * from [AFCOReporting].dbo.tblOrder 
    WHERE ixTransferNumber in ('184186-1','184241-1','184438-1','184662-1','185557-1','186217-1','186993-1','187038-1','187049-1','187323-1','187934-1','188109-1','188603-1','188610-1','188676-1','189538-1','190116-1','190118-1','190565-1','190607-1','190639-1','190974-1','191034-1','191050-1','191118-1','191705-1','191917-1','192079-1','192140-1','193490-1','193550-1','193572-1','193725-1','193734-1','193918-1','194030-1','194031-1')
    order by dtDateLastSOPUpdate 

    SELECT count(*) 'Qty',
        ixStartDate
    FROM [AFCOReporting].dbo.tblOrder 
    GROUP BY ixStartDate
    ORDER BY ixStartDate
    /*

    */


*/

select * from [SMI Reporting].dbo.tblOrder 
where ixTransferNumber = '1594855-1'

select * from [AFCOReporting].dbo.tblOrder 
where ixTransferNumber = '59818-1'




select ixTransferNumber, ixStartDate, dtDateLastSOPUpdate, dtCanceledDate, flgClosed
from [AFCOReporting].dbo.tblOrder
where ixStartDate is NOT NULL
order by ixStartDate  
-- dtDateLastSOPUpdate
/* AFCOReporting
115 ixTransferNumber records (one of which is closed) contain an ixStartDate value as of 6-15-16 15:05
ixStartDate range = 17699 to 17774  (6/15/16 to 8/29/16)
*/

select * from tblDate where ixDate in (17699,17774)                       

-- verified with Connie that AFCOReporting counts match SOP counts 100%