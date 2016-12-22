set serveroutput on
BEGIN
  IF SYS_CONTEXT('USERENV','NETWORK_PROTOCOL')!='tcps' THEN
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is not enabled.');
  ELSE
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is enabled.');
  END IF;
END;
/
