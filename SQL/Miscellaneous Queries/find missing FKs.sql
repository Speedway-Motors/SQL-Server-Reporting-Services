-- find missing FKs
select (S.name + '.' + O.name) BaseTable,C.name BaseColumn , 
       (S2.name+'.'+O2.name) as ReferenceTable,
       ('alter table '+S.name+'.'+O.name+' with check  add constraint FK_'+O.name+'_'+O2.name+'  foreign key ('+C.name+') references '+S2.name+'.'+O2.name+'('+IDC.name+')') FKCreateStatement
from sys.columns C 
inner join sys.identity_columns IDC on (IDC.name =C.name OR C.name = object_name(IDC.object_id)+IDC.name)
					   and C.object_id <>IDC.object_id and C.is_identity = 0 --exlude Columns which are identities
inner join sys.objects O on O.object_id = C.object_id and O.is_ms_shipped =0 and O.type = 'u'
inner join sys.schemas S on S.schema_id = O.schema_id
inner join sys.objects O2 on O2.object_id = IDC.object_id and O2.is_ms_shipped =0 and O2.type = 'u'
inner join sys.schemas S2 on S2.schema_id = O2.schema_id
left join sys.foreign_key_columns FKC on IDC.object_id = FKC.referenced_object_id and FKC.referenced_column_id = IDC.column_id
Inner join (select I.object_id,IC.index_id 
		  from sys.index_columns IC 
		  inner join sys.indexes I on I.object_id=IC.object_id and I.index_id = IC.index_id  
		  where is_primary_key=1
		  group by I.object_id,IC.index_id
		  having count(*) =1) SingleColumnPK on IDC.object_id = SingleColumnPK.object_id  
Where FKC.referenced_object_id is null
	  and C.name <>'ID'
order by 1