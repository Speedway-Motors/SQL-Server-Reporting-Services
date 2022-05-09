-- SMIHD-6586 - Set flgEndUserSKU values
/*   BACKUP TABLE!
select *
into BU_tblSKU_20170208
from [SMI Reporting].dbo.tblSKU -- 348,655
*/


/****** SKUs with YES for the flag **********/
        /*  NO DUPES
        SELECT count(distinct ixSKU), count(*)
        from PJC_SMIHD6586_flgEndUserSKU_YES
        6009	6009
        */

        BEGIN TRAN
        -- DROP TABLE PJC_SMIHD6586_flgEndUserSKU_YES
        UPDATE [SMI Reporting].dbo.tblSKU
        SET flgEndUserSKU = 1
        where ixSKU in (select top 10000 ixSKU 
                        from PJC_SMIHD6586_flgEndUserSKU_YES
                        where ixSKU in (select ixSKU from [SMI Reporting].dbo.tblSKU where flgEndUserSKU is NULL)
                        )
                       
        ROLLBACK TRAN                
                        
        /*
        SELECT COUNT(*)
        FROM [SMI Reporting].dbo.tblSKU 
        WHERE flgEndUserSKU = 1
        */         
        
        
        
        
        
 /****** SKUs with YES for the flag **********/       
        /*  NO DUPES
        SELECT count(distinct ixSKU), count(*)
        from PJC_SMIHD6586_flgEndUserSKU_NO
        
        159709	159709
        */



        BEGIN TRAN
        -- DROP TABLE PJC_SMIHD6586_flgEndUserSKU_NO
        UPDATE [SMI Reporting].dbo.tblSKU
        SET flgEndUserSKU = 0
        where ixSKU in (select top 10000 ixSKU 
                        from PJC_SMIHD6586_flgEndUserSKU_NO
                        where ixSKU in (select ixSKU from [SMI Reporting].dbo.tblSKU where flgEndUserSKU is NULL)
                        )
                        
        ROLLBACK TRAN                
                        
        /*
        SELECT COUNT(*)
        FROM [SMI Reporting].dbo.tblSKU 
        WHERE flgEndUserSKU = 0
        */         
        
        
               BEGIN TRAN 
               UPDATE [SMI Reporting].dbo.tblSKU
        SET flgDeletedFromSOP = 1 where ixSKU in ('6740105', '910701265', '910678')
                ROLLBACK TRAN  
        
        
        
               