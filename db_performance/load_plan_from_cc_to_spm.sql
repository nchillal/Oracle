# If you have a good plan in the cursor cache, then you can load these into SPM so that you can use this baseline to preserve the performance.
var n number
begin
  :n:=dbms_spm.load_plans_FROM_cursor_cache(sql_id=>'&sql_id', plan_hash_value=>&plan_hash_value, fixed =>'NO', enabled=>'YES');
end;
/
