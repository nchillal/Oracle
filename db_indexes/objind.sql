SET SERVEROUTPUT ON FORMAT TRUNCATED FEED OFF LINES 250

DECLARE
    -- Create bind variable for storing table_name
    v_table_owner VARCHAR2(30) := '&table_owner';
    v_table_name VARCHAR2(30) := '&table_name';
BEGIN
    -- List indexes defined on the table.
    DBMS_OUTPUT.PUT_LINE(CHR(13));

    FOR row IN  (
                SELECT  index_name, tablespace_name, last_analyzed, index_type, uniqueness, status, partitioned
                FROM    dba_indexes
                WHERE   table_name=v_table_name
                AND     owner=v_table_owner
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(row.index_name, 30)||RPAD(row.tablespace_name, 30)||RPAD(row.last_analyzed, 30)||RPAD(row.index_type, 15)||RPAD(row.uniqueness, 15)||RPAD(row.status, 15)||RPAD(row.partitioned, 30));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(13));

    FOR row IN  (
                SELECT  index_name, column_position, column_name
                FROM    dba_ind_columns
                WHERE   table_name=v_table_name
                AND     table_owner=v_table_owner
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(row.index_name, 30)||RPAD(row.column_position, 5)||RPAD(row.column_name, 30));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(13));
END;
/
