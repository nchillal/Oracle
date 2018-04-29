SELECT  file_type,
        percent_space_used,
        percent_space_used * p.value / 100 / 1024 / 1024 "MB Used",
        percent_space_reclaimable,
        number_of_files,
        percent_space_reclaimable * p.value / 100 / 1024 / 1024 "MB Reclaimable"
FROM    v$flash_recovery_area_usage f, v$parameter p
WHERE   p.name='db_recovery_file_dest_size'; 
