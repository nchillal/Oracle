Rem
Rem $Header: rdbms/admin/utlu112i.sql /st_rdbms_11.2.0.4.0dbpsu/1 2013/10/25 11:29:12 ewittenb Exp $
Rem
Rem utlu112i.sql
Rem
Rem Copyright (c) 2006, 2013, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      utlu112i.sql - UTiLity Upgrade Information
Rem
Rem    DESCRIPTION
Rem      This script provides information about databases to be
Rem      upgraded to 11.2.
Rem
Rem      Supported releases: 9.2.0, 10.1.0, 10.2.0 and 11.1.0, 11.2.0
Rem
Rem    NOTES
Rem      Run connected AS SYSDBA to the database to be upgraded
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    ewittenb    10/09/13 - Backport ewittenb_bug-17288409 from main
Rem    ewittenb    08/16/13 - fix parenthesis bug-17288409
Rem    cdilling    07/02/13 - fix lrg 9205085 - more invalid objects
Rem    jerrede     05/23/13 - Allow to work in a Read Only Database
Rem    cdilling    03/21/13 - exclude patch invalid objects
Rem    bmccarth    09/19/12 - bug 13836336 db_platform_name
Rem                         - bug 12897845 - warn about job_que_process
Rem                         - Fix feching cpu_count mulitple times
Rem    cmlim       04/25/12 - bug 13968961 - customize backport
Rem                           cmlim_preupg_tblspace_sizes from 12.1 to 11.2.0.4
Rem                          - performance in ts_has_queues: add condition
Rem                            'q.owner = t.owner'
Rem    cmlim       04/04/12 - bug 12807768: check that timed_statistics is TRUE
Rem                           if statistics_level is not BASIC
Rem    cdilling    02/03/12 - update version for 11.2.0.4
Rem    cmlim       06/30/11 - bug 12699712 - alert about audit rows update
Rem    cmlim       05/30/11 - bug 12565777: fix the autoextensible check for
Rem                           data files and temp files
Rem    cdilling    05/02/11 - warn that APEX will only be upgraded if target
Rem                           version is higher (bug 12409090) 
Rem    cmlim       04/21/11 - cmlim_bug-11899181_11203: pre-upgrade not checking
Rem                           that undo tablespace size is a minimum of 400M
Rem    jerrede     04/07/11 - Fix lrg 5426470
Rem    jerrede     04/01/11 - Fix Bug 11887624
Rem    bmccarth    01/11/11 - fix size output for xml, use sys_dba_segs 
Rem                         - to avoid overflow (9483844)
Rem    cmlim       01/05/11 - lrg 4944010: 2 invalid objs for in-place upgrades
Rem                         - also included fix for bug_10068587-b_main into
Rem                           11203 to populate invalid objs into
Rem                           registry$sys_inv_objs/registry$nonsys_inv_objs
Rem    jerrede     12/16/10 - Backport jerrede_bug-10352598 from main
Rem    vmedam      11/19/10 - Backport vmedam_bug-10175219 from main
Rem    cdilling    11/23/10 - change version to 11.2.0.3
Rem    cmlim       10/21/10 - Backport cmlim_bug-10068587_main from main
Rem    bmccarth    08/17/10 - bug 10017332
Rem                           cell_partition_large_extents
Rem    cdilling    07/26/10 - bug 9930725 - recompile
Rem                           dba_registry/dba_registry_database
Rem    cmlim       07/19/10 - Backport cmlim_bug-9858126 from main
Rem    cmlim       06/21/10 - update_tzv14: 11202 is now at time zone file v14
Rem    bmccarth    06/16/10 - fix connect by 9797974
Rem    bmccarth    06/03/10 - DMSYS recommendation coming from 11.1 to 11.2
Rem    cmlim       06/01/10 - bug 9664514 - size tblspace with apex correctly
Rem    cmlim       05/27/10 - evaluate time zone checks for 112 patchsets too
Rem    bmccarth    05/03/10 - stale stats warning being removed, added
Rem                           recommendations section
Rem    bmccarth    04/27/10 - Fix invalidobject list (LRG)
Rem                         - Fix XML output for STATUS/VERSION of components
Rem                         - Fix <warning> for xml output
Rem    cmlim       04/28/10 - bug 9463683 - change drop table to truncate if
Rem                           possible
Rem    bmccarth    03/16/10 - fix optimized dba_queues query
Rem    cdilling    03/12/10 - check for editioning views - bug 9464506
Rem    bmccarth    02/23/10 - Rework queries inside execute_immedidate
Rem                         - Bug 8889137
Rem                         - Removed several tmp variables
Rem                         - Some checks are now displayed on read-only db.
Rem                         - Control output in local routines
Rem                         - Bug 9398987 - cpu_count 
Rem    cmlim       02/01/10 - 11202 is now at time zone file version 13
Rem    cmlim       01/05/10 - pool sizing
Rem    bmccarth    02/01/10 - warn about _ params, events, remove asm check.
Rem                         - core_dump_dest lives - 8937877
Rem                         - remove autoextend text, too confusing 8715709
Rem    vmedam      02/02/10 - bug#9066715
Rem    bmccarth    11/23/09 - cursor_space_for_time
Rem    cmlim       12/03/09 - bug 9105687: generate recommendations for both
Rem                           32-bit and 64-bit databases
Rem    bmccarth    10/20/09 - allow uppercase in log-archive-format
Rem    cdilling    10/09/09 - fix ultrasearch check
Rem    cdilling    09/29/09 - change recycle bin message to reflect 'required'
Rem    cdilling    09/25/09 - optimize query in function ts_has_queues
Rem    cmlim       09/23/09 - bug 8916085 - up sga_target hard-coded minimums
Rem                           and fix sga_target new minimum calculation
Rem    bmccarth    09/09/09 - add versioning/date for metalink
Rem                         - bug 8751969 - add patchset to version output for dbua
Rem                         - bug 8883722 - provide command to update stats
Rem                         - bug 8874588 - round off flashback used 
Rem                         - bug 6614161 - Remove Network ACL warnings
Rem    cdilling    09/02/09 - warn if sys.enabled$indexes table exists
Rem    cdilling    08/06/09 - support patch upgrades for 11.2.0
Rem    bmccarth    08/25/09 - extend structure for fb path
Rem    cdilling    07/15/09 - set version to 11.2.0.2
Rem    bmccarth    07/01/09 - sql_trace is not obsolete
Rem    cmlim       06/26/09 - add more timezone versions for 9i - v8 to v11
Rem                         - update utlu_tz_version from v8 to v11
Rem    cmlim       06/12/09 - bug 8592763: add more timezone versions for 9i
Rem                           (from utltzver.sql)
Rem    bmccarth    06/03/09 - check recycle bin and change text of stale stats
Rem    bmccarth    06/03/09 - fix version to 11.2.0.1
Rem    cmlim       05/21/09 - lrg 3880817: fix typos in comments
Rem    bmccarth    05/20/09 - report if imageindex is in use
Rem                         - fix queries to sys objects/tables
Rem    bmccarth    05/14/09 - report in invalid log_archive_format strings
Rem                         - Renamed a few global variables (names were too short)
Rem    cmlim       05/14/09 - bug 8509010: check java_pool_size always
Rem    bmccarth    05/12/09 - Put exception around check for redo_logs
Rem    cmlim       05/11/09 - lrg 3880817: suggested->recommended for DBMS_DST
Rem    bmccarth    04/16/09 - report obsolete params and change format of 
Rem                           output to include version
Rem    bmccarth    02/06/09 - info about FRA space
Rem    bmccarth    03/18/09 - remote redo transport check bug
Rem    cmlim       03/05/09 - bug 7656036: add more time zone file versions for
Rem                           9208 db
Rem    bmccarth    01/29/09 - display warning when SYS/SYSTEM default ts not
Rem                           SYSTEM
Rem    cdilling    01/20/09 - exclude 'JOB$' from gather statistics
Rem    cmlim       01/03/09 - bug 7569744: 920 is not generating correct
Rem                           timezone msg
Rem    cmlim       12/12/08 - timezone_b7193417-b: 112 is shipping with v8
Rem                           timezone file (not v5)
Rem    cdilling    11/18/08 - change name to oracle datbase vault
Rem                           propogate dsemler changes for APPQOSSYS checks 
Rem    cmlim       11/16/08 - lrg 3681155: update min shared_pool_size and
Rem                           fix it so that db_cache_size is displayed
Rem    cmlim       10/12/08 - bug 7457704: 11.2 DBUA: no mod registry$database
Rem                           using utlu_tz_version if table PUIU$SETTZ exists
Rem    cdilling    09/02/08 - add support for MEMORY_TARGET
Rem    cdilling    08/21/08 - add ultrasearch warnings - bug 7012341
Rem    cmlim       07/24/08 - bug 7193417: support timezone file version
Rem                           changes in 11.2
Rem    cmlim       05/20/08 - bug 7112063: upgrade from pre-11g dbs:
Rem                           set UNDO_MANAGEMENT to MANUAL if unset
Rem    awitkows    03/30/08 - DST and timezone in props
Rem    cdilling    03/11/08 - Created
Rem

SET SERVEROUTPUT ON FORMAT WRAPPED;
-- Linesize 100 for 'i' version 1000 for 'x' version
SET ECHO OFF FEEDBACK OFF PAGESIZE 0 LINESIZE 100;

---------------------------- DECLARATIONS ---------------------------

DECLARE

-- *****************************************************************
-- Release Specific Constants
-- These constants must be updated for each new patch release
-- *****************************************************************

  utlu_banner      CONSTANT VARCHAR2(50) := 'Oracle Database 11.2 Pre-Upgrade Information Tool ';
  utlu_support_ver CONSTANT VARCHAR2(40) := '9.2.0, 10.1.0, 10.2.0, 11.1.0, 11.2.0';
  utlu_version     CONSTANT VARCHAR2(30) := '11.2.0.4';
  utlu_patchset    CONSTANT VARCHAR2(3)  := '.0';
  utlu_buildrev    CONSTANT VARCHAR2(3)  := '007';
  utlu_tz_version  CONSTANT NUMBER := 14;  -- Match with catupstr.sql

-- *****************************************************************
-- Database Information 
-- *****************************************************************

  db_name         VARCHAR2(30);
  db_version      VARCHAR2(30);
  db_dict_version VARCHAR2(30);
  db_prev_version VARCHAR2(30);
  db_compat       VARCHAR2(30);
  db_platform_id  NUMBER;
  db_platform_name VARCHAR2(256);
  db_block_size   NUMBER;
  db_undo         VARCHAR2(30);
  db_undo_tbs     VARCHAR2(30);
  db_log_mode     VARCHAR2(12);
  db_tz_version   NUMBER := 0;
  db_vlm          VARCHAR2(30);     -- TRUE when Very Large Memory enabled
  db_64           BOOLEAN := FALSE; -- TRUE when platform is 64-bit
  db_readonly     BOOLEAN := FALSE;

  dbv             BINARY_INTEGER; -- (920, 101, 102, 111, 112)
  vers            VARCHAR2(12);   -- major version (e.g., 10.1.0)
  patch           VARCHAR2(12);   -- patch version (e.g., 10.1.0.2)
  tznames_dist    NUMBER;         -- 9.2 distinct time zone names
  tznames_count   NUMBER;         -- 9.2 total time zone names
  memory_target   BOOLEAN := FALSE; -- TRUE when memory_target is set 
  tmp_num1        NUMBER;
  tmp_num2        NUMBER;
  tmp_num3        NUMBER;
  tmp_varchar1    VARCHAR2(512);
  tmp_varchar2    VARCHAR2(512);

-- *****************************************************************
-- Component Information 
-- *****************************************************************

  TYPE comp_record_t IS RECORD (
      cid            VARCHAR2(30), -- component id
      cname          VARCHAR2(45), -- component name
      version        VARCHAR2(30), -- version
      status         VARCHAR2(15), -- component status
      schema         VARCHAR2(30), -- owner of component
      def_ts         VARCHAR2(30), -- name of default tablespace
      script         VARCHAR2(128), -- upgrade script name
      processed      BOOLEAN,      -- TRUE IF in the registry AND is not
                                   -- status REMOVING/REMOVED, OR
                                   -- TRUE IF will be in the registry because
                                   -- because cmp_info().install is TRUE
      install        BOOLEAN, -- TRUE if component to be installed in upgrade
      sys_kbytes     NUMBER,  -- upgrade size needed in system tablespace
      sysaux_kbytes  NUMBER,  -- upgrade size needed in sysaux tablespace
      def_ts_kbytes  NUMBER,  -- upgrade size needed in 'other' tablespace
      ins_sys_kbytes NUMBER,  -- install size needed in system tablespace
      ins_def_kbytes NUMBER   -- install size needed in 'other' tablespace
      );
  TYPE comp_table_t IS TABLE of comp_record_t INDEX BY BINARY_INTEGER;
  cmp_info comp_table_t;      -- Table of component information

-- index values for components (order as in upgrade script)
  catalog CONSTANT BINARY_INTEGER:=1;
  catproc CONSTANT BINARY_INTEGER:=2;
  javavm  CONSTANT BINARY_INTEGER:=3;
  xml     CONSTANT BINARY_INTEGER:=4;
  rac     CONSTANT BINARY_INTEGER:=5;
  owm     CONSTANT BINARY_INTEGER:=6;
  mgw     CONSTANT BINARY_INTEGER:=7;
  aps     CONSTANT BINARY_INTEGER:=8;
  amd     CONSTANT BINARY_INTEGER:=9;
  ols     CONSTANT BINARY_INTEGER:=10;
  dv      CONSTANT BINARY_INTEGER:=11;
  em      CONSTANT BINARY_INTEGER:=12;
  context CONSTANT BINARY_INTEGER:=13;
  xdb     CONSTANT BINARY_INTEGER:=14;
  catjava CONSTANT BINARY_INTEGER:=15;
  ordim   CONSTANT BINARY_INTEGER:=16;
  sdo     CONSTANT BINARY_INTEGER:=17;
  odm     CONSTANT BINARY_INTEGER:=18;
  wk      CONSTANT BINARY_INTEGER:=19;
  exf     CONSTANT BINARY_INTEGER:=20;
  rul     CONSTANT BINARY_INTEGER:=21;
  apex    CONSTANT BINARY_INTEGER:=22;
  xoq     CONSTANT BINARY_INTEGER:=23;
  stats   CONSTANT BINARY_INTEGER:=24;

  max_comps CONSTANT BINARY_INTEGER :=24; -- include STATS for space calcs
  max_components CONSTANT BINARY_INTEGER :=23;

  c_kb    CONSTANT BINARY_INTEGER := 1024;  -- constant for 1Kb = 1024 bytes

-- *****************************************************************
-- Tablespace Information 
-- *****************************************************************

   TYPE tablespace_record_t IS RECORD (
       name    VARCHAR2(30),  -- tablespace name
       inuse   NUMBER,        -- kbytes inuse in tablespace
       alloc   NUMBER,        -- kbytes allocated to tbs
       auto    NUMBER,        -- autoextend kbytes available
       avail   NUMBER,        -- total kbytes available
       delta   NUMBER,        -- kbytes required for upgrade
       inc_by  NUMBER,        -- kbytes to increase tablespace by
       min     NUMBER,        -- minimum required kbytes to perform upgrade
       addl    NUMBER,        -- additional space allocated during upgrade
       fname   VARCHAR2(513), -- filename in tablespace
       fauto   BOOLEAN,       -- TRUE if there is a file to increase autoextend
       temporary BOOLEAN,     -- TRUE if Temporary tablespace
       localmanaged BOOLEAN   -- TRUE if locally managed temporary tablespace
                              -- FALSE if dictionary managed temp tablespace
       );

   TYPE tablespace_table_t IS TABLE OF tablespace_record_t
        INDEX BY BINARY_INTEGER;
 
   ts_info tablespace_table_t; -- Tablespace information
   max_ts  BINARY_INTEGER; -- Total number of relevant tablespaces

-- *****************************************************************
-- Rollback Segment Information 
-- *****************************************************************

   TYPE rollback_record_t IS RECORD (
       tbs_name VARCHAR2(30), -- tablespace name
       seg_name VARCHAR2(30), -- segment name
       status   VARCHAR(30),  -- online or offline
       inuse    NUMBER, -- kbytes in use
       next     NUMBER, -- kbytes in NEXT
       max_ext  NUMBER, -- max extents
       auto     NUMBER  -- autoextend available for tablespace
       );

   TYPE rollback_table_t IS TABLE of rollback_record_t
        INDEX BY BINARY_INTEGER;

   rs_info    rollback_table_t;  -- Rollback segment information
   max_rs     BINARY_INTEGER; -- Total number of public rollback segs

-- *****************************************************************
-- Log File Information 
-- *****************************************************************

   TYPE log_file_record_t IS RECORD (
        file_spec    VARCHAR2(513),
        grp          NUMBER, 
        bytes        NUMBER,
        status       VARCHAR2(16)
        );

   TYPE log_file_table_t IS TABLE of log_file_record_t
        INDEX BY BINARY_INTEGER;
 
   lf_info log_file_table_t;  -- Log File Information
   max_lf        BINARY_INTEGER;  -- Total number of log file groups

   min_log_size CONSTANT NUMBER := 4194304;   -- Minimum size 4M
   rmd_log_size CONSTANT NUMBER := 15;        -- Recommended size 15M

-- *****************************************************************
-- Flashback Information (10.n and above)
-- *****************************************************************

  TYPE fb_record_t IS RECORD (
      active         BOOLEAN,       -- ON or OFF
      file_dest      VARCHAR2(1000), -- db_recovery_file_dest
      dsize           NUMBER,        -- db_recovery_file_dest_size
      name           VARCHAR2(513), -- name
      limit          NUMBER,        -- space limit
      used           NUMBER,        -- Used
      reclaimable    NUMBER,
      files          NUMBER         -- number of files
      );
  flashback_info fb_record_t;

-- *****************************************************************
-- Initialization Parameter Information 
-- *****************************************************************

   TYPE obsolete_record_t IS RECORD (
      name VARCHAR2(80),
      version  VARCHAR2(20),  -- version where is was obsolete/deprecated
      deprecated BOOLEAN,    -- Has become Depreciated
      db_match BOOLEAN
      );

   TYPE obsolete_table_t IS TABLE of obsolete_record_t
      INDEX BY BINARY_INTEGER;

   op     obsolete_table_t;
   max_op BINARY_INTEGER;

   TYPE renamed_record_t IS RECORD (
      oldname VARCHAR2(80),
      newname VARCHAR2(80),
      db_match BOOLEAN
      );

   TYPE renamed_table_t IS TABLE of renamed_record_t
      INDEX BY BINARY_INTEGER;

   rp      renamed_table_t;
   max_rp  BINARY_INTEGER;

   TYPE special_record_t IS RECORD (
      oldname  VARCHAR2(80),
      oldvalue VARCHAR2(80),
      newname  VARCHAR2(80),
      newvalue VARCHAR2(80),
      db_match BOOLEAN
      );

   TYPE special_table_t IS TABLE of special_record_t
      INDEX BY BINARY_INTEGER;

   sp      special_table_t;
   max_sp  BINARY_INTEGER;

   TYPE required_record_t IS RECORD (
      name     VARCHAR2(80),
      newnumbervalue NUMBER,
      newstringvalue VARCHAR2(4000),
      type NUMBER,
      db_match BOOLEAN
      );

   TYPE required_table_t IS TABLE of required_record_t
      INDEX BY BINARY_INTEGER;

   reqp      required_table_t;
   max_reqp  BINARY_INTEGER;

   --
   -- Params that have min values
   --
   TYPE minvalue_record_t IS RECORD (
      name     VARCHAR2(80),
      minvalue NUMBER,
      oldvalue NUMBER,
      newvalue NUMBER,
      display  BOOLEAN,
      diff     NUMBER  -- the positive diff of 'oldvalue - minvalue' if
                       -- sga_target or memory_target is used
      );

   TYPE minvalue_table_t IS TABLE of minvalue_record_t
      INDEX BY BINARY_INTEGER;

   minvp_db32   minvalue_table_t;
   minvp_db64   minvalue_table_t;
   max_minvp    BINARY_INTEGER;

   cpu          NUMBER;  -- number of CPUs
   cpu_threads  NUMBER;  -- number of threads per CPU
   sesn         NUMBER;  -- number of sessions 

   sp_idx BINARY_INTEGER;  -- shared_pool_size
   jv_idx BINARY_INTEGER;  -- java_pool_size
   tg_idx BINARY_INTEGER;  -- sga_target
   cs_idx BINARY_INTEGER;  -- cache_size
   pg_idx BINARY_INTEGER;  -- pga_aggreate_target
   mt_idx BINARY_INTEGER;  -- memory_target
   lp_idx BINARY_INTEGER;  -- large_pool_size
   str_idx BINARY_INTEGER; -- streams_pool_size

-- *****************************************************************
-- Warning Information 
-- *****************************************************************

   sysaux_exists     BOOLEAN := FALSE; -- TRUE when sysaux tablespace exists
   sysaux_not_online BOOLEAN := FALSE; -- TRUE when sysaux is not online
   sysaux_not_perm   BOOLEAN := FALSE; -- TRUE when sysaux is not permanent
   sysaux_not_local  BOOLEAN := FALSE; -- TRUE when sysaux is not extent local
   sysaux_not_auto   BOOLEAN := FALSE; -- TRUE when sysaux is not auto seg 
   dip_user_exists   BOOLEAN := FALSE; -- TRUE when DIP user found in user$
   ocm_user_exists   BOOLEAN := FALSE; -- TRUE when OCM user found in user$
   qos_user_exists   BOOLEAN := FALSE; -- TRUE when APPQOSSYS user is in user$
   cluster_dbs       BOOLEAN := FALSE; -- TRUE when "cluster_database" init
   nls_al24utffss    BOOLEAN := FALSE; -- TRUE when AL24UTFFSS found in
   utf8_al16utf16    BOOLEAN := FALSE; -- TRUE when AL16UTF16 nor UTF8 NCHAR
   owm_replication   BOOLEAN := FALSE; -- TRUE when wmsys.wm$replication_table
   dblinks           BOOLEAN := FALSE; -- TRUE when database links exist
   cdc_data          BOOLEAN := FALSE; -- TRUE when cdc data exists
   version_mismatch  BOOLEAN := FALSE; -- TRUE when dictionary != instance
   connect_role      BOOLEAN := FALSE; -- TRUE when connect role used
   invalid_objs      BOOLEAN := FALSE; -- TRUE when invalid objects exist
   ssl_users         BOOLEAN := FALSE; -- TRUE when potential SSL users
   timezone_old      BOOLEAN := FALSE; -- TRUE when older time zone version
   timezone_new      BOOLEAN := FALSE; -- TRUE when newer time zone version
   xe_upgrade        BOOLEAN := FALSE; -- TRUE when XE database being upgraded
   em_exists         BOOLEAN := FALSE; -- TRUE when EM in database
   snapshot_refresh  BOOLEAN := FALSE; -- TRUE when active snapshot refreshes
   recovery_files    BOOLEAN := FALSE; -- TRUE when files need media recovery
   files_backup_mode BOOLEAN := FALSE; -- TRUE when files are in backup mode
   pending_2pc_txn   BOOLEAN := FALSE; -- TRUE when pending distribution txns
   sync_standby_db   BOOLEAN := FALSE; -- TRUE when standby database needs sync
   ultrasearch_data  BOOLEAN := FALSE; -- TRUE when "used" Ultrasearch found
   remote_redo_issue BOOLEAN := FALSE; -- TRUE when remote redo conditions are bad
   laf_format        BOOLEAN := FALSE; -- TRUE when log_archive_format is missing %r
   imageidx_used     BOOLEAN := FALSE; -- TRUE when ordsys.ordimageindex exists
   recyclebin_on     BOOLEAN := FALSE; -- TRUE if recyclebin is ON
   laf_format_string VARCHAR2(4000) := ''; -- log_archive_format value from v$parameter
   sys_ts_default    VARCHAR2(30) := '';  -- Name of default tablespace for SYS
   system_ts_default VARCHAR2(30) := '';  -- Name of default tablespace for SYSTEM
   enabled_indexes_tbl BOOLEAN := FALSE;  -- TRUE when sys.enabled$indexes table exists in database
   hidden_params_in_use BOOLEAN := FALSE; -- TRUE if there are hidden params
   non_default_events BOOLEAN := FALSE;   -- TRUE if we want to report events
   dbms_ldap_dep     BOOLEAN := FALSE;    -- TRUE if DBMS_LDAP dependencies exist
   edition_exists    BOOLEAN := FALSE;    -- TRUE if editioning views exist but users is not edition enabled
   dmsys_recommendation BOOLEAN := FALSE; -- TRUE if recommending dropping dmsys
   fga_upd_rowcnt    NUMBER;  -- # of rows in fga_log$ to update during upgrade
   aud_upd_rowcnt    NUMBER;  -- # of rows in aud$ to update during upgrade
   timed_statistics_mbt  BOOLEAN := FALSE; -- TRUE if
                                           --   TIMED_STATISTICS Must Be True
   job_queue_issue BOOLEAN := FALSE;
   job_queue_count NUMBER  := 0;

-- *****************************************************************
-- Global Constants and Variables
-- *****************************************************************

   idx          BINARY_INTEGER;
   type cursor_t IS REF CURSOR;
   reg_cursor   cursor_t;
   tmp_cursor   cursor_t;

   p_null       CHAR(1);
   p_user       VARCHAR2(30);
   p_cid        VARCHAR2(30);
   p_status     VARCHAR2(30);
   n_status     NUMBER;
   p_version    VARCHAR2(30);
   p_schema     VARCHAR2(30);
   n_schema     NUMBER;
   p_value      VARCHAR2(80);
   p_pos        INTEGER;
   p_count      INTEGER;
   p_char       CHAR(1);
   p_tsname     VARCHAR2(30);
   p_edition    VARCHAR2(128);
   sum_bytes      NUMBER;
   delta_kbytes   NUMBER;
   delta_sysaux   NUMBER;
   delta_queues   INTEGER;
   rows_processed INTEGER;
   nonsys_invalid_objs INTEGER;
   wk_index       INTEGER;
   wk_table       INTEGER;
   wk_data        INTEGER; 
   recycle_objects INTEGER;
   tbl_exists     INTEGER;  -- does table exist?  0 is no; > 0 is yes
   ev_count       INTEGER;

-- display_xml is FALSE for 'i' version, TRUE for 'x' version
   display_xml  BOOLEAN := FALSE;

   collect_diag BOOLEAN := FALSE;
   collect_diag_2 BOOLEAN := FALSE;  -- more tablespace sizing diag info
   rerun        BOOLEAN := FALSE;
   inplace      BOOLEAN := FALSE;
   SYS_todo     BOOLEAN := FALSE;
   warning_5000 BOOLEAN := FALSE;

   NO_SUCH_TABLE  EXCEPTION;
   PRAGMA exception_init(NO_SUCH_TABLE, -942);


-- *****************************************************************
-- ------------- INTERNAL FUNCTIONS AND PROCEDURES -----------------
-- *****************************************************************

--------------------  display_line/display_warning -----------------
PROCEDURE display_line (text varchar2)
IS
BEGIN
   -- Move to utl_file at some point
   dbms_output.put_line (text);
END display_line;

PROCEDURE display_warning (text varchar2)
IS
BEGIN
   display_line ('WARNING: --> ' || text);
END display_warning;

--------------------------- store_renamed --------------------------------
PROCEDURE store_renamed (i   IN OUT BINARY_INTEGER,
                         old VARCHAR2,
                         new VARCHAR2)
IS
BEGIN
   i:= i+1;
   rp(i).oldname:=old;
   rp(i).newname:=new;
END store_renamed;

--------------------------- store_removed --------------------------------
PROCEDURE store_removed (i IN OUT BINARY_INTEGER,
                         name       VARCHAR2,
                         version    VARCHAR2,
                         deprecated BOOLEAN)
IS
BEGIN
   i:=i+1;
   op(i).name:=name;
   op(i).version:=version;
   op(i).deprecated:=deprecated;
END store_removed;

--------------------------- store_special --------------------------------
PROCEDURE store_special (i    IN OUT BINARY_INTEGER,
                         old  VARCHAR2,
                         oldv VARCHAR2,
                         new  VARCHAR2,
                         newv VARCHAR2)
IS
BEGIN
   i:= i+1;
   sp(i).oldname:=old;
   sp(i).oldvalue:=oldv;
   sp(i).newname:=new;
   sp(i).newvalue:=newv;
   
END store_special;

--------------------------- store_required --------------------------------
PROCEDURE store_required (i    IN OUT BINARY_INTEGER,
                         name  VARCHAR2,
                         newvn NUMBER,
                         newvs VARCHAR2,
                         dtype NUMBER)
--
-- Pass a 0, or '', for the newvn (new value numeric) or 
-- that you are not setting.
--  store_required(idx, 'foo', 0, 'bar', 2); 
-- would mean a string value of 'bar' is expected
-- 
IS
BEGIN
   i:= i+1;
   reqp(i).name:=name;
   reqp(i).newnumbervalue:=newvn;
   reqp(i).newstringvalue:=newvs;
   reqp(i).type:= dtype;
   reqp(i).db_match:=FALSE;   
END store_required;

--------------------------- store_minvalue --------------------------------
PROCEDURE store_minvalue (i     BINARY_INTEGER,
                          name  VARCHAR2,
                          minv  NUMBER,
                          minvp IN OUT MINVALUE_TABLE_T)
IS
BEGIN
   minvp(i).name := name;
   minvp(i).minvalue := minv;
   minvp(i).display := FALSE;
   minvp(i).diff := 0;
END store_minvalue;

--------------------------- store_minval_dbbit -----------------------------
PROCEDURE store_minval_dbbit  (dbbit  NUMBER,
                               i      IN OUT BINARY_INTEGER,
                               name   VARCHAR2,
                               minv   NUMBER)
