# SPA

## SQL Performance Analyzer Workflow

1. Capture the SQL workload that you intend to analyze and store it in a SQL tuning set.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @create_sts.sql
    !

2. Load the SQL tuning set.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @load_sts_from_awr.sql
    !

3. Create a SQL Performance Analyzer task.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @create_analysis_task.sql
    !

4. Build the pre-change SQL trial by test executing or generating execution plans for the SQL statements stored in the SQL tuning set.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @execute_spa_task.sql
    !

5. Perform the system change.

6. Build the post-change SQL trial by re-executing the SQL statements in the SQL tuning set on the post-change test system.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @execute_spa_task.sql
    !

7. Compare and analyze the pre-change and post-change versions of performance data, and generate a report to identify the SQL statements that have improved, remained unchanged, or regressed after the system change.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @compare_performance.sql
    !

8. Tune any regressed SQL statements that are identified.