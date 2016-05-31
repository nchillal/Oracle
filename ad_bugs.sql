set lines 230
col APPLICATION_SHORT_NAME for a6 heading ASN
select  * 
from    apps.ad_bugs 
where   bug_number='&bug_number';