IS
BEGIN

   i:= i+1;

   IF dbbit = 32 THEN  -- set values for 32-bit
     store_minvalue(i, name, minv, minvp_db32);
   ELSIF dbbit = 64 THEN  -- set values for 64-bit
     store_minvalue(i, name, minv, minvp_db64);
   ELSE -- if 0 (or anything but 32 and 64), then set values for both db bits
     store_minvalue(i, name, minv, minvp_db32);
     store_minvalue(i, name, minv, minvp_db64);
   END IF;

END store_minval_dbbit;

--------------------------- store_comp -----------------------------------
PROCEDURE store_comp (i       BINARY_INTEGER,
                      schema  VARCHAR2,
                      version VARCHAR2,
                      status  NUMBER)
IS
BEGIN

   cmp_info(i).processed := TRUE;
   IF status = 0 THEN
      cmp_info(i).status := 'INVALID';
   ELSIF status = 1 THEN
      cmp_info(i).status := 'VALID';
   ELSIF status = 2 THEN
      cmp_info(i).status := 'LOADING';
   ELSIF status = 3 THEN
      cmp_info(i).status := 'LOADED';
   ELSIF status = 4 THEN
      cmp_info(i).status := 'UPGRADING';
   ELSIF status = 5 THEN
      cmp_info(i).status := 'UPGRADED';
   ELSIF status = 6 THEN
      cmp_info(i).status := 'DOWNGRADING';
   ELSIF status = 7 THEN
      cmp_info(i).status := 'DOWNGRADED';
   ELSIF status = 8 THEN
      cmp_info(i).status := 'REMOVING';
   ELSIF status = 9 THEN
      cmp_info(i).status := 'OPTION OFF';
   ELSIF status = 10 THEN
      cmp_info(i).status := 'NO SCRIPT';
   ELSIF status = 99 THEN
      cmp_info(i).status := 'REMOVED';
   ELSE
      cmp_info(i).status := NULL;
   END IF;
   cmp_info(i).version   := version;
   cmp_info(i).schema    := schema;
   EXECUTE IMMEDIATE 
      'SELECT default_tablespace FROM sys.dba_users WHERE username =:1'
   INTO cmp_info(i).def_ts
   USING schema;
EXCEPTION
   WHEN NO_DATA_FOUND THEN NULL;
END store_comp;

------------------------------ update_puiu_data ---------------------
PROCEDURE update_puiu_data (dtype varchar2, dname varchar2, delta number)
IS
BEGIN

    IF collect_diag AND NOT db_readonly THEN
       EXECUTE IMMEDIATE 'UPDATE sys.puiu$data SET puiu_delta = :delta 
                  WHERE d_type=:dtype and d_name= :dname'
       USING delta, dtype, dname;
       COMMIT;
    END IF;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN NULL;
END;

------------------------------ insert_puiu_data ---------------------
PROCEDURE insert_puiu_data (dtype varchar2, dname varchar2, delta number)
IS
BEGIN

    IF collect_diag AND NOT display_xml AND NOT db_readonly THEN
       EXECUTE IMMEDIATE 'INSERT INTO sys.puiu$data 
              (d_type, d_name, puiu_delta) VALUES (:dtype, :dname, :delta)'
       USING dtype, dname, delta;
       COMMIT;
    END IF;
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN NULL;
END;

-------------------------- is_comp_tablespace ------------------------------------
-- returns TRUE if some existing component has the tablespace as a default

FUNCTION is_comp_tablespace (tsname VARCHAR2) RETURN BOOLEAN
IS
BEGIN
    FOR i IN 1..max_components LOOP
        IF cmp_info(i).processed AND
           tsname = cmp_info(i).def_ts THEN
           RETURN TRUE;
        END IF;
    END LOOP;
    RETURN FALSE;
END is_comp_tablespace;

-------------------------- ts_has_queues ---------------------------------
-- returns TRUE if there is at least one queue in the tablespace

