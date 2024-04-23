WITH time AS (
SELECT
  event_date,
  user_pseudo_id AS user_id,
  (
    SELECT
      value.int_value
    FROM
      UNNEST (event_params)
    WHERE
      key='ga_session_id'
  ) as `Session_id`,
  
  TIMESTAMP_DIFF(TIMESTAMP_MICROS(MAX(event_timestamp)), TIMESTAMP_MICROS(MIN(event_timestamp)), SECOND) as time_on_session 
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY ALL 
ORDER BY  time_on_session DESC 
)
SELECT AVG(time_on_session)
FROM time t
