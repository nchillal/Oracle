SET LINES 260 PAGES 2000
SELECT  'GRANT '||privilege||' ON '||owner||'.'||table_name||' TO '|| grantee||';' "TABLE GRANTS"
FROM    dba_tab_privs
WHERE   table_name LIKE '&table_name'
AND     owner='&table_owner';
