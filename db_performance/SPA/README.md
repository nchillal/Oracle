# SPA

## SQL Performance Analyzer Workflow

1. Capture the SQL workload that you intend to analyze and store it in a SQL tuning set.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @create_sts.sql
    !

2. Create a SQL Performance Analyzer task.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @create_analysis_task.sql
    !

3. Build the pre-change SQL trial by test executing or generating execution plans for the SQL statements stored in the SQL tuning set.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @execute_spa_task.sql
    !

4. Perform the system change.

5. Build the post-change SQL trial by re-executing the SQL statements in the SQL tuning set on the post-change test system.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @execute_spa_task.sql
    !

6. Compare and analyze the pre-change and post-change versions of performance data, and generate a report to identify the SQL statements that have improved, remained unchanged, or regressed after the system change.

    ```SHELL
    sqlplus -s / as sysdba <<!
    @compare_performance.sql
    !

7. Tune any regressed SQL statements that are identified.