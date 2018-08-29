SET SERVEROUTPUT ON FORMAT TRUNCATED FEED OFF LINES 250

DECLARE
    -- Create bind variable for storing table_name
    v_table_owner VARCHAR2(30) := '&table_owner';
    v_table_name VARCHAR2(30) := '&table_name';

    TYPE dbIndexes IS TABLE OF dba_indexes%ROWTYPE;
    rec1 dbIndexes;

    TYPE dbIndCols IS TABLE OF dba_ind_columns%ROWTYPE;
    rec2 dbIndCols;

BEGIN
    -- List indexes defined on the table.
    SELECT  * BULK COLLECT INTO rec1
    FROM    dba_indexes
    WHERE   table_name=v_table_name
    AND     owner=v_table_owner;

    DBMS_OUTPUT.PUT_LINE(CHR(13));

    FOR row IN rec1.FIRST..rec1.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(rec1(row).index_name, 30)||RPAD(rec1(row).tablespace_name, 30)||RPAD(rec1(row).last_analyzed, 30)||RPAD(rec1(row).index_type, 15)||RPAD(rec1(row).uniqueness, 15)||RPAD(rec1(row).status, 15)||RPAD(rec1(row).partitioned, 30));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(13));

    SELECT  * BULK COLLECT INTO rec2
    FROM    dba_ind_columns
    WHERE   table_name=v_table_name
    AND     table_owner=v_table_owner;

    FOR row IN rec2.FIRST..rec2.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(rec2(row).index_name, 30)||RPAD(rec2(row).column_position, 5)||RPAD(rec2(row).column_name, 30));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(13));
END;
/