FUNCTION ts_has_queues (tsname VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   EXECUTE IMMEDIATE 'SELECT NULL FROM sys.dba_tables t
      WHERE EXISTS 
         (SELECT 1 FROM sys.dba_queues q
          WHERE q.queue_table = t.table_name AND q.owner = t.owner)
      AND t.tablespace_name = :1 AND rownum <= 1'
     INTO p_null
     USING tsname;
   RETURN TRUE;
EXCEPTION
   WHEN NO_DATA_FOUND THEN RETURN FALSE;
END ts_has_queues;

-------------------------- ts_is_SYS_temporary ---------------------------------
-- returns TRUE if there is at least one queue in the tablespace

FUNCTION ts_is_SYS_temporary (tsname VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   EXECUTE IMMEDIATE 'SELECT NULL FROM sys.dba_users 
        WHERE username = ''SYS'' AND temporary_tablespace = :1' 
   INTO p_null
   USING tsname;
   RETURN TRUE;
EXCEPTION
   WHEN NO_DATA_FOUND THEN RETURN FALSE;
END ts_is_SYS_temporary;

-------------------------- display_banner -------------------------------------
PROCEDURE display_banner
IS
BEGIN
    display_line(
   '**********************************************************************');
END display_banner;


-------------------------- display_header_and_db -------------------------------------
PROCEDURE display_header_and_db (oracleversion VARCHAR2)
IS
BEGIN
  --
  -- oracleversion is only used for xml output and can be rerun= and/or value= 
  --
  IF display_xml THEN
    display_line('<RDBMSUP version="' || utlu_version || utlu_patchset || '">');
    display_line('<SupportedOracleVersions value="' || utlu_support_ver || '"/>');
    display_line('<OracleVersion ' || oracleversion || '/>'); 
    display_line('<Database>');
    display_line('<database Name="' || db_name || '"/>');
    display_line('<database Version="' || db_version || '"/>');
    display_line('<database Compatibility="' || db_compat || '"/>');
    display_line('</Database>');
  ELSE
    display_line(utlu_banner || TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'));
    display_line('Script Version: ' || utlu_version || utlu_patchset ||
                            ' Build: ' || utlu_buildrev);
    display_line('.');

    display_banner;

    IF NOT db_readonly THEN
      display_line('Database:');
    ELSE
      display_line('Database:    ***** READ ONLY MODE *****');
    END IF;
    display_banner;
    display_line ('--> name:          ' || db_name );
    display_line ('--> version:       ' || db_version );
    display_line ('--> compatible:    ' || db_compat );
    display_line ('--> blocksize:     ' || db_block_size );
    IF xe_upgrade THEN
      display_line ('--> edition:       ' || 'XE' );
    END IF;
    IF NOT (dbv=920) THEN
      display_line ('--> platform:      ' || db_platform_name );
    END IF;
    if (dbv = 920 and db_tz_version is NULL) THEN
      display_line ('--> timezone file: UNKNOWN');
     ELSE
      display_line ('--> timezone file: V' || db_tz_version );
    END IF;
    display_line ('.');
  END IF;
END display_header_and_db;

-------------------------------  boolval  -------------------------------------
FUNCTION boolval (p boolean, 
                  trueval VARCHAR2, 
                  falseval VARCHAR2) return varchar2
IS
--
-- Return truval if the bool is TRUE otherwise return falseval
-- Usage: boolval(somebool, 'Yes', 'No')
--        boolval(somebool, 'On', 'Off')
--        boolval(somebool, 'True', 'False')
BEGIN
   if p = TRUE THEN
      return trueval;
   ELSE
      return falseval;
   END IF;
END boolval;

------------------------------ display_logfiles -----------------------------
-- Display the names and sizes of all logfiles in lf_info

PROCEDURE display_logfiles
IS

BEGIN
   IF display_xml THEN
      IF max_lf > 0 THEN
         FOR i IN 1..max_lf LOOP
            display_line(
               '<RedologFile name="' || lf_info(i).file_spec || 
                 '" group="'  || TO_CHAR(lf_info(i).grp) ||
                 '" status="' || lf_info(i).status||
                 '" size="'   || TO_CHAR(rmd_log_size) || 
                 '" unit="MB"/>');
          END LOOP;
      END IF;
      display_line(
          '<RollbackSegment name="SYSTEM" size="90" unit="MB"/>');
   ELSE
      display_banner;
      display_line(
           'Logfiles: [make adjustments in the current environment]');
      display_banner;
      IF max_lf > 0 THEN
        FOR i IN 1..max_lf LOOP
            display_line('--> ' || lf_info(i).file_spec);
            display_line('.... status="' || lf_info(i).status ||
                                   '", group#="' || TO_CHAR(lf_info(i).grp) ||
                                   '"');
            display_line(
            '.... current size="' || TO_CHAR(lf_info(i).bytes/1024) || '" KB');

            display_line(
            '.... suggested new size="' || TO_CHAR(rmd_log_size) || 
                                           '" MB');
        END LOOP;
        display_warning('one or more log files is less than 4MB.');
        display_line('Create additional log files larger ' ||
             'than 4MB, drop the smaller ones and then upgrade.');
      ELSE
         display_line(
         '--> The existing log files are adequate. No changes are required.');
      END IF;
      display_line ('.');
   END IF;
END display_logfiles;


------------------------------ display_flashback ----------------------------
-- Display details relating to flashback setting of the database 


PROCEDURE display_flashback
IS
BEGIN
   IF dbv = 920 THEN 
    --
    -- No flashback until 10.n
    --
      RETURN;
   END IF;

   IF display_xml THEN
      display_line(
        '<FlashbackInfo name="' || flashback_info.name || 
                 '" status="' || boolval (flashback_info.active, 'ON', 'OFF') ||
                 '" limit="'  || TO_CHAR((flashback_info.limit / (1024*1024)))          || ' MB' ||
                 '" used="'  || TO_CHAR( round((flashback_info.used / (1024 * 1024)),0))  || ' MB' || 
                 '" size="' || TO_CHAR( (flashback_info.dsize / (1024*1024)))           || ' MB' || 
                 '" reclaim="'  || TO_CHAR( (flashback_info.reclaimable) / (1024*1024)) || ' MB' ||
                 '" files="'  || TO_CHAR(flashback_info.files) ||
                 '" />');
   ELSE
     display_banner;
     display_line('Flashback: ' || boolval(flashback_info.active, 'ON', 'OFF'));
     display_banner;

     IF flashback_info.active THEN
       display_line('FlashbackInfo:');
       display_line ('--> name:          ' || flashback_info.name );
       display_line ('--> limit:         ' || TO_CHAR( (flashback_info.limit / (1024*1024)))          || ' MB');
       display_line ('--> used:          ' || TO_CHAR( round((flashback_info.used / (1024 * 1024)),0))  || ' MB');
       display_line ('--> size:          ' || TO_CHAR( (flashback_info.dsize / (1024*1024)))       || ' MB');
       display_line ('--> reclaim:       ' || TO_CHAR( (flashback_info.reclaimable / (1024*1024))) || ' MB');
       display_line ('--> files:         ' || TO_CHAR(flashback_info.files));
       display_warning('Flashback Recovery Area Set.  Please ensure adequate disk space ' ||
                             '             in recovery areas before performing an upgrade.');
       display_line ('.');
     END IF;
   END IF;
END display_flashback;
 
----------------------- display_crs_xml -----------------------------
-- Display create rollback segment. Display is in xml format, only
-- for use by DBUA. Static. Note: display_line does no more than
-- 255 bytes.

PROCEDURE display_crs_xml
IS
BEGIN
   display_line(
        '<CreateRollbackSegments value="ODMA_RBS01" revert="true">');
   display_line(
        '<InNewTablespace name="ODMA_RBS" size="70" unit="MB">');
   display_line(
        '<Datafile name="{ORACLE_BASE}/oradata/{DB_NAME}/odma_rbs.dbf"/>');
   display_line(
        '<Autoextend value="ON">');
   display_line(
        '<Next value="10" unit="MB"/>');
   display_line(
        '<Maxsize value="200" unit="MB"/>');
   display_line(
        '</Autoextend>');
   display_line(
        '<Storage>');
   display_line(
        '<Initial value="10" unit="MB"/>');
   display_line(
        '<Next value="10" unit="MB"/>');
   display_line(
        '<MinExtents value="1"/>');
   display_line(
        '<MaxExtents value="30"/>');
   display_line(
        '</Storage>');
   display_line(
        '</InNewTablespace>');
   display_line(
        '</CreateRollbackSegments>');

END display_crs_xml;

---------------------- display_sysaux ------------------------------
PROCEDURE display_sysaux 
IS

BEGIN
   IF display_xml THEN
      display_line('<SYSAUXtbs>');
   ELSE
      display_banner;
      display_line('SYSAUX Tablespace:');
      display_line('[Create tablespace in the Oracle ' ||
                            'Database 11.2 environment]');
      display_banner;
   END IF;

   IF sysaux_exists THEN
      IF display_xml THEN
          display_line('<SysauxTablespace present="true"/>');
          display_line('<Attributes>');
          display_line('<Size value="' || TO_CHAR(delta_sysaux) ||
                                           '" unit="MB"/>');
          IF sysaux_not_online THEN
             display_line('<Online value="false"/>');
          ELSE 
             display_line('<Online value="true"/>');
          END IF;

          IF sysaux_not_perm THEN
             display_line('<Permanent value="false"/>');
          ELSE 
             display_line('<Permanent value="true"/>');
          END IF;
          -- Online and Readwrite are together
          IF sysaux_not_online THEN
             display_line('<Readwrite value="false"/>');
          ELSE 
             display_line('<Readwrite value="true"/>');
          END IF;
          IF sysaux_not_local THEN
             display_line('<ExtentManagementLocal value="false"/>');
          ELSE 
             display_line('<ExtentManagementLocal value="true"/>');
          END IF;
          IF sysaux_not_auto THEN
             display_line(
                           '<SegmentSpaceManagementAuto value="false"/>');
          ELSE 
             display_line(
                           '<SegmentSpaceManagementAuto value="true"/>');
          END IF;
          display_line('</Attributes>');
      ELSE
          display_line('WARNING: SYSAUX tablespace is present.');
          display_line(
             '.... Minimum required size for database upgrade:' ||
             TO_CHAR(delta_sysaux) || ' MB');
          -- Online and Readwrite are together 
          IF sysaux_not_online THEN
             display_line('WARNING:.... OFFLINE');
          ELSE 
             display_line('.... Online');
          END IF;
          IF sysaux_not_perm THEN
             display_line('WARNING:.... NOT Permanent');
          ELSE 
             display_line('.... Permanent');
          END IF;
          -- Online and Readwrite are together
          IF sysaux_not_online THEN
             display_line('WARNING:.... NOT Readwrite');
          ELSE 
             display_line('.... Readwrite');
          END IF;
          IF sysaux_not_local THEN
             display_line(
             '.... WARNING:  NOT ExtentManagementLocal');
          ELSE 
             display_line('.... ExtentManagementLocal');
          END IF;

          IF sysaux_not_auto THEN
             display_line(
             'WARNING:.... NOT SegmentSpaceManagementAuto');
          ELSE 
             display_line(
             '.... SegmentSpaceManagementAuto');
          END IF; 
      END IF;
   ELSE  -- SYSAUX tablespace does not exist
      IF display_xml THEN
          display_line('<SysauxTablespace present="false"/>');
          display_line('<Attributes>');
          display_line('<Size value="' ||
                      TO_CHAR(delta_sysaux) || '" unit="MB"/>');
          display_line('</Attributes>');
      ELSE
          display_line('--> New "SYSAUX" tablespace ');
          display_line(
             '.... minimum required size for database upgrade: '  ||
                   TO_CHAR(delta_sysaux) || ' MB');
      END IF;
   END IF;
   IF display_xml THEN
      display_line('</SYSAUXtbs>');
   ELSE
     display_line ('.');
   END IF;
END display_sysaux;

--------------------------- display_components -----------------------------
PROCEDURE display_components
IS
   ui VARCHAR2(10);
   tmp_varchar VARCHAR2(30);

BEGIN
   IF display_xml THEN
      IF (cmp_info(catalog).status = 'VALID' AND cmp_info(catproc).status = 'VALID') THEN
        tmp_varchar := cmp_info(catalog).status;
      ELSE
        tmp_varchar := 'INVALID';
      END IF;

      display_line('');
      display_line('<Components>');
      --
      -- For Server status, use Catalog status (catalog and catproc are 
      -- skipped in the below loop)
      --
      display_line( 
         '<Component id ="Oracle Server" type="SERVER" cid="RDBMS" status="' ||
              tmp_varchar || '">');
      display_line(
          '<CEP value="{ORACLE_HOME}/rdbms/admin/rdbmsup.sql"/>');
      display_line(
          '<SupportedOracleVersions value="9.2.0,10.1.0, 10.2.0,11.1.0,11.2.0"/>');
      display_line(   
         '<OracleVersion value ="'|| db_version || '"/>'); 
      display_line('</Component>');
      --
      -- Note 1,2 are catalog and catproc which are skipped 
      --
      FOR i IN 3 .. max_components LOOP
         IF cmp_info(i).processed and NOT (cmp_info(i).cid = 'WK') THEN
           IF (cmp_info(i).status = NULL) THEN
             -- If we get a NULL value, don't dump out the status
             tmp_varchar := '';
           ELSE
             -- Create the status= entry 
             tmp_varchar := ' status="' || cmp_info(i).status || '"';
           END IF;
           display_line('<Component id="'   || cmp_info(i).cname   ||
                              '" cid="'     || cmp_info(i).cid     || 
                              '" script="'  || cmp_info(i).script  || 
                              '" version="' || cmp_info(i).version || 
                              '"' || tmp_varchar || '>');
         display_line('</Component>');
     END IF;
   END LOOP;
   display_line('</Components>');

ELSE
    display_line('');
    display_banner;
    display_line (
      'Components: [The following database components will be ' ||
      'upgraded or installed]'); 
    display_banner;
    FOR i IN 1..max_components LOOP
        IF cmp_info(i).processed THEN
            IF cmp_info(i).install THEN
               ui := '[install]';
            ELSE
               ui := '[upgrade]';
            END IF;
            display_line(
            '--> ' || rpad(cmp_info(i).cname, 28) || ' ' ||
                      rpad(ui, 10) || ' ' ||
                      rpad(cmp_info(i).status, 9));
            IF (cmp_info(i).cid = 'DV') THEN
            display_line(
               '... To successfully upgrade Oracle Database Vault, choose ');
               display_line(
               '... ''Select Options'' in Oracle installer and then select ');
               display_line(
               '... Oracle Label Security.');
            ELSIF ((cmp_info(i).cid  = 'OLS') AND 
                  NOT cmp_info(dv).processed) THEN
               display_line(
               '... To successfully upgrade Oracle Label Security, choose ');
               display_line(
               '... ''Select Options'' in Oracle installer and then select ');
               display_line(
               '... Oracle Label Security.');
	    ELSIF ((cmp_info(i).cid  = 'APEX') AND 
                  NOT cmp_info(apex).install) THEN
               display_line(
               '... APEX will only be upgraded if the version of APEX in ');
               display_line(
               '... the target Oracle home is higher than the current one.');
            END IF;
        END IF;
    END LOOP;
    display_line ('.');
END IF;

END display_components;

--------------------------- display_tablespaces -----------------------------
-- Display the names and sizes of all tablespaces in ts_info

PROCEDURE display_tablespaces
IS
BEGIN

   IF display_xml THEN
      display_line('<SystemResource>');
      display_line('<MinFreeSpace>');
      FOR i IN 1..max_ts LOOP
         IF ts_info(i).inc_by > 0 OR ts_info(i).addl > 0 THEN
            IF ts_info(i).fauto = FALSE AND ts_info(i).inc_by > 0 THEN
               display_line(
                    '<DefaultTablespace value="' || ts_info(i).name ||
                 '"> <AdditionalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).inc_by)) ||
                             '" unit="MB"/>' ||
                 ' <TotalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).min)) ||
                             '" unit="MB"/>');
               display_line(' </DefaultTablespace>');
            ELSE 
               -- Autoextend is ON
               IF ts_info(i).inc_by > 0 THEN
                  display_line(
                        '<DefaultTablespace value="' || ts_info(i).name ||
                     '"> <Datafile name="' || ts_info(i).fname ||
                    '"/> <AdditionalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).inc_by)) ||
                             '" unit="MB"' ||
                    '/> <TotalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).min)) ||
                             '" unit="MB"/>');
                  display_line(
                     '<Autoextend value="ON"> <Next value="10" unit="MB"/>' ||
                    ' <Maxsize value="' ||
                             TO_CHAR(ROUND(ts_info(i).min)) ||
                             '" unit="MB"/> ' ||
                     '</Autoextend>');
                  display_line('</DefaultTablespace>');
               ELSIF ts_info(i).addl > 0 THEN
                  display_line(
                        '<DefaultTablespace value="' || ts_info(i).name ||
                     '"> <Datafile name="' || ts_info(i).fname ||
                    '"/> <AdditionalAlloc size="' ||
                             TO_CHAR(ROUND(ts_info(i).addl)) ||
                             '" unit="MB"/>');
                  display_line('</DefaultTablespace>');
               END IF;
            END IF;
         END IF;
      END LOOP;

      display_logfiles;
      display_line('</MinFreeSpace>');

      -- Display the DBUA required create rollback segment static tags
      display_crs_xml;
      display_line('</SystemResource>');

      -- Report the SYSAUX tablespace
      IF dbv NOT IN (101,102) THEN
         display_sysaux;
      END IF;

   ELSE -- display TEXT output
      display_banner;
      display_line(
           'Tablespaces: [make adjustments in the current environment]');
      display_banner;
      IF max_ts > 0 THEN
         FOR i IN 1..max_ts LOOP
           IF ts_info(i).inc_by = 0 THEN
              display_line(
                '--> ' || ts_info(i).name || 
                     ' tablespace is adequate for the upgrade.');
              IF collect_diag_2 THEN
                 display_line(
                    '.... currently allocated size: ' ||
                     TO_CHAR(ROUND(ts_info(i).alloc)) || ' MB');
                 display_line(
                    '.... currently used size: ' ||
                     TO_CHAR(ROUND(ts_info(i).inuse)) || ' MB');
              END IF;
              display_line(
                '.... minimum required size: ' ||
                TO_CHAR(ROUND(ts_info(i).min)) || ' MB');
           ELSE  -- need more space in tablespace
              display_warning(ts_info(i).name || 
                          ' tablespace is not large enough for the upgrade.');
              display_line(
                 '.... currently allocated size: ' ||
                  TO_CHAR(ROUND(ts_info(i).alloc)) || ' MB');
              IF collect_diag_2 THEN
              display_line(
                 '.... currently used size: ' ||
                  TO_CHAR(ROUND(ts_info(i).inuse)) || ' MB');
              END IF;
              display_line(
                 '.... minimum required size: ' ||
                  TO_CHAR(ROUND(ts_info(i).min)) || ' MB');
              display_line(
                 '.... increase current size by: ' ||
                  TO_CHAR(ROUND(ts_info(i).inc_by)) || ' MB');
              IF ts_info(i).fauto THEN
                 display_line(
                   '.... tablespace is AUTOEXTEND ENABLED.');
              ELSE 
                 display_line(
                  '.... tablespace is NOT AUTOEXTEND ENABLED.');
              END IF;    
           END IF; 
        END LOOP;

      display_line ('.');
      END IF;
   END IF;
END display_tablespaces;
 
------------------------------ display_rollback_segs ---------------------
-- Display information about public rollback segments

PROCEDURE display_rollback_segs
IS
  auto VARCHAR2(3);

BEGIN
   IF NOT display_xml THEN
      IF max_rs > 0 THEN
         display_banner;
         display_line('Rollback Segments: [make adjustments ' ||
                              'immediately prior to upgrading]');
         display_banner;
         -- Loop through the rs_info table
         FOR i IN 1..max_rs LOOP
            IF rs_info(i).auto > 0 THEN 
               auto:='ON'; 
            ELSE
               auto:='OFF'; 
            END IF;
            display_line(
                '--> ' || rs_info(i).seg_name || ' in tablespace ' || 
                          rs_info(i).tbs_name || ' is ' || 
                          rs_info(i).status ||
                          '; AUTOEXTEND is ' || auto);
            display_line(
                '.... currently allocated: ' || rs_info(i).inuse 
                      || 'K');
            display_line(
                '.... next extent size: ' || rs_info(i).next 
                      || 'K; max extents: ' || rs_info(i).max_ext);
         END LOOP;
         display_warning('For the upgrade, use a large (minimum 70M) ' ||
                            'public rollback segment');
         IF max_rs > 1 THEN
            display_warning('Take smaller public rollback segments OFFLINE');
         END IF;
         display_line ('.');
      END IF;
   END IF;

END display_rollback_segs;


---------------------------- display_update_params_xml ------------------------
-- Display init ora parameters for update in text.

PROCEDURE display_update_params_xml (minvp MINVALUE_TABLE_T)
IS

BEGIN

 -- minimum value parameters
  FOR i IN 1..max_minvp LOOP
    IF minvp(i).display THEN
      IF NOT (i = jv_idx and NOT cmp_info(javavm).processed) THEN
        IF NOT (i = mt_idx and minvp(i).oldvalue IS NULL) THEN
           display_line('<Parameter name="' ||
              minvp(i).name ||
              '" atleast="' || TO_CHAR(ROUND(minvp(i).newvalue)) ||
              '" atleast_32="' || TO_CHAR(ROUND(minvp_db32(i).newvalue)) ||
              '" atleast_64="' || TO_CHAR(ROUND(minvp_db64(i).newvalue)) ||
              '" type="NUMBER"/>');
        END IF;
      END IF;
    END IF;
  END LOOP;

  -- Parameters with new names
  FOR i IN 1..max_sp LOOP
     IF sp(i).db_match = TRUE AND
        sp(i).oldvalue IS NOT NULL AND
        sp(i).newvalue IS NULL THEN
        display_line(
           '<Parameter name="' || sp(i).newname ||
          '" setThis="' || sp(i).oldvalue || '" type="STRING"/>');
     END IF;
  END LOOP;

  -- Required values if missing
  FOR i IN 1..max_reqp LOOP
     IF reqp(i).db_match = TRUE THEN
        -- For values of type NUMBER
        IF reqp(i).type = 3 THEN
          display_line('<Parameter name="' ||
           reqp(i).name ||
           '" setThis="' ||
           TO_CHAR(ROUND(reqp(i).newnumbervalue)) ||
           '" type="NUMBER"/>');
        -- For values of type STRING
        ELSIF reqp(i).type = 2 THEN
          display_line('<Parameter name="' ||
           reqp(i).name ||
           '" setThis="' ||
           reqp(i).newstringvalue ||
           '" type="STRING"/>');
        END IF;
     END IF;
  END LOOP;

  -- Display the minimum compatibility static tag
  IF dbv = 920 OR (dbv IN (101,102) AND SUBSTR(db_compat,1,2)!='10') THEN
     display_line(
      '<Parameter name="compatible" atleast="10.1.0" atleast_32="10.1.0" atleast_64="10.1.0" type="VERSION"/>');
  END IF;

END display_update_params_xml;

------------------------------- display_parameters_xml ------------------------
-- Display any renamed, obsolete, and special parameters.

PROCEDURE display_parameters_xml
IS

BEGIN

  display_line('<InitParams>');

  --
  -- Update parameters
  --
  display_line('<Update>');
  IF db_64 THEN
    display_update_params_xml(minvp_db64);
  ELSE
    display_update_params_xml(minvp_db32);
  END IF;
  display_line('</Update>');
  -- End of Update Parameters.


  -- Static tags for Migration and NonHandled go here (XML, only)
  display_line('<Migration>');
--  display_line('<Parameter name="optimizer_mode" value="choose"/>');
  display_line('</Migration>');

  display_line('<NonHandled>');
  display_line('<Parameter name="remote_listener"/>');
  display_line('</NonHandled>');

  -- Renamed Parameters
  display_line('<Rename>');
  FOR i IN 1..max_rp LOOP
     IF rp(i).db_match = TRUE THEN
        display_line(
         '<Parameter oldName="' || rp(i).oldname || 
                  '" newName="' || rp(i).newname || '"/>');
     END IF;
  END LOOP;  

  -- Display parameters that have a new name and a new value
  FOR i IN 1..max_sp LOOP
     IF sp(i).db_match = TRUE AND
        sp(i).newvalue IS NOT NULL THEN
        display_line('<Parameter oldName="' || sp(i).oldname ||
         '" newName="' || sp(i).newname ||
         '" newValue="' || sp(i).newvalue || '"/>');
     END IF;
  END LOOP;

  display_line('</Rename>');

  -- Display Obsolete Parameters to remove
  display_line('<Remove>');
  FOR i IN 1..max_op LOOP
     IF op(i).db_match = TRUE THEN
        display_line('<Parameter name="' ||
         op(i).name || '"/>');
     END IF;
  END LOOP;  
  display_line('</Remove>');
  display_line('</InitParams>');
  --
  -- DBUA does not deal with warning about hidden params, if they did it would
  -- go right here
  --

END display_parameters_xml;


------------------------- display_update_params_text  -----------------------
-- Display init ora parameters for update in text 

PROCEDURE display_update_params_text (minvp        MINVALUE_TABLE_T,
                                      changes_req  IN OUT BOOLEAN)
IS

BEGIN

  -- Display the minimum compatibility static tag
  IF dbv = 920 OR (dbv IN (101,102) AND SUBSTR(db_compat,1,2)!='10') THEN
     display_warning('"compatible" must be set to at least 10.1.0');
     changes_req := TRUE;
  END IF;

  -- parameters with minimum values
  FOR i IN 1..max_minvp LOOP
    IF minvp(i).display THEN
      IF NOT (i = jv_idx and NOT cmp_info(javavm).processed) THEN
       IF NOT (i = mt_idx and minvp(i).oldvalue IS NULL) THEN
        changes_req := TRUE;
        IF minvp(i).oldvalue IS NULL THEN
           -- Convert to M from bytes
           IF i IN (tg_idx,pg_idx,jv_idx,sp_idx) THEN
              display_warning ('"' || minvp(i).name ||
                 '" is not currently defined and needs a value of at least ' ||
                 TO_CHAR(ROUND((minvp(i).newvalue/1024)/1024)) || ' MB');
           ELSE
              display_warning('"' || minvp(i).name ||
                  '" is not currently defined and needs a value of at least '||
                   TO_CHAR(ROUND(minvp(i).newvalue)));
           END IF;
        ELSE
         IF minvp(i).oldvalue < minvp(i).newvalue THEN
            IF i IN (tg_idx,pg_idx,jv_idx,sp_idx,mt_idx) THEN
              display_warning('"'  || minvp(i).name ||
                     '" needs to be increased to at least ' ||
                      TO_CHAR(ROUND((minvp(i).newvalue/1024)/1024)) || ' MB');
              ELSE
                 if (i = cs_idx) then
                   tmp_varchar1 := ' bytes';
                 else
                   tmp_varchar1 := ' ';
                 end if;
                 display_warning('"' || minvp(i).name ||
                         '" needs to be increased to at least ' ||
                         TO_CHAR(ROUND(minvp(i).newvalue)) || tmp_varchar1);
              END IF;
            ELSE
              -- Convert to M from bytes
              IF i IN (tg_idx,pg_idx,jv_idx,sp_idx,mt_idx) THEN 
                 display_line(
                    '--> "'||minvp(i).name || '" is already at ' ||
                    TO_CHAR(ROUND((minvp(i).oldvalue/1024)/1024)) ||
                    '; calculated minimum value is ' ||
                    TO_CHAR(ROUND((minvp(i).newvalue/1024)/1024)) || ' MB');
              ELSE
                 display_line(
                     '--> "'||minvp(i).name || '" is already at ' ||
                    TO_CHAR(ROUND(minvp(i).oldvalue)) ||
                    '; calculated minimum value is ' ||
                    TO_CHAR(ROUND(minvp(i).newvalue)));
              END IF;
           END IF;
        END IF; -- null oldvalue
       END IF; -- not (mt_idx and mt null oldvalue)
      END IF; -- not (jv_idx and not processed)
    END IF; -- display
  END LOOP;

  -- Required values if missing
  FOR i IN 1..max_reqp LOOP
     IF reqp(i).db_match = TRUE THEN
        changes_req := TRUE;
        IF reqp(i).type = 3 THEN
           display_warning('"' ||
            reqp(i).name || '" is not defined and must have a value=' ||
            TO_CHAR(ROUND(reqp(i).newnumbervalue)));
        ELSIF reqp(i).type = 2 THEN
           display_warning('"' ||
            reqp(i).name || '" is not defined and must have a value=' ||
            reqp(i).newstringvalue);
        END IF;
     END IF;
  END LOOP;

  IF  NOT changes_req THEN
     display_line(
         '-- No update parameter changes are required.');
  END IF;
  display_line('.');

END display_update_params_text;

------------------------------- display_parameters_text -----------------------
-- Display any renamed, obsolete, and special parameters.

PROCEDURE display_parameters_text
IS

  changes_req BOOLEAN := FALSE;
  do  VARCHAR2(15);     -- Used for temp output value

BEGIN

  -- banner for 'Update Parameters:'
  display_banner;
  display_line(
    'Update Parameters: [Update Oracle Database 11.2 init.ora or spfile]');
  IF (db_64) THEN
    display_line(
      'Note: Pre-upgrade tool was run on a lower version 64-bit database.');
  ELSE
    display_line(
      'Note: Pre-upgrade tool was run on a lower version 32-bit database.');
  END IF;
  display_banner;

  -- update parameter values for 32-bit db
  changes_req := FALSE;
  display_line('--> If Target Oracle is 32-Bit, refer here for Update Parameters:');
  display_update_params_text(minvp_db32, changes_req);

  -- update parameter values for 64-bit db
  changes_req := FALSE;
  display_line('');
  display_line('--> If Target Oracle is 64-Bit, refer here for Update Parameters:');
  display_update_params_text(minvp_db64, changes_req);


  -- banner for 'Renamed Parameters:'
  display_banner;
  display_line(
  'Renamed Parameters: [Update Oracle Database 11.2 init.ora or spfile]');
  display_banner;
  changes_req := FALSE;

  -- renamed parameters
  FOR i IN 1..max_rp LOOP
     IF rp(i).db_match = TRUE THEN
        changes_req := TRUE;
        display_warning('"' || rp(i).oldname ||
         '" new name is "' || rp(i).newname || '"');
     END IF;
  END LOOP;

  -- renamed parameters with new values
  FOR i IN 1..max_sp LOOP
     IF sp(i).db_match = TRUE THEN
        changes_req := TRUE;
        IF sp(i).oldvalue IS NULL THEN
           display_warning('"' || sp(i).oldname ||
             '" new name is "' || sp(i).newname ||
             '" new value is "' || sp(i).newvalue || '"');
        ELSE
           display_warning('"' || sp(i).oldname ||
             '" old value was "' || sp(i).oldvalue || '";');
           display_line('.        --> new name is "' || 
             sp(i).newname || '", new value is "' || sp(i).newvalue || '"');
        END IF;
     END IF;
  END LOOP;

  IF  NOT changes_req THEN
     display_line(
     '-- No renamed parameters found. No changes are required.');
  END IF;
  display_line('.');

  display_banner;
  display_line(
   'Obsolete/Deprecated Parameters: [Update Oracle Database 11.2 init.ora or spfile]');
  display_banner;
  changes_req := FALSE;

  -- obsolete (removed) parameters
  FOR i IN 1..max_op LOOP
     IF op(i).db_match = TRUE THEN
        changes_req := TRUE;
        IF op(i).deprecated = TRUE THEN
          do := 'DEPRECATED';
        ELSE
          do := 'OBSOLETE';
        END IF;
        IF op(i).name NOT IN ('background_dump_dest','user_dump_dest') THEN
          display_line(
          '--> ' || rpad(op(i).name, 28) || ' ' ||
                    rpad(op(i).version, 10) || ' ' ||
                    rpad(do, 12));
        ELSE
           -- bdump, udump deprecated by diagnostic_dest
           -- If core_dump_dest gets back onto this list, it goes here (and above)
          display_line(
          '--> ' || rpad(op(i).name, 28) || ' ' ||
                    rpad(op(i).version, 10) || ' ' ||
                    rpad(do, 12) || 
                    ' replaced by  "diagnostic_dest"');
        END IF;
     END IF;
  END LOOP;  
  IF NOT changes_req THEN
     display_line(
     '-- No obsolete parameters found. No changes are required');
  END IF;

  display_line('.');


END display_parameters_text;

--
-- Display Recommendation for xml
--
PROCEDURE display_recommendations_xml
IS
BEGIN

   display_line('<warning name="GATHER_STATS"/>');

   IF hidden_params_in_use THEN
     display_line('<warning name="HIDDEN_PARAMS"/>');
   END IF;

   IF non_default_events THEN
     display_line('<warning name="NON_DEFAULT_EVENTS"/>');
   END IF;

   IF dmsys_recommendation THEN
     display_line('<warning name="REMOVE_DMSYS"/>');
   END IF;

END display_recommendations_xml;

--
-- Display Recommendation for text
--
PROCEDURE display_recommendations
IS
BEGIN

   display_banner;
   display_line('Recommendations');

   --
   -- Stale Stats - we don't check any more, but dump out the info on how to 
   --               update them
   --
   display_banner;
   display_line('Oracle recommends gathering dictionary statistics prior to');
   display_line('upgrading the database.');
   IF dbv = 920 THEN
     display_line('To gather dictionary statistics execute the following commands');
     display_line('while connected as SYSDBA:');
     OPEN tmp_cursor FOR 
          'SELECT name FROM sys.user$ WHERE name IN 
               (''SYS'', ''SYSTEM'', ''WMSYS'',''MDSYS'',''CTXSYS'',''XDB'',''WKSYS'',''LBACSYS'',''ORDSYS'',
                ''ORDPLUGINS'',''SI_INFORMATION_SCHEMA'', ''OUTLN'', ''DBSNMP'')';
     LOOP 
       FETCH tmp_cursor INTO tmp_varchar1;
       EXIT when tmp_cursor%NOTFOUND;
       display_line ('    EXECUTE dbms_stats.gather_schema_stats(''' || tmp_varchar1 || 
                            ''',options=>''GATHER''');
       display_line ('             ,estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE');
       display_line ('             ,method_opt=>''FOR ALL COLUMNS SIZE AUTO''');
       display_line ('             ,cascade=>TRUE);');
     END LOOP;
     CLOSE tmp_cursor;
   ELSE
     display_line('To gather dictionary statistics execute the following command');
     display_line('while connected as SYSDBA:');
     display_line('');
     display_line('    EXECUTE dbms_stats.gather_dictionary_stats;');
   END IF;
   display_line('');

   --
   -- If there are no hidden params set, no need to recommend review.
   --
   IF hidden_params_in_use THEN
     display_banner;
     display_line('Oracle recommends removing all hidden parameters prior to upgrading.');
     display_line('');
     display_line('To view existing hidden parameters execute the following command');
     display_line('while connected AS SYSDBA:');
     display_line('');
     display_line('    SELECT name,description from SYS.V$PARAMETER WHERE name');
     display_line('        LIKE ''\_%'' ESCAPE ''\''');
     display_line('');
     display_line('Changes will need to be made in the init.ora or spfile.');
     display_line('');
   END IF; -- end of hidden_params_in_use

   --
   -- Same with events that are set.
   --
   IF non_default_events THEN
     display_banner;
     display_line('Oracle recommends reviewing any defined events prior to upgrading.'); 
     display_line('');
     display_line('To view existing non-default events execute the following commands');
     display_line('while connected AS SYSDBA:');
     display_line('  Events:');
     display_line('    SELECT (translate(value,chr(13)||chr(10),'' '')) FROM sys.v$parameter2');
     display_line('      WHERE  UPPER(name) =''EVENT'' AND  isdefault=''FALSE''');
     display_line('');
     display_line('  Trace Events:');
     display_line('    SELECT (translate(value,chr(13)||chr(10),'' '')) from sys.v$parameter2');
     display_line('      WHERE UPPER(name) = ''_TRACE_EVENTS'' AND isdefault=''FALSE''');
     display_line('');
     display_line('Changes will need to be made in the init.ora or spfile.');
     display_line('');
   END IF; -- end of non_default_events

   IF dmsys_recommendation THEN
     display_banner; 
     display_line('The DMSYS schema exists in the database.  Prior to performing an ');
     display_line('upgrade Oracle recommends that the DMSYS schema, and its associated ');
     display_line('objects be removed from the database.');
     display_line('');
     display_line('Refer to the Oracle Data Mining Administration Guide for the');
     display_line('instructions on how to perform this task.');
     display_line('');
   END IF;

   -- bug 12699712: alert if aud$/fga_log$ will be populated during db upgrade
   -- from 101/102/111
   IF (dbv = 101 or dbv = 102 or dbv = 111) THEN
     IF (aud_upd_rowcnt > 0 or fga_upd_rowcnt > 0) THEN
       display_banner;
       display_line('Oracle recommends examining audit tables AUD$ and FGA_LOG$ before ');
       display_line('upgrading the database.');
       display_line('');
       display_line('This database has ' || aud_upd_rowcnt || ' rows in AUD$ and ' || fga_upd_rowcnt || ' rows in FGA_LOG$ that '); 
        display_line('will be updated during the database upgrade from ' || db_version || '.');
       display_line('');
       display_line('During this upgrade, null DBIDs in AUD$ and FGA_LOG$ will be updated ');
       display_line('with non-null values.');
       display_line('');
       display_line('The upgrade downtime could be affected if there are many rows to update. ');
       display_line('If downtime is a concern, the audit update could be done manually prior ');
       display_line('to upgrading the database. ');
       display_line('');
       display_line('Please refer to My Oracle Support Note 1329590.1 titled "How to ');
       display_line('Pre-Process SYS.AUD$ Records Pre-Upgrade From 10.1 or Later to 11.2".');

       display_line('');
     END IF;
   END IF;

  -- End Recommendations section with a banner.
  display_banner;   



END display_recommendations;



----------------- display_misc_warnings ------------------------------
PROCEDURE display_misc_warnings
IS

BEGIN
  
   IF display_xml THEN
      display_line('<Warnings>');

      IF db_readonly THEN
         display_line('<warning name="DATABASE_READ_ONLY"/>');
      END IF;
   
      IF version_mismatch THEN
          display_line('<warning name="VERSION_MISMATCH"/>');
      END IF;
   
      IF cluster_dbs THEN
          display_line('<warning name="CLUSTER_DATABASE"/>');
      END IF;

      IF dip_user_exists THEN
           display_line('<warning name="DIP_USER_PRESENT"/>');
      END IF;

      IF ocm_user_exists THEN
           display_line('<warning name="OCM_USER_PRESENT"/>');
      END IF;

      IF qos_user_exists THEN
           display_line('<warning name="APPQOSSYS_USER_PRESENT"/>');
      END IF;

      IF nls_al24utffss THEN
          display_line(
            '<warning name="DESUPPORTED_CHARSET_AL24UTFFSS"/>');
      END IF;

      IF utf8_al16utf16 THEN
          display_line(
            '<warning name="NCHAR_TYPE_NOT_SUPP"/>');
      END IF;

      IF owm_replication THEN
          display_line('<warning name="WMSYS_REPLICATION_PRESENT"/>');
      END IF;

      IF dblinks  THEN
          display_line('<warning name="DBLINKS_WITH_PASSWORDS"/>');
      END IF;

      IF cdc_data THEN
          display_line('<warning name="CDC_CHANGE_SOURCE"/>');
      END IF;

      IF connect_role THEN
          display_line('<warning name="CONNECT_ROLE_IN_USE"/>');
      END IF;

      IF invalid_objs THEN
          display_line('<warning name="INVALID_OBJECTS_EXIST"/>');
      END IF;

      IF ssl_users THEN
          display_line('<warning name="SSL_USERS_EXIST"/>');
      END IF;

      IF timezone_old THEN
          display_line('<warning name="OLD_TIME_ZONES_EXIST"/>');
      ELSIF timezone_new THEN
          display_line('<warning name="NEW_TIME_ZONES_EXIST"/>');
      END IF;

      IF em_exists THEN
          display_line('<warning name="EM_PRESENT"/>');
      END IF;

      IF snapshot_refresh THEN -- TRUE when outstanding snapshot refreshes
          display_line('<warning name="REFRESHES_EXIST"/>');
      END IF;

      IF recovery_files THEN -- TRUE when files need media recovery
          display_line('<warning name="FILES_NEED_RECOVERY"/>');
      END IF;

      IF files_backup_mode THEN -- TRUE when files are in backup mode
          display_line('<warning name="FILES_BACKUP_MODE"/>');
      END IF;

      IF pending_2pc_txn THEN  -- TRUE when pending distribution txns
          display_line('<warning name="2PC_TXN_EXIST"/>');
      END IF;

      IF sync_standby_db THEN  -- TRUE when need to sync the standby db
          display_line('<warning name="SYNC_STANDBY_DB"/>');
      END IF;

      IF ultrasearch_data THEN  -- TRUE when "used" ultrasearch is detected
          display_line('<warning name="ULTRASEARCH_DATA"/>');
      END IF;

      IF remote_redo_issue THEN  -- TRUE when remote redo doesn't pass checks
          display_line('<warning name="REMOTE_REDO"/>');
      END IF;

      IF sys_ts_default != 'SYSTEM' OR system_ts_default != 'SYSTEM' THEN 
          display_line('<warning name="SYS_DEFAULT_TABLESPACE"/>');
      END IF;

      if laf_format THEN
          display_line('<warning name="INVALID_LOG_ARCHIVE_FORMAT"/>');
      END IF;

      if imageidx_used THEN
          display_line('<warning name="ORSYS.ORDIMAGEINDEX used"/>');
      END IF;

      if NOT (dbv=920) AND (recycle_objects > 0) THEN
          display_line('<warning name="PURGE_RECYCLEBIN"/>');
      END IF;

      IF enabled_indexes_tbl THEN
          display_line('<warning name="ENABLED_INDEXES_TBL"/>');
      END IF;

      IF dbms_ldap_dep THEN
          display_line('<warning name="DBMS_LDAP_DEPENDENCIES_EXIST"/>');
      END IF;

      IF timed_statistics_mbt THEN
          display_line('<warning name="TIMED_STATISTICS_MUST_BE_TRUE"/>');
      END IF;

      --
      -- This is a recommendation in the 'i' version.
      -- 
      display_recommendations_xml;


      display_line('</Warnings>');

   ELSE
      IF version_mismatch or cluster_dbs OR dip_user_exists OR 
         nls_al24utffss OR ssl_users OR timezone_old OR timezone_new OR
         utf8_al16utf16 OR owm_replication OR dblinks OR connect_role OR 
         invalid_objs OR cdc_data OR ocm_user_exists OR 
         em_exists OR remote_redo_issue OR laf_format OR
         enabled_indexes_tbl OR dbms_ldap_dep OR edition_exists
      THEN
            display_banner;
            display_line('Miscellaneous Warnings');
            display_banner;
      ELSE
         RETURN;
      END IF;

      IF version_mismatch THEN
         display_warning('The database has not been patched to release ' ||
             db_version || '.');
         display_line('... Run catpatch.sql prior to upgrading.');
      END IF;

      IF cluster_dbs THEN
         display_warning('The "cluster_database" parameter is currently "TRUE"');
        display_line('.... and must be set to "FALSE" prior to running a manual upgrade.');
      END IF;

      IF dip_user_exists THEN
         display_warning('"DIP" user found in database.');
         display_line(
             '.... This is a generic account used for '||
             'connecting to ');
         display_line(
            '.... the Database when processing DIP ' ||
             'callback functions.');
         display_line(
             '.... Oracle may add additional privileges to this account '||
             'during the upgrade.');
      END IF;

      IF ocm_user_exists THEN
         display_warning('"ORACLE_OCM" user found in database.');
         display_line(
             '.... This is an internal account used by the '||
             'Oracle Configuration Manger. ');
         display_line(
             '.... Oracle recommends dropping this user prior to '||
             'upgrading.');
      END IF;

     IF qos_user_exists THEN
         display_warning('"APPQOSSYS" user found in database.');
         display_line(
             '.... This is an internal account used by Oracle Application Quality');
         display_line(
             '.... of Service Management.');
         display_line(
             '.... Oracle recommends dropping this user prior to upgrading.');
      END IF;

      IF nls_al24utffss THEN
         display_warning('"nls_characterset" has ' ||
               ' "AL24UTFFSS" character set.');
         display_line(
             ' * The database must be converted to a supported character ' ||
             'set prior to upgrading.');
      END IF;

      IF utf8_al16utf16 THEN
         display_warning('Your database is using an ' ||
                     'obsolete NCHAR character set.');
         display_line(
             'The NCHAR data types (NCHAR, NVARCHAR2, and NCLOB)');
         display_line('are limited to the Unicode character ' ||
              'set encoding UTF8 and AL16UTF16.'); 
      END IF;

      IF owm_replication THEN
         display_warning('Workspace Manager replication is in use.');
         display_line(
           '.... Drop OWM replication support before upgrading:');
         display_line(
           '.... EXECUTE dbms_wm.DropReplicationSupport;');
      END IF;

      IF dblinks  THEN
         display_warning('Passwords exist in some database links.');
         display_line(
           '.... Passwords will be encrypted during the upgrade.');
         display_line(
          '.... Downgrade of database links with passwords is not supported.');
      END IF;

      IF cdc_data THEN
         display_warning('CDC change sources exist; for full 11.2 support, alter ');
         display_line(
           '.... the change source on the staging database after the upgrade.');
      END IF;

      IF connect_role THEN
         display_warning('Deprecated CONNECT role granted to some user/roles.');
         display_line(
           '.... CONNECT role after upgrade has only CREATE SESSION privilege.');
      END IF;

      -- bug 7193417: support time zone change in 11.2
      IF timezone_old or timezone_new THEN
        IF timezone_old THEN
          display_warning('Database is using a timezone file older than version ' || utlu_tz_version || '.');
          display_line(
            '.... After the release migration, it is recommended that DBMS_DST package');
          display_line(
            '.... be used to upgrade the ' || db_version || ' database timezone version');
          display_line(
            '.... to the latest version which comes with the new release.');
        ELSIF timezone_new THEN
          display_warning('Database is using a timezone file greater than version ' || utlu_tz_version || '.');
          display_line(
            '.... BEFORE upgrading the database, patch the 11gR2');
          display_line(
            '.... $ORACLE_HOME/oracore/zoneinfo/ with a timezone data file of the');
          display_line(
            '.... same version as the one used in the ' || db_version || ' release database.');
        END IF;
      END IF;

      IF enabled_indexes_tbl THEN
         display_warning('Table sys.enabled$indexes exists in the database.');
         display_line(
           '.... DROP TABLE sys.enabled$indexes prior to upgrading the database.' );
      END IF;

      IF invalid_objs THEN
         display_warning('Database contains INVALID objects prior to upgrade.');
         display_line( 
           '.... The list of invalid SYS/SYSTEM objects was written to');
         display_line(
           '.... registry$sys_inv_objs.');
         IF warning_5000 THEN
            display_line(
             '.... Because there were more than 5000 invalid non-SYS/SYSTEM objects');
            display_line(
             '.... the list was not stored in registry$nonsys_inv_objs.');
         ELSE
           display_line(
            '.... The list of non-SYS/SYSTEM objects was written to');
           display_line(
            '.... registry$nonsys_inv_objs.');
         END IF;
         display_line(
          '.... Use utluiobj.sql after the upgrade to identify any new invalid');
          display_line('.... objects due to the upgrade.');
         -- For upgrades that are not 'inplace' keep it simple.
         IF NOT inplace THEN

            OPEN tmp_cursor FOR 
               'SELECT owner, count(*) FROM SYS.DBA_OBJECTS
                WHERE status = ''INVALID'' AND object_name NOT LIKE ''BIN$%'' 
                GROUP BY owner';
            LOOP
              FETCH tmp_cursor INTO tmp_varchar1, tmp_num1;
              EXIT WHEN tmp_cursor%NOTFOUND;
              display_line('.... USER ' || tmp_varchar1  || ' has ' || tmp_num1  || 
                    ' INVALID objects.');
            END LOOP;
            CLOSE tmp_cursor;
         ELSE
            -- For inplace upgrades, ignore objects that may be invalid
            -- due to their dependencies on other objects that may have changed
            -- Bug 4905742
            -- V_$ROLLNAME special cased because of refernces to x$ tables
            -- lrg 4944010: add GV$SQLAREA_PLAN_HASH and GV$ARCHIVE_GAP
            OPEN tmp_cursor FOR 
                'SELECT owner, count(*) FROM SYS.DBA_OBJECTS
                WHERE status = ''INVALID'' AND object_name NOT LIKE ''BIN$%'' AND 
                   object_name NOT IN 
                      (SELECT name FROM SYS.dba_dependencies
                         START WITH referenced_name IN ( 
                              ''V$LOGMNR_SESSION'', ''V$ACTIVE_SESSION_HISTORY'',
                              ''V$BUFFERED_SUBSCRIBERS'',  ''GV$FLASH_RECOVERY_AREA_USAGE'',
                              ''GV$ACTIVE_SESSION_HISTORY'', ''GV$BUFFERED_SUBSCRIBERS'',
                              ''V$RSRC_PLAN'', ''V$SUBSCR_REGISTRATION_STATS'',
                              ''GV$STREAMS_APPLY_READER'',''GV$ARCHIVE_DEST'',
                              ''GV$LOCK'',''DBMS_STATS_INTERNAL'',''V$STREAMS_MESSAGE_TRACKING'',
                              ''GV$SQL_SHARED_CURSOR'',''V$RMAN_COMPRESSION_ALGORITHM'',
                              ''V$RSRC_CONS_GROUP_HISTORY'',''V$PERSISTENT_SUBSCRIBERS'',''V$RMAN_STATUS'',
                              ''GV$RSRC_CONSUMER_GROUP'',''V$ARCHIVE_DEST'',''GV$RSRCMGRMETRIC'',
                              ''GV$RSRCMGRMETRIC_HISTORY'',''V$PERSISTENT_QUEUES'',''GV$CPOOL_CONN_INFO'',
                              ''GV$RMAN_COMPRESSION_ALGORITHM'',''DBA_BLOCKERS'',''V$STREAMS_TRANSACTION'',
                              ''V$STREAMS_APPLY_READER'',''GV$SGA_DYNAMIC_FREE_MEMORY'',''GV$BUFFERED_QUEUES'',
                              ''GV$RSRC_PLAN_HISTORY'',''GV$ENCRYPTED_TABLESPACES'',''V$ENCRYPTED_TABLESPACES'',
                              ''GV$RSRC_CONS_GROUP_HISTORY'',''GV$RSRC_PLAN'',
                              ''GV$RSRC_SESSION_INFO'',''V$RSRCMGRMETRIC'',''V$STREAMS_CAPTURE'',
                              ''V$RSRCMGRMETRIC_HISTORY'',''GV$STREAMS_TRANSACTION'',''DBMS_LOGREP_UTIL'',
                              ''V$RSRC_SESSION_INFO'',''GV$STREAMS_CAPTURE'',''V$RSRC_PLAN_HISTORY'',
                              ''GV$FLASHBACK_DATABASE_LOGFILE'',''V$BUFFERED_QUEUES'',
                              ''GV$PERSISTENT_SUBSCRIBERS'',''GV$FILESTAT'',''GV$STREAMS_MESSAGE_TRACKING'',
                              ''V$RSRC_CONSUMER_GROUP'',''V$CPOOL_CONN_INFO'',''DBA_DML_LOCKS'',
                              ''V$FLASHBACK_DATABASE_LOGFILE'',''GV$HM_RECOMMENDATION'',
                              ''V$SQL_SHARED_CURSOR'',''GV$PERSISTENT_QUEUES'',''GV$FILE_HISTOGRAM'',
                              ''DBA_WAITERS'',''GV$SUBSCR_REGISTRATION_STATS'',
                              ''GV$SQLAREA_PLAN_HASH'',''GV$ARCHIVE_GAP'',
                              ''V$STREAMS_APPLY_SERVER'',''DBA_DDL_LOCKS'',
                              ''DBA_LOCK_INTERNAL'', ''V_$STREAMS_APPLY_SERVER'',
                              ''DBA_KGLLOCK'',''GV$LOGSTDBY_TRANSACTION'',
                              ''GV_$DATAFILE'', ''GV_$STREAMS_APPLY_SERVER'',
                              ''GV$STREAMS_APPLY_SERVER'', ''GV$DATAFILE'',
                              ''GV_$LOGSTDBY_TRANSACTION'',
                              ''GV$SYSTEM_EVENT'', ''V$SQL_MONITOR'',
                              ''GV$WLM_PCMETRIC'',''V$WLM_PCMETRIC'',
			      ''V$DB_OBJECT_CACHE'',''GV$LOGMNR_REGION'',
			      ''GV$ASM_DISK_STAT'',''GV$WLM_PCMETRIC_HISTORY'',
 			      ''V$WLM_PCMETRIC_HISTORY'',''V$DNFS_CHANNELS'',
			      ''V$HANG_INFO'',''GV$DNFS_STATS'',
                              ''GV$SESSION_CONNECT_INFO'',''GV$SQL_MONITOR'',
                              ''GV$ASM_OPERATION'',''V$DNFS_STATS'',
                              ''GV$DB_OBJECT_CACHE'',''GV$ARCHIVE_PROCESSES'',
                              ''GV$RESULT_CACHE_OBJECTS'',
''V$ARCHIVE_PROCESSES'',				      ''GV$ASM_DISK'',''V$LOGMNR_REGION'',
''V$RESULT_CACHE_OBJECTS'', ''GV$ROWCACHE'',''V$ROWCACHE'',''GV$PROCESS_MEMORY_DETAIL'',''V$PROCESS_MEMORY_DETAIL'',''GV$DLM_MISC'',''V$DLM_MISC'',''V$DELETED_OBJECT'',''GV$DELETED_OBJECT'',''GV$STREAMS_APPLY_COORDINATOR'',''V$STREAMS_APPLY_COORDINATOR'')
                                     AND referenced_type in (''VIEW'',''PACKAGE'') OR
                               name = ''V_$ROLLNAME''
                                  CONNECT BY
                                    PRIOR name = referenced_name and
                                    PRIOR type = referenced_type)
                 GROUP by owner';
            LOOP
              FETCH tmp_cursor INTO tmp_varchar1, tmp_num1;
              EXIT WHEN tmp_cursor%NOTFOUND;
              display_line('.... USER ' || tmp_varchar1  || ' has ' || tmp_num1  || 
                    ' INVALID objects.');
            END LOOP;
            CLOSE tmp_cursor;
         END IF;
      END IF;

      IF ssl_users THEN
         display_warning('Database contains globally authenticated users.');
         display_line(
           '.... Refer to the Upgrade Guide to upgrade SSL users.');
      END IF;

      IF em_exists  THEN
         display_warning('EM Database Control Repository exists in the database.');
         display_line(
           '.... Direct downgrade of EM Database Control is not supported. Refer to the');
         display_line(
           '.... Upgrade Guide for instructions to save the EM data prior to upgrade.');
      END IF;

      IF snapshot_refresh THEN -- TRUE when outstanding snapshot refreshes
         display_warning('There are materialized view refreshes in progress.');
         display_line('.... Ensure all materialized view refreshes are complete prior to upgrade.');
      END IF;

      IF recovery_files THEN -- TRUE when files need media recovery
         display_warning('There are files which need media recovery.');
         display_line('.... Ensure no files need media recovery prior to upgrade.');
      END IF;

      IF files_backup_mode THEN -- TRUE when files are in backup mode
         display_warning('There are files in backup mode.');
         display_line('.... Ensure no files are in backup mode prior to upgrade.');
      END IF;

      IF pending_2pc_txn THEN  -- TRUE when pending distribution txns
         display_warning('There are outstanding unresolved distributed transactions.');
         display_line('.... Resolve outstanding distributed transactions prior to upgrade.');
      END IF;

      IF sync_standby_db THEN  -- TRUE when need to sync the standby db
         display_warning('Sync standby database prior to upgrade.');
      END IF;

      IF ultrasearch_data  THEN  -- TRUE when "used" Ultra Search detected
         display_warning('Ultra Search is not supported in 11.2 and must be removed');
         display_line('.... prior to upgrading by running rdbms/admin/wkremov.sql.');
         display_line('.... If you need to preserve Ultra Search data');
         display_line('.... please perform a manual cold backup prior to upgrade.');
      END IF;

      IF remote_redo_issue THEN  -- TRUE when remote redo doesn't pass checks
         display_warning('REDO Configuration not supported in 11.2');
         display_line('.... Your REDO configuration is defaulting the use of ');
         display_line('...  LOG_ARCHIVE_DEST_10 for local archiving of redo data to');
         display_line('.... the recovery area and has also defined '); 
         display_line('.... LOG_ARCHIVE_DEST_1 for remote use. ');
         display_line('.... In 11.2, only LOG_ARCHIVE_DEST_1 is used for defaulting local');
         display_line('.... archival of redo data.');
         display_line('.... You must specify a destination for local archiving since ');
         display_line('.... LOG_ARCHIVE_DEST_1 is not available.');
      END IF;

      IF sys_ts_default != 'SYSTEM' THEN
         display_warning('SYS schema default tablespace has been altered.');
         display_line('.... The SYS schema default tablespace is currently set to '
                       || sys_ts_default || '.');
         display_line('.... Prior to upgrading your database please reset the ');
         display_line('.... SYS schema default tablespace to SYSTEM  using the command:');        
         display_line('.... ALTER USER SYS DEFAULT TABLESPACE SYSTEM;');
      END IF;

      IF system_ts_default != 'SYSTEM' THEN
         display_warning('SYSTEM schema default tablespace has been altered.');
         display_line('.... The SYSTEM schema default tablespace is currently set to '
                       || system_ts_default || '.');
         display_line('.... Prior to upgrading your database please reset the ');
         display_line('.... SYSTEM schema default tablespace to SYSTEM  using the command:');        
         display_line('.... ALTER USER SYSTEM DEFAULT TABLESPACE SYSTEM;');
      END IF;

      IF laf_format THEN
         display_warning('log_archive_format must be updated.');
         display_line('.... As of 10.1, log_archive_format requires a %r format qualifier');
         display_line('.... be present in its format string.  Your current setting is:');
         display_line('.... log_archive_format='''
                 || laf_format_string || '''.');
         -- Tell them what is going to happen if they don't change it (subtle text diffs between
         -- OFF and ON message)
         IF db_log_mode = 'NOARCHIVELOG' THEN
           display_line('.... Archive Logging is currently OFF, but failure to add the %r to the');
           display_line('.... format string will still prevent the upgraded database from starting up.'); 
         ELSE
           display_line('.... Archive Logging is currently ON, and failure to add the %r to the');
           display_line('.... format string will prevent the upgraded database from starting up.'); 
         END IF;
      END IF;

      IF imageidx_used THEN
         display_warning('ORDSYS.OrdImageIndex in use.');
         display_line('.... The previously deprecated Oracle Multimedia image domain index,');
         display_line('.... ORDSYS.OrdImageIndex, is no longer supported and has been removed in ');
         display_line('.... Oracle Database 11g Release 2 (11.2).');
         display_line('.... Below is the list of affected indexes that will be');
         display_line('.... dropped during the upgrade to 11.2');
         display_line('....');
         OPEN tmp_cursor FOR 
           'SELECT dbai.index_name, dbai.owner FROM SYS.DBA_INDEXES dbai
            WHERE dbai.index_type = ''DOMAIN'' AND 
                  dbai.ityp_name  = ''ORDIMAGEINDEX'' 
            ORDER BY dbai.owner';
         LOOP 
           FETCH tmp_cursor INTO tmp_varchar1, tmp_varchar2;
           EXIT WHEN tmp_cursor%NOTFOUND;
           display_line('.... USER: ' || RPAD(tmp_varchar2, 32) || 
                           ' Index: ' || RPAD(tmp_varchar1,32));
         END LOOP;
         CLOSE tmp_cursor;
         display_line('....');
      END IF;  -- end of imageidx_used

      --
      -- Recycle bin info (only above 9.2)
      --
      IF NOT (dbv=920) THEN
        IF (recycle_objects > 0) THEN
           display_warning('Your recycle bin contains ' || TO_CHAR(recycle_objects) || ' object(s).');
           display_line('.... It is REQUIRED that the recycle bin is empty prior to upgrading');
           display_line('.... your database.  The command:');
           display_line('        PURGE DBA_RECYCLEBIN');
           display_line('.... must be executed immediately prior to executing your upgrade.');
        ELSE 
          -- No objects, if its on, let them know.
          IF (recyclebin_on) THEN
            display_warning('Your recycle bin is turned on and currently contains no objects.');
            display_line('.... Because it is REQUIRED that the recycle bin be empty prior to upgrading');
            display_line('.... and your recycle bin is turned on, you may need to execute the command:');
            display_line('        PURGE DBA_RECYCLEBIN');
            display_line('.... prior to executing your upgrade to confirm the recycle bin is empty.');
          END IF;
        END IF;
      END IF;  -- endof recycle-bin check

      IF dbms_ldap_dep THEN
         display_warning(
           'Database contains schemas with objects dependent on DBMS_LDAP package.');
         display_line(
           '.... Refer to the 11g Upgrade Guide for instructions to configure Network ACLs.');
         OPEN tmp_cursor FOR 
             'SELECT DISTINCT owner FROM DBA_DEPENDENCIES
              WHERE referenced_name IN (''DBMS_LDAP'')
                  AND owner NOT IN (''SYS'',''PUBLIC'',''ORDPLUGINS'')';
         LOOP 
           FETCH tmp_cursor INTO tmp_varchar1;
           EXIT WHEN tmp_cursor%NOTFOUND;
           display_line( '.... USER ' || tmp_varchar1 || ' has dependent objects.');
         END LOOP;
         CLOSE tmp_cursor;
      END IF;

      --
      -- The owner of an editioning view must be editions-enabled.
      -- An existing 11.2.0.1 database could possibly have
      -- non editions-enabled users that have editioning
      -- views in their schema. The dba will need to take action to enable 
      -- editions on the users found to fix this inconsistency in their data
      -- dictionary. There are three ways to remedy this:
      -- 1. drop these editioning views
      -- 2. editions enable the listed schemas 
      -- 3. replace the editioning views with regular views
      --
      -- This check is only required for upgrades from 11.2.0.1 to 11.2.0.2
      --
      IF dbv=112 AND edition_exists  THEN 
         -- user/schema is not edition enabled
         display_warning('Database contains the following editioning views yet');
         display_warning('the corresponding schema is not edition enabled.');
         display_line('....  The upgrade process will not continue unless you');
         display_line('....  drop these views OR re-create these as regular views');
         display_line('....  OR edition enable each owner of the view(s).');
        OPEN tmp_cursor FOR 
	 'SELECT DISTINCT EV.owner,EV.view_name from SYS.DBA_EDITIONING_VIEWS EV
		WHERE EXISTS
		(select 1 from SYS.DBA_USERS WHERE USERNAME=EV.OWNER AND
		 EDITIONS_ENABLED <> ''Y'')';          
         LOOP 
           FETCH tmp_cursor INTO tmp_varchar1, tmp_varchar2;
           EXIT WHEN tmp_cursor%NOTFOUND;
           display_line('.... User: ' || RPAD(tmp_varchar1,32) || 
                            ' View: ' || RPAD(tmp_varchar2,32));         
	 END LOOP;
         CLOSE tmp_cursor;
         display_line('....');
      END IF;  -- end of editions enabled


      -- Bug 12807768: On upgrades from pre-10205 (e.g. 9208, 10105, 10204 but
      -- not 10205) to 112, timed_statistics must be TRUE if statistics_level is
      -- not BASIC.  Else, db will fail to start up in the new oracle home,
      -- throwing the following errors:
      -- ORA-00044: timed_statistics must be TRUE when statistics_level is not
      --            BASIC
      -- ORA-01078: failure in processing system parameters
      --
      IF dbv in (920, 101, 102) THEN
        IF (timed_statistics_mbt = TRUE) THEN  -- TIMED_STATISTICS Must Be True
           display_warning('Initialization parameter timed_statistics is currently set');
           display_line('.... to FALSE while statistics_level is set to a non BASIC value.');
           display_line('.... Must set timed_statistics in initialization parameter file to TRUE');
           display_line('.... prior to executing the database upgrade; else the database may');
           display_line('.... fail to start up in the new Oracle home.');
        END IF;
      END IF;  -- end of timed_statistics_mbt check

      -- if job_queue is set to 0, warn them
      IF job_queue_issue THEN
       display_warning ('JOB_QUEUE_PROCESS value must be updated');
       display_line ('.... Your current setting of "' || job_queue_count || '" is too low.');
       display_line ('');
       display_line ('.... Starting with Oracle Database 11g Release 2 (11.2), setting');
       display_line ('.... JOB_QUEUE_PROCESSES to 0 causes both DBMS_SCHEDULER and');
       display_line ('.... DBMS_JOB jobs to not run. Previously, setting JOB_QUEUE_PROCESSES');
       display_line ('.... to 0 caused DBMS_JOB jobs to not run, but DBMS_SCHEDULER jobs were');
       display_line ('.... unaffected and would still run. This parameter must be updated to');
       display_line ('.... a value greater than ' || to_char(cpu*cpu_threads) || '  (default value is 1000) prior to upgrade.');
       display_line ('.... Not doing so will affect the running of utlrp.sql after the upgrade');
      END IF;

      --
      -- This Warning is ALWAYS the last to go out in this section.
      -- 
      IF db_readonly THEN
        display_warning ('Database is open for READ ONLY.');
        display_line ('   Not all checks are being performed.');
        display_line ('   This Script must be run at least once on the database');
        display_line ('   when it is open for READ WRITE.');
      END IF;
      --
      -- mark the end of the section
      --
      display_line('.');
   END IF;

END display_misc_warnings;


--------------------------- pvalue_to_number --------------------------------
-- This function converts a parameter string to a number. The function takes
-- into account that the parameter string may have a 'K' or 'M' multiplier
-- character.
FUNCTION pvalue_to_number (value_string VARCHAR2) RETURN NUMBER
IS
  ilen NUMBER;
  pvalue_number NUMBER;

BEGIN
    -- How long is the input string?
    ilen := LENGTH ( value_string );

    -- Is there a 'K' or 'M' in last position?
    IF SUBSTR(UPPER(value_string), ilen, 1) = 'K' THEN
         RETURN (1024 * TO_NUMBER (SUBSTR (value_string, 1, ilen-1)));

    ELSIF SUBSTR(UPPER(value_string), ilen, 1) = 'M' THEN
         RETURN (1024 * 1024 * TO_NUMBER (SUBSTR (value_string, 1, ilen-1)));
    END IF;

    -- A multiplier wasn't found. Simply convert this string to a number.
    RETURN (TO_NUMBER (value_string));

END pvalue_to_number;


--------------------------- store_oldval -----------------------------------

PROCEDURE store_oldval (minvp  IN OUT MINVALUE_TABLE_T)
IS
  sps       NUMBER;  -- shared_pool_size
  sps_ovrhd NUMBER;  -- shared_pool_size overheads
BEGIN

   FOR i IN 1..max_minvp LOOP
     IF i = sp_idx and dbv = 920 THEN
        -- This block of code is dealing with shared_pool_size
        EXECUTE IMMEDIATE 'SELECT SUM(bytes) FROM v$sgastat WHERE pool=''shared pool'''
        INTO minvp(sp_idx).oldvalue;

        EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = LOWER(:1)'
        INTO p_value
        USING minvp(i).name;
        sps := pvalue_to_number(p_value);

        -- On a large database, the minimum of 144M may not be enough for shared 
        -- pool size, we have to factor in the number of CPU, the number of session,
        -- and some new added features. So here is the formula:
        -- Recommended minimum share_pool_size = minvp(sp_idx).minvalue + 
        -- (Num_of_CPU * 2MB) +
        -- (Num_of_sessiions * 17408) + 
        -- (10% of the old shared_pool_size for overhead)
        sps_ovrhd := sps * 0.1;

        IF collect_diag THEN
          display_line('DIAG-sps_min: ' || minvp(sp_idx).minvalue);
--          display_line('DIAG-cpu: ' || cpu 
--                    || ', cpu*2097152: ' || cpu * 2097152);
          display_line('DIAG-sesn: ' || sesn || ', sesn*17408: ' 
                                || sesn * 17408);
          display_line('DIAG-sps: ' || sps || 
                                ', sps_ovrhd(10%): ' || sps_ovrhd);
           minvp(sp_idx).minvalue := minvp(sp_idx).minvalue + 
/* avoid CPU dependency in DIAG mode (cpu * 2097152) +  */
                                (sesn * 17408) + 
                                (sps_ovrhd);
        ELSE
           minvp(sp_idx).minvalue := minvp(sp_idx).minvalue + 
                                (cpu * 2097152) + 
                                (sesn * 17408) + 
                                (sps_ovrhd);
        END IF;
     ELSE
        BEGIN
           EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = 
             LOWER(:1)'
           INTO p_value
           USING minvp(i).name;
           minvp(i).oldvalue := pvalue_to_number(p_value);
        EXCEPTION WHEN NO_DATA_FOUND THEN
           minvp(i).oldvalue := NULL;
        END;
     END IF;
   END LOOP;

   -- After getting init ora values:
   -- Parameter streams_pool_size is not available in 92. Set old value to 0.
   IF (dbv = 920) THEN
     minvp(str_idx).oldvalue := 0;
   END IF;
END store_oldval;

--------------------------- find_sga_mem_values -------------------------------
-- This is called when sga_target or memory_target is used.

PROCEDURE find_sga_mem_values (minvp  IN OUT MINVALUE_TABLE_T,
                               dbbit  NUMBER)
IS
  cpucalc   NUMBER;
  extra     NUMBER;
  mtgval    NUMBER;
BEGIN

  -- We're here because sga_target/memory_target is used.
  -- Need to find new values for sga_target.

  -- First, reset min values for pools related to sga_target.

  -- If cpu is < 12, then calculate sga_target using 12 cpus.
  -- If cpu is >= 12, then calculate sga_target using cpu_count.
  -- If cpu is >= 64, then calculate sga_target using 64 cpus.
  -- At this point, we don't have enough data to size for greater than 64 cpus.
  IF (cpu >= 64) THEN
    cpucalc := 64;
  ELSIF (cpu >= 12) THEN
    cpucalc := cpu;
  ELSIF (cpu < 12) THEN
    cpucalc := 12;
  END IF;

  minvp(cs_idx).minvalue := cpucalc*4 * 1024*1024;
  minvp(str_idx).minvalue := 0 * 1024*1024;  -- 0M

  IF dbbit = 32 THEN
    minvp(jv_idx).minvalue := 64 * 1024*1024;
    minvp(sp_idx).minvalue := 180 * 1024*1024;
    minvp(lp_idx).minvalue := (cpucalc*2*2 * .5) * 1024*1024;
    extra := (8 + 32 + 56) * 1024*1024;  -- 96M
  ELSE
    minvp(jv_idx).minvalue := 100 * 1024*1024;
    minvp(sp_idx).minvalue := 280 * 1024*1024;
    minvp(lp_idx).minvalue := (cpucalc*2*2 * .5) * 1024*1024;
    extra := (8*2+32*2+28+20+16) * 1024*1024;  -- 144M
  END IF;

  minvp(tg_idx).minvalue :=
    minvp(cs_idx).minvalue + minvp(jv_idx).minvalue +
    minvp(sp_idx).minvalue + minvp(lp_idx).minvalue +
    minvp(str_idx).minvalue + extra;

  minvp(mt_idx).minvalue :=
    minvp(cs_idx).minvalue + minvp(jv_idx).minvalue +
    minvp(sp_idx).minvalue + minvp(lp_idx).minvalue +
    minvp(str_idx).minvalue + minvp(pg_idx).minvalue + extra;

  -- buffer cache (cs)
  IF minvp(cs_idx).oldvalue > minvp(cs_idx).minvalue THEN
    minvp(cs_idx).diff := minvp(cs_idx).oldvalue - minvp(cs_idx).minvalue;
  END IF;

  -- java pool (jv)
  IF minvp(jv_idx).oldvalue > minvp(jv_idx).minvalue THEN
    minvp(jv_idx).diff := minvp(jv_idx).oldvalue - minvp(jv_idx).minvalue;
  END IF;

  -- shared pool (sp)
  IF minvp(sp_idx).oldvalue > minvp(sp_idx).minvalue THEN
    minvp(sp_idx).diff := minvp(sp_idx).oldvalue - minvp(sp_idx).minvalue;
  END IF;

  -- large pool (lp)
  IF minvp(lp_idx).oldvalue > minvp(lp_idx).minvalue THEN
    minvp(lp_idx).diff := minvp(lp_idx).oldvalue - minvp(lp_idx).minvalue;
  END IF;

  -- streams pool (str)
  IF minvp(str_idx).oldvalue > minvp(str_idx).minvalue THEN
    minvp(str_idx).diff :=
      minvp(str_idx).oldvalue - minvp(str_idx).minvalue;
  END IF;

  -- pga_aggregate_target (pg)
  IF minvp(pg_idx).oldvalue > minvp(pg_idx).minvalue THEN
    minvp(pg_idx).diff :=
      minvp(pg_idx).oldvalue - minvp(pg_idx).minvalue;
  END IF;

  -- calculate sga_target 'newvalue' (new derived minimum) based on
  -- tg_idx.minvalue and user-specified pool sizes
  minvp(tg_idx).newvalue := 
      minvp(tg_idx).minvalue + minvp(cs_idx).diff
      + minvp(jv_idx).diff + minvp(sp_idx).diff
      + minvp(lp_idx).diff + minvp(str_idx).diff;

  -- calculate memory_target 'newvalue' (new derived minimum) based on
  -- mt_idx.minvalue and user-specified pool sizes
  minvp(mt_idx).newvalue :=
    minvp(mt_idx).minvalue + minvp(cs_idx).diff
    + minvp(jv_idx).diff + minvp(sp_idx).diff
    + minvp(lp_idx).diff + minvp(str_idx).diff + minvp(pg_idx).diff;
  IF (minvp(tg_idx).oldvalue != 0) THEN -- SGA_TARGET in use
    -- calculate 'newvalue' (new derived minimum) based on user-set sga_target
    -- and user-set pga_aggregate_target.  also add 12M to this calculation
    -- for memory_target if sga_target is also set.
    mtgval := minvp(tg_idx).oldvalue + minvp(pg_idx).oldvalue + 12*1024*1024;
    -- set 'newvalue' to the larger of the two new derived minimums (see above)
    IF (mtgval > minvp(mt_idx).newvalue) THEN
      minvp(mt_idx).newvalue := mtgval;
    END IF;
  END IF;

  -- Note: Although sga_target and memory_target values are found here, we
  -- don't set DISPLAY in minvp in this procedure.  This setting is done
  -- in find_newval.

END find_sga_mem_values;


PROCEDURE find_newval (minvp  IN OUT MINVALUE_TABLE_T,
                       dbbit  NUMBER)
IS
  extra    NUMBER;
BEGIN

   IF minvp(tg_idx).oldvalue != 0 THEN  -- SGA_TARGET in use
     find_sga_mem_values(minvp, dbbit);

     IF minvp(tg_idx).newvalue > minvp(tg_idx).oldvalue THEN
       minvp(tg_idx).display := TRUE;
     END IF;

     -- do not set display to TRUE for these params: sga_target,
     -- memory_target, db_cache_size, java_pool_size,
     -- shared_pool_size, large_pool_size, and streams_pool_size
     FOR i IN 1..max_minvp LOOP
       IF i NOT IN (tg_idx,mt_idx,cs_idx,jv_idx,sp_idx,lp_idx,str_idx) AND 
         (minvp(i).oldvalue IS NULL OR
          minvp(i).oldvalue < minvp(i).minvalue) THEN  
          minvp(i).display := TRUE;
          minvp(i).newvalue := minvp(i).minvalue;
       END IF;
     END LOOP;
   ELSE -- pool sizes included 
     FOR i IN 1..max_minvp LOOP
       -- don't print recommendations for sga_target, memory_target,
       -- large_pool_size, and streams_pool_size
       IF i NOT IN (tg_idx,mt_idx,lp_idx,str_idx) AND 
          (minvp(i).oldvalue IS NULL OR
           minvp(i).oldvalue < minvp(i).minvalue) THEN  
           minvp(i).display := TRUE;
           minvp(i).newvalue := minvp(i).minvalue;
        END IF;
      END LOOP;
   END IF;

   -- For 11.1 and 11.2 check if MEMORY_TARGET is set and NON-ZERO 
   -- then check that MEMORY_TARGET is at least 12M greater than 
   -- sga_target + pga_target (for cases where SGA_TARGET is in use)
   IF dbv IN (111,112) AND memory_target AND (minvp(mt_idx).oldvalue != 0) THEN 
     find_sga_mem_values(minvp, dbbit);

     -- If the newvalue is greater than the old value set the display TRUE
     IF minvp(mt_idx).newvalue > minvp(mt_idx).oldvalue THEN
       minvp(mt_idx).display := TRUE;
       -- Loop through other pool sizes to ignore warnings
       -- If displaying MEMORY_TARGET warning then the other 
       -- pool sizes do not need warnings
     END IF;

     -- If a minimum value is required for MEMORY_TARGET then
     -- do not output a minimum value for sga_target or pga_aggregate
     -- or shared_pool_size or java_pool_size or db_cache_size or
     -- large_pool_size or streams_pool_size as these values
     -- are no longer considered once MEMORY_TARGET value is set.
     -- i.e., for params listed above, set display to FALSE if memory_target
     -- is set.
     FOR i IN 1..max_minvp LOOP
       IF i IN (tg_idx,pg_idx,sp_idx,jv_idx,cs_idx,lp_idx,str_idx) AND minvp(i).display THEN
         minvp(i).display := FALSE;
       END IF;
     END LOOP;     
   END IF; -- 11.1/11.2 db and memory_target in use

END find_newval;

-- *****************************************************************
-- --------------------- MAIN PROGRAM ------------------------------
-- *****************************************************************
 
BEGIN

    -- Increase SERVEROUTPUT limit.
  DBMS_OUTPUT.ENABLE(900000);

   -- Check for SYSDBA
  SELECT USER INTO p_user FROM SYS.DUAL;
  IF p_user != 'SYS' THEN
     EXECUTE IMMEDIATE 'BEGIN 
         RAISE_APPLICATION_ERROR (-20000,
          ''This script must be run AS SYSDBA''); END;';
  END IF;

-- *****************************************************************
-- Collect Database Information - from fixed views only!
-- *****************************************************************
   EXECUTE IMMEDIATE 'SELECT name FROM v$database' INTO db_name;
   EXECUTE IMMEDIATE 'SELECT version FROM v$instance' INTO db_version;
   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''compatible'''
       INTO db_compat;
   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''db_block_size'''
       INTO db_block_size;
   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''undo_management'''
       INTO db_undo;
   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''undo_tablespace'''
       INTO db_undo_tbs;
   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''use_indirect_data_buffers'''
       INTO db_vlm;

   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''cpu_count'''
   INTO p_value;
   cpu := pvalue_to_number(p_value);

   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''parallel_threads_per_cpu'''
   INTO p_value;
   cpu_threads := pvalue_to_number(p_value);

   EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''sessions'''
   INTO p_value;
   sesn := pvalue_to_number(p_value);

   -- get platform information 
   BEGIN
      EXECUTE IMMEDIATE 'SELECT platform_id, platform_name
             FROM v$database'
      INTO db_platform_id, db_platform_name;
      IF db_platform_id NOT IN (1,7,10,15,16,17) THEN
         db_64 := TRUE; -- NOT 32 (solaris, windows, linux, vms, mac, sol x86)
      END IF;
   EXCEPTION                  -- check banner for 9.2
      WHEN OTHERS THEN 
         BEGIN
            SELECT NULL INTO p_null FROM v$version 
            WHERE INSTR(banner,'64') > 0 AND
                  INSTR(UPPER(banner),'ORACLE') > 0 AND
                  ROWNUM = 1;
            db_64 := TRUE;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;  -- no 64 bit banner
         END;
   END;

  -- Set if we are open or open readonly

   EXECUTE IMMEDIATE 'SELECT open_mode FROM v$database' INTO tmp_varchar1;
   IF SUBSTR(tmp_varchar1,1,9) = 'READ ONLY' THEN
     db_readonly := TRUE;
   ELSE
     db_readonly := FALSE;
   END IF;

  -- determine if memory_target value is set
   BEGIN
     EXECUTE IMMEDIATE 'SELECT NULL FROM v$parameter WHERE name=''memory_target'''
        INTO p_null;
         memory_target := TRUE;
   EXCEPTION               
     WHEN NO_DATA_FOUND THEN NULL;  -- memory_target value not set
   END;

   -- get time zone region version used by server
   BEGIN
      EXECUTE IMMEDIATE 'SELECT version from v$timezone_file'
      INTO db_tz_version;
   EXCEPTION
      -- no time zone version view in 9.2 (no v$timezone_file)
      -- determine time zone version based on UTLTZVER.SQL
      WHEN OTHERS THEN
       -- Initialize db_tz_version to '' (not 0) as we don't want a record with
       -- a numerical value for tz_version to be inserted into
       -- registry$database if db_tz_version is not found.  This tz_version
       -- value and count(*) of registry$database being non-zero are critical
       -- to the time zone check in catupstr.sql.
       -- NOTE: If db_tz_version for 92 is not found, we don't want catupstr.sql
       -- to error out in the time zone check.
       db_tz_version := '';

       -- checking if V7 (or higher) is used in 9i
       EXECUTE IMMEDIATE 
         'SELECT CASE
            TO_NUMBER(TO_CHAR(
              TO_TIMESTAMP_TZ(''20080405 23:00:00 Australia/Victoria'',
                              ''YYYYMMDD HH24:MI:SS TZR'') +
              to_dsinterval(''0 08:00:00''),''HH24''))
          WHEN 7 THEN 6
          WHEN 6 THEN 7 END
          FROM SYS.DUAL'
       INTO db_tz_version;

       -- checking if V6 is used in 9i
       IF db_tz_version = 6
       THEN 
         EXECUTE IMMEDIATE
           'SELECT CASE
              TO_NUMBER(TO_CHAR(
                TO_TIMESTAMP_TZ(''20070929 23:00:00 NZ'',
                                ''YYYYMMDD HH24:MI:SS TZR'') +
                to_dsinterval(''0 08:00:00''),''HH24''))
           WHEN 7 THEN 5
           WHEN 8 THEN 6 END
           FROM SYS.DUAL'
         INTO db_tz_version;
       END IF;

       -- checking if V5 is used in 9i
       IF db_tz_version = 5
       THEN 
         EXECUTE IMMEDIATE
           'SELECT CASE
              TO_NUMBER(TO_CHAR(
                TO_TIMESTAMP_TZ(''20070310 23:00:00 CUBA'',
                                ''YYYYMMDD HH24:MI:SS TZR'') +
                to_dsinterval(''0 08:00:00''),''HH24''))
           WHEN 7 THEN 4
           WHEN 8 THEN 5 END
           FROM SYS.DUAL'
         INTO db_tz_version;
       END IF;
 
       -- checking if V4 or lower is used in 9i
       IF db_tz_version = 4
       THEN
          EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                     FROM v$timezone_names'
                     INTO tznames_dist, tznames_count;
          db_tz_version := 
          CASE 
            WHEN tznames_dist in (183, 355, 347)               THEN 1
            WHEN tznames_dist = 377                            THEN 2
            WHEN (tznames_dist = 186 and tznames_count = 636)  THEN 2
            WHEN (tznames_dist = 186 and tznames_count = 626)  THEN 3
            WHEN tznames_dist in (185, 386)                    THEN 3
            WHEN (tznames_dist = 387 and tznames_count = 1438) THEN 3
            WHEN (tznames_dist = 391 and tznames_count = 1457) THEN 4
            WHEN (tznames_dist = 188 and tznames_count = 637)  THEN 4
          END;
       END IF;

       -- checking if V8 is used or DSTv14 small file
       -- no DST rules changed, only tz's added
       IF db_tz_version = 7
       THEN
         EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                             FROM v$timezone_names' 
                             INTO tznames_dist, tznames_count;         
         db_tz_version :=
         CASE
           WHEN (tznames_dist = 519 and tznames_count = 1858) THEN 7
           WHEN (tznames_dist = 188 and tznames_count =  637) THEN 7
           WHEN (tznames_dist = 199 and tznames_count =  755) THEN 14 
           WHEN (tznames_dist = 197 and tznames_count =  676) THEN '' -- UNKNOWN
           WHEN (tznames_dist > 519 and tznames_count > 1858) THEN 8
         END;
       END IF;
       -- checking if V9 is used
       IF db_tz_version = 8
       THEN
         EXECUTE IMMEDIATE
           'SELECT CASE
              TO_NUMBER(TO_CHAR(
                TO_TIMESTAMP_TZ(''20080531 23:00:00 Africa/Casablanca'',
                                ''YYYYMMDD HH24:MI:SS TZR'') +
                to_dsinterval(''0 08:00:00''),''HH24''))
            WHEN 8 THEN 9
            WHEN 7 THEN 7 END
            FROM SYS.DUAL'
            INTO db_tz_version;
       END IF;

       -- checking if V10, V11, V13, or V14 is used
       -- no need to check for DSTv12
       -- no DST rules changed
       IF db_tz_version = 9
       THEN
         EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                            FROM v$timezone_names' 
                            INTO tznames_dist, tznames_count;
         db_tz_version :=
         CASE
             WHEN (tznames_dist = 548 and tznames_count = 1987) THEN 9
             WHEN (tznames_dist = 549 and tznames_count = 1992) THEN 10
             WHEN (tznames_dist = 551 and tznames_count = 2137) THEN 11
             WHEN (tznames_dist = 551 and tznames_count = 2141) THEN 13
             WHEN (tznames_dist = 556 and tznames_count = 2164) THEN 14
             -- the following 2 cases indicate Unknown db_tz_version
             WHEN (tznames_dist > 556 ) THEN ''
             WHEN (tznames_dist = 556 and tznames_count > 2164) THEN ''
         END;
       END IF;
   END; -- END OF get time zone region version used by server

   vers  := SUBSTR(db_version,1,6);   -- get 3 digit version
   patch := SUBSTR(db_version,1,8);   -- get 4 digit version

    --
    -- For this script to do what it needs to, the database must be 
    -- in OPEN state, if not, exit right now.
    --
    EXECUTE IMMEDIATE 'SELECT status FROM V$INSTANCE' 
    INTO tmp_varchar1;

    IF tmp_varchar1 NOT IN ('OPEN', 'OPEN MIGRATE') THEN
      IF display_xml THEN
        display_header_and_db('value="' || vers || '"');
        display_line('<WARNINGS>');
        display_line('<warning name="DATABASE_NOT_OPEN"/>');
        display_line('</WARNINGS>');
        display_line('</RDBMSUP>');
      ELSE
        display_header_and_db('');
        display_warning ('Database not in OPEN state.');
        display_line ('   Database must be in OPEN state for script to execute correctly.');
        display_line ('   Current Status: ' || tmp_varchar1 || '.');
      END IF;
      RETURN;
    END IF;

    -- Turn on diagnostic collection
    BEGIN
        EXECUTE IMMEDIATE 'SELECT NULL FROM sys.obj$
              WHERE owner#=0 AND type#=2 AND name=''PUIU$DATA'''
        INTO p_null;
        collect_diag := TRUE;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;


   -- Check for XE database 
   BEGIN
      EXECUTE IMMEDIATE
         'SELECT edition FROM sys.registry$ WHERE cid=''CATPROC'''
         INTO p_edition;
      IF p_edition = 'XE' THEN 
         xe_upgrade := TRUE;
      END IF; -- XE edition
   EXCEPTION
      WHEN OTHERS THEN NULL;  -- no edition column
   END;      

   --
   -- Update registry$ with time zone information
   --
   -- Update registry$database with tz version (create it if necessary).
   -- If the registry$database already exists and column tz_version 
   -- is added to the existing registry$database table then this will
   -- invalidate dbms_registry package, dba_registry_database view and
   -- dbms_registry_database synonym, so we need to compile these after>   
   -- alter table add column via the ALTER xx ..COMPILE statement below
   -- Update registry$database with tz version (create it if necessary)

   IF NOT db_readonly THEN

     BEGIN
            EXECUTE IMMEDIATE 
             'UPDATE registry$database set tz_version = :1'
            USING db_tz_version;
     EXCEPTION WHEN OTHERS THEN 
        IF sqlcode = -904 THEN  -- registry$database exists but no tz_version
           EXECUTE IMMEDIATE
              'ALTER TABLE registry$database ADD (tz_version NUMBER)';
           EXECUTE IMMEDIATE
              'UPDATE registry$database set tz_version = :1'
           USING db_tz_version;
            EXECUTE IMMEDIATE
             'ALTER PACKAGE dbms_registry COMPILE BODY';
            EXECUTE IMMEDIATE
             'ALTER VIEW dba_registry_database COMPILE';
            EXECUTE IMMEDIATE
               'ALTER PUBLIC SYNONYM DBA_REGISTRY_DATABASE COMPILE';
        END IF;
        IF sqlcode = -942 THEN -- no registry$database table so create it
           EXECUTE IMMEDIATE 
             'CREATE TABLE registry$database( 
               platform_id   NUMBER,       
               platform_name VARCHAR2(101),
               edition       VARCHAR2(30), 
               tz_version    NUMBER        
               )';

           IF substr(db_version,1,3) != '9.2' THEN -- no v$ views for 9.2
              EXECUTE IMMEDIATE
                 'INSERT into registry$database 
                       (platform_id, platform_name, edition, tz_version) 
                  VALUES ((select platform_id from v$database),
                          (select platform_name from v$database),
                           NULL,
                          (select version from v$timezone_file))';
           ELSE
              EXECUTE IMMEDIATE
                'INSERT into registry$database
                   (platform_id, platform_name, edition, tz_version)
                 VALUES (NULL, NULL, NULL, :1)'
              USING db_tz_version;
           END IF;
        END IF;
        COMMIT;
     END;

   END IF; -- End if Readonly

   -- Get log_mode
   --  NOARCHIVELOG means its off
   --  ARCHIVELOG  means its on
   --  Other values, well, we only check for those
   --  and if the fetch fails, put it to the default of off.
   --
   BEGIN
      EXECUTE IMMEDIATE
         'SELECT LOG_MODE FROM v$database'
         INTO db_log_mode;
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN db_log_mode := 'NOARCHIVELOG';
   END;      


   IF db_undo != 'AUTO' OR db_undo_tbs IS NULL THEN
      db_undo_tbs := 'NO UNDO TBS';  -- undo tbs is not in use
   END IF;


   IF vers = '11.2.0' AND 
      patch = utlu_version THEN -- rerun or inplace
      BEGIN -- rerun or inplace upgrade since instance is current version
         EXECUTE IMMEDIATE 'SELECT version, prv_version FROM sys.registry$ 
                            WHERE cid = ''CATPROC'''
                 INTO db_dict_version, db_prev_version;
         IF db_dict_version = db_version THEN  -- catproc upgraded, rerun 
            rerun := TRUE;
            vers := substr(db_prev_version,1,6);   -- use prev catproc version 
         ELSE -- 11g patch upgrade inplace
            inplace := TRUE;
            vers := substr(db_dict_version,1,6);   -- use CATPROC version 
            db_version := db_dict_version;
         END IF;
         
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            rerun := TRUE;  -- registry$ exists, but no CATPROC entry
      END;
   END IF;

   IF rerun THEN
      IF display_xml THEN
         display_header_and_db('rerun="TRUE"');
         display_line('<Components>');
         IF vers IS NOT NULL THEN  -- If null, then is a newly created DB
            display_line(
               '<Component id ="Oracle Server" type="SERVER" cid="RDBMS">');
            display_line(
             '<CEP value="{ORACLE_HOME}/rdbms/admin/rdbmsup.sql"/>');
            display_line(
             '<SupportedOracleVersions value="9.2.0, 10.1.0, 10.2.0, 11.1.0, 11.2.0"/>');
            display_line(
              '<OracleVersion value ="'|| db_version || '"/>');
            display_line('</Component>');
         END IF;
         display_line('</Components>');
         display_line('</RDBMSUP>'); 
     ELSE
         display_header_and_db('');
         display_line('Database already upgraded; to rerun upgrade ' ||
             'use rdbms/admin/catupgrd.sql.');
     END IF;
     RETURN;
   END IF;

   IF vers = '9.2.0.' THEN 
      dbv := 920;
   ELSIF vers = '10.1.0' THEN 
      dbv := 101;
   ELSIF vers = '10.2.0' THEN 
      dbv := 102;
   ELSIF vers = '11.1.0' THEN
      dbv := 111;
   ELSIF vers = '11.2.0' THEN
      dbv := 112;
   ELSE
       EXECUTE IMMEDIATE 'BEGIN
          RAISE_APPLICATION_ERROR (-20000,
           ''Version '' || db_version || 
           '' not supported for upgrade to release 11.2.0''); END;';
   END IF;

   -- populate sys.props$ with Day Light Saving Time (DST) props
   -- Only needed for releases before 11.2
   IF dbv IN (920, 101, 102, 111) AND NOT db_readonly THEN
     -- Only needed for releases before 11.2.
     -- Populate sys.props$ with Day Light Saving Time (DST) props
     -- only if the database time zone file versions match.
     BEGIN
       -- remove all DST entries that we will then populate
       EXECUTE IMMEDIATE '
         DELETE sys.props$ WHERE name IN (''DST_UPGRADE_STATE'', 
                                        ''DST_PRIMARY_TT_VERSION'',
                                        ''DST_SECONDARY_TT_VERSION'')';
       EXECUTE IMMEDIATE 'INSERT INTO sys.props$ (name, value$, comment$)
           VALUES (''DST_UPGRADE_STATE'', ''NONE'', 
                 ''State of Day Light Saving Time Upgrade'')';
       EXECUTE IMMEDIATE 'INSERT INTO sys.props$ (name, value$, comment$)
           VALUES (''DST_PRIMARY_TT_VERSION'', TO_CHAR( :1, ''FM999''),
                 ''Version of primary timezone data file'')'
       USING db_tz_version;
       EXECUTE IMMEDIATE 'INSERT INTO sys.props$ (name, value$, comment$)
            VALUES (''DST_SECONDARY_TT_VERSION'', ''0'', 
                  ''Version of secondary timezone data file'')';
       COMMIT;
     END;
   END IF;


-- *****************************************************************
-- START of Constant Data
-- *****************************************************************

-- *****************************************************************
-- Constant Initialization Parameter Data
-- *****************************************************************
/*
   To identify new obsolete and deprecated parameters, use the 
   following queries and diff with the list from the prior release:

   select name from v$obsolete_parameter order by name;

   select name from v$parameter 
   where isdeprecated = 'TRUE' order by name; 
   
*/

-- Load Obsolete and Deprecated parameters

   -- Obsolete initialization parameters in release 8.0 --
   idx:=0;
   store_removed(idx,'checkpoint_process', '8.0', FALSE);
   store_removed(idx,'fast_cache_flush', '8.0', FALSE);
   store_removed(idx,'gc_db_locks', '8.0', FALSE);
   store_removed(idx,'gc_freelist_groups', '8.0', FALSE);
   store_removed(idx,'gc_rollback_segments', '8.0', FALSE);
   store_removed(idx,'gc_save_rollback_locks', '8.0', FALSE);
   store_removed(idx,'gc_segments', '8.0', FALSE);
   store_removed(idx,'gc_tablespaces', '8.0', FALSE);
   store_removed(idx,'io_timeout', '8.0', FALSE);
   store_removed(idx,'init_sql_files', '8.0', FALSE);
   store_removed(idx,'ipq_address', '8.0', FALSE);
   store_removed(idx,'ipq_net', '8.0', FALSE);
   store_removed(idx,'lm_domains', '8.0', FALSE);
   store_removed(idx,'lm_non_fault_tolerant', '8.0', FALSE);
   store_removed(idx,'mls_label_format', '8.0', FALSE);
   store_removed(idx,'optimizer_parallel_pass', '8.0', FALSE);
   store_removed(idx,'parallel_default_max_scans', '8.0', FALSE);
   store_removed(idx,'parallel_default_scan_size', '8.0', FALSE);
   store_removed(idx,'post_wait_device', '8.0', FALSE);
   store_removed(idx,'sequence_cache_hash_buckets', '8.0', FALSE);
   store_removed(idx,'unlimited_rollback_segments', '8.0', FALSE);
   store_removed(idx,'use_readv', '8.0', FALSE);
   store_removed(idx,'use_sigio', '8.0', FALSE);
   store_removed(idx,'v733_plans_enabled', '8.0', FALSE);

   -- Obsolete in 8.1
   store_removed(idx,'allow_partial_sn_results', '8.1', FALSE);
   store_removed(idx,'arch_io_slaves', '8.1', FALSE);
   store_removed(idx,'b_tree_bitmap_plans', '8.1', FALSE);
   store_removed(idx,'backup_disk_io_slaves', '8.1', FALSE);
   store_removed(idx,'cache_size_threshold', '8.1', FALSE);
   store_removed(idx,'cleanup_rollback_entries', '8.1', FALSE);
   store_removed(idx,'close_cached_open_cursors', '8.1', FALSE);
   store_removed(idx,'complex_view_merging', '8.1', FALSE);
   store_removed(idx,'db_block_checkpoint_batch', '8.1', FALSE);
   store_removed(idx,'db_block_lru_extended_statistics', '8.1', FALSE);
   store_removed(idx,'db_block_lru_statistics', '8.1', FALSE);
   store_removed(idx,'db_file_simultaneous_writes', '8.1', FALSE);
   store_removed(idx,'delayed_logging_block_cleanouts', '8.1', FALSE);
   store_removed(idx,'discrete_transactions_enabled', '8.1', FALSE);
   store_removed(idx,'distributed_recovery_connection_hold_time', '8.1', FALSE);
   store_removed(idx,'ent_domain_name', '8.1', FALSE);
   store_removed(idx,'fast_full_scan_enabled', '8.1', FALSE);
   store_removed(idx,'freeze_DB_for_fast_instance_recovery', '8.1', FALSE);
   store_removed(idx,'gc_latches', '8.1', FALSE);
   store_removed(idx,'gc_lck_procs', '8.1', FALSE);
   store_removed(idx,'job_queue_keep_connections', '8.1', FALSE);
   store_removed(idx,'large_pool_min_alloc', '8.1', FALSE);
   store_removed(idx,'lgwr_io_slaves', '8.1', FALSE);
   store_removed(idx,'lm_locks', '8.1', FALSE);
   store_removed(idx,'lm_procs', '8.1', FALSE);
   store_removed(idx,'lm_ress', '8.1', FALSE);
   store_removed(idx,'lock_sga_areas', '8.1', FALSE);
   store_removed(idx,'log_archive_buffer_size', '8.1', FALSE);
   store_removed(idx,'log_archive_buffers', '8.1', FALSE);
   store_removed(idx,'log_block_checksum', '8.1', FALSE);
   store_removed(idx,'log_files', '8.1', FALSE);
   store_removed(idx,'log_simultaneous_copies', '8.1', FALSE);
   store_removed(idx,'log_small_entry_max_size', '8.1', FALSE);
   store_removed(idx,'mts_rate_log_size', '8.1', FALSE);
   store_removed(idx,'mts_rate_scale', '8.1', FALSE);
   store_removed(idx,'ogms_home', '8.1', FALSE);
   store_removed(idx,'ops_admin_group', '8.1', FALSE);
   store_removed(idx,'optimizer_search_limit', '8.1', FALSE);
   store_removed(idx,'parallel_default_max_instances', '8.1', FALSE);
   store_removed(idx,'parallel_min_message_pool', '8.1', FALSE);
   store_removed(idx,'parallel_server_idle_time', '8.1', FALSE);
   store_removed(idx,'parallel_transaction_resource_timeout', '8.1', FALSE);
   store_removed(idx,'push_join_predicate', '8.1', FALSE);
   store_removed(idx,'reduce_alarm', '8.1', FALSE);
   store_removed(idx,'row_cache_cursors', '8.1', FALSE);
   store_removed(idx,'sequence_cache_entries', '8.1', FALSE);
   store_removed(idx,'sequence_cache_hash_buckets', '8.1', FALSE);
   store_removed(idx,'shared_pool_reserved_min_alloc', '8.1', FALSE);
   store_removed(idx,'snapshot_refresh_interval', '8.1', FALSE);
   store_removed(idx,'snapshot_refresh_keep_connections', '8.1', FALSE);
   store_removed(idx,'snapshot_refresh_processes', '8.1', FALSE);
   store_removed(idx,'sort_direct_writes', '8.1', FALSE);
   store_removed(idx,'sort_read_fac', '8.1', FALSE);
   store_removed(idx,'sort_spacemap_size', '8.1', FALSE);
   store_removed(idx,'sort_write_buffer_size', '8.1', FALSE);
   store_removed(idx,'sort_write_buffers', '8.1', FALSE);
   store_removed(idx,'spin_count', '8.1', FALSE);
   store_removed(idx,'temporary_table_locks', '8.1', FALSE);
   store_removed(idx,'use_ism', '8.1', FALSE);

   -- Obsolete in 9.0.1
   store_removed(idx,'always_anti_join', '9.0.1', FALSE);
   store_removed(idx,'always_semi_join', '9.0.1', FALSE);
   store_removed(idx,'db_block_lru_latches', '9.0.1', FALSE);
   store_removed(idx,'db_block_max_dirty_target', '9.0.1', FALSE);
   store_removed(idx,'gc_defer_time', '9.0.1', FALSE);
   store_removed(idx,'gc_releasable_locks', '9.0.1', FALSE);
   store_removed(idx,'gc_rollback_locks', '9.0.1', FALSE);
   store_removed(idx,'hash_multiblock_io_count', '9.0.1', FALSE);
   store_removed(idx,'instance_nodeset', '9.0.1', FALSE);
   store_removed(idx,'job_queue_interval', '9.0.1', FALSE);
   store_removed(idx,'ops_interconnects', '9.0.1', FALSE);
   store_removed(idx,'optimizer_percent_parallel', '9.0.1', FALSE);
   store_removed(idx,'sort_multiblock_read_count', '9.0.1', FALSE);
   store_removed(idx,'text_enable', '9.0.1', FALSE);

   -- Obsolete in 9.2
   store_removed(idx,'distributed_transactions', '9.2', FALSE);
   store_removed(idx,'max_transaction_branches', '9.2', FALSE);
   store_removed(idx,'parallel_broadcast_enabled', '9.2', FALSE);
   store_removed(idx,'standby_preserves_names', '9.2', FALSE);

   -- Obsolete in 10.1 (mts_ renames commented out)
   store_removed(idx,'dblink_encrypt_login', '10.1', FALSE);
   store_removed(idx,'hash_join_enabled', '10.1', FALSE);
   store_removed(idx,'log_parallelism', '10.1', FALSE);
   store_removed(idx,'max_rollback_segments', '10.1', FALSE);
--   store_removed(idx,'mts_circuits');
--   store_removed(idx,'mts_dispatchers');
   store_removed(idx,'mts_listener_address', '10.1', FALSE);
--   store_removed(idx,'mts_max_dispatchers');
--   store_removed(idx,'mts_max_servers');
   store_removed(idx,'mts_multiple_listeners', '10.1', FALSE);
--   store_removed(idx,'mts_servers');
   store_removed(idx,'mts_service', '10.1', FALSE);
--   store_removed(idx,'mts_sessions');
   store_removed(idx,'optimizer_max_permutations', '10.1', FALSE);
   store_removed(idx,'oracle_trace_collection_name', '10.1', FALSE);
   store_removed(idx,'oracle_trace_collection_path', '10.1', FALSE);
   store_removed(idx,'oracle_trace_collection_size', '10.1', FALSE);
   store_removed(idx,'oracle_trace_enable', '10.1', FALSE);
   store_removed(idx,'oracle_trace_facility_name', '10.1', FALSE);
   store_removed(idx,'oracle_trace_facility_path', '10.1', FALSE);
   store_removed(idx,'partition_view_enabled', '10.1', FALSE);
   store_removed(idx,'plsql_native_c_compiler', '10.1', FALSE);
   store_removed(idx,'plsql_native_linker', '10.1', FALSE);
   store_removed(idx,'plsql_native_make_file_name', '10.1', FALSE);
   store_removed(idx,'plsql_native_make_utility', '10.1', FALSE);
   store_removed(idx,'row_locking', '10.1', FALSE);
   store_removed(idx,'serializable', '10.1', FALSE);
   store_removed(idx,'transaction_auditing', '10.1', FALSE);
   store_removed(idx,'undo_suppress_errors', '10.1', FALSE);

   -- Deprecated in 10.1, no new value
   store_removed(idx,'global_context_pool_size', '10.1', TRUE);
   store_removed(idx,'log_archive_start', '10.1', TRUE);
   store_removed(idx,'max_enabled_roles', '10.1', TRUE);
   store_removed(idx,'parallel_automatic_tuning', '10.1', TRUE);

   store_removed(idx,'_average_dirties_half_life', '10.1', TRUE);
   store_removed(idx,'_compatible_no_recovery', '10.1', TRUE);
   store_removed(idx,'_db_no_mount_lock', '10.1', TRUE);
   store_removed(idx,'_lm_direct_sends', '10.1', TRUE);
   store_removed(idx,'_lm_multiple_receivers', '10.1', TRUE);
   store_removed(idx,'_lm_statistics', '10.1', TRUE);
   store_removed(idx,'_oracle_trace_events', '10.1', TRUE);
   store_removed(idx,'_oracle_trace_facility_version', '10.1', TRUE);
   store_removed(idx,'_seq_process_cache_const', '10.1', TRUE);

   -- Obsolete in 10.2  
   store_removed(idx,'enqueue_resources', '10.2', FALSE);

   -- Deprecated, but not renamed in 10.2
   store_removed(idx,'logmnr_max_persistent_sessions', '10.2', TRUE);
   store_removed(idx,'max_commit_propagation_delay', '10.2', TRUE);
   store_removed(idx,'remote_archive_enable', '10.2', TRUE);
   store_removed(idx,'serial_reuse', '10.2', TRUE);
   store_removed(idx,'sql_trace', '10.2', TRUE);

   -- Deprecated, but not renamed in 11.1
   store_removed(idx,'commit_write', '11.1', TRUE);
   store_removed(idx,'cursor_space_for_time', '11.1', TRUE);
   store_removed(idx,'instance_groups', '11.1', TRUE);
   store_removed(idx,'log_archive_local_first', '11.1', TRUE);
   store_removed(idx,'remote_os_authent', '11.1', TRUE);
   store_removed(idx,'sql_version', '11.1', TRUE);
   store_removed(idx,'standby_archive_dest', '11.1', TRUE);
   store_removed(idx,'plsql_v2_compatibility', '11.1', TRUE);

   -- Instead a new parameter diagnostic_dest will replace two (core_dump_dest lives)
   store_removed(idx,'background_dump_dest', '11.1', TRUE);
   store_removed(idx,'user_dump_dest', '11.1', TRUE);

   -- Obsolete in 11.1  

   store_removed(idx,'_log_archive_buffer_size', '11.1', FALSE);
   store_removed(idx,'_fast_start_instance_recover_target', '11.1', FALSE);
   store_removed(idx,'_lm_rcv_buffer_size', '11.1', FALSE);
   store_removed(idx,'ddl_wait_for_locks', '11.1', FALSE);
   store_removed(idx,'remote_archive_enable', '11.1', FALSE);

   -- Deprecated in 11.2
   store_removed(idx,'active_instance_count', '11.2', TRUE);
   store_removed(idx,'cursor_space_for_time', '11.2', TRUE);
   store_removed(idx,'fast_start_io_target', '11.2', TRUE);
   store_removed(idx,'global_context_pool_size', '11.2', TRUE);
   store_removed(idx,'instance_groups', '11.2', TRUE);
   store_removed(idx,'lock_name_space', '11.2', TRUE);
   store_removed(idx,'log_archive_local_first', '11.2', TRUE);
   store_removed(idx,'max_commit_propagation_delay', '11.2', TRUE);
   store_removed(idx,'parallel_automatic_tuning', '11.2', TRUE);
   store_removed(idx,'parallel_io_cap_enabled', '11.2', TRUE);
   store_removed(idx,'resource_manager_cpu_allocation', '11.2', TRUE);
   store_removed(idx,'serial_reuse', '11.2', TRUE);

   -- Obsolete in 11.2
   store_removed(idx,'drs_start', '11.2', FALSE);
   store_removed(idx,'gc_files_to_locks', '11.2', FALSE);
   store_removed(idx,'plsql_native_library_dir', '11.2', FALSE);
   store_removed(idx,'plsql_native_library_subdir_count', '11.2', FALSE);
   store_removed(idx,'sql_version', '11.2', FALSE);
   store_removed(idx,'cell_partition_large_extents', '11.2', FALSE);

   -- Sessions removed for XE upgrade only
   IF xe_upgrade THEN
      store_removed(idx,'sessions', '10.1', FALSE);   
   END IF;
   max_op := idx; 

-- Load Renamed parameters

   -- Initialization Parameters Renamed in Release 8.0 --
   idx:=0;
   store_renamed(idx,'async_read','disk_asynch_io');
   store_renamed(idx,'async_write','disk_asynch_io');
   store_renamed(idx,'ccf_io_size','db_file_direct_io_count');
   store_renamed(idx,'db_file_standby_name_convert','db_file_name_convert');
   store_renamed(idx,'db_writers','dbwr_io_slaves');
   store_renamed(idx,'log_file_standby_name_convert',
                     'log_file_name_convert');
   store_renamed(idx,'snapshot_refresh_interval','job_queue_interval');

   -- Initialization Parameters Renamed in Release 8.1.4 --
   store_renamed(idx,'mview_rewrite_enabled','query_rewrite_enabled');
   store_renamed(idx,'rewrite_integrity','query_rewrite_integrity');

   -- Initialization Parameters Renamed in Release 8.1.5 --
   store_renamed(idx,'nls_union_currency','nls_dual_currency');
   store_renamed(idx,'parallel_transaction_recovery',
                     'fast_start_parallel_rollback');

   -- Initialization Parameters Renamed in Release 9.0.1 --
   store_renamed(idx,'fast_start_io_target','fast_start_mttr_target');
   store_renamed(idx,'mts_circuits','circuits');
   store_renamed(idx,'mts_dispatchers','dispatchers');
   store_renamed(idx,'mts_max_dispatchers','max_dispatchers');
   store_renamed(idx,'mts_max_servers','max_shared_servers');
   store_renamed(idx,'mts_servers','shared_servers');
   store_renamed(idx,'mts_sessions','shared_server_sessions');
   store_renamed(idx,'parallel_server','cluster_database');
   store_renamed(idx,'parallel_server_instances',
                     'cluster_database_instances');

   -- Initialization Parameters Renamed in Release 9.2 --
   store_renamed(idx,'drs_start','dg_broker_start');

   -- Initialization Parameters Renamed in Release 10.1 --
   store_renamed(idx,'lock_name_space','db_unique_name');

   -- Initialization Parameters Renamed in Release 10.2 --
   -- none as of 4/1/05

   -- Initialization Parameters Renamed in Release 11.2 --

   store_renamed(idx,'buffer_pool_keep', 'db_keep_cache_size');
   store_renamed(idx,'buffer_pool_recycle', 'db_recycle_cache_size');
   store_renamed(idx,'commit_write', 'commit_logging,commit_wait');

   max_rp := idx; 

-- Initialize special initialization parameters

   idx := 0;
   store_special(idx,'rdbms_server_dn',NULL,'ldap_directory_access','SSL');
   store_special(idx,'plsql_compiler_flags','INTERPRETED',
                     'plsql_code_type','INTERPRETED');
   store_special(idx,'plsql_compiler_flags','NATIVE',
                     'plsql_code_type','NATIVE');
   store_special(idx,'plsql_debug','TRUE','plsql_optimize_level','1');
   store_special(idx,'plsql_compiler_flags','DEBUG',
                     'plsql_optimize_level','1');

   --  Only use these special parameters for databases 
   --  in which Very Large Memory is not enabled
   IF db_vlm = 'FALSE' THEN
      store_special(idx,'db_block_buffers',NULL,
                        'db_cache_size',NULL); 
      store_special(idx,'buffer_pool_recycle',NULL,
                        'db_recycle_cache_size',NULL); 
      store_special(idx,'buffer_pool_keep',NULL,
                        'db_keep_cache_size',NULL);  
   END IF;
   max_sp := idx;

-- Initialization parameters with required values if missing
   --
   -- The array is processed below (search for 'process required data')
   -- The value passed to store_required is used as the 
   -- value that should be set
   --

   idx := 0;
   --
   -- Min value for db_block_size
   --
   store_required (idx, 'db_block_size', 2048, '', 3);

   IF dbv IN (920, 101, 102) THEN
     -- If undo_management is not specified in pre-11g database, then
     -- it needs to be specified MANUAL since the default is changing
     -- from MANUAL to AUTO starting in 11.1.
     store_required(idx, 'undo_management', 0, 'MANUAL', 2);
   END IF;
   max_reqp := idx;

--
-- Initialize parameters with minimum values

   -- the loop sets values that differ for a 32-bit db versus a 64-bit db
   FOR i IN 1..2 LOOP
   -- 1st loop sets values for 32-bit db
   -- 2nd loop sets values for 64-bit db

     idx := 0;
  
     -- bug 8916085:
     -- 32-bit: up sga_target 336M to 528M. up memory_target 436M to 628M.
     -- 64-bit: up sga_target 672M to 744M. up memory_target 836M to 844M.
  
     IF i = 1 THEN  -- sets values for 32-bit db
       IF memory_target THEN
         store_minval_dbbit(32, idx,'memory_target', 628*1024*1024); --  628 MB 
       END IF;
       mt_idx := idx;

       -- sga_target = cs + jv + sp + lp + strp + extra :
       -- (12*4 + 64 + 180 + (12*2*2)*.5 + 0 + 8+32+56) -- 412MB
       -- (32*4 + 64 + 180 + (32*2*2)*.5 + 0 + 8+32+56) -- 532MB
       -- (64*4 + 64 + 180 + (64*2*2)*.5 + 0 + 8+32+56) -- 724MB
       store_minval_dbbit(32, idx,'sga_target',
         (32*4 + 64 + 180 + (32*2*2)*.5 + 0 + 8+32+56) * (1024*1024)); -- 532MB
       tg_idx := idx;

       store_minval_dbbit(32, idx,'shared_pool_size',236*1024*1024); -- 236 MB
       sp_idx := idx;  

       store_minval_dbbit(32, idx,'java_pool_size',   64*1024*1024); -- 64 MB
       jv_idx := idx;

     END IF;

     IF i = 2 THEN  -- sets values for 64-bit db
       -- use larger pool sizes for 64-bit systems

       IF memory_target THEN
          store_minval_dbbit(64,idx,'memory_target', 844*1024*1024); --  844 MB 
       END IF;
       mt_idx := idx;

       -- sga_target = cs + jv + sp + lp + strp + extra :
       -- (12*4 + 100 + 280 + (12*2*2)*.5 + 0 + 8*2+32*2+28+20+16) -- 596M
       -- (32*4 + 100 + 280 + (32*2*2)*.5 + 0 + 8*2+32*2+28+20+16) -- 716M
       -- (64*4 + 100 + 280 + (64*2*2)*.5 + 0 + 8*2+32*2+28+20+16) -- 908M
       store_minval_dbbit(64, idx,'sga_target',
         (32*4 + 100 + 280 + 32*2 + 0 + 16+64+28+20+16) * (1024*1024)); --716MB
       tg_idx := idx;

       store_minval_dbbit(64,idx,'shared_pool_size',472*1024*1024); -- 472 MB
       sp_idx := idx;  

       store_minval_dbbit(64,idx,'java_pool_size',  128*1024*1024); -- 128 MB
       jv_idx := idx;
     END IF;
   END LOOP;  -- store minimum parameter values for both 32 and 64 bit
  
   -- finish loop
   -- now we set values that are the same regardless of db bit

   store_minval_dbbit(0,idx,'db_cache_size',    48*1024*1024); --  48 MB
   cs_idx := idx;

   store_minval_dbbit(0,idx,'pga_aggregate_target', 24*1024*1024); --  24 MB
   pg_idx := idx;

   -- Added large_pool_size and streams_pool_size so that we can include these
   -- user-specified values (if set) for sga_target minimum caculation.
   -- Note that we're not making minimum recommendations for these 2 pools at
   -- at this time.
   store_minval_dbbit(0,idx,'large_pool_size', 0);
   lp_idx := idx;
   store_minval_dbbit(0,idx,'streams_pool_size', 0);
   str_idx := idx;

   -- For XML output only for DBUA with EM config
   -- Minimum number of processes should be 150
   IF display_xml THEN
      store_minval_dbbit(0, idx,'processes', 150);   
   END IF;

   max_minvp := idx;

-- *****************************************************************
-- Store Constant Component Data
-- *****************************************************************

-- Clear all variable component data
   FOR i IN 1..max_comps LOOP
       cmp_info(i).sys_kbytes := 2*c_kb; -- initialize with default of 2M
                                         -- instead of 0
       cmp_info(i).sysaux_kbytes := 2*c_kb; -- initialize with 2M instead of 0
       cmp_info(i).def_ts_kbytes:=  0;
       cmp_info(i).ins_sys_kbytes:= 0;
       cmp_info(i).ins_def_kbytes:= 0;
       cmp_info(i).def_ts     := NULL;
       cmp_info(i).processed  := FALSE;
       cmp_info(i).install    := FALSE;
   END LOOP;

-- Load component id and name
   cmp_info(catalog).cid := 'CATALOG';
   cmp_info(catalog).cname := 'Oracle Catalog Views';
   cmp_info(catproc).cid := 'CATPROC';
   cmp_info(catproc).cname := 'Oracle Packages and Types';
   cmp_info(javavm).cid := 'JAVAVM';
   cmp_info(javavm).cname := 'JServer JAVA Virtual Machine';
   cmp_info(xml).cid := 'XML';
   cmp_info(xml).cname := 'Oracle XDK for Java';
   cmp_info(catjava).cid := 'CATJAVA';
   cmp_info(catjava).cname := 'Oracle Java Packages';
   cmp_info(xdb).cid := 'XDB';
   cmp_info(xdb).cname := 'Oracle XML Database';
   cmp_info(rac).cid := 'RAC';
   cmp_info(rac).cname := 'Real Application Clusters';
   cmp_info(owm).cid := 'OWM';
   cmp_info(owm).cname := 'Oracle Workspace Manager';
   cmp_info(odm).cid := 'ODM';
   cmp_info(odm).cname := 'Data Mining';
   cmp_info(mgw).cid := 'MGW';
   cmp_info(mgw).cname := 'Messaging Gateway';
   cmp_info(aps).cid := 'APS';
   cmp_info(aps).cname := 'OLAP Analytic Workspace';
   cmp_info(amd).cid := 'AMD';
   cmp_info(amd).cname := 'OLAP Catalog';
   cmp_info(xoq).cid := 'XOQ';
   cmp_info(xoq).cname := 'Oracle OLAP API';
   cmp_info(ordim).cid := 'ORDIM';
   cmp_info(ordim).cname := 'Oracle interMedia';
   cmp_info(sdo).cid := 'SDO';
   cmp_info(sdo).cname := 'Spatial';
   cmp_info(context).cid := 'CONTEXT';
   cmp_info(context).cname := 'Oracle Text';
   cmp_info(wk).cid := 'WK';
   cmp_info(wk).cname := 'Oracle Ultra Search';
   cmp_info(ols).cid := 'OLS';
   cmp_info(ols).cname := 'Oracle Label Security';
   cmp_info(exf).cid := 'EXF';
   cmp_info(exf).cname := 'Expression Filter';
   cmp_info(em).cid := 'EM';
   cmp_info(em).cname := 'EM Repository';
   cmp_info(rul).cid := 'RUL';
   cmp_info(rul).cname := 'Rule Manager';
   cmp_info(apex).cid := 'APEX';
   cmp_info(apex).cname := 'Oracle Application Express';
   cmp_info(dv).cid := 'DV';
   cmp_info(dv).cname := 'Oracle Database Vault'; 
   cmp_info(stats).cid := 'STATS';
   cmp_info(stats).cname := 'Gather Statistics';
   
-- Initialize script names
 IF dbv = 112 THEN
   -- 
   -- for 11.2, several components moved into
   -- catalog/catproc so they no longer have their own scripts
   --
   cmp_info(catalog).script := '?/rdbms/admin/catalog.sql';
   cmp_info(catproc).script := '?/rdbms/admin/catproc.sql';
   cmp_info(javavm).script  := '?/javavm/install/jvmpatch.sql'; 
   cmp_info(xml).script     := '?/xdk/admin/xmlpatch.sql';
   cmp_info(xdb).script     := '?/rdbms/admin/xdbpatch.sql';
   cmp_info(rac).script     := '?/rdbms/admin/catclust.sql';
   cmp_info(ols).script     := '?/rdbms/admin/olspatch.sql';
   cmp_info(exf).script     := '?/rdbms/admin/exfpatch.sql';
   cmp_info(rul).script     := '?/rdbms/admin/rulpatch.sql';
   cmp_info(owm).script     := '?/rdbms/admin/owmpatch.sql';
   cmp_info(ordim).script   := '?/ord/im/admin/impatch.sql';
   cmp_info(sdo).script     := '?/md/admin/sdopatch.sql';
   cmp_info(context).script := '?/ctx/admin/ctxpatch.sql';
   cmp_info(mgw).script     := '?/mgw/admin/mgwpatch.sql';
   cmp_info(amd).script     := '?/olap/admin/amdpatch.sql';
   cmp_info(aps).script     := '?/olap/admin/apspatch.sql';
   cmp_info(xoq).script     := '?/olap/admin/xoqpatch.sql';
   cmp_info(em).script      := '?/sysman/admin/emdrep/sql/empatch.sql';
   cmp_info(apex).script    := '?/apex/apxpatch.sql';
   cmp_info(dv).script      := '?/rdbms/admin/dvpatch.sql';
 ELSE
   cmp_info(catalog).script := '?/rdbms/admin/catalog.sql';
   cmp_info(catproc).script := '?/rdbms/admin/catproc.sql';
   cmp_info(javavm).script  := '?/javavm/install/jvmdbmig.sql'; 
   cmp_info(xml).script     := '?/xdk/admin/xmldbmig.sql';
   cmp_info(xdb).script     := '?/rdbms/admin/xdbdbmig.sql';
   cmp_info(rac).script     := '?/rdbms/admin/catclust.sql';
   cmp_info(ols).script     := '?/rdbms/admin/olsdbmig.sql';
   cmp_info(exf).script     := '?/rdbms/admin/exfdbmig.sql';
   cmp_info(rul).script     := '?/rdbms/admin/ruldbmig.sql';
   cmp_info(owm).script     := '?/rdbms/admin/owmdbmig.sql';
   cmp_info(odm).script     := '?/rdbms/admin/odmdbmig.sql';
   cmp_info(ordim).script   := '?/ord/im/admin/imdbmig.sql';
   cmp_info(sdo).script     := '?/md/admin/sdodbmig.sql';
   cmp_info(context).script := '?/ctx/admin/ctxdbmig.sql';
   cmp_info(wk).script      := '?/rdbms/admin/wkremov.sql';
   cmp_info(mgw).script     := '?/mgw/admin/mgwdbmig.sql';
   cmp_info(amd).script     := '?/olap/admin/amddbmig.sql';
   cmp_info(aps).script     := '?/olap/admin/apsdbmig.sql';
   cmp_info(xoq).script     := '?/olap/admin/xoqdbmig.sql';
   cmp_info(em).script      := '?/sysman/admin/emdrep/sql/empatch.sql';
   cmp_info(apex).script    := '?/apex/apxdbmig.sql';
   cmp_info(dv).script      := '?/rdbms/admin/dvdbmig.sql';

 END IF;
-- *****************************************************************
-- Store Release Dependent Data
-- *****************************************************************

-- kbytes for component installs (into SYSTEM and DEFAULT tablespaces)
-- rae: add 10% for 11g .
-- the '*1.2' below from point (a) to (b) are rae's .
-- Point (a)
   cmp_info(javavm).ins_sys_kbytes:= 105972*1.2;  -- rae's
   cmp_info(xml).ins_sys_kbytes:=      4818*1.2;  -- rae's
   cmp_info(catjava).ins_sys_kbytes:=  5760*1.2;  -- rae's
   cmp_info(xdb).ins_sys_kbytes :=     10*c_kb * 1.2;
   IF db_block_size = 16384 THEN
      cmp_info(xdb).ins_def_kbytes:=   (88*2)*c_kb * 1.2;
   ELSE
      cmp_info(xdb).ins_def_kbytes:=   88*c_kb * 1.2;
   END IF;
   cmp_info(ordim).ins_sys_kbytes :=   10*c_kb * 1.2;  -- actually saw 1MB
   cmp_info(ordim).ins_def_kbytes :=   60*c_kb * 1.2;
   cmp_info(em).ins_sys_kbytes:=       22528*1.2;
   cmp_info(em).ins_def_kbytes:=       51200*1.2;
-- Point (b)

   -- XDB itself seems to take about 10M increase in its sysaux/xdb tablespace
   -- to upgrade.
   -- Since many components use XDB, lets default space needed for xdb 
   -- to be 85M.  And if APEX is in the db, then add 30M to xdb space.
   -- cmp_info(xdb).def_ts_kbytes:=    85*c_kb; -- XDB

   IF dbv = 920 OR dbv = 101 THEN

      cmp_info(catalog).sys_kbytes:= 106*c_kb * 1.1;
      cmp_info(catproc).sys_kbytes:=   (11+20)*c_kb * 1.1; -- catproc+catupend
      cmp_info(javavm).sys_kbytes:=   100*c_kb * 1.1;  
      cmp_info(xml).sys_kbytes:=       3*c_kb * 1.1;  
      cmp_info(owm).sys_kbytes:=       3*c_kb * 1.1;
      cmp_info(context).sys_kbytes:=   4*c_kb * 1.1;  
      cmp_info(xdb).sys_kbytes:=       10*c_kb * 1.1; 
      cmp_info(ordim).sys_kbytes:=    44*c_kb * 1.1;
      cmp_info(sdo).sys_kbytes:=      17*c_kb * 1.1;  -- saw 10M
      cmp_info(apex).sys_kbytes:=     81*c_kb * 1.1;
      cmp_info(em).sys_kbytes:=        62*c_kb * 1.1;
      cmp_info(wk).sys_kbytes:=        0;

      cmp_info(catalog).sysaux_kbytes:=  2*c_kb; -- default
      cmp_info(catproc).sysaux_kbytes:=  130*c_kb * 1.1;
      cmp_info(aps).sysaux_kbytes:=      38*c_kb * 1.1;

      cmp_info(catproc).def_ts_kbytes:= 130*c_kb * 1.1;
      cmp_info(ordim).def_ts_kbytes:=      10*c_kb * 1.1;
      cmp_info(sdo).def_ts_kbytes:=      61*c_kb * 1.1; -- MDSYS
      cmp_info(owm).def_ts_kbytes:=       7*c_kb * 1.1; -- WMSYS
      cmp_info(xdb).def_ts_kbytes:=       85*c_kb; -- XDB
      cmp_info(apex).def_ts_kbytes:=    265*c_kb; -- APEX
      cmp_info(wk).def_ts_kbytes:=  0; -- WK removed => 0 increase
      cmp_info(em).def_ts_kbytes:=       73*c_kb * 1.1;

   ELSIF dbv = 102 THEN

      -- mult by 1.1 for experimental noise
      cmp_info(catalog).sys_kbytes:=  106*c_kb * 1.1;
      cmp_info(catproc).sys_kbytes:=   (2+20)*c_kb * 1.1; -- catproc+catupend
      cmp_info(javavm).sys_kbytes:=    51*c_kb * 1.1;  
      cmp_info(xdb).sys_kbytes:=       10*c_kb * 1.1;  
      cmp_info(ordim).sys_kbytes:=      6*c_kb * 1.1;
      cmp_info(sdo).sys_kbytes:=       16*c_kb * 1.1;
      cmp_info(apex).sys_kbytes:=      81*c_kb * 1.1;
      cmp_info(mgw).sys_kbytes:=        3*c_kb * 1.1;
      cmp_info(em).sys_kbytes:=        62*c_kb * 1.1;
      cmp_info(wk).sys_kbytes:=        0;

      cmp_info(catalog).sysaux_kbytes:=  14*c_kb * 1.1;
      cmp_info(catproc).sysaux_kbytes:=  96*c_kb * 1.1;  
      cmp_info(aps).sysaux_kbytes:=       6*c_kb * 1.1;

      cmp_info(catproc).def_ts_kbytes:= 96*c_kb * 1.1;
      cmp_info(context).def_ts_kbytes:=  2*c_kb; -- CTXSYS , default
      cmp_info(exf).def_ts_kbytes:=      2*c_kb; -- EXFSYS , default
      cmp_info(apex).def_ts_kbytes:=         265*c_kb; -- FLOWS_
      cmp_info(ordim).def_ts_kbytes:=   11*c_kb * 1.1; -- ORDSYS
      cmp_info(sdo).def_ts_kbytes:=     42*c_kb * 1.1; -- MDSYS
      cmp_info(em).def_ts_kbytes:=      73*c_kb * 1.1; -- SYSMAN
      cmp_info(owm).def_ts_kbytes:=      2*c_kb; -- WMSYS
      cmp_info(xdb).def_ts_kbytes:=     85*c_kb; -- XDB
      cmp_info(ols).def_ts_kbytes:=      2*c_kb; -- LBACSYS , default
      cmp_info(dv).def_ts_kbytes:=       2*c_kb; -- DVSYS , default
      cmp_info(aps).def_ts_kbytes :=     6*c_kb * 1.1;
      cmp_info(wk).def_ts_kbytes:=       0;      -- WK removed => 0 increase
      cmp_info(javavm).def_ts_kbytes:=    4*c_kb * 1.1;  

   ELSIF dbv = 111 THEN 

      -- mult by 1.1 or 1.2 for experimental noise
      cmp_info(catalog).sys_kbytes:=  11*c_kb * 1.1;
      cmp_info(catproc).sys_kbytes:=  (35+20)*c_kb * 1.1; -- catproc+catupend 
      cmp_info(javavm).sys_kbytes:=    9*c_kb * 1.1;
      cmp_info(context).sys_kbytes:=   3*c_kb * 1.1;  
      cmp_info(xdb).sys_kbytes:=       2*c_kb * 1.1;  
      cmp_info(ordim).sys_kbytes:=    50*c_kb * 1.1;
      cmp_info(sdo).sys_kbytes:=      5*c_kb * 1.1;
      cmp_info(apex).sys_kbytes:=     30*c_kb * 1.1;
      cmp_info(em).sys_kbytes:=       12*c_kb * 1.1;
      cmp_info(wk).sys_kbytes:=        0;

      cmp_info(catalog).sysaux_kbytes:=   7*c_kb * 1.1;
      cmp_info(catproc).sysaux_kbytes:=   10*c_kb * 1.1;  
      cmp_info(aps).sysaux_kbytes:=       5*c_kb * 1.1;

      cmp_info(catproc).def_ts_kbytes:= 10*c_kb * 1.1;
      cmp_info(context).def_ts_kbytes:=  2*c_kb; -- CTXSYS , default
      cmp_info(exf).def_ts_kbytes:=      2*c_kb; -- EXFSYS , default
      cmp_info(apex).def_ts_kbytes :=  212*c_kb * 1.1; -- FLOWS_
      cmp_info(sdo).def_ts_kbytes:=     27*c_kb * 1.1; -- MDSYS
      cmp_info(ordim).def_ts_kbytes:=   15*c_kb * 1.1; -- ORDSYS
      cmp_info(em).def_ts_kbytes:=       2*c_kb; -- SYSMAN , default
      cmp_info(owm).def_ts_kbytes:=      2*c_kb;       -- WMSYS, default
      cmp_info(xdb).def_ts_kbytes:=     85*c_kb; -- XDB
      cmp_info(ols).def_ts_kbytes:=      2*c_kb;       -- LBACSYS , default
      cmp_info(dv).def_ts_kbytes:=       2*c_kb;       -- DVSYS , default
      cmp_info(wk).def_ts_kbytes:=       0;        -- WK removed => 0 increase

   ELSIF dbv = 112 THEN

      -- mult by 1.1 or 1.2 for experimental noise
      cmp_info(catalog).sys_kbytes:=  10*c_kb * 1.1;
      cmp_info(catproc).sys_kbytes:=  (11+20)*c_kb * 1.1;  -- catproc+catupend
      cmp_info(em).sys_kbytes:=        3*c_kb * 1.1;  
      cmp_info(context).sys_kbytes:=   3*c_kb * 1.1;  
      cmp_info(ordim).sys_kbytes:=     4*c_kb * 1.1;  
      cmp_info(wk).sys_kbytes:=        0;

      cmp_info(catalog).sysaux_kbytes:=   2*c_kb;  -- default
      cmp_info(catproc).sysaux_kbytes:=   2*c_kb;  -- default

      cmp_info(catproc).def_ts_kbytes:=   2*c_kb;  -- default
      cmp_info(em).def_ts_kbytes:=       4*c_kb * 1.1;   -- SYSMAN
      cmp_info(ordim).def_ts_kbytes:=      4*c_kb * 1.1;
      cmp_info(wk).def_ts_kbytes:=       0;        -- WK removed => 0 increase

   END IF;

   -- misc: round up to 100M fudge for stats
   -- CML: TS: estimate for utlrp later?
   cmp_info(stats).sys_kbytes:=     100*c_kb;

   -- misc: round up to 25M fudge
   cmp_info(stats).sysaux_kbytes:=   25*c_kb;

-- *****************************************************************
-- END of Constant Data
-- *****************************************************************

-- *****************************************************************
-- START of Collect Section
-- *****************************************************************

-- *****************************************************************
-- Collect Variable Component Information 
-- *****************************************************************

   BEGIN -- Get components
      
      IF dbv = 920 THEN  -- No namespace
         OPEN reg_cursor FOR 
              'SELECT cid, status, version, schema# 
                 FROM sys.registry$';
      ELSE
          OPEN reg_cursor FOR 
              'SELECT cid, status, version, schema# 
                 FROM sys.registry$ WHERE namespace =''SERVER''';
     END IF;

     LOOP
        FETCH reg_cursor INTO p_cid, n_status, p_version, n_schema;
        EXIT WHEN reg_cursor%NOTFOUND;
        IF n_status NOT IN (99,8) THEN -- not REMOVED or REMOVING
           EXECUTE IMMEDIATE 'SELECT name FROM sys.user$ 
                  WHERE user#=:1'
              INTO p_schema
              USING n_schema;
           FOR i IN 1..max_components LOOP
               IF p_cid = cmp_info(i).cid THEN
                  store_comp(i, p_schema, p_version, n_status);
                  EXIT; -- from component search loop
               END IF;
           END LOOP;  -- ignore if not in component list
        END IF;
     END LOOP;
     CLOSE reg_cursor;

     -- Ultra Search not in 10.1.0.2 registry so check schema
     IF NOT cmp_info(wk).processed THEN
        BEGIN
           EXECUTE IMMEDIATE 'SELECT NULL FROM sys.user$ WHERE name = ''WKSYS'''
           INTO p_null;
           store_comp(wk, 'WKSYS', db_version, NULL);
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;
     END IF;

      -- Check for HTML DB in 9.2.0 and 10.1 databases
      BEGIN
         EXECUTE IMMEDIATE 'SELECT FLOWS_010500.wwv_flows_release from sys.dual'
         INTO p_version;
         store_comp(apex,'FLOWS_010500',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'SELECT FLOWS_010600.wwv_flows_release from sys.dual'
         INTO p_version;
         store_comp(apex,'FLOWS_010600',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

      -- Check for APEX in 10.2 databases
      BEGIN
         EXECUTE IMMEDIATE 'SELECT FLOWS_020000.wwv_flows_release from sys.dual'
         INTO p_version;
         store_comp(apex,'FLOWS_020000',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'SELECT FLOWS_020100.wwv_flows_release from sys.dual'
         INTO p_version;
         store_comp(apex,'FLOWS_020100',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END; 
            
     -- Database Vault not in registry so check schema
     IF NOT cmp_info(dv).processed THEN
        BEGIN
           EXECUTE IMMEDIATE 'SELECT NULL FROM sys.user$ WHERE name = ''DVSYS'''
           into P_NULL;
           store_comp(dv, 'DVSYS', '10.2.0', NULL);           
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;
     END IF;

   -- CML: TS: estimate for utlrp later?
     -- Consider STATS (stats) in registry because
     -- cmp_info(stats).processed has to be equal to TRUE before the tablespace
     -- sizing algorithm will consider the space needed for STATS.
     -- this call will set 'cmp_info(stats).processed := TRUE;'
     store_comp(stats, 'SYS', NULL, NULL);      

 END; -- Get components

 IF dbv != 112 THEN -- install required components on major release only
   -- if SDO, ORDIM, WK, EXF, or ODM components are present, need JAVAVM
   IF NOT cmp_info(javavm).processed THEN
      IF cmp_info(ordim).processed OR cmp_info(wk).processed OR 
         cmp_info(exf).processed OR
         cmp_info(sdo).processed THEN
         store_comp(javavm, 'SYS', NULL, NULL);           
         cmp_info(javavm).install := TRUE;
         store_comp(catjava, 'SYS', NULL, NULL);           
         cmp_info(catjava).install := TRUE;
      END IF;
   END IF;
 
   -- If there is a JAVAVM component
   -- THEN include the CATJAVA component.
   IF cmp_info(javavm).processed AND NOT cmp_info(catjava).processed THEN
      store_comp(catjava, 'SYS', NULL, NULL);           
      cmp_info(catjava).install := TRUE;
   END IF;

   -- If interMedia or Spatial component, but no XML, Then
   -- install XML
   IF NOT cmp_info(xml).processed AND
         (cmp_info(ordim).processed OR cmp_info(sdo).processed) THEN
      store_comp(xml, 'SYS', NULL, NULL);           
      cmp_info(xml).install := TRUE;
   END IF;
   
   -- If XML, interMedia or Spatial component, but no XDB, Then
   -- install XDB
   IF NOT cmp_info(xdb).processed AND
         (cmp_info(ordim).processed OR cmp_info(sdo).processed OR
          cmp_info(xml).processed) THEN
      store_comp(xdb, 'XDB', NULL, NULL);           
      cmp_info(xdb).install := TRUE;
      cmp_info(xdb).def_ts := 'SYSAUX';
   END IF;
   
   -- If Spatial component, but no ORDIM, Then
   -- install ORDIM
   IF NOT cmp_info(ordim).processed AND
         (cmp_info(sdo).processed) THEN
      store_comp(ordim, 'ORDSYS', NULL, NULL);           
      cmp_info(ordim).install := TRUE;
      cmp_info(ordim).def_ts := 'SYSAUX';
   END IF;

 END IF;  -- not for patch release

-- *****************************************************************
-- Collect Variable Initialization Parameter Information
-- *****************************************************************

   -- Find renamed parameters in use
   FOR i IN 1..max_rp LOOP
      BEGIN
        EXECUTE IMMEDIATE 'SELECT NULL FROM v$parameter WHERE name = 
            LOWER(:1) AND isdefault = ''FALSE'''
        INTO p_null
        USING rp(i).oldname;
         rp(i).db_match := TRUE;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         rp(i).db_match := FALSE;
      END;
   END LOOP;
 
   -- Find obsolete parameters in use
   FOR i IN 1..max_op LOOP
      BEGIN
        EXECUTE IMMEDIATE 'SELECT NULL FROM v$parameter WHERE name = 
           LOWER(:1) AND isdefault = ''FALSE'''
        INTO p_null
        USING op(i).name;
         op(i).db_match := TRUE;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         op(i).db_match := FALSE;
      END;
   END LOOP;

   -- Find special parameters in use
   FOR i IN 1..max_sp LOOP
      BEGIN
         EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = 
              LOWER(:1) AND isdefault = ''FALSE'''  
         INTO p_value
         USING sp(i).oldname;
         IF sp(i).oldvalue IS NULL OR
            p_value = sp(i).oldvalue THEN
            sp(i).db_match := TRUE;

            -- calculate new values for cache size params (buffers x blocksize)
            IF sp(i).oldname = 'db_block_buffers' THEN
               sp(i).newvalue := TO_CHAR(TO_NUMBER(p_value) * db_block_size);
            ELSIF sp(i).oldname = 'buffer_pool_recycle' OR
                  sp(i).oldname = 'buffer_pool_keep' THEN
               IF INSTR(UPPER(p_value),'BUFFERS:') > 0 THEN -- has keyword
                  IF INSTR(SUBSTR(p_value,INSTR(UPPER(p_value),
                          'BUFFERS:')+8),',') > 0  THEN 
                     -- has second keyword after BUFFERS
                     sp(i).newvalue := TO_CHAR(TO_NUMBER(SUBSTR(p_value,
                        INSTR(UPPER(p_value),'BUFFERS:')+8,
                        INSTR(p_value,',')-INSTR(UPPER(p_value),'BUFFERS:')-8))
                        * db_block_size);
                  ELSE -- no second keyword
                     sp(i).newvalue := TO_CHAR(TO_NUMBER(SUBSTR(p_value,
                        INSTR(UPPER(p_value),'BUFFERS:')+8)) * db_block_size);
                  END IF; -- second keyword
               ELSIF INSTR(UPPER(p_value),',') > 0 THEN   -- has keyword format #,#
                  --
                  -- In the #,# Format the first number before the comma is
                  -- buffers second number is the lru latches. For the calculation
                  -- we parse out the the buffer number and multiply
                  -- by db_block_size.
                  --
                  tmp_num2       := INSTR(UPPER(p_value),',');
                  sp(i).newvalue := TRIM(SUBSTR(p_value, 1, tmp_num2-1));
                  sp(i).newvalue := TO_CHAR(TO_NUMBER(sp(i).newvalue)
                                              * db_block_size);
               ELSE -- no keywords, just number
                  sp(i).newvalue := TO_CHAR(TO_NUMBER(p_value) * db_block_size);
               END IF; -- keywords
            END IF; -- params with calculated values
         ELSE
            -- plsql_compiler_flags may contain two values
            -- in this case we process the list of values
            IF (sp(i).oldname = 'plsql_compiler_flags') AND
               (INSTR(p_value,sp(i).oldvalue) > 0) THEN
                   -- If 'DEBUG' value found in list then make sure 
                   -- it is not finding NON_DEBUG                
                   -- (using premise that DEBUG and NON_DEBUG do not mix)
                   IF (sp(i).oldvalue='DEBUG' AND 
                      INSTR(p_value,'NON_DEBUG') = 0) OR 
                      (sp(i).oldvalue != 'DEBUG') THEN
                         sp(i).db_match := TRUE;
                   END IF;
            ELSE
               sp(i).db_match := FALSE;
            END IF;
         END IF;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         sp(i).db_match := FALSE;
      END;
   END LOOP;
 
  -- Process required data

   FOR i IN 1..max_reqp LOOP
      BEGIN
         EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = 
              :1 AND isdefault = ''TRUE'''
         INTO p_value
         USING reqp(i).name;
         IF reqp(i).name = 'db_block_size' THEN
            IF dbv = 920 THEN  -- db_block_size default changed in 10g
               reqp(i).db_match := TRUE;
            END IF;
         ELSIF reqp(i).name = 'undo_management' THEN
            -- Starting in 11.1, undo_management default is changed
            -- from MANUAL to AUTO.
            IF dbv IN (920, 101, 102) THEN
              reqp(i).db_match := TRUE;
            END IF;
         END IF;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         reqp(i).db_match := FALSE;
      END;
   END LOOP;

   -- Find values for initialization parameters with minimum values
   -- Convert to numeric values
   store_oldval(minvp_db32);
   store_oldval(minvp_db64);

   -- determine new values for initialization parameters with minimum values
   find_newval(minvp_db32, 32);
   find_newval(minvp_db64, 64);


-- *****************************************************************
-- Collect Tablespace Information
-- *****************************************************************

   idx := 0;
   OPEN tmp_cursor FOR 
      'SELECT tablespace_name, contents, extent_management FROM SYS.dba_tablespaces';
   LOOP
     FETCH tmp_cursor INTO p_tsname, tmp_varchar1, tmp_varchar2;
     EXIT WHEN tmp_cursor%NOTFOUND;
     IF p_tsname IN ('SYSTEM', 'SYSAUX', db_undo_tbs) OR 
        is_comp_tablespace(p_tsname) OR
        ts_has_queues (p_tsname) OR 
        ts_is_SYS_temporary (p_tsname) THEN

        idx:=idx+1;
        ts_info(idx).name  :=p_tsname;
        IF tmp_varchar1 = 'TEMPORARY' THEN      
           ts_info(idx).temporary := TRUE;
        ELSE
           ts_info(idx).temporary := FALSE;
        END IF;

        IF tmp_varchar2 = 'LOCAL' THEN
           ts_info(idx).localmanaged := TRUE;
        ELSE
           ts_info(idx).localmanaged := FALSE;
        END IF;

        -- Get number of kbytes used
        IF (dbv=920) THEN
          -- Need to use sys_dba_segs for 920 because of possible overflow
          EXECUTE IMMEDIATE 
            'SELECT SUM(bytes) FROM sys.sys_dba_segs seg WHERE seg.tablespace_name = :1'
          INTO sum_bytes
          USING p_tsname;
        ELSE
          EXECUTE IMMEDIATE 
            'SELECT SUM(bytes) FROM sys.dba_segments seg WHERE seg.tablespace_name = :1'
          INTO sum_bytes
          USING p_tsname;
        END IF;
        IF sum_bytes IS NULL THEN 
           ts_info(idx).inuse:=0;
        ELSIF sum_bytes <= 1024 THEN
           ts_info(idx).inuse:=1;
        ELSE
           ts_info(idx).inuse :=ROUND(sum_bytes/1024);
        END IF;  

        -- Get number of kbytes allocated
        IF ts_info(idx).temporary AND
           ts_info(idx).localmanaged THEN
          EXECUTE IMMEDIATE 
            'SELECT SUM(bytes) FROM sys.dba_temp_files files WHERE ' ||
                 'files.tablespace_name = :1'
          INTO sum_bytes
          USING p_tsname;
        ELSE
          EXECUTE IMMEDIATE 
             'SELECT SUM(bytes) FROM sys.dba_data_files files WHERE ' ||
                    'files.tablespace_name = :1'
          INTO sum_bytes
          USING p_tsname;
        END IF;
        IF sum_bytes IS NULL THEN 
           ts_info(idx).alloc:=0;
        ELSIF sum_bytes <= 1024 THEN
           ts_info(idx).alloc:=1;
        ELSE
           ts_info(idx).alloc:=ROUND(sum_bytes/1024);
        END IF;  
          
        -- Get number of kbytes of unused autoextend
        IF ts_info(idx).temporary AND 
           ts_info(idx).localmanaged THEN
          EXECUTE IMMEDIATE 
            'SELECT SUM(decode(maxbytes, 0, 0, maxbytes-bytes)) ' ||
            'FROM sys.dba_temp_files WHERE tablespace_name=:1'
          INTO sum_bytes
          USING p_tsname;
        ELSE
          EXECUTE IMMEDIATE 
            'SELECT SUM(decode(maxbytes, 0, 0, maxbytes-bytes)) ' ||
            'FROM sys.dba_data_files WHERE tablespace_name=:1'
          INTO sum_bytes
          USING p_tsname;
        END IF;
        IF sum_bytes IS NULL THEN 
           ts_info(idx).auto:=0;
        ELSIF sum_bytes <= 1024 THEN
           ts_info(idx).auto:=1;
        ELSE
           ts_info(idx).auto:=ROUND(sum_bytes/1024);
        END IF;  

        -- total available is allocated plus auto extend
        ts_info(idx).avail := ts_info(idx).alloc + ts_info(idx).auto;
    END IF;
   END LOOP;
   CLOSE tmp_cursor;

   max_ts := idx;   -- max tablespaces of interest

-- *****************************************************************
-- Collect Public Rollback Information
-- *****************************************************************

   idx := 0;
   IF db_undo != 'AUTO' THEN  -- using rollback segments

     OPEN tmp_cursor FOR 
          'SELECT segment_name, next_extent, max_extents, status FROM SYS.dba_rollback_segs 
              WHERE owner=''PUBLIC'' OR (owner=''SYS'' AND segment_name != ''SYSTEM'')';
     LOOP
       FETCH tmp_cursor INTO tmp_varchar1, tmp_num1, tmp_num2, p_status;
       EXIT WHEN tmp_cursor%NOTFOUND;
        BEGIN
          --- get sum of bytes and tablespace name
          IF (dbv=920) THEN
            -- Need to use sys_dba_segs for 920 because of possible overflow
            EXECUTE IMMEDIATE 
                'SELECT tablespace_name, sum(bytes) FROM sys.sys_dba_segs 
                    WHERE segment_name = :1  AND ROWNUM = 1 GROUP BY tablespace_name' 
            INTO p_tsname, sum_bytes
            USING tmp_varchar1;
          ELSE
            EXECUTE IMMEDIATE 
                'SELECT tablespace_name, sum(bytes) FROM sys.dba_segments
                    WHERE segment_name = :1  AND ROWNUM = 1 GROUP BY tablespace_name' 
            INTO p_tsname, sum_bytes
            USING tmp_varchar1;
          END IF;
          IF sum_bytes < 1024 THEN
             sum_bytes := 1;
          ELSE
             sum_bytes := sum_bytes/1024;
          END IF;
        EXCEPTION WHEN NO_DATA_FOUND THEN
          sum_bytes := NULL;
        END;

        IF sum_bytes IS NOT NULL THEN
           idx:=idx + 1;
           rs_info(idx).tbs_name := p_tsname;
           rs_info(idx).seg_name := tmp_varchar1;
           rs_info(idx).status := p_status;
           rs_info(idx).next := tmp_num1/1024;
           rs_info(idx).max_ext := tmp_num2;
           rs_info(idx).status := p_status;
           rs_info(idx).inuse := sum_bytes;
           EXECUTE IMMEDIATE 
             'SELECT ROUND(SUM(DECODE(maxbytes, 0, 0,maxbytes-bytes)/1024))
                 FROM sys.dba_data_files WHERE tablespace_name=:1'
           INTO rs_info(idx).auto
           USING p_tsname;

           EXECUTE IMMEDIATE 
             'SELECT ROUND(SUM(DECODE(maxbytes, 0, 0,maxbytes-bytes)/1024))
                 FROM sys.dba_data_files WHERE tablespace_name=:1'
           INTO tmp_num1
           USING p_tsname;
        END IF;
      END LOOP;
      CLOSE tmp_cursor;
   END IF;  -- using undo tablespace, not rollback

   max_rs := idx;


-- *****************************************************************
-- Collect Log File Information
-- *****************************************************************

   idx := 0;
   OPEN tmp_cursor FOR 
        'SELECT lf.member as member, l.bytes as bytes, l.status as status, 
               l.group# as group# 
          FROM  v$logfile lf, v$log l 
          WHERE lf.group# = l.group#  AND l.bytes < ' || min_log_size || '
          ORDER BY l.status DESC';
   LOOP
     FETCH tmp_cursor INTO tmp_varchar1, tmp_num1, p_status, tmp_num3;
     EXIT WHEN tmp_cursor%NOTFOUND;
     idx := idx + 1;
     lf_info(idx).file_spec := tmp_varchar1;
     lf_info(idx).grp       := tmp_num3;
     lf_info(idx).bytes     := tmp_num1;
     lf_info(idx).status    := p_status;
   END LOOP;
   CLOSE tmp_cursor;

   max_lf := idx;


-- *****************************************************************
-- Collect Flashback Information
-- *****************************************************************

   flashback_info.active := FALSE;
   flashback_info.name := '';
   flashback_info.limit := 0;
   flashback_info.used := 0;
   flashback_info.reclaimable := 0;
   flashback_info.files := 0; 
   flashback_info.file_dest := '';
   flashback_info.dsize := 0;

   IF substr(db_version,1,2) <> '9.' THEN
     --
     -- Flashback exists in 10n and above
     -- 
     -- flashback_on can have several 'on' states but only
     -- one off, so check for 'no'
     --
     EXECUTE IMMEDIATE 'SELECT count(*) from v$database WHERE
                          flashback_on = ''NO'''
     INTO p_count;

     IF p_count <= 0 THEN
        --
        -- Get the rest of the flashback settings
        -- 
        flashback_info.active := TRUE;

        BEGIN
          EXECUTE IMMEDIATE 'SELECT rfd.name, rfd.space_limit, rfd.space_used, 
                      rfd.space_reclaimable, rfd.number_of_files,
                      vp1.value, vp2.value 
             FROM v$recovery_file_dest rfd, v$parameter vp1, v$parameter vp2
             WHERE UPPER(vp1.name) = ''DB_RECOVERY_FILE_DEST'' AND
                   UPPER(vp2.name) = ''DB_RECOVERY_FILE_DEST_SIZE'''
          INTO flashback_info.name, flashback_info.limit, flashback_info.used,
                  flashback_info.reclaimable, flashback_info.files, 
                  flashback_info.file_dest, flashback_info.dsize;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
               flashback_info.active := FALSE;
        END;
     END IF;
   END IF;

-- *****************************************************************
-- Collect Misc Information for Warnings
-- *****************************************************************

   -- Check for patch applied in DBs with registry
   BEGIN
      IF dbv IN (920,101) THEN  -- starting in 10.2, can't happen
         EXECUTE IMMEDIATE 
             'SELECT NULL FROM sys.registry$ 
              WHERE cid = ''CATPROC'' AND version != :inst_version'
         INTO p_null USING db_version;
         version_mismatch := TRUE;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for RAC
   BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM v$parameter 
            WHERE name = ''cluster_database'' AND value = ''TRUE'''
      INTO p_null;
      cluster_dbs := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for pre-existing DIP user in pre-10.1 databases
   BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM sys.user$ WHERE name=''DIP'''
      INTO p_null;
      IF dbv = 920 THEN
         dip_user_exists:=TRUE;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for ORACLE_OCM user and no OCM packages 
   IF dbv != 112 THEN
    BEGIN
      EXECUTE IMMEDIATE 'SELECT user# FROM sys.user$ WHERE name=''ORACLE_OCM'''
      INTO tmp_num1;
      BEGIN
         EXECUTE IMMEDIATE 'SELECT NULL FROM sys.obj$ WHERE owner# = :1 AND 
               name =''MGMT_DB_LL_METRICS'' AND  type# = 9'
         INTO p_null
         USING tmp_num1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN ocm_user_exists := TRUE;
      END;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN ocm_user_exists := FALSE;
    END;
   END IF;

   -- Check for APPQOSSYS user without WLM_METRICS_STREAM table
   IF dbv != 112 THEN
    BEGIN
      EXECUTE IMMEDIATE 'SELECT user# FROM sys.user$ WHERE name=''APPQOSSYS'''
      INTO tmp_num1;
      BEGIN
        EXECUTE IMMEDIATE 
          'SELECT NULL FROM sys.obj$ WHERE owner# = :1 AND ' ||
             'name =''WLM_METRICS_STREAM'' AND type# = 2'
        INTO p_null
        USING tmp_num1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN qos_user_exists := TRUE;
      END;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN qos_user_exists := FALSE;
    END;
   END IF;

   -- Check for Database Character Set for use of AL24UTFFSS
   BEGIN
       EXECUTE IMMEDIATE 
         'SELECT NULL FROM v$nls_parameters 
         WHERE parameter = ''NLS_CHARACTERSET'' AND value = ''AL24UTFFSS'''
       INTO p_null;
       nls_AL24UTFFSS := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;
 
   -- Check for supported NCHAR character set
   BEGIN
       EXECUTE IMMEDIATE 
         'SELECT NULL FROM v$nls_parameters WHERE parameter=''NLS_NCHAR_CHARACTERSET'' 
            AND value NOT IN (''UTF8'',''AL16UTF16'')'
       INTO p_null;
       UTF8_AL16UTF16 := TRUE;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
   END;
   
   -- Check for OWM replication
   IF cmp_info(owm).processed AND dbv IN (920, 101) THEN
      BEGIN
         -- Does this database have wmsys replication?
         EXECUTE IMMEDIATE 
            'SELECT NULL FROM sys.obj$ o, sys.user$ u 
               WHERE o.name = ''WM$REPLICATION_TABLE'' AND u.name=''WMSYS'' 
                 AND u.user#=o.owner# and o.type#=2'
         INTO p_null;
         EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM wmsys.wm$replication_table'
         INTO rows_processed;

         IF rows_processed >0 THEN
            -- Is the Advanced Replication option installed?
            EXECUTE IMMEDIATE 
              'SELECT NULL FROM v$option WHERE parameter = ''Advanced replication'' AND 
                        value=''TRUE'''
            INTO p_null;
            -- If we made it this far then this installation has
            -- replication installed and is using it for OWM
            owm_replication := TRUE;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
      END;
   END IF;
 
   -- Check for database links
   BEGIN
      IF dbv IN (920,101) THEN
         EXECUTE IMMEDIATE 
           'SELECT NULL FROM sys.link$ WHERE (password IS NOT NULL OR 
              authpwd IS NOT NULL) AND rownum <=1'
         INTO p_null;
         dblinks := TRUE;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for CDC streams
   BEGIN
      IF dbv IN (920, 101) THEN
         EXECUTE IMMEDIATE 'SELECT NULL 
             FROM sys.dba_capture cap, sys.dba_queues q, sys.dba_queue_tables qt
             WHERE substr(cap.capture_name,4) = substr(q.name,4) AND
                     substr(q.name,4) = substr(qt.queue_table,4) AND
                     cap.queue_owner = q.owner AND
                     cap.queue_name = q.name AND
                     q.owner = qt.owner AND
                     q.queue_table = qt.queue_table AND
                     rownum <= 1'
         INTO p_null;
         cdc_data := TRUE;
       END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for CONNECT role
   BEGIN
     IF dbv IN (920,101) THEN
        EXECUTE IMMEDIATE
          'SELECT NULL FROM sys.dba_role_privs WHERE granted_role = ''CONNECT'' AND 
             grantee NOT IN (
                ''SYS'', ''OUTLN'', ''SYSTEM'', ''CTXSYS'', ''DBSNMP'', 
                ''LOGSTDBY_ADMINISTRATOR'', ''ORDSYS'', ''ORDPLUGINS'', 
                ''OEM_MONITOR'', ''WKSYS'', ''WKPROXY'', ''WK_TEST'',  
                ''WKUSER'', ''MDSYS'', ''LBACSYS'', ''DMSYS'', ''WMSYS'', 
                ''OLAPDBA'', ''OLAPSVR'', ''OLAP_USER'', ''OLAPSYS'', ''EXFSYS'', 
                ''SYSMAN'', ''MDDATA'', ''SI_INFORMTN_SCHEMA'',''XDB'', ''ODM'') 
              AND rownum <= 1';
         connect_role := TRUE;
     END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for INVALID objects
   -- For "inplace" upgrades check for invalid objects that can be excluded
   -- as they may have changed between releases and don't need to be reported.
   -- For all other types of upgrades, use the simple query below to 
   -- eliminate running the intricate queries except when they are needed.
   -- Bug 4905742
   -- lrg 4944010: add GV$SQLAREA_PLAN_HASH and GV$ARCHIVE_GAP
   BEGIN
      IF NOT inplace THEN
        EXECUTE IMMEDIATE 'SELECT NULL FROM sys.dba_objects
            WHERE status = ''INVALID'' AND object_name NOT LIKE ''BIN$%'' AND 
               rownum <=1'
        INTO p_null;
      -- For 11.2 patch release - update the objects in the query below
      ELSE
        -- V_$ROLLNAME special cased because of references  to x$ tables
        EXECUTE IMMEDIATE 'SELECT NULL FROM SYS.DBA_OBJECTS
                WHERE status = ''INVALID'' AND object_name NOT LIKE ''BIN$%'' AND 
                   rownum <=1 AND
                   object_name NOT IN 
                      (SELECT name FROM SYS.dba_dependencies
                         START WITH referenced_name IN ( 
                              ''V$LOGMNR_SESSION'', ''V$ACTIVE_SESSION_HISTORY'',
                              ''V$BUFFERED_SUBSCRIBERS'',  ''GV$FLASH_RECOVERY_AREA_USAGE'',
                              ''GV$ACTIVE_SESSION_HISTORY'', ''GV$BUFFERED_SUBSCRIBERS'',
                              ''V$RSRC_PLAN'', ''V$SUBSCR_REGISTRATION_STATS'',
                              ''GV$STREAMS_APPLY_READER'',''GV$ARCHIVE_DEST'',
                              ''GV$LOCK'',''DBMS_STATS_INTERNAL'',''V$STREAMS_MESSAGE_TRACKING'',
                              ''GV$SQL_SHARED_CURSOR'',''V$RMAN_COMPRESSION_ALGORITHM'',
                              ''V$RSRC_CONS_GROUP_HISTORY'',''V$PERSISTENT_SUBSCRIBERS'',''V$RMAN_STATUS'',
                              ''GV$RSRC_CONSUMER_GROUP'',''V$ARCHIVE_DEST'',''GV$RSRCMGRMETRIC'',
                              ''GV$RSRCMGRMETRIC_HISTORY'',''V$PERSISTENT_QUEUES'',''GV$CPOOL_CONN_INFO'',
                              ''GV$RMAN_COMPRESSION_ALGORITHM'',''DBA_BLOCKERS'',''V$STREAMS_TRANSACTION'',
                              ''V$STREAMS_APPLY_READER'',''GV$SGA_DYNAMIC_FREE_MEMORY'',''GV$BUFFERED_QUEUES'',
                              ''GV$RSRC_PLAN_HISTORY'',''GV$ENCRYPTED_TABLESPACES'',''V$ENCRYPTED_TABLESPACES'',
                              ''GV$RSRC_CONS_GROUP_HISTORY'',''GV$RSRC_PLAN'',
                              ''GV$RSRC_SESSION_INFO'',''V$RSRCMGRMETRIC'',''V$STREAMS_CAPTURE'',
                              ''V$RSRCMGRMETRIC_HISTORY'',''GV$STREAMS_TRANSACTION'',''DBMS_LOGREP_UTIL'',
                              ''V$RSRC_SESSION_INFO'',''GV$STREAMS_CAPTURE'',''V$RSRC_PLAN_HISTORY'',
                              ''GV$FLASHBACK_DATABASE_LOGFILE'',''V$BUFFERED_QUEUES'',
                              ''GV$PERSISTENT_SUBSCRIBERS'',''GV$FILESTAT'',''GV$STREAMS_MESSAGE_TRACKING'',
                              ''V$RSRC_CONSUMER_GROUP'',''V$CPOOL_CONN_INFO'',''DBA_DML_LOCKS'',
                              ''V$FLASHBACK_DATABASE_LOGFILE'',''GV$HM_RECOMMENDATION'',
                              ''V$SQL_SHARED_CURSOR'',''GV$PERSISTENT_QUEUES'',''GV$FILE_HISTOGRAM'',
                              ''DBA_WAITERS'',''GV$SUBSCR_REGISTRATION_STATS'',
                              ''GV$SQLAREA_PLAN_HASH'',''GV$ARCHIVE_GAP'',
                              ''V$STREAMS_APPLY_SERVER'',''DBA_DDL_LOCKS'',
                              ''DBA_LOCK_INTERNAL'', ''V_$STREAMS_APPLY_SERVER'',
                              ''DBA_KGLLOCK'',''GV$LOGSTDBY_TRANSACTION'',
                              ''GV_$DATAFILE'', ''GV_$STREAMS_APPLY_SERVER'',
                              ''GV$STREAMS_APPLY_SERVER'', ''GV$DATAFILE'',
                              ''GV_$LOGSTDBY_TRANSACTION'',
                              ''GV$SYSTEM_EVENT'', ''V$SQL_MONITOR'',
                              ''GV$WLM_PCMETRIC'',''V$WLM_PCMETRIC'',
			      ''V$DB_OBJECT_CACHE'',''GV$LOGMNR_REGION'',
			      ''GV$ASM_DISK_STAT'',''GV$WLM_PCMETRIC_HISTORY'',
 			      ''V$WLM_PCMETRIC_HISTORY'',''V$DNFS_CHANNELS'',
			      ''V$HANG_INFO'',''GV$DNFS_STATS'',
                              ''GV$SESSION_CONNECT_INFO'',''GV$SQL_MONITOR'',
                              ''GV$ASM_OPERATION'',''V$DNFS_STATS'',
                              ''GV$DB_OBJECT_CACHE'',''GV$ARCHIVE_PROCESSES'',
                              ''GV$RESULT_CACHE_OBJECTS'',
''V$ARCHIVE_PROCESSES'',				      ''GV$ASM_DISK'',''V$LOGMNR_REGION'',
''V$RESULT_CACHE_OBJECTS'', ''GV$ROWCACHE'',''V$ROWCACHE'',''GV$PROCESS_MEMORY_DETAIL'',''V$PROCESS_MEMORY_DETAIL'',''GV$DLM_MISC'',''V$DLM_MISC'',''V$DELETED_OBJECT'',''GV$DELETED_OBJECT'',''GV$STREAMS_APPLY_COORDINATOR'',''V$STREAMS_APPLY_COORDINATOR'')
                                     AND referenced_type in (''VIEW'',''PACKAGE'') OR
                               name = ''V_$ROLLNAME''
                                  CONNECT BY
                                    PRIOR name = referenced_name and
                                    PRIOR type = referenced_type)'
        INTO p_null;
      END IF;
      invalid_objs := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- create a table to store invalid objects (create it if necessary)
   IF NOT db_readonly THEN
     tbl_exists := 0;
     EXECUTE IMMEDIATE
       'SELECT count(*) FROM dba_tables
          WHERE table_name = upper(''registry$sys_inv_objs'')'
      into tbl_exists;

     IF tbl_exists != 0 -- if registry$sys_inv_objs table exists
     THEN
       -- Truncate table first
       EXECUTE IMMEDIATE 'TRUNCATE TABLE registry$sys_inv_objs';

       -- Insert into table next
       EXECUTE IMMEDIATE
         'INSERT INTO registry$sys_inv_objs
          SELECT owner,object_name,object_type
            FROM sys.dba_objects
            WHERE status !=''VALID'' AND owner in (''SYS'',''SYSTEM'')
            ORDER BY owner';
     ELSE  -- if table does not exist
       -- Create invalid objects table and populate with all SYS and SYSTEM
       -- invalid objects
       EXECUTE IMMEDIATE
         'CREATE TABLE registry$sys_inv_objs
            AS
          SELECT owner,object_name,object_type
            FROM sys.dba_objects 
            WHERE status !=''VALID'' AND owner in (''SYS'',''SYSTEM'')
            ORDER BY owner';
     END IF;  -- IF/ELSE registry$sys_inv_objs exists

     -- If there are less than 5000 non-sys invalid objects then create 
     -- another table with non-SYS/SYSTEM owned objects.
     -- If there are more than 5000 total then that is too many
     -- for utluiobj.sql to handle so output a message.
     EXECUTE IMMEDIATE 'SELECT count(*) FROM sys.dba_objects 
            WHERE status !=''VALID'' AND owner NOT in (''SYS'',''SYSTEM'')'
     INTO nonsys_invalid_objs;
     IF nonsys_invalid_objs > 5000 THEN
        warning_5000 := TRUE;
     ELSE
       tbl_exists := 0;
       EXECUTE IMMEDIATE
         'SELECT count(*) FROM dba_tables
            WHERE table_name = upper(''registry$nonsys_inv_objs'')'
          into tbl_exists;
       IF tbl_exists != 0 -- if registry$nonsys_inv_objs table exists
       THEN
         -- Truncate table first
         EXECUTE IMMEDIATE 'TRUNCATE TABLE registry$nonsys_inv_objs';

         -- Insert into table next
         EXECUTE IMMEDIATE
           'INSERT INTO registry$nonsys_inv_objs
            SELECT owner,object_name,object_type
              FROM sys.dba_objects
              WHERE status !=''VALID'' AND owner NOT in (''SYS'',''SYSTEM'')
              ORDER BY owner';
       ELSE  -- if table does not exist
         -- Create invalid objects table and populate with non-SYS and
         -- non-SYSTEM invalid objects
         EXECUTE IMMEDIATE
           'CREATE TABLE registry$nonsys_inv_objs
              AS
            SELECT owner,object_name,object_type
              FROM sys.dba_objects
              WHERE status !=''VALID'' AND owner NOT in (''SYS'',''SYSTEM'')
              ORDER BY owner';
       END IF;  -- IF/ELSE registry$nonsys_inv_objs exists
     END IF;  -- IF/ELSE nonsys_invalid_objs > 5000

     COMMIT;
   END IF; -- db NOT readonly

   -- Check for externally authenticated SSL users
   BEGIN
     IF dbv IN (920,101) THEN
       EXECUTE IMMEDIATE 'SELECT NULL FROM sys.user$ 
             WHERE ext_username IS NOT NULL AND password = ''GLOBAL'' and rownum <=1'
       INTO p_null;
       ssl_users := TRUE;
     END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check whether source time zone file version is older or newer than target
   IF db_tz_version < utlu_tz_version THEN
    timezone_old := TRUE;
   ELSIF  db_tz_version > utlu_tz_version THEN
    timezone_new := TRUE;
   END IF;

   -- if EM is in the database then set em_exists to TRUE
   IF cmp_info(em).processed and dbv != 112 THEN
      em_exists := TRUE;
  END IF;

   -- ensure that all snapshot/mv refreshes are successfully completed
   BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM sys.obj$ o, sys.user$ u, sys.sum$ s 
           WHERE o.obj# = s.obj# AND  o.owner# = u.user# AND 
                 o.type# = 42 AND bitand(s.mflags, 8) = 8 AND
                 rownum <=1'
      INTO p_null;
      snapshot_refresh:= TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for files that need media recovery
   BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM v$recover_file WHERE rownum <=1'
         INTO p_null;
         recovery_files := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for files that are in backup mode
   BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM v$backup  WHERE 
           status != ''NOT ACTIVE'' AND rownum <=1'
         INTO p_null;
         files_backup_mode := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;
   
   -- Check for pending distribution txns
   BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM sys.dba_2pc_pending WHERE rownum <=1'
      INTO p_null;
       pending_2pc_txn   := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for standby environment to warn that standby database needs sync
   BEGIN
     EXECUTE IMMEDIATE 'SELECT NULL FROM v$parameter WHERE 
        name LIKE ''log_archive_dest%'' AND upper(value) LIKE ''SERVICE%''
         AND rownum <=1'
     INTO p_null;
       sync_standby_db   := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   --
   -- Check to detect if REDO configuration is supported with 11.2
   --
   --  For 11.2, REDO has changed its maximum number of remote redo transport 
   --  destinations from 9 to 30, we need to see if 10 is being used, and what 
   --  its default is, if its local, there is an error.
   --
   -- Condition 1) Archiving of log files is enabled
   --
   -- Condition 2) DB_RECOVERY_FILE_DEST is defined
   -- 
   -- Condition 3) No local destinations are defined
   -- 
   -- Condition 4) LOG_ARCHIVE_DEST_1 is in use, and is a remote destition
   -- 
   --
   -- Only continue if archive logging is on
   --
   IF db_log_mode = 'ARCHIVELOG' THEN
     --
     -- Check for db_recovery_file_dest
     --
     tmp_varchar1 := NULL;
     BEGIN
       EXECUTE IMMEDIATE 'SELECT vp.value FROM v$parameter vp WHERE  
                      UPPER(vp.NAME) = ''DB_RECOVERY_FILE_DEST''' 
       INTO tmp_varchar1; 

       EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
     END;
     IF tmp_varchar1 IS NOT NULL OR tmp_varchar1 != '' THEN
        --
        -- See if there are any local destinations defined
        -- Note the regexp_like 
        --
        IF dbv != 920 THEN -- use regexp_like
          EXECUTE IMMEDIATE '
            SELECT count(*) FROM v$parameter v 
               WHERE v.NAME  LIKE ''log_archive_dest_%'' AND 
                   REGEXP_LIKE(v.VALUE,''*[ ^]?location([ ])?=([ ])?*'')'
          INTO p_count;
        ELSE
          EXECUTE IMMEDIATE '
            SELECT count(*) FROM v$parameter v 
                WHERE v.NAME  LIKE ''log_archive_dest_%'' AND 
                      v.VALUE LIKE ''%location=%'''
          INTO p_count;
        END IF;

        IF p_count > 0 THEN
          --
          -- Next is _1 in use, and remote
          --
          EXECUTE IMMEDIATE '
            SELECT count(*) FROM v$archive_dest ad 
                WHERE ad.status=''VALID'' AND ad.dest_id=1 AND
                      ad.target=''STANDBY'''
          INTO p_count; 

          IF p_count = 1 then
             --
             -- There is an issue to report.
             --
             remote_redo_issue := TRUE;
          END IF; -- p_count = 1
        END IF;  -- having local dest values set
     END IF;  -- db_recovery_file_dest 
   END IF;

   --
   -- Check for Ultra Search in case it needs to be removed.
   --
   -- Once Ultra Search instance is created, wk$instance table is populated.
   -- The new logic determines if Ultra Search has data or not by looking up
   -- wk$instance table. WKSYS.WK$INSTANCE table exists when Ultra Search is
   -- installed. If it's not installed, WKSYS.WK$INSTANCE doesn't exist and the
   -- pl/sql block raises exception. In the exception block, nothing is done.
   -- In this case, ultrasearch_data variable has the default value, which is
   -- FALSE. 
   BEGIN
     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM wksys.wk$instance'
          INTO wk_index;
     -- wk_index will be = 0 when there are no rows in wksys.wk$instance
     -- so if NOT(wk_index = 0) then there is at least one row in
     -- wksys.wk$instance and an ultra search warning should be displayed
     IF NOT (wk_index = 0) THEN
       ultrasearch_data := TRUE;
     END IF;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN NULL;
     WHEN NO_SUCH_TABLE THEN NULL;
   END;

   --
   -- invalid log_archive_format check
   -- 
   -- for 9.x, RDBMS set a default value which did not include %r, 
   -- which is required by 11.2.
   -- Grab the format string, and if its defaulted or not, 
   -- Only dump out an error if its NOT defaulted (user set) and it is 
   -- missing the %r.
   --
   BEGIN 
     EXECUTE IMMEDIATE 
        'SELECT value, isdefault FROM v$parameter WHERE name = ''log_archive_format'''
     INTO laf_format_string, tmp_varchar1;
   EXCEPTION WHEN OTHERS THEN NULL;
   END;

   IF (tmp_varchar1 = 'FALSE') AND 
      (instr (LOWER(laf_format_string), '%r') = 0) THEN
     -- 
     -- no %[r|R] and we are not defaulted by the system - we have to report something...
     --
     laf_format := TRUE;
   END IF;

   --
   -- See if OrdImageIndex is being used 
   -- 
   -- The upgrade will remove them, so the misc warning section will
   -- let them know.
   --
   BEGIN
     EXECUTE IMMEDIATE
       'SELECT COUNT(*)  FROM sys.dba_indexes WHERE index_type = ''DOMAIN''
           and ityp_name = ''ORDIMAGEINDEX'''
     INTO p_count;
   EXCEPTION 
     WHEN OTHERS THEN NULL;
   END;
   IF (p_count > 0) THEN
      imageidx_used := TRUE;
   END IF;

   -- 
   -- check for recycle bin usage
   -- 
   -- We report if its on, and also if its off and not empty.
   --
   IF NOT (dbv=920) THEN
     -- Recycle bin didn't exist in 9.2
     IF (dbv=101) THEN
       -- for 10.1 its _recyclebin and TRUE/FALSE
       BEGIN
         EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''_recyclebin'''
         INTO p_value;
       EXCEPTION WHEN NO_DATA_FOUND THEN p_value := '';
       END;
       IF UPPER(p_value) = 'TRUE' THEN
          recyclebin_on := TRUE;
       END IF;
     ELSE
       -- for 10.2 and above its recyclebin and on/off
       BEGIN
         EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE name = ''recyclebin'''
         INTO p_value;
       EXCEPTION WHEN NO_DATA_FOUND THEN p_value := '';
       END;
       IF UPPER(p_value) = 'ON' THEN
            recyclebin_on := TRUE;
       END IF;
     END IF;
     -- Now get the number of objects in the recycle 
     -- bin (even if its off, used for reporting).
     -- Optimizer will attempt to execute some statements 
     -- even inside of an 'if' and since recyclebin does not
     -- exist in 9.2, play it safe and wrap it with execute immediate
     EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM sys.recyclebin$' 
     INTO recycle_objects;
   END IF;

   --
   -- Check for pre-existing temporary table sys.enabled$indexes.
   -- If it exists, then warn the user to DROP SYS.ENABLED$INDEXES.
   --
   BEGIN
     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM sys.enabled$indexes'
     INTO tbl_exists;
     IF (tbl_exists >= 0) THEN
       enabled_indexes_tbl := TRUE;
     END IF;
   EXCEPTION
      WHEN NO_SUCH_TABLE THEN NULL;
   END;

   -- Check for schemas with objects dependent on DBMS_LDAP package
     BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM dba_dependencies
           WHERE referenced_name IN (''DBMS_LDAP'')
           AND owner NOT IN (''SYS'',''PUBLIC'',''ORD_PLUGINS'')
           AND rownum <= 1'
      INTO p_null;
      dbms_ldap_dep := TRUE;
     EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
     END;

   --
   -- The owner of an editioning view must be editions-enabled before
   -- the editioning view is created. An existing 11.2.0.1 installation
   -- could possibly have non editions-enabled users that have editioning
   -- views in their schema. The dba will need to take action to enable 
   -- editions on the users found to fix this inconsistency in their data
   -- dictionary. There are three ways to remedy this:
   -- 1. drop these editioning views
   -- 2. editions enable the listed schemas 
   -- 3. replace the editioning views with regular views
   --
   IF dbv = 112 THEN
     BEGIN
     EXECUTE IMMEDIATE 'SELECT count(*) FROM SYS.DBA_EDITIONING_VIEWS EV, 
                                             SYS.DBA_USERS US
                                        WHERE US.USERNAME = EV.OWNER AND
                                              US.EDITIONS_ENABLED <> ''Y'' AND
                                              ROWNUM < 2'
       INTO ev_count;
      IF ev_count > 0 THEN
        edition_exists := TRUE;
      END IF;
     EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
     END;
   END IF;

   --
   -- Bug 12807768: On upgrades from pre-10205 (e.g. 9208, 10105, 10204 but
   -- not 10205) to 112, timed_statistics must be TRUE if statistics_level is
   -- not BASIC.  Else, db will not start up with the following errors:
   -- ORA-00044: timed_statistics must be TRUE when statistics_level is not
   --            BASIC
   -- ORA-01078: failure in processing system parameters
   --
   p_count := 0;
   timed_statistics_mbt := FALSE;
   IF (dbv in (920, 101)) OR (dbv = 102 AND patch <= '10.2.0.4')
   THEN
     EXECUTE IMMEDIATE 'SELECT count(1)
                        FROM v$parameter v1, v$parameter v2
                        WHERE lower(v1.name) = ''timed_statistics'' and
                                v1.value = ''FALSE'' and 
                                lower(v2.name) = ''statistics_level'' and
                                v2.value != ''BASIC'''
     INTO p_count;
     IF (p_count = 1) THEN
       timed_statistics_mbt := TRUE;
     END IF;
   END IF;  -- end of check for : TIMED_STATISTICS Must Be True

  -- end of timed_statistics_mbt check

-- *****************************************************************
-- Collect SYSAUX Information for Warnings
-- *****************************************************************

   IF dbv = 920 THEN
     BEGIN
       EXECUTE IMMEDIATE 'SELECT NULL FROM SYS.DBA_TABLESPACES
            WHERE tablespace_name = ''SYSAUX''' 
       INTO p_null;
        -- SYSAUX already exists, so check attributes
       sysaux_exists := TRUE;

       -- permanent
       BEGIN 
         EXECUTE IMMEDIATE 'SELECT NULL FROM SYS.DBA_TABLESPACES
             WHERE tablespace_name = ''SYSAUX'' 
                AND CONTENTS != ''PERMANENT''' 
         INTO p_null;
         sysaux_not_perm := TRUE;
       EXCEPTION
             WHEN NO_DATA_FOUND THEN NULL;
       END;

       -- online
       BEGIN
         EXECUTE IMMEDIATE 'SELECT NULL FROM SYS.DBA_TABLESPACES
              WHERE tablespace_name = ''SYSAUX'' AND
                     STATUS != ''ONLINE'''
         INTO p_null;
         sysaux_not_online := TRUE;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
       END;
 
       -- local extent management
       BEGIN
         EXECUTE IMMEDIATE 'SELECT NULL FROM SYS.DBA_TABLESPACES
            WHERE tablespace_name = ''SYSAUX'' AND
                 extent_management != ''LOCAL'''
         INTO p_null;
         sysaux_not_local := TRUE;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
       END;
       -- auto segment space management
       BEGIN 
         EXECUTE IMMEDIATE 'SELECT NULL FROM SYS.DBA_TABLESPACES
            WHERE tablespace_name = ''SYSAUX'' AND
                   segment_space_management != ''AUTO'''
         INTO p_null;
         sysaux_not_auto := TRUE;
       EXCEPTION
             WHEN NO_DATA_FOUND THEN NULL;
       END;

     EXCEPTION -- No SYSAUX tablespace
         WHEN NO_DATA_FOUND THEN NULL;
     END;
   END IF;  -- dbv 920

   -- Store away the default tablespaces for SYS and SYSTEM
   EXECUTE IMMEDIATE 'SELECT default_tablespace FROM sys.dba_users WHERE username = ''SYS'''  
   INTO sys_ts_default;
   EXECUTE IMMEDIATE 'SELECT default_tablespace FROM sys.dba_users WHERE username = ''SYSTEM'''
   INTO system_ts_default;

   -- Set flag if any _ params are in place.  The recommendations section will output
   -- the command needed to view them.
   -- Only output for interactive, dbua does their own thing.
   BEGIN
     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM sys.v$parameter WHERE name LIKE ''\_%'' ESCAPE ''\'''
     INTO n_status;
     IF (n_status >= 1) THEN
       hidden_params_in_use := TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   -- Set flag if any non-default events are present.  The recommendations section will output
   -- the commands needed to view them.
   -- Only output for interactive, dbua does their own thing.
   BEGIN
     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM sys.v$parameter2 WHERE (UPPER(name) = ''EVENT'' 
           OR UPPER(name)=''_TRACE_EVENTS'') AND isdefault=''FALSE'''
     INTO n_status;
     IF (n_status >= 1) THEN
         non_default_events := TRUE;
     END IF;
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   -- change to JOB_QUEUE_PROCESSES
   BEGIN
     EXECUTE IMMEDIATE 'SELECT value FROM v$parameter WHERE 
        name=''job_queue_processes'''
     INTO tmp_varchar1;
       job_queue_count := to_number(tmp_varchar1);
       IF job_queue_count = 0 THEN
         --
         -- Always an issue if zero
         --
         job_queue_issue := TRUE;
       ELSE
         IF ((cpu * cpu_threads) > 0) THEN
           -- We have a positive cpu*cpu_threads, warn 
           -- if job_queue_count is < that value
           IF (job_queue_count < (cpu*cpu_threads)) THEN
             job_queue_issue := TRUE;
           END IF;
           -- The else would be if cpu*cpu_threads
           -- is equal to, or less than zero, and
           -- that has nothing to do with a job_queue_issue
         END IF;
       END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;


-- *****************************************************************
-- END of Collect for WARNING
-- *****************************************************************

-- *****************************************************************
-- START of Collect for RECOMMENDATION 
-- *****************************************************************

   -- Check for DMSYS and running on 11.1 (otherwise do not recommend)
   -- Note for DBUA, this shows up under the WARNING section.
   IF dbv IN (111,112) THEN
    BEGIN
      EXECUTE IMMEDIATE 'SELECT NULL FROM sys.user$ WHERE name=''DMSYS'''
        INTO p_null;
      dmsys_recommendation := TRUE;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
    END;
   END IF;

   ---
   -- bug 12699712
   -- Get a row count of rows in aud$/fga_log$ that will be updated during
   -- db upgrade from 101/102/111.
   -- note: c0902000.sql updates null NTIMESTAMP# and DBID in AUD$ and FGA_LOG$
   -- note: c1101000.sql updates null DBID in AUD$ and FGA_LOG$
   ---
   IF dbv IN (101, 102, 111) THEN
     aud_upd_rowcnt := 0;
     fga_upd_rowcnt := 0;

     -- loop 2 times.  1st time for aud$.  2nd time for fga_log$.
     -- in 1st loop: find schema for aud$.  (schema can be 'SYS' or 'SYSTEM'.)
     -- in 2nd loop: no need to find schema for fga_log$, as it is 'SYS'.
     FOR i in 1..2 LOOP
       IF (i = 1) THEN
         BEGIN
           EXECUTE IMMEDIATE
             'SELECT u.name
                FROM obj$ o, user$ u
                WHERE o.name = ''AUD$'' and
                      o.type#=2 and
                      o.owner# = u.user# and
                      o.remoteowner is NULL and
                      o.linkname is NULL and
                      u.name in (''SYS'', ''SYSTEM'')'
             INTO p_schema;
         EXCEPTION
           WHEN OTHERS THEN p_schema := 'SYSTEM';
         END;
         p_value := 'AUD$';
       ELSIF (i = 2) THEN
         p_schema := 'SYS';
         p_value := 'FGA_LOG$';
       END IF;

       BEGIN
         EXECUTE IMMEDIATE
           'SELECT count(*) FROM ' || p_schema || '.' || p_value ||
             ' WHERE dbid is null'
           INTO p_count;
       EXCEPTION
         WHEN OTHERS THEN p_count := 0;
       END;
       IF (i = 1) THEN
         aud_upd_rowcnt := p_count;
       ELSIF (i = 2) THEN
         fga_upd_rowcnt := p_count;
       END IF;  -- end of if dbv = 101/102/111

     END LOOP;
   END IF;  -- IF dbv IN (101, 102, 111) THEN
   ---
   -- End of setting variables aud_upd_rowcnt and fga_upd_rowcnt
   ---


-- *****************************************************************
-- END of Collect Section
-- *****************************************************************

-- *****************************************************************
-- START of Calculate Section
-- *****************************************************************

-- *****************************************************************
-- Calculate Tablespace Requirements
-- *****************************************************************

   -- Look at all relevant tablespaces
   -- TS: loop per tablespace (ts_info(t).name)
   FOR t IN 1..max_ts LOOP
       delta_kbytes:=0;   -- initialize calculated tablespace delta

       IF ts_info(t).name = 'SYSTEM' THEN -- sum the component SYS kbytes
          FOR i IN 1..max_comps LOOP
              IF collect_diag_2 THEN
                IF cmp_info(i).processed = TRUE THEN
                  dbms_output.put_line('... ' || cmp_info(i).cid || ' Processed. ' || ' Default Tblspace ' || cmp_info(i).def_ts || '.');
                ELSE
                  dbms_output.put_line('... ' || cmp_info(i).cid || ' NOT Processed.');
                END IF;
              END IF;
              IF cmp_info(i).processed THEN
                IF cmp_info(i).install THEN  -- if component will be installed
                    delta_kbytes := delta_kbytes + cmp_info(i).ins_sys_kbytes;
                    IF collect_diag THEN
                       display_line('DIAG-CMPTS: SYSTEM ' || 
                             LPAD(cmp_info(i).cid, 10) ||
                             LPAD(cmp_info(i).ins_sys_kbytes/1024,10) || 'Mb'); 
                    ELSIF collect_diag_2 THEN
                       display_line('DIAG-CMPTS: SYSTEM ' || 
                             LPAD(cmp_info(i).cid, 10) || ' ToBeInstalled ' ||
                             LPAD(cmp_info(i).ins_sys_kbytes/1024,10) || 'Mb'); 
                    END IF;
                ELSE  -- if component is already in the registry
                    delta_kbytes := delta_kbytes + cmp_info(i).sys_kbytes;
                    IF collect_diag THEN
                       display_line('DIAG-CMPTS: SYSTEM ' || 
                                LPAD(cmp_info(i).cid, 10) ||
                                LPAD(cmp_info(i).sys_kbytes/1024,10) || 'Mb');
                    ELSIF collect_diag_2 THEN
                       display_line('DIAG-CMPTS: SYSTEM ' || 
                                LPAD(cmp_info(i).cid, 10) || ' IsInRegistry ' ||
                                LPAD(cmp_info(i).sys_kbytes/1024,10) || 'Mb');
                    END IF;
                END IF;
              END IF;  -- nothing to add if component is or will not be in
                       -- the registry
           END LOOP;
        END IF;  -- end of special SYSTEM tablespace processing
        -- TS: delta after looping through components in SYSTEM

        IF ts_info(t).name = 'SYSAUX' THEN -- sum the component SYSAUX kbytes
          FOR i IN 1..max_comps LOOP
            IF cmp_info(i).processed AND
                                  (cmp_info(i).def_ts = 'SYSAUX' OR
                                   cmp_info(i).def_ts = 'SYSTEM') THEN
              IF cmp_info(i).sysaux_kbytes >= cmp_info(i).def_ts_kbytes THEN
                delta_kbytes := delta_kbytes + cmp_info(i).sysaux_kbytes;
                IF collect_diag THEN
                  display_line('DIAG-CMPTS: SYSAUX ' || 
                                LPAD(cmp_info(i).cid, 10) || ' ' ||
                                LPAD(cmp_info(i).sysaux_kbytes/1024,10) ||
                                'Mb');
                END IF;
              ELSE
                delta_kbytes := delta_kbytes + cmp_info(i).def_ts_kbytes;
                IF collect_diag THEN
                  display_line('DIAG-CMPTS: SYSAUX ' || 
                                LPAD(cmp_info(i).cid, 10) || ' ' ||
                                LPAD(cmp_info(i).def_ts_kbytes/1024,10) ||
                                'Mb');
                END IF;
              END IF;

              -- bug 13060071 , modifed for 112 :  apex , xdb
              -- if xdb and apex are both in db, then add 30M 
              -- to sysaux if xdb resides in sysaux
              IF (cmp_info(i).cid = 'XDB'
                   AND cmp_info(apex).processed = TRUE) THEN
                delta_kbytes :=  delta_kbytes + (30*c_kb);
                IF collect_diag_2 THEN
                   display_line('DIAG-CMPTS: SYSAUX ' || 
                                 LPAD(cmp_info(i).cid, 10) || ' ' ||
                                   '(due to APEX) ' ||
                                 LPAD(30, 10) || 'Mb');
                 END IF;
              END IF;
            END IF;
          END LOOP;
        END IF;  -- end of special SYSAUX tablespace processing
        -- TS: sum delta for components in SYSAUX

        -- For tablespaces that are not SYSTEM:
        -- For tablespaces that are not SYSAUX:
        -- For tablespaces that are not UNDO:
        -- Now add in component default tablespace deltas
        -- def_tablespace_name is NULL for unprocessed comps
        IF (ts_info(t).name != 'SYSTEM' AND
            ts_info(t).name != 'SYSAUX' AND
            ts_info(t).name != db_undo_tbs) THEN
          FOR i IN 1..max_comps LOOP 
             IF (ts_info(t).name = cmp_info(i).def_ts AND
                  cmp_info(i).processed) THEN
                IF cmp_info(i).install THEN  -- use install amount
                   delta_kbytes := delta_kbytes + cmp_info(i).ins_def_kbytes;
                   IF collect_diag THEN
                      display_line('DIAG-CMPTS: ' || 
                                    RPAD(ts_info(t).name, 10) ||
                                    LPAD(cmp_info(i).cid, 10) || ' ' ||
                                    LPAD(cmp_info(i).ins_def_kbytes,10));   
                   END IF;
                ELSE  -- use default tablespace amount
                   -- bug 9664514
                   -- if apex version in the source db is older than the version
                   -- in target db, then apex upgrade include apex install;
                   -- estimate 180M for typical apex install.
                   --
                   -- note: this section is for space calculations for
                   -- tablespaces that are non-system and non-sysaux
                   delta_kbytes :=  delta_kbytes + cmp_info(i).def_ts_kbytes;
                   IF collect_diag THEN
                      display_line('DIAG-CMPTS: ' || 
                                    RPAD(ts_info(t).name, 10) ||
                                    LPAD(cmp_info(i).cid, 10) || ' ' ||
                                    LPAD(cmp_info(i).def_ts_kbytes/1024, 10) ||
                                    'Mb');
                      update_puiu_data('SCHEMA', 
                             ts_info(t).name || '-' || cmp_info(i).schema,
                             cmp_info(i).def_ts_kbytes);
                   END IF;
                END IF;
               
                -- bug 13060071 , modified for 112 :  apex , xdb
                -- if xdb and apex are both in db, then add 30M 
                -- more to xdb default tablespace
                IF (cmp_info(i).cid = 'XDB' AND
                     cmp_info(apex).processed = TRUE) THEN
                   delta_kbytes :=  delta_kbytes + (30*c_kb);
                   IF collect_diag_2 THEN
                     display_line('DIAG-CMPTS: ' ||
                                   RPAD(ts_info(t).name, 10) || ' ' ||
                                   LPAD(cmp_info(i).cid, 10) || ' ' ||
                                     '(due to APEX) ' ||
                                   LPAD(30, 10) || 'Mb');
                   END IF;
                END IF;
             END IF;
          END LOOP; -- end of default tablespace calculations 
        END IF;  -- end of if tblspace is not undo and not sysaux and not system
                 -- then add in component default tablespace deltas
        -- TS: sum delta for install in default tablespaces other than
        --          SYSAUX

        -- For tablespaces that are not undo:
        -- Now look for queues in user schemas
        IF ts_info(t).name != db_undo_tbs THEN
          EXECUTE IMMEDIATE 'SELECT count(*) FROM sys.dba_tables tb, sys.dba_queues q
             WHERE q.queue_table = tb.table_name AND
                 tb.tablespace_name = '' || ts_info(t).name || '' AND tb.owner NOT IN
                 (''SYS'',''SYSTEM'',''MDSYS'',''ORDSYS'',''OLAPSYS'',''XDB'',
                 ''LBACSYS'',''CTXSYS'',''ODM'',''DMSYS'', ''WKSYS'',''WMSYS'',
                 ''SYSMAN'',''EXFSYS'') '
          INTO delta_queues;
          IF delta_queues > 0 THEN
             IF collect_diag THEN
                display_line('DIAG-QUES: ' || 
                            RPAD(ts_info(t).name, 10) ||
                            ' QUEUE count = ' || delta_queues);
             END IF;
             -- estimate 48K per queue
             delta_kbytes := delta_kbytes + delta_queues*48; 
          END IF;
        END IF;  -- end of if tablespace is not undo
                 -- then look for queues in user schemas


        -- See if this is the temporary tablespace for SYS
        IF ts_is_SYS_temporary(ts_info(t).name) THEN
           delta_kbytes := delta_kbytes + 50*1024;  -- Add 50M for TEMP
        END IF;

        -- See if this is the UNDO tablespace - be sure at least 400M available
        IF ts_info(t).name = db_undo_tbs THEN
          ts_info(t).min := 400 * 1024;
          IF ts_info(t).alloc < ts_info(t).min THEN
            delta_kbytes := ts_info(t).min - ts_info(t).inuse;
          ELSE
            delta_kbytes := 0;
          END IF;
        END IF;  -- end of if this is the undo tablespace

        -- If DBUA output, then add in EM install if not in database
        IF display_XML THEN  
           IF NOT cmp_info(em).processed THEN
              IF ts_info(t).name = 'SYSTEM' THEN 
                 delta_kbytes := delta_kbytes + cmp_info(em).ins_sys_kbytes;
              ELSIF ts_info(t).name = 'SYSAUX' THEN
                 delta_kbytes := delta_kbytes + cmp_info(em).ins_def_kbytes;
              END IF;
           END IF;
        END IF;

        -- Put a 20% safety factor on DELTA and round it off
        delta_kbytes := ROUND(delta_kbytes*1.20);            

        -- Finally, save DELTA value
        ts_info(t).delta := delta_kbytes;

        -- Calculate here the recommendation for minimum tablespace size - it is
        -- the "delta" plus existing in use amount IF tablespace is not undo.
        -- Else if tablespace is undo, then minimum was already set above
        -- to 400M; therefore no need to calculate here.
        IF ts_info(t).name != db_undo_tbs THEN
          ts_info(t).min := ts_info(t).inuse + ts_info(t).delta;
        END IF;

        IF collect_diag THEN
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' used =    ' || LPAD(ts_info(t).inuse,10));
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' delta=    ' || LPAD(ts_info(t).delta,10));
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' total req=' || LPAD(ts_info(t).min,10));
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                           '    alloc=      ' || LPAD(ts_info(t).alloc,10));
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                           '    auto_avail= ' || LPAD(ts_info(t).auto,10));
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                           '    total avail=' ||  LPAD(ts_info(t).avail,10));
        END IF;

        -- put calculated delta into puiu$data if it exists
        update_puiu_data('TABLESPACE', ts_info(t).name, delta_kbytes);

        -- convert to MB and round up(min required)/down (alloc,avail,inuse)
        ts_info(t).min :=   CEIL(ts_info(t).min/1024);
        ts_info(t).alloc := ROUND((ts_info(t).alloc-512)/1024);
        ts_info(t).avail := ROUND((ts_info(t).avail-512)/1024);
        ts_info(t).inuse := ROUND((ts_info(t).inuse)/1024);

        -- Determine amount of additional space needed
        -- independent of autoextend on/off
        IF ts_info(t).min > ts_info(t).alloc THEN
           ts_info(t).addl  := ts_info(t).min - ts_info(t).alloc;
        ELSE
           ts_info(t).addl := 0;
        END IF;

        -- Do we have enough space in the existing tablespace?
        IF ts_info(t).min < ts_info(t).avail  THEN
           ts_info(t).inc_by := 0;
        ELSE
           -- need to add space
           ts_info(t).inc_by := ts_info(t).min - ts_info(t).avail; 
        END IF;

        -- Find at least one file in the tablespace with autoextend on.
        -- If found, then that tablespace has autoextend on; else not on.
        -- DBUA will use this information to add to autoextend
        -- or to check for total space on disk
        IF ts_info(t).addl > 0 OR ts_info(t).inc_by > 0 THEN
           ts_info(t).fauto := FALSE;
           IF ts_info(t).temporary AND
              ts_info(t).localmanaged THEN
             OPEN tmp_cursor FOR 
                  'SELECT file_name, autoextensible from sys.dba_temp_files ' ||
                   'where tablespace_name = :1' using ts_info(t).name;
           ELSE
             OPEN tmp_cursor FOR
                  'SELECT file_name, autoextensible from sys.dba_data_files ' ||
                   'where tablespace_name = :1' using ts_info(t).name;
           END IF;
           LOOP
             FETCH tmp_cursor INTO tmp_varchar1, tmp_varchar2;
             EXIT WHEN tmp_cursor%NOTFOUND;
             IF tmp_varchar2 = 'YES' THEN
               ts_info(t).fname := tmp_varchar1;
               ts_info(t).fauto := TRUE;
               EXIT;
             END IF;
           END LOOP;
           CLOSE tmp_cursor;
        END IF;

        IF collect_diag_2 THEN
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' additional space needed =    ' || LPAD(ts_info(t).addl,10) || 'Mb');
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' increment by =    ' || LPAD(ts_info(t).inc_by,10));
           display_line('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                           '    total avail=' ||  LPAD(ts_info(t).avail,10));
        END IF;


    END LOOP;  -- end of tablespace loop

-- *****************************************************************
-- Calculate SYSAUX Requirements for pre-10.1 databases
-- *****************************************************************

   delta_sysaux := 0;

   IF dbv = 920 THEN
   -- sum the component SYSAUX usage for earlier releases
      FOR i IN 1..max_comps LOOP
         IF cmp_info(i).processed THEN -- add upgrade amount
            -- TS: looks like if cmp_info(i).cid is installed, PROCESSED
            -- is also TRUE.  cmp_info(i).sysaux_kbytes is for upgrades.
            delta_sysaux := delta_sysaux + cmp_info(i).sysaux_kbytes;
            IF collect_diag THEN
               display_line('DIAG-CMPTS:  SYSAUX ' || 
                                  LPAD(cmp_info(i).cid, 10) || ' ' ||
                                  LPAD(cmp_info(i).sysaux_kbytes,10));   
            END IF;
         END IF;
          -- TS: set delta_sysaux as sum of ins_def_kbytes for sysaux
         IF cmp_info(i).install AND 
            cmp_info(i).def_ts = 'SYSAUX' THEN  -- add def_ts install amount also
            delta_sysaux := delta_sysaux + cmp_info(i).ins_def_kbytes;
            IF collect_diag THEN
               display_line('DIAG-CMPTS:  SYSAUX ' || 
                      LPAD(cmp_info(i).cid, 10) || ' ' ||
                      LPAD(cmp_info(i).ins_def_kbytes,10));   
            END IF;
         END IF;
       END LOOP;

       -- Add a base of 62000 bytes to our calculation
       delta_sysaux := delta_sysaux + 62000;

       IF collect_diag THEN
           display_line('DIAG-TS:   SYSAUX' || 
                              ' total req=' || LPAD(delta_sysaux,10));
       END IF;

    -- Put a 500MB (512000KB) floor on delta_sysaux
       IF delta_sysaux < 512000 THEN
          delta_sysaux := 512000;
       END IF;
   ELSE  -- SYSAUX handled as existing tablespace
     delta_sysaux := 0;
     -- TS: delta_sysaux is for if sysaux does not exist; else 
     --     ts_info(sysaux_tsinfo_idx).min
   END IF;

   delta_sysaux := ROUND(delta_sysaux/1024); -- convert to MB

-- *****************************************************************
-- END of Calculate Section
-- *****************************************************************

-- *****************************************************************
-- START of Display Section
-- *****************************************************************

   IF display_xml THEN
      display_header_and_db('value="' || vers || '"');
      display_flashback;
      display_parameters_xml;
      display_components;
      display_tablespaces;
      display_misc_warnings;
--    display_recommendations_xml called from display_misc_warnings
      display_line('</RDBMSUP>');
   ELSE
      display_header_and_db('');
      IF dbv = 920 THEN  -- database not upgraded yet
         display_logfiles;
      END IF;
      display_tablespaces;
      display_rollback_segs;
      display_flashback;
      display_parameters_text;
      display_components;
      display_misc_warnings;
      display_recommendations;
      IF dbv = 920 THEN
         display_sysaux;
      END IF;
   END IF;

-- *****************************************************************
-- END of Display Section
-- *****************************************************************

END;
/

SET SERVEROUTPUT OFF

-- *****************************************************************
-- END utlu112i.sql
-- *****************************************************************
