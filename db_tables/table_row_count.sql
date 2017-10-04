SELECT    'SELECT COUNT(*) FROM '||owner||'.'||table_name||';' "NUM_ROWS_TABLE"
FROM      dba_tables
WHERE     owner='&schema_owner'
ORDER BY  table_name;
