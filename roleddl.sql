-- -----------------------------------------------------------------------------------
-- Description  : Displays the DDL for a specific role.
-- Call Syntax  : @role_ddl (role)
-- -----------------------------------------------------------------------------------

SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
COLUMN ddl FORMAT a1000

begin
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
end;
/

variable v_role VARCHAR2(30);

exec :v_role := upper('&1');

SELECT dbms_metadata.get_ddl('ROLE', r.role) AS ddl
FROM   dba_roles r
WHERE  r.role = :v_role
UNION ALL
SELECT dbms_metadata.get_granted_ddl('ROLE_GRANT', rp.grantee) AS ddl
FROM   dba_role_privs rp
WHERE  rp.grantee = :v_role
AND    rownum = 1
UNION ALL
SELECT dbms_metadata.get_granted_ddl('SYSTEM_GRANT', sp.grantee) AS ddl
FROM   dba_sys_privs sp
WHERE  sp.grantee = :v_role
AND    rownum = 1
UNION ALL
SELECT dbms_metadata.get_granted_ddl('OBJECT_GRANT', tp.grantee) AS ddl
FROM   dba_tab_privs tp
WHERE  tp.grantee = :v_role
AND    rownum = 1
/

set linesize 80 pagesize 14 feedback on verify on
