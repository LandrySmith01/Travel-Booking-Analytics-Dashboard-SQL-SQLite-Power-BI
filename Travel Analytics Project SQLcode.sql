
SELECT
    c.channel_name,
    COUNT(*) AS completed_bookings,
    ROUND(SUM(b.booking_amount), 2) AS completed_revenue
FROM bookings AS b
JOIN channels AS c
    ON b.channel_id = c.channel_id
WHERE b.status = 'Completed'
GROUP BY c.channel_name
ORDER BY completed_revenue DESC;



SELECT
    c.channel_name,
    COUNT(*) AS completed_bookings,
    ROUND(SUM(b.booking_amount), 2) AS completed_revenue,
    ROUND(AVG(b.booking_amount), 2) AS average_booking_value
FROM bookings AS b
JOIN channels AS c
    ON b.channel_id = c.channel_id
WHERE b.status = 'Completed'
GROUP BY c.channel_name
ORDER BY completed_revenue DESC;




SELECT
    c.channel_name,
    COUNT(*) AS total_bookings,
    SUM(
        CASE
            WHEN b.status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_bookings,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN b.status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM bookings AS b
JOIN channels AS c
    ON b.channel_id = c.channel_id
GROUP BY c.channel_name
ORDER BY cancellation_rate_pct DESC;


SELECT
    COUNT(*) AS total_bookings,
    SUM(
        CASE
            WHEN status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_bookings,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS overall_cancellation_rate_pct
FROM bookings;


SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN booking_amount IS NULL THEN 1 ELSE 0 END)
        AS missing_amounts,
    SUM(CASE WHEN booking_date IS NULL OR TRIM(booking_date) = ''
        THEN 1 ELSE 0 END) AS missing_dates
FROM bookings;


SELECT COUNT(*) AS original_booking_rows
FROM bookings;

SELECT
    COUNT(*) AS cleaned_bookings,
    SUM(CASE
        WHEN status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_bookings,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'Cancelled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM bookings
WHERE booking_amount IS NOT NULL
  AND booking_date IS NOT NULL;
  
  SELECT
    c.channel_name,
    COUNT(*) AS total_bookings,
    SUM(CASE
        WHEN b.status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_bookings,
    ROUND(
        100.0 * SUM(CASE
            WHEN b.status = 'Cancelled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM bookings AS b
JOIN channels AS c
    ON b.channel_id = c.channel_id
WHERE b.booking_amount IS NOT NULL
  AND b.booking_date IS NOT NULL
GROUP BY c.channel_name
ORDER BY cancellation_rate_pct DESC;

SELECT
    c.channel_name,
    COUNT(*) AS total_bookings,
    SUM(CASE
        WHEN b.status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_bookings,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*)
         FROM bookings
         WHERE booking_amount IS NOT NULL
           AND booking_date IS NOT NULL),
        2
    ) AS share_of_all_bookings_pct
FROM bookings AS b
JOIN channels AS c
    ON b.channel_id = c.channel_id
WHERE b.booking_amount IS NOT NULL
  AND b.booking_date IS NOT NULL
GROUP BY c.channel_name
ORDER BY total_bookings DESC;