EXEC strmadmin.gsd_streams_adm.set_tag(tag => HEXTORAW('17'));

SET SERVEROUTPUT ON;
DECLARE
    LM_Column VARCHAR2(5000) DEFAULT NULL;
    LM_COUNT NUMBER;
CURSOR cur IS SELECT at.table_name, at.owner FROM all_tables at WHERE 1=1 AND owner IN ('&schema_owner') AND at.table_name NOT LIKE 'STR%LAG%MON%' ORDER BY owner;
BEGIN
    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    FOR rec IN cur
    LOOP
        --dbms_output.put_line('The table name is ' || rec.table_name);
        --dbms_output.put_line('The owner name is ' || rec.owner);
        LM_Column := null;
        DBMS_OUTPUT.PUT_LINE(chr(10));
        DBMS_OUTPUT.PUT_LINE('declare');
        DBMS_OUTPUT.PUT_LINE('cols dbms_utility.name_array;');
        DBMS_OUTPUT.PUT_LINE('begin');
        FOR i IN (SELECT owner, table_name, column_name, column_id FROM all_tab_columns atc WHERE atc.table_name=rec.table_name AND atc.owner=rec.owner ORDER BY column_id)
        LOOP
            DBMS_OUTPUT.PUT_LINE('cols('||i.column_id||') :='''||i.column_name||''';');
        END LOOP;

        BEGIN
            SELECT COUNT(*) INTO LM_COUNT FROM all_tab_columns atc WHERE atc.table_name=rec.table_name AND atc.owner=rec.owner AND atc.column_name IN ('LASTMODIFIED', 'LAST_MODIFIED');
            IF LM_COUNT != 1
            THEN
                DBMS_OUTPUT.PUT_LINE('Check LASTMODIFIED column for table: ' || rec.table_name );
            END IF;
            SELECT column_name INTO LM_Column FROM all_tab_columns atc WHERE atc.table_name=rec.table_name AND atc.owner=rec.owner AND atc.column_name IN ('LASTMODIFIED', 'LAST_MODIFIED');
        END;

        DBMS_OUTPUT.PUT_LINE('dbms_apply_adm.set_update_conflict_handler(');
        DBMS_OUTPUT.PUT_LINE('object_name         => '''||rec.owner||'.'||rec.table_name||''',');
        DBMS_OUTPUT.PUT_LINE('method_name         => ''MAXIMUM'',');
        DBMS_OUTPUT.PUT_LINE('resolution_column   => '''||LM_Column||''',');
        DBMS_OUTPUT.PUT_LINE('column_list         => cols ');
        DBMS_OUTPUT.PUT_LINE(');');
        DBMS_OUTPUT.PUT_LINE('end;');
        DBMS_OUTPUT.PUT_LINE('/');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('THE ERROR MESSAGE IS '|| SUBSTR(SQLERRM,1,300));
END;
/
