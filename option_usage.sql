SET LINESIZE 230;
SET PAGESIZE 1000;
SET FEEDBACK OFF;
SET COLSEP '|';
WHENEVER SQLERROR EXIT SQL.SQLCODE;

COL "Host Name" FORMAT A40;
COL "Option/Management Pack" FORMAT A60;
COL "Used" FORMAT A5;
with features as(
SELECT a OPTIONS, b NAME  FROM
(
SELECT 'Active Data Guard' a,  'Active Data Guard - Real-Time Query on Physical Standby' b FROM dual
union all 
SELECT 'Advanced Compression', 'HeapCompression' FROM dual
union all
SELECT 'Advanced Compression', 'Backup BZIP2 Compression' FROM dual
union all 
SELECT 'Advanced Compression', 'Backup DEFAULT Compression' FROM dual
union all 
SELECT 'Advanced Compression', 'Backup HIGH Compression' FROM dual
union all
SELECT 'Advanced Compression', 'Backup LOW Compression' FROM dual
union all
SELECT 'Advanced Compression', 'Backup MEDIUM Compression' FROM dual
union all
SELECT 'Advanced Compression', 'Backup ZLIB, Compression' FROM dual
union all
SELECT 'Advanced Compression', 'SecureFile Compression (user)' FROM dual
union all
SELECT 'Advanced Compression', 'SecureFile Deduplication (user)' FROM dual
union all
SELECT 'Advanced Compression',        'Data Guard' FROM dual
union all
SELECT 'Advanced Compression', 'Oracle Utility Datapump (Export)' FROM dual
union all
SELECT 'Advanced Compression', 'Oracle Utility Datapump (Import)' FROM dual
union all
SELECT 'Advanced Security',	'ASO native encryption and checksumming' FROM dual
union all
SELECT 'Advanced Security', 'Transparent Data Encryption' FROM dual
union all
SELECT 'Advanced Security', 'Encrypted Tablespaces' FROM dual
union all
SELECT 'Advanced Security', 'Backup Encryption' FROM dual
union all
SELECT 'Advanced Security', 'SecureFile Encryption (user)' FROM dual
union all
SELECT 'Change Management Pack',	'Change Management Pack (GC)' FROM dual
union all
SELECT 'Data Masking Pack',	'Data Masking Pack (GC)' FROM dual
union all
SELECT 'Data Mining',	'Data Mining' FROM dual
union all
SELECT 'Diagnostic Pack',  	'Diagnostic Pack' FROM dual
union all
SELECT 'Diagnostic Pack',  	'ADDM' FROM dual
union all
SELECT 'Diagnostic Pack',  	'AWR Baseline' FROM dual
union all
SELECT 'Diagnostic Pack',  	'AWR Baseline Template' FROM dual
union all
SELECT 'Diagnostic Pack',  	'AWR Report' FROM dual
union all
SELECT 'Diagnostic Pack',  	'Baseline Adaptive Thresholds' FROM dual
union all
SELECT 'Diagnostic Pack',  	'Baseline Static Computations' FROM dual
union all
SELECT 'Tuning  Pack',  	'Tuning Pack' FROM dual
union all
SELECT 'Tuning  Pack',  	'Real-Time SQL Monitoring' FROM dual
union all
SELECT 'Tuning  Pack',  	'SQL Tuning Advisor' FROM dual
union all
SELECT 'Tuning  Pack',  	'SQL Access Advisor' FROM dual
union all
SELECT 'Tuning  Pack',  	'SQL Profile' FROM dual
union all
SELECT 'Tuning  Pack',  	'Automatic SQL Tuning Advisor' FROM dual
union all
SELECT 'Database Vault',  	'Oracle Database Vault' FROM dual
union all
SELECT 'WebLogic Server Management Pack Enterprise Edition',  	'EM AS Provisioning and Patch Automation (GC)' FROM dual
union all
SELECT 'Configuration Management Pack for Oracle Database',  	'EM Config Management Pack (GC)' FROM dual
union all
SELECT 'Provisioning and Patch Automation Pack for Database',  	'EM Database Provisioning and Patch Automation (GC)' FROM dual
union all
SELECT 'Provisioning and Patch Automation Pack',  	'EM Standalone Provisioning and Patch Automation Pack (GC)' FROM dual
union all
SELECT 'Exadata',  	'Exadata' FROM dual
union all
SELECT 'Label Security',  	'Label Security' FROM dual
union all
SELECT 'OLAP',  	'OLAP - Analytic Workspaces' FROM dual
union all
SELECT 'Partitioning',  	'Partitioning (user)' FROM dual
union all
SELECT 'Real Application Clusters',  	'Real Application Clusters (RAC)' FROM dual
union all
SELECT 'Real Application Testing',  	'Database Replay: Workload Capture' FROM dual
union all
SELECT 'Real Application Testing',  	'Database Replay: Workload Replay' FROM dual
union all
SELECT 'Real Application Testing',  	'SQL Performance Analyzer' FROM dual
union all
SELECT 'Spatial'	,'Spatial (Not used because this does not differential usage of spatial over locator, which is free)' FROM dual
union all
SELECT 'Total Recall',	'Flashback Data Archive' FROM dual
)
)
SELECT t.o "Option/Management Pack", 
       t.u "Used",
       d.DBID "DBID",
       d.name "DB Name",
       i.version "DB Version",
       i.host_name "Host Name",
       to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') "ReportGen Time"
FROM
(SELECT OPTIONS o, DECODE(sum(num),0,'NO','YES') u
FROM
(
SELECT f.OPTIONS OPTIONS, case
                   when f_stat.name is null then 0
                   when ( ( f_stat.currently_used = 'TRUE' and
                            f_stat.detected_usages > 0 and
                            (sysdate - f_stat.last_usage_date) < 366 and
                            f_stat.total_samples > 0
                          )
                          or 
                          (f_stat.detected_usages > 0 and 
                          (sysdate - f_stat.last_usage_date) < 366 and
                          f_stat.total_samples > 0)
                        ) and 
                        ( f_stat.name not in('Data Guard', 'Oracle Utility Datapump (Export)', 'Oracle Utility Datapump (Import)')
                          or
                          (f_stat.name in('Data Guard', 'Oracle Utility Datapump (Export)', 'Oracle Utility Datapump (Import)') and
                           f_stat.feature_info is not null and trim(substr(to_char(feature_info), instr(to_char(feature_info), 'compression used: ',1,1) + 18, 2)) != '0')
                        )
                        then 1
                   else 0
                  end num
  FROM features f,
       sys.dba_feature_usage_statistics f_stat
where f.name = f_stat.name(+)
) group by options) t,
  v$instance i,
  v$database d
ORDER BY 2 desc,1 
;

exit;

