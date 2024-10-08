USE restaurant_db;

CREATE INDEX idx_reservation_status ON restaurant_reservations (status);
CREATE INDEX idx_reservation_month ON restaurant_reservations (MONTH(reservation_date));
CREATE INDEX idx_reservation_date_time ON restaurant_reservations (reservation_date, reservation_time); -- Композитний індекс

-- Використання CTE для підрахунку кількості бронювань для кожного клієнта
WITH client_reservations AS (
    SELECT
        r.client_id,
        COUNT(r.reservation_id) AS reservation_count
    FROM
        restaurant_reservations AS r
    WHERE
        r.status = 'confirmed'
    GROUP BY
        r.client_id
),

-- Використання другого CTE для отримання деталей клієнтів і столів
reservation_details AS (
    SELECT
        r.reservation_id,
        r.reservation_date,
        r.reservation_time,
        c.name,
        c.surname,
        t.table_number,
        t.location,
        t.capacity,
        r.guests_count,
        r.status,
        cr.reservation_count
    FROM
        restaurant_reservations AS r
    JOIN
        restaurant_clients AS c ON r.client_id = c.client_id
    JOIN
        restaurant_tables AS t ON r.table_id = t.table_id
    LEFT JOIN
        client_reservations AS cr ON r.client_id = cr.client_id
    WHERE
        r.status = 'confirmed'
        AND MONTH(r.reservation_date) = 12
)

-- Основний запит для вибору всіх підтверджених бронювань за грудень з деталями та сортуванням
SELECT
    reservation_id,
    reservation_date,
    reservation_time,
    CONCAT(name, ' ', surname) AS client_name,
    table_number,
    location,
    capacity,
    guests_count,
    reservation_count
FROM
    reservation_details
ORDER BY
    reservation_date,
    reservation_time;   
