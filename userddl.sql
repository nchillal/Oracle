-- -----------------------------------------------------------------------------------
-- Description  : Displays the DDL for a specific user.
-- Call Syntax  : @user_ddl (username)
-- -----------------------------------------------------------------------------------

set long 20000 longchunksize 20000 pagesize 0 linesize 1000 feedback off verify off trimspool on
column ddl format a1000

begin
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
end;
/

variable v_username VARCHAR2(30);

exec:v_username := upper('&1');

SELECT dbms_metadata.get_ddl('USER', u.username) AS ddl
FROM   dba_users u
where  u.username = :v_username
union all
SELECT dbms_metadata.get_granted_ddl('TABLESPACE_QUOTA', tq.username) AS ddl
FROM   dba_ts_quotas tq
where  tq.username = :v_username
and    rownum = 1
union all
SELECT dbms_metadata.get_granted_ddl('ROLE_GRANT', rp.grantee) AS ddl
FROM   dba_role_privs rp
where  rp.grantee = :v_username
and    rownum = 1
union all
SELECT dbms_metadata.get_granted_ddl('SYSTEM_GRANT', sp.grantee) AS ddl
FROM   dba_sys_privs sp
where  sp.grantee = :v_username
and    rownum = 1
union all
SELECT dbms_metadata.get_granted_ddl('OBJECT_GRANT', tp.grantee) AS ddl
FROM   dba_tab_privs tp
where  tp.grantee = :v_username
and    rownum = 1
union all
SELECT dbms_metadata.get_granted_ddl('DEFAULT_ROLE', rp.grantee) AS ddl
FROM   dba_role_privs rp
where  rp.grantee = :v_username
and    rp.default_role = 'YES'
and    rownum = 1
union all
SELECT to_clob('/* Start profile creation script in case they are missing') AS ddl
FROM   dba_users u
where  u.username = :v_username
and    u.profile <> 'DEFAULT'
and    rownum = 1
union all
SELECT dbms_metadata.get_ddl('PROFILE', u.profile) AS ddl
FROM   dba_users u
where  u.username = :v_username
and    u.profile <> 'DEFAULT'
union all
SELECT to_clob('End profile creation script */') AS ddl
FROM   dba_users u
where  u.username = :v_username
and    u.profile <> 'DEFAULT'
and    rownum = 1
/

set linesize 80 pagesize 14 feedback on trimspool on verify on
