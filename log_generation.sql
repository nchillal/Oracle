SELECT * 
FROM  (
      SELECT  first_time, TO_CHAR(first_time, 'DD-MON-YYYY') AS d, TO_CHAR(first_time, 'HH24') AS h
      FROM    v$log_history      
      )
PIVOT (
      COUNT(TO_CHAR(first_time, 'DD-MON-YYYY')) 
      FOR h IN  (
                '00' as H00,
                '01' as H01,
                '02' as H02,
                '03' as H03,
                '04' as H04,
                '05' as H05,
                '06' as H06,
                '07' as H07,
                '08' as H08,
                '09' as H09,
                '10' as H10,
                '11' as H11,
                '12' as H12,
                '13' as H13,
                '14' as H14,
                '15' as H15,
                '16' as H16,
                '17' as H17,
                '18' as H18,
                '19' as H19,
                '20' as H20,
                '21' as H21,
                '22' as H22,
                '23' as H23
                )
)
ORDER BY TO_DATE(d)
/
