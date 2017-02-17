SET LINESIZE 230 ECHO OFF PAGESIZE 200 PAUSE ON HEADING OFF
SET PAUSE "Press ENTER to continue . . . "
ACCEPT SCHEMA PROMPT 'Enter Schema Name: '

PROMPT  *******************************************
PROMPT        Public Synonym Creation For Tables
PROMPT  *******************************************
SELECT  'CREATE PUBLIC SYNONYM '||table_name||' FOR '||owner||'.'||table_name||';'
FROM    dba_tables
WHERE   owner='&SCHEMA';

PROMPT  *******************************************
PROMPT       Public Synonym Creation For Sequences
PROMPT  *******************************************
SELECT  'CREATE PUBLIC SYNONYM '||sequence_name||' FOR '||sequence_owner||'.'||sequence_name||';'
FROM    dba_sequences
WHERE   sequence_owner='&SCHEMA';

SET ECHO ON PAUSE OFF HEADING ON
