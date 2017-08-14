SET SERVEROUTPUT ON
DECLARE
  encrypt_count NUMBER(5);
BEGIN
  SELECT COUNT(*) INTO encrypt_count FROM v$encryption_wallet WHERE wrl_type IS NOT NULL;
  IF encrypt_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TDE is enabled.');
  ELSE
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TDE is not enabled.');
  END IF;
END;
/
