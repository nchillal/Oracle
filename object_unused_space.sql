SET SERVEROUTPUT ON
DECLARE
  TOTAL_BLOCKS              number;
  TOTAL_BYTES               number;
  UNUSED_BLOCKS             number;
  UNUSED_BYTES              number;
  LAST_USED_EXTENT_FILE_ID  number;
  LAST_USED_EXTENT_BLOCK_ID number;
  LAST_USED_BLOCK           number;
BEGIN
  dbms_space.unused_space('&schema','&object','&type', TOTAL_BLOCKS, TOTAL_BYTES, UNUSED_BLOCKS, UNUSED_BYTES, LAST_USED_EXTENT_FILE_ID, LAST_USED_EXTENT_BLOCK_ID, LAST_USED_BLOCK);
  dbms_output.put_line('-----------------------------------');
  dbms_output.put_line('           UNUSED SPACE            ');
  dbms_output.put_line('-----------------------------------');
  dbms_output.put_line('TOTAL_BLOCKS              = '||TOTAL_BLOCKS);
  dbms_output.put_line('TOTAL_BYTES               = '||TOTAL_BYTES);
  dbms_output.put_line('UNUSED_BLOCKS             = '||UNUSED_BLOCKS);
  dbms_output.put_line('UNUSED BYTES              = '||UNUSED_BYTES);
  dbms_output.put_line('LAST_USED_EXTENT_FILE_ID  = '||LAST_USED_EXTENT_FILE_ID);
  dbms_output.put_line('LAST_USED_EXTENT_BLOCK_ID = '||LAST_USED_EXTENT_BLOCK_ID);
  dbms_output.put_line('LAST_USED_BLOCK           = '||LAST_USED_BLOCK);
END;
/

SET SERVEROUTPUT ON
DECLARE
  su NUMBER;
  sa NUMBER;
BEGIN
  dbms_space.object_space_usage('&segment_owner', '&segment_name', '&segment_type', NULL, su, sa);
  dbms_output.put_line('Space Used: '|| ROUND(TO_CHAR(su)/1024, 2)||' K');
  dbms_output.put_line('Space Allocated: ' || ROUND(TO_CHAR(sa)/1024, 2)||' K');
END;
/
