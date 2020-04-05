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
COLUMN segment_owner FORMAT a30
COLUMN segment_name FORMAT a30
COLUMN segment_type FORMAT a20
COLUMN tablespace_name FORMAT a30
COLUMN partition_name FORMAT a30
COLUMN lob_column_name FORMAT a30

BREAK ON segment_owner ON segment_name ON segment_type

SELECT  segment_owner,
        segment_name,
        segment_type,
        tablespace_name,
        partition_name,
        lob_column_name
FROM    (TABLE(DBMS_SPACE.OBJECT_DEPENDENT_SEGMENTS(objowner => '&schema', objname => '&object', partname => NULL, objtype => &type)));
