BREAK ON table_name SKIP 1
COLUMN columns FORMAT a150 WRAP
SELECT * FROM
(
    SELECT      object_name table_name, 'Conflict Handler Columns: '||LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP(ORDER BY column_name) columns
    FROM        dba_apply_conflict_columns
    WHERE       object_owner = '&&schema_name'
    AND         object_name NOT LIKE 'STR_LAG_MON%'
    GROUP BY    object_name
    UNION
    SELECT      table_name, RPAD('Table Columns: ', 26)||LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP(ORDER BY column_name) columns
    FROM        dba_tab_columns
    WHERE       owner = '&&schema_name'
    AND         table_name NOT LIKE 'STR_LAG_MON%'
    AND         table_name NOT LIKE 'BIN$%'
    AND         data_type NOT IN ('LOB', 'LONG', 'LONG RAW', 'BLOB', 'CLOB')
    GROUP BY    table_name
)
ORDER BY table_name;

SELECT  'Conflict Columns: '|| COUNT(*)
FROM    dba_apply_conflict_columns
WHERE   object_name = '&&table_name'
UNION
SELECT  'Table Columns: ' || COUNT(*)
FROM    dba_tab_columns
WHERE   table_name='&&table_name'
AND     data_type NOT IN ('LOB', 'LONG', 'LONG RAW', 'BLOB');

-- Conflict View
SELECT  'Conflict Handler Columns: '||LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP(ORDER BY column_name) COLUMNS
FROM    dba_apply_conflict_columns
WHERE   object_name = '&&table_name'
UNION
SELECT  'Table Columns: '||LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP(ORDER BY column_name) COLUMNS
FROM    dba_tab_columns
WHERE   table_name='&&table_name'
AND     data_type NOT IN ('LOB', 'LONG', 'LONG RAW', 'BLOB');