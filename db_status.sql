set lines 200 
SELECT    instance_name, 
          host_name, 
          status 
FROM      gv$instance;

SELECT    name, 
          open_mode, 
          database_role 
FROM      v$database; 
