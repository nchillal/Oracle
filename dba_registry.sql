set lines 230 pages 30
col comp_name for a80
select comp_id, comp_name, version, status from dba_registry
/
