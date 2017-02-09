SET LINESIZE 155 PAGESIZE 200 PAUSE ON
SET PAUSE "Press ENTER to continue . . . "
ACCEPT TNAME PROMPT 'Enter Table Name:'
ACCEPT SNAME PROMPT 'Enter Schema Name:'


COLUMN owner FORMAT a20
COLUMN column_name FORMAT a20
COLUMN search_condition FORMAT a35
COLUMN constraint_name FORMAT a30

SELECT    constraint_name,
          DECODE(constraint_type, 'C', 'Check',
                                  'P', 'Primary',
                                  'U', 'Unique',
                                  'R', 'Referential') "Constraint Type",
          search_condition,
          status,
          deferrable,
          deferred,
          validated,
          generated
FROM      dba_constraints
WHERE     table_name = '&TNAME'
AND       owner = '&SNAME'
/

ACCEPT CNAME PROMPT 'Enter Column Name:'

SELECT    b.owner, a.constraint_name, b.table_name, a.column_name, b.search_condition, b.validated
FROM      dba_cons_columns a, dba_constraints b
WHERE     a.constraint_name = b.constraint_name
AND       b.table_name = '&TNAME'
AND       b.owner = '&SNAME'
AND       a.column_name LIKE '&CNAME'
/
