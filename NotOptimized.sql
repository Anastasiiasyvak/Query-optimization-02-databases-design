use restaurant_db;

SELECT
    r.reservation_id,
    r.reservation_date,
    r.reservation_time,
    (SELECT CONCAT(c.name, ' ', c.surname)
     FROM restaurant_clients c
     WHERE c.client_id = r.client_id) AS client_name,
    (SELECT t.table_number
     FROM restaurant_tables t
     WHERE t.table_id = r.table_id) AS table_number,
    (SELECT t.location
     FROM restaurant_tables t
     WHERE t.table_id = r.table_id) AS location,
    (SELECT t.capacity
     FROM restaurant_tables t
     WHERE t.table_id = r.table_id) AS capacity,
    r.guests_count,
    (SELECT COUNT(*)
     FROM restaurant_reservations r2
     WHERE r2.client_id = r.client_id AND r2.status = 'confirmed') AS reservation_count
FROM
    restaurant_reservations r
WHERE
    r.status = 'confirmed'
    AND MONTH(r.reservation_date) = 12
ORDER BY
    r.reservation_date,
    r.reservation_time;
