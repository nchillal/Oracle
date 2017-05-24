-- -----------------------------------------------------------------------------------
-- Description  : Displays the DDL for a specific role.
-- Call Syntax  : @role_ddl (role)
-- -----------------------------------------------------------------------------------

set long 20000 longchunksize 20000 pagesize 0 linesize 1000 feedback off verify off trimspool on
column ddl format a1000

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
