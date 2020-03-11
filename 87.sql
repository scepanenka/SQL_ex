WITH x AS (SELECT ID_psg,
                  town_from,
                  CASE WHEN town_to = 'Moscow' THEN 1 ELSE 0 END                    to_msk,
                  ROW_NUMBER() OVER (PARTITION BY ID_psg ORDER BY "date", time_out) rw
           FROM Pass_in_trip a
                    JOIN Trip b ON a.trip_no = b.trip_no)
SELECT (SELECT name FROM Passenger WHERE ID_psg = x.ID_psg), SUM(to_msk)
FROM x
GROUP BY ID_psg
HAVING SUM(CASE WHEN town_from = 'Moscow' AND rw = 1 THEN 1 ELSE 0 END) = 0
   AND SUM(to_msk) > 1;