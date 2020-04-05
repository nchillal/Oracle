-- Tables in MSSM (Manual Segment Space Management) tablespaces
EXEC DBMS_STATS.GATHER_TABLE_STATS('&owner','&table_name');

SELECT  owner,
        table_name,
        ROUND((blocks*8),2)||' kb' "TABLE SIZE",
        ROUND((num_rows*avg_row_len/1024),2)||' kb' "ACTUAL DATA"
FROM    dba_tables
WHERE   table_name='&table_name';

-- LOBs in MSSM(Manual Segment Space Management) tablespaces
-- The size of the LOB segment can be found by querying dba_segments, as follows:
SELECT  bytes
FROM    dba_segments
WHERE   segment_name ='&lob_segment_name'
AND     owner ='&table_owner';

-- To get the details of the table to which this LOB segment belong to:
SELECT  table_name,
        column_name
FROM    dba_lobs
WHERE   OWNER = '&owner'
AND     segment_name= '&lob_segment_name';

-- Check the space that is actually allocated to the LOB data
SELECT  SUM(DBMS_LOB.GETLENGTH(&lob_column_name))
FROM    &table_name;

-- The difference between these two is free space and/or undo space. It is not possible to assess the actual empty space using the queries above alone, because of the UNDO segment size, which is virtually impossible to assess.



-- ASSM (Automatic Segment Space Management) tablespaces
-- To find fragmentation at TABLE level
SET SERVEROUTPUT ON
DECLARE
    v_unformatted_blocks NUMBER;
    v_unformatted_bytes NUMBER;
    v_fs1_blocks NUMBER;
    v_fs1_bytes NUMBER;
    v_fs2_blocks NUMBER;
    v_fs2_bytes NUMBER;
    v_fs3_blocks NUMBER;
    v_fs3_bytes NUMBER;
    v_fs4_blocks NUMBER;
    v_fs4_bytes NUMBER;
    v_full_blocks NUMBER;
    v_full_bytes NUMBER;
BEGIN
    DBMS_SPACE.SPACE_USAGE ('&segment_owner', '&segment_name', '&segment_type', v_unformatted_blocks,
    v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
    v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes);
    DBMS_OUTPUT.PUT_LINE('Total number of blocks unformatted = '||v_unformatted_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 0 to 25% free space = '||v_fs1_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 25 to 50% free space = '||v_fs2_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 50 to 75% free space = '||v_fs3_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 75 to 100% free space = '||v_fs4_blocks);
    DBMS_OUTPUT.PUT_LINE('Total number of blocks full in the segment = '||v_full_blocks);
end;
/

-- To find fragmentation at partition level
SET SERVEROUTPUT ON
DECLARE
    v_unformatted_blocks NUMBER;
    v_unformatted_bytes NUMBER;
    v_fs1_blocks NUMBER;
    v_fs1_bytes NUMBER;
    v_fs2_blocks NUMBER;
    v_fs2_bytes NUMBER;
    v_fs3_blocks NUMBER;
    v_fs3_bytes NUMBER;
    v_fs4_blocks NUMBER;
    v_fs4_bytes NUMBER;
    v_full_blocks NUMBER;
    v_full_bytes NUMBER;
BEGIN
    DBMS_SPACE.SPACE_USAGE ('&segment_owner', '&segment_name', '&segment_type', v_unformatted_blocks,
    v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
    v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes, '&partition_name');
    DBMS_OUTPUT.PUT_LINE('Total number of blocks unformatted = '||v_unformatted_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 0 to 25% free space = '||v_fs1_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 25 to 50% free space = '||v_fs2_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 50 to 75% free space = '||v_fs3_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 75 to 100% free space = '||v_fs4_blocks);
    DBMS_OUTPUT.PUT_LINE('Total number of blocks full in the segment = '||v_full_blocks);
end;
/

-- To find fragmentation LOBs
SET SERVEROUTPUT ON
DECLARE
    v_unformatted_blocks NUMBER;
    v_unformatted_bytes NUMBER;
    v_fs1_blocks NUMBER;
    v_fs1_bytes NUMBER;
    v_fs2_blocks NUMBER;
    v_fs2_bytes NUMBER;
    v_fs3_blocks NUMBER;
    v_fs3_bytes NUMBER;
    v_fs4_blocks NUMBER;
    v_fs4_bytes NUMBER;
    v_full_blocks NUMBER;
    v_full_bytes NUMBER;
BEGIN
    DBMS_SPACE.SPACE_USAGE ('&owner', '&lob_segment_name', 'LOB', v_unformatted_blocks,
    v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
    v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes);
    DBMS_OUTPUT.PUT_LINE('Total number of blocks unformatted = '||v_unformatted_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 0 to 25% free space = '||v_fs1_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 25 to 50% free space = '||v_fs2_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 50 to 75% free space = '||v_fs3_blocks);
    DBMS_OUTPUT.PUT_LINE('Number of blocks having at least 75 to 100% free space = '||v_fs4_blocks);
    DBMS_OUTPUT.PUT_LINE('Total number of blocks full in the segment = '||v_full_blocks);
end;
/

-- To find fragmentation Securefile LOBs
SET SERVEROUTPUT ON
DECLARE
    v_segment_size_blocks NUMBER;
    v_segment_size_bytes NUMBER;
    v_used_blocks NUMBER;
    v_used_bytes NUMBER;
    v_expired_blocks NUMBER;
    v_expired_bytes NUMBER;
    v_unexpired_blocks NUMBER;
    v_unexpired_bytes NUMBER;
BEGIN
    DBMS_SPACE.SPACE_USAGE ('&owner', '&securefile_segment_name', 'LOB', v_segment_size_blocks, v_segment_size_bytes, v_used_blocks, v_used_bytes, v_expired_blocks, v_expired_bytes, v_unexpired_blocks, v_unexpired_bytes);
    DBMS_OUTPUT.PUT_LINE('Segment size in blocks = '||v_segment_size_blocks);
    DBMS_OUTPUT.PUT_LINE('Used Blocks = '||v_used_blocks);
    DBMS_OUTPUT.PUT_LINE('Expired Blocks = '||v_expired_blocks);
    DBMS_OUTPUT.PUT_LINE('Unxpired Blocks = '||v_unexpired_blocks);
end;
/
