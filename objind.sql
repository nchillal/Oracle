select OWNER, INDEX_NAME, INDEX_TYPE, UNIQUENESS, STATUS from dba_indexes where TABLE_NAME='&table_name'
/
