-- update DW1 with values in matching DWStaging table
-- Run on DW1 to get the statements
-- Run statements on staging

-- First Update is the incorrect value from dw1, the second update is the correct value from staging.
select 
'update tblBin set flgDeletedFromSOP = ' + cast(b.flgDeletedFromSOP as varchar(10)) + ' where ixBin = ''' + b.ixBin + ''';' + 'update tblBin set flgDeletedFromSOP = ' + cast(sb.flgDeletedFromSOP as varchar(10)) + ' where ixBin = ''' + b.ixBin + ''';'
from tblBin b inner join [lnk-dwstaging1].[SMI Reporting].dbo.tblBin sb on b.ixBin = sb.ixBin 
where b.flgDeletedFromSOP <> sb.flgDeletedFromSOP order by b.ixBin


