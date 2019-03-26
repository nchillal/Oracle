SET SERVEROUTPUT ON FORMAT TRUNCATED FEED OFF LINES 250

DECLARE
    -- Create bind variable for storing table_name
    v_table_owner VARCHAR2(30) := '&table_owner';
    v_table_name VARCHAR2(30) := '&table_name';
BEGIN
    -- Table details
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 158, '*'));
    DBMS_OUTPUT.PUT_LINE(RPAD('owner', 30)||RPAD('table_name', 30)||RPAD('tablespace_name', 25)||RPAD('num_rows', 10)||RPAD('blocks', 8)||RPAD('empty_blocks', 15)||RPAD('degree', 8)||RPAD('last_analyzed', 18)||RPAD('sample_size', 15));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 158, '*'));
    FOR row IN  (
                SELECT  owner, table_name, tablespace_name, num_rows, blocks, empty_blocks, degree, TO_CHAR(last_analyzed, 'DD-MON-RR HH24:MI') last_analyzed, sample_size
                FROM    dba_tables
                WHERE   table_name = v_table_name
                AND     owner = v_table_owner
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(row.owner, 30)||RPAD(row.table_name, 30)||RPAD(row.tablespace_name, 25)||RPAD(row.num_rows, 10)||RPAD(row.blocks, 8)||RPAD(row.empty_blocks, 15)||RPAD(row.degree, 8)||RPAD(row.last_analyzed, 18)||RPAD(row.sample_size, 15));
    END LOOP;

    -- Table column details
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 80, '*'));
    DBMS_OUTPUT.PUT_LINE(RPAD('column_name', 30)||RPAD('data_type', 15)||RPAD('data_length', 15)||RPAD('data_precision', 18));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 80, '*'));
    FOR row IN  (
                SELECT  column_name, data_type, data_length, data_precision, data_default, num_distinct, last_analyzed, nullable
                FROM    dba_tab_columns
                WHERE   table_name = v_table_name
                AND     owner = v_table_owner
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(row.column_name, 30)||RPAD(row.data_type, 15)||RPAD(row.data_length, 15)||RPAD(row.data_precision, 18));
    END LOOP;

    -- List indexes defined on the table.
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 155, '*'));
    DBMS_OUTPUT.PUT_LINE(RPAD('index_name', 35)||RPAD('tablespace_name', 30)||RPAD('index_type', 15)||RPAD('uniqueness', 15)||RPAD('status', 15)||RPAD('partitioned', 15)||RPAD('last_analyzed', 30));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 155, '*'));
    FOR row IN  (
                SELECT  index_name, tablespace_name, last_analyzed, index_type, uniqueness, status, partitioned
                FROM    dba_indexes
                WHERE   table_name = v_table_name
                AND     owner = v_table_owner
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(row.index_name, 35)||RPAD(row.tablespace_name, 30)||RPAD(row.index_type, 15)||RPAD(row.uniqueness, 15)||RPAD(row.status, 15)||RPAD(row.partitioned, 15)||RPAD(row.last_analyzed, 30));
    END LOOP;

    -- Index column details
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 150, '*'));
    DBMS_OUTPUT.PUT_LINE(RPAD('index_owner', 30)||RPAD('index_name', 35)||RPAD('column_position', 30)||RPAD('column_name', 30)||RPAD('descend', 10));
    DBMS_OUTPUT.PUT_LINE(LPAD('*', 150, '*'));
    FOR row IN  (
                SELECT      index_owner, index_name, column_position, column_name, descend
                FROM        dba_ind_columns
                WHERE       table_name = v_table_name
                AND         table_owner = v_table_owner
                ORDER BY    index_name, column_position
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(row.index_owner, 30)||RPAD(row.index_name, 35)||RPAD(row.column_position, 30)||RPAD(row.column_name, 30)||RPAD(row.descend, 5));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(13));
END;
/
