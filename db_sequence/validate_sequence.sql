SELECT  'SELECT '||sequence_owner||'.'||sequence_name||'.nextval FROM dual;'
FROM    dba_sequences
WHERE   sequence_owner='&schema';
