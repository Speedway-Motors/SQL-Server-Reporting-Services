-- Clean up deleted Purchase Orders from PO tables
    -- check SMI and AFCO

SELECT ixPO, dtDateLastSOPUpdate --count(*) 
FROM tblPOMaster
WHERE dtDateLastSOPUpdate < '07/22/2021'
       -- or dtDateLastSOPUpdate is NULL
order by ixPO --dtDateLastSOPUpdate

SELECT * 
FROM tblPOMaster
WHERE ixPO in ('13526','1851','1899','2203','2208','2214','7210','8286')

SELECT * from tblDate where ixDate = 15339



-- REMOVE POs deleted from SOP
    BEGIN TRAN

        DELETE FROM tblPODetail
        where ixPO in ('101598','106602','68256#1','68256#2','70586','70955','75086','81451','81978','82057','82058','87709','90500','91522','MAINTNANCE','OrderNumbe','RAMSHORN T','W1111')

    ROLLBACK TRAN

    BEGIN TRAN

        DELETE FROM tblPOMaster
        where ixPO in ('101598','106602','68256#1','68256#2','70586','70955','75086','81451','81978','82057','82058','87709','90500','91522','MAINTNANCE','OrderNumbe','RAMSHORN T','W1111')

    ROLLBACK TRAN



    -- If Receiver data needs to be deleted too
        BEGIN TRAN

            DELETE FROM tblReceiver
            where ixPO in ('101598','106602','68256#1','68256#2','70586','70955','75086','81451','81978','82057','82058','87709','90500','91522','MAINTNANCE','OrderNumbe','RAMSHORN T','W1111')

        ROLLBACK TRAN

        SELECT ixReceiver 
        FROM tblReceiver
        where ixPO in ('101598','106602','68256#1','68256#2','70586','70955','75086','81451','81978','82057','82058','87709','90500','91522','MAINTNANCE','OrderNumbe','RAMSHORN T','W1111')

        BEGIN TRAN

            DELETE FROM tblInventoryReceipt
            where ixReceiver in ('69638','69648')

        ROLLBACK TRAN

