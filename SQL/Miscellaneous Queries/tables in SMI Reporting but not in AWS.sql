-- tables in SMI Reporting but not in AWS

-- run on LNK-SQL-LIVE-2

select SL.*, T.*
FROM 
sys.tables T
left join tblAwsQueueTypeReference AWS on T.name = AWS.sTableName
left join tblTableSizeLog SL on SL.sTableName = T.name
where (AWS.sTableName is NULL
            or AWS.flgActive = 0)
        and T.name like 'tbl%'
        and SL.dtDate = '04/23/2019'
        and T.name NOT LIKE 'tblAws%'
        and SL.sRowCount > 0
order by SL.sRowCount






