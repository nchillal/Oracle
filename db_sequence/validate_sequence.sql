SELECT  'SELECT '||sequence_owner||'.'||sequence_name||'.currval FROM dual;'
FROM    dba_sequences
WHERE   sequence_owner='&schema';

SELECT  'SELECT '||sequence_name||'.nextval FROM dual;'
FROM    user_sequences;
