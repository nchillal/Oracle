-- For the parameter, objtype must be specified by one of the following numbers:
--  object_type_table = 1
--  obje ct_type_nested_table = 2
--  object_type_index = 3
--  object_type_cluster = 4
--  object_type_table_partition = 7
--  object_type_index_partition = 8
--  object_type_table_subpartition = 9
--  object_type_index_subpartition = 10
--  object_type_mv = 13
--  object_type_mvlog = 14

SET LINESIZE 200
COLUMN segment_owner FORMAT a25
COLUMN segment_name FORMAT a25
COLUMN segment_type FORMAT a20
COLUMN tablespace_name FORMAT a20
COLUMN partition_name FORMAT a20
COLUMN lob_column_name FORMAT a12

SELECT  segment_owner,
        segment_name,
        segment_type,
        tablespace_name
FROM    (TABLE(dbms_space.object_dependent_segments(objowner => '&schema', objname => '&object', partname => NULL, objtype => &type)));
