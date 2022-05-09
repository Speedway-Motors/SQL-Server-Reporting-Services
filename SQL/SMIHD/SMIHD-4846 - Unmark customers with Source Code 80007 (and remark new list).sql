-- SMIHD-4846 - Unmark customers with Source Code 80007 (and remark new list)

SELECT * from tblCustomerOffer 
where ixSourceCode = '80007' -- 32,490   

-- ONCE SOP Unmark process is complete, manually delete the records from tblCustomerOffer on LNK-DWSTAGING1 !!!
/*
BEGIN TRAN
    DELETE FROM tblCustomerOffer 
    where ixSourceCode = '80007'
ROLLBACK TRAN    
*/


SELECT * from tblCustomerOffer 
where ixSourceCode = '80007' -- 32,490 


-- THEN reload the customer offers Alaina provided.