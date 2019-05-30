-- On Source
SET SERVEROUTPUT ON
DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id => '&sql_id');
  DBMS_OUTPUT.put_line('Plans Loaded: ' || l_plans_loaded);
END;
/

EXEC DBMS_SPM.CREATE_STGTAB_BASELINE(table_name => 'sqlplan_staging_tab', table_owner => 'dbamaint_user');

SET SERVEROUTPUT ON
DECLARE
  l_plans_packed  PLS_INTEGER;
BEGIN
  l_plans_packed := DBMS_SPM.PACK_STGTAB_BASELINE
    (
    table_name      => 'sqlplan_staging_tab',
    table_owner     => 'dbamaint_user',
    sql_handle      => '&sql_handle'
    );
  DBMS_OUTPUT.PUT_LINE('Plans Packed: ' || l_plans_packed);
END;
/

expdp dumpfile=sqlplan_staging_tab.dmp logfile=sqlplan_staging_tab.log directory=EXPDIR tables=dbamaint_user.sqlplan_staging_tab

scp -rp sqlplan_staging_tab.dmp <target>:<target_dest>

-- On Target
impdp dumpfile=sqlplan_staging_tab.dmp logfile=sqlplan_staging_tab.log directory=EXPDIR

SET SERVEROUTPUT ON
DECLARE
  l_plans_unpacked  PLS_INTEGER;
BEGIN
  l_plans_unpacked := DBMS_SPM.UNPACK_STGTAB_BASELINE
    (
    table_name      => 'sqlplan_staging_tab',
    table_owner     => 'dbamaint_user',
    sql_handle      => '&sql_handle'
    );
  DBMS_OUTPUT.PUT_LINE('Plans Unpacked: ' || l_plans_unpacked);
END;
/
