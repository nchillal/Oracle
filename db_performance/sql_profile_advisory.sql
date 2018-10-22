set serveroutput on echo off
DECLARE
  -- input variables
  input_task_owner DBA_ADVISOR_TASKS.OWNER%TYPE:='SYS';
  input_task_name DBA_ADVISOR_TASKS.TASK_NAME%TYPE:='&task_name';
  input_show_outline boolean:=TRUE;
  -- local variables
  task_id  DBA_ADVISOR_TASKS.TASK_ID%TYPE;
  outline_data XMLTYPE;
  benefit NUMBER;
BEGIN
  FOR o IN (SELECT * FROM dba_advisor_objects WHERE owner=input_task_owner AND task_name=input_task_name AND type='SQL')
  LOOP
    -- get the profile hints (opt_estimate)
    DBMS_OUTPUT.PUT_LINE('--- PROFILE HINTS from '||o.task_name||' ('||o.object_id||') statement '||o.attr1||':');
    DBMS_OUTPUT.PUT_LINE('/*+');
    FOR r IN (
      SELECT  hint,
              benefit
      FROM    (
              SELECT    CASE
                          WHEN attr5 LIKE 'OPT_ESTIMATE%' THEN cast(attr5 as VARCHAR2(4000))
                          WHEN attr1 LIKE 'OPT_ESTIMATE%' THEN attr1
                        END hint,
                        benefit
              FROM      dba_advisor_recommendations t JOIN dba_advisor_rationale r USING (task_id,rec_id)
              WHERE     t.owner=o.owner
              AND       t.task_name = o.task_name
              AND       r.object_id=o.object_id
              AND       t.type='SQL PROFILE'
              --and r.message='This attribute adjusts optimizer estimates.'
              )
              ORDER BY  TO_NUMBER(REGEXP_REPLACE(hint,'^.*=([0-9.]+)[^0-9].*$','1'))
              ) loop
    DBMS_OUTPUT.PUT_LINE('   '||r.hint); benefit:=TO_NUMBER(r.benefit)/100;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('*/');
    -- get the outline hints
    BEGIN
      SELECT  outline_data INTO outline_data
      FROM    (
              SELECT    CASE
                          WHEN other_xml IS NOT NULL THEN EXTRACT(XMLTYPE(other_xml),'/*/outline_data/hint')
                        END outline_data
              FROM      dba_advisor_tasks t JOIN dba_sqltune_plans p USING (task_id)
              WHERE     t.owner=o.owner
              AND       t.task_name = o.task_name
              AND       p.object_id=o.object_id
              AND       t.advisor_name='SQL Tuning Advisor'
              AND       p.attribute='Using SQL profile'
              )
      WHERE   outline_data IS NOT NULL;
    EXCEPTION WHEN no_data_found THEN NULL;
    END;
    EXIT WHEN NOT input_show_outline;
    DBMS_OUTPUT.PUT_LINE('--- OUTLINE HINTS from '||o.task_name||' ('||o.object_id||') statement '||o.attr1||':');
    DBMS_OUTPUT.PUT_LINE('/*+');
    FOR r IN  (
      SELECT  (EXTRACTVALUE(VALUE(d), '/hint')) hint
      FROM    TABLE(XMLSEQUENCE(EXTRACT( outline_data , '/'))) d
              ) loop
      DBMS_OUTPUT.PUT_LINE('   '||r.hint);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('*/');
    DBMS_OUTPUT.PUT_LINE('--- Benefit: '||TO_CHAR(TO_NUMBER(benefit),'FM99.99')||'%');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');
END;
/
