set lines 230 
col db_link for a60

select  * 
from    dba_synonyms 
where   synonym_name='&synonym_name'; 
