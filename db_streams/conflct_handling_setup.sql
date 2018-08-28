EXEC strmadmin.gsd_streams_adm.set_tag(tag => HEXTORAW('17'));

SET serveroutput ON;
DECLARE
    LM_Column VARCHAR2(5000) DEFAULT NULL;
    LM_COUNT NUMBER;
CURSOR cur IS SELECT at.table_name, at.owner FROM all_tables at WHERE 1=1 AND owner IN ('&schema_owner') AND at.table_name NOT LIKE 'STR%LAG%MON%' ORDER BY owner;
BEGIN
    DBMS_OUTPUT.ENABLE(1000000);
    dbms_output.put_line(chr(10));
    FOR rec IN cur
    LOOP
        --dbms_output.put_line('The table name is ' || rec.table_name);
        --dbms_output.put_line('The owner name is ' || rec.owner);
        LM_Column := null;
        dbms_output.put_line(chr(10));
        dbms_output.put_line('declare');
        dbms_output.put_line('cols dbms_utility.name_array;');
        dbms_output.put_line('begin');
        FOR i IN (SELECT owner, table_name, column_name, column_id FROM all_tab_columns atc WHERE atc.table_name=rec.table_name AND atc.owner=rec.owner ORDER BY column_id)
        LOOP
            dbms_output.put_line('cols('||i.COLUMN_ID||') :='''||i.COLUMN_NAME||''';');
        END LOOP;

        BEGIN
            SELECT COUNT(*) INTO LM_COUNT FROM all_tab_columns atc WHERE atc.table_name=rec.table_name AND atc.owner=rec.owner AND atc.column_name IN ('LASTMODIFIED', 'LAST_MODIFIED');
            IF LM_COUNT != 1
            THEN
                DBMS_OUTPUT.PUT_LINE('Check LASTMODIFIED column for table: ' || rec.table_name );
            END IF;
            SELECT column_name INTO LM_Column FROM all_tab_columns atc WHERE atc.table_name=rec.table_name AND atc.owner=rec.owner AND atc.column_name IN ('LASTMODIFIED', 'LAST_MODIFIED');
        END;

        dbms_output.put_line('dbms_apply_adm.set_update_conflict_handler(');
        dbms_output.put_line('object_name         => '''||rec.owner||'.'||rec.table_name||''',');
        dbms_output.put_line('method_name         => ''MAXIMUM'',');
        dbms_output.put_line('resolution_column   => '''||LM_Column||''',');
        dbms_output.put_line('column_list         => cols ');
        dbms_output.put_line(');');
        dbms_output.put_line('end;');
        dbms_output.put_line('/');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('THE ERROR MESSAGE IS '|| SUBSTR(SQLERRM,1,300));
END;
/
