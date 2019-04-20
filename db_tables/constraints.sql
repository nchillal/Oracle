DECLARE
    -- Create bind variable for storing table_name
    v_table_owner VARCHAR2(30) := '&table_owner';
    v_table_name VARCHAR2(30) := '&table_name';
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 158, '*'));
    DBMS_OUTPUT.PUT_LINE(RPAD('constraint_name', 35)||RPAD('column_name', 30)||RPAD('constraint_type', 18)||RPAD('status', 10)||RPAD('deferrable', 18)||RPAD('deferred', 12)||RPAD('validated', 12)||RPAD('search_condition', 35));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 158, '*'));
    FOR row in (SELECT    b.constraint_name constraint_name,
                          a.column_name column_name,
                          DECODE(b.constraint_type, 'C', 'Check',
                                      'P', 'Primary',
                                      'U', 'Unique',
                                      'R', 'Referential') constraint_type,
                          b.status status,
                          b.deferrable deferrable,
                          b.deferred deferred,
                          b.validated validated,
                          b.search_condition search_condition
              FROM        dba_cons_columns a, dba_constraints b
              WHERE       a.constraint_name = b.constraint_name
              AND         b.table_name = v_table_name
              AND         b.owner = v_table_owner
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(row.constraint_name, 35)||RPAD(row.column_name, 30)||RPAD(row.constraint_type, 18)||RPAD(row.status, 10)||RPAD(row.deferrable, 18)||RPAD(row.deferred, 12)||RPAD(row.validated, 12)||RPAD(row.search_condition, 35));
    END LOOP;
END;
/

COLUMN REFERENCES FORMAT a150

SELECT ' TABLE "'||b.owner||'.'||b.table_name||'"'||
        '('||listagg (c.column_name, ',') within group (order by c.column_name)||')'||
        ' FK "'||b.constraint_name||'" -> '||a.table_name||
        ' INDEX "'||a.index_name||'"'
        REFERENCES
FROM all_indexes a,
       all_constraints b,
       all_cons_columns c
WHERE RTRIM(a.owner) = '&owner'
AND a.index_name = b.r_constraint_name
AND c.constraint_name = b.constraint_name
GROUP BY b.owner, b.table_name, b.constraint_name, a.table_name, a.index_name
ORDER BY 1;