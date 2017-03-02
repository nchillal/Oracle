SET LINES 150 PAGES 200

SELECT  owner, synonym_name, table_owner, table_name
FROM    dba_synonyms
WHERE   synonym_name IN (SELECT sequence_name FROM dba_sequences);

SET HEADING OFF

SELECT  'CREATE '||owner||' SYNONYM '||synonym_name||' FOR '||table_owner||'.'||table_name||';'
FROM    dba_synonyms
WHERE   synonym_name IN (SELECT sequence_name FROM dba_sequences);

SET HEADING ON
