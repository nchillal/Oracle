SELECT 'SELECT COUNT(*) FROM '||owner||'.'||object_name||';' table_count FROM dba_objects WHERE object_name LIKE 'SYS%JOURNAL%';

SELECT owner, object_name FROM dba_objects WHERE object_name LIKE 'SYS%JOURNAL%';

SET SERVEROUTPUT ON
DECLARE
    isClean BOOLEAN;
BEGIN
    isClean := DBMS_REPAIR.ONLINE_INDEX_CLEAN();
    IF isClean=TRUE THEN
        DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF;
END;
/

SELECT owner, object_name FROM dba_objects WHERE object_name LIKE 'SYS%JOURNAL%';
