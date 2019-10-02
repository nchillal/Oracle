SELECT  'CREATE SEQUENCE '||sequence_owner||'.'||sequence_name||' MINVALUE '||MIN_VALUE||' MAXVALUE '||MAX_VALUE||' START WITH '||last_number||' INCREMENT BY '||increment_by||';'
FROM    dba_sequences
WHERE   sequence_owner = '&owner'
AND     sequence_name = '&sequence_name';

SELECT  'CREATE SEQUENCE '||sequence_owner||'.'||sequence_name||' START WITH '||last_number||' INCREMENT BY '||increment_by||';' AS SEQUENCE_SQL
FROM    dba_sequences
WHERE   sequence_name = '&name'
AND     sequence_name = '&sequence_name';
