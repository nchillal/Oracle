set lines 200 
select    instance_name, 
          host_name, 
          status 
from      gv$instance;
