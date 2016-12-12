set serveroutput on
BEGIN
  IF SYS_CONTEXT('USERENV','NETWORK_PROTOCOL')!='TCPS' THEN
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is enabled.');
  ELSE
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is not enabled.');
  END IF;
END;
/
