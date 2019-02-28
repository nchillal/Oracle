BREAK ON table_name SKIP 1
SELECT * FROM
(
    SELECT      'Conflict Table' metadata, object_name table_name, COUNT(*) CNT
    FROM        dba_apply_conflict_columns
    WHERE       object_owner = '&&schema_name'
    GROUP BY    object_name
    UNION
    SELECT      'Table Columns' metadata, table_name, COUNT(*) CNT
    FROM        dba_tab_columns
    WHERE       owner = '&&schema_name'
    GROUP BY table_name
)
ORDER BY table_name;

SELECT  'Conflict Columns: '|| COUNT(*)
FROM    dba_apply_conflict_columns
WHERE   object_name = '&&table_name'
UNION
SELECT  'Table Columns: ' || COUNT(*)
FROM    dba_tab_columns
WHERE   table_name='&&table_name';

-- Conflict View
BREAK ON object_owner ON object_name SKIP 1
SELECT      object_owner, object_name, column_name
FROM        dba_apply_conflict_columns
WHERE       object_owner = '&schema_owner'
ORDER BY    2;