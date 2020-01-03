set linesize 230
col db_link for a60

SELECT  *
FROM    dba_synonyms
where   synonym_name='&synonym_name';
