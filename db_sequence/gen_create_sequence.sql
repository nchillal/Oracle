SELECT  'CREATE SEQUENCES '||sequence_owner||'.'||sequence_name||' START WITH '||last_number||' INCREMENT BY '||increment_by||';'
FROM    dba_sequences
WHERE   sequence_owner = '&owner';

SELECT  'CREATE SEQUENCES '||sequence_owner||'.'||sequence_name||' START WITH '||last_number||' INCREMENT BY '||increment_by||';'
FROM    dba_sequences
WHERE   sequence_name = '&name';
