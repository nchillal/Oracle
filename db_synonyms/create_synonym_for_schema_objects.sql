SET LINESIZE 250 ECHO OFF PAGESIZE 2000

-- Public Synonym Creation For Tables
SELECT  'CREATE PUBLIC SYNONYM '||table_name||' FOR '||owner||'.'||table_name||';'
FROM    dba_tables
WHERE   owner='&&SCHEMA';

-- Public Synonym Creation For Sequences
SELECT  'CREATE PUBLIC SYNONYM '||sequence_name||' FOR '||sequence_owner||'.'||sequence_name||';'
FROM    dba_sequences
WHERE   sequence_owner='&&SCHEMA';
