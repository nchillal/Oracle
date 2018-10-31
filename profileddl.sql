-- -----------------------------------------------------------------------------------
-- Description  : Displays the DDL for the specified profile(s).
-- Call Syntax  : @profile_ddl (profile | part of profile)
-- -----------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
COLUMN ddl FORMAT a1000

BEGIN
   DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);
   DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);
END;
/

SELECT  DBMS_METADATA.GET_DDL('PROFILE', profile) AS profile_ddl
FROM    (
        SELECT DISTINCT profile
        FROM   dba_profiles
        )
WHERE   profile LIKE UPPER('%&profile_name%');
