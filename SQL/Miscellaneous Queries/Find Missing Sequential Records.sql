-- Find Missing Sequential Records    

/*
globally replace:
MAIN TABLE: [LNK-DW1].[SMITemp].dbo.PJC_MissingSequenceTest 
MAIN SEQUENTIAL FIELD: ixIDField
*/
        
select (select isnull(max(ixIDField)+1,1) 
        from [LNK-DW1].[SMITemp].dbo.PJC_MissingSequenceTest 
        where ixIDField < md.ixIDField
        ) as 'MissingFrom',
        md.ixIDField - 1 as 'To'
from [LNK-DW1].[SMITemp].dbo.PJC_MissingSequenceTest md
where md.ixIDField != 1 
    and not exists (select 1 
                    from [LNK-DW1].[SMITemp].dbo.PJC_MissingSequenceTest md2 
                    where md2.ixIDField = md.ixIDField - 1)   