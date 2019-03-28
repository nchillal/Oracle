-- If you have a good plan in the cursor cache, then you can load these into SPM so that you can use this baseline to preserve the performance.
var n NUMBER
BEGIN
  :n:=DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id=>'&sql_id', plan_hash_value=>&plan_hash_value, fixed =>'NO', enabled=>'YES');
END;
/
