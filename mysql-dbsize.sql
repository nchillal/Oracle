SELECT      table_schema "Data Base Name",
            SUM(data_length + index_length) / 1024 / 1024 "Data Base Size in MB",
            SUM(data_free)/ 1024 / 1024 "Free Space in MB"
FROM        information_schema.TABLES
GROUP BY    table_schema;
