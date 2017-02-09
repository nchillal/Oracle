SELECT  index_name, table_name, partitioning_type, partition_count, locality, alignment 
FROM    all_part_indexes 
WHERE   index_name='&index_name';
