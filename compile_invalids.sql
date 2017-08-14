SET PAGESIZE 0 HEADING OFF FEEDBACK OFF ECHO OFF TERMOUT OFF
SPOOL validate_all.sql
SELECT    'set echo on' FROM dual;

SELECT    'ALTER '||object_type||' '||owner||'.'||object_name||' COMPILE;'
FROM      dba_objects
WHERE     object_type IN ('PROCEDURE','FUNCTION','VIEW','TRIGGER','MATERIALIZED VIEW')
AND       status='INVALID'
ORDER BY  owner;

SELECT    'ALTER PACKAGE '||owner||'.'||object_name||' COMPILE PACKAGE;'
FROM      dba_objects
WHERE     object_type IN ('PACKAGE')
AND       status='INVALID'
ORDER BY  owner;

SELECT    'ALTER PACKAGE '||owner||'.'||object_name||' COMPILE BODY;'
FROM      dba_objects
WHERE     object_type IN ('PACKAGE BODY')
AND       status='INVALID'
ORDER BY  owner;

SELECT    'ALTER JAVA SOURCE "' || object_name || '" COMPILE;'
FROM      dba_objects
WHERE     object_type = 'JAVA SOURCE'
AND       status = 'INVALID';

SELECT    'ALTER JAVA CLASS "' || object_name || '" RESOLVE;'
FROM      dba_objects
WHERE     object_type = 'JAVA CLASS'
AND       status = 'INVALID';

SELECT    'ALTER TYPE '||owner||'.'||object_name||' COMPILE;'
FROM      dba_objects
WHERE     object_type IN ('TYPE')
AND       status='INVALID'
ORDER BY  owner;

SELECT    'ALTER TYPE '||owner||'.'||object_name||' COMPILE BODY;'
FROM      dba_objects
WHERE     object_type IN ('TYPE BODY')
AND       status='INVALID'
ORDER BY  owner;

SELECT    DECODE(owner, 'SYS', 'ALTER SYNONYM '||owner||'.'||object_name||' COMPILE;',
                        'PUBLIC', 'ALTER PUBLIC SYNONYM '||object_name||' COMPILE;')
FROM      dba_objects
WHERE     object_type = 'SYNONYM'
AND       status = 'INVALID';

SPOOL OFF
EXIT
