BEGIN
  dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',TRUE);
  dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',TRUE);
  dbms_metadata.set_transform_param(dbms_metadata.session_transform,'CONSTRAINTS_AS_ALTER',TRUE);
  dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE', FALSE);
  dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',TRUE);
END;
/

SET LONG 1000000
SET LONGCHUNK 1000000
SET LINESIZE 200
SET PAGESIZE 0
SELECT  dbms_metadata.get_ddl('&object_type','&object_name','&schema_name')
FROM    dual;
