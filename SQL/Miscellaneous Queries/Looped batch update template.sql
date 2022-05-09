set nocount on
/* You can change the batch size */
Declare @BatchSize int
set @BatchSize = 100
/* you can run it in test Mode, when in test mode SampleSize is 3 times the BatchSize and a before and after will be selected of the updated rows */
/* the transaction will also be rolled back */
Declare @TestMode bit
Declare @SampleSize bigint
set @TestMode = 0



if @TestMode = 1
    begin
           set @SampleSize = 3 * @BatchSize
    end 
else
    begin
           set @SampleSize = 99999999
    end



Declare @TotalCount int
Declare @Table table
(
       ixCustomer bigint
)

Declare @BatchTable as table
(
       ixCustomer bigint
)


insert into @Table (ixCustomer) select top (@SampleSize) ixCustomer from [SMITemp].dbo.PJC_Customer_sMailToZipFour
set @TotalCount = (select count(*) from @Table)

Declare @Count int
set @Count = 1
while exists( select top 1 1from @Table )
begin
       insert into @BatchTable (ixCustomer)
       select top (@BatchSize) ixCustomer from @Table 

       Delete @Table where ixCustomer in (select ixCustomer from @BatchTable)

       begin tran
              if @TestMode = 1
                  begin 
                    select * from tblCustomer where ixCustomer in (select ixCustomer from @BatchTable)
                  end
              update C 
              set sMailToZipFour = ZPF.sMailToZipFour
              from [SMI Reporting].dbo.tblCustomer C
                join [SMITemp].dbo.PJC_Customer_sMailToZipFour ZPF on ZPF.ixCustomer = C.ixCustomer
              where ZPF.ixCustomer in (select ixCustomer from @BatchTable)
              
              if @TestMode = 1
                  begin 
                    select * from tblCustomer where ixCustomer in (select ixCustomer from @BatchTable)
                  end
       if @TestMode = 1
           begin
                  rollback tran
           end 
       else
           begin
                  commit tran
           end

       delete @BatchTable
       -- updates counter every @BatchSize records
       print cast(@Count * @BatchSize as nvarchar(max)) + ' of ' + cast(@TotalCount  as nvarchar(max))
       set @Count = @Count + 1
end



