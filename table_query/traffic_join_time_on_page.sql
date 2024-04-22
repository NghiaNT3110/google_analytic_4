WITH traffic AS(
SELECT
  event_date,
  user_pseudo_id AS user_id,
  (SELECT value.string_value
    FROM
      UNNEST (event_params)
    WHERE
      key='page_title'
  ) as `Page_title`,
  (SELECT value.string_value
    FROM
      UNNEST (event_params)
    WHERE
      key='page_location'
  ) as `Page_location`,
  (
    SELECT
      value.int_value
    FROM
      UNNEST (event_params)
    WHERE
      key='ga_session_id'
  ) as `Session_id`,

  traffic_source.source ||"/"|| traffic_source.medium AS traffic_name,
  traffic_source.source AS traffic_source,
  traffic_source.medium AS traffic_medium,
  device.category AS device_category,
  device.web_info.browser AS browser,
  geo.country, geo.city,
  event_name,

  CASE WHEN 
    event_name = 'first_visit' THEN 'New User'
    ELSE 'Return User'
    END AS user_type, 

  CASE WHEN 
  event_name LIKE '%view_item'
  OR event_name LIKE '%add_to_cart%'
  OR event_name LIKE '%begin_check%'
  OR event_name LIKE '%select_item%'
  OR event_name LIKE '%add%'
  OR event_name LIKE '%select_promo%'
  OR event_name LIKE '%purchase%'
  THEN 'TRUE'
  ELSE 'FALSE' 
  END AS is_conversion, 

  CASE WHEN 
    event_name = 'purchase' THEN ecommerce.transaction_id 
    ELSE NULL 
    END AS transaction_ID,
COUNTIF(event_name ='page_view') AS page_view,
COUNTIF(event_name ='view_item') AS view_item,
COUNTIF(event_name ='view_promotion') AS view_promotion,
COUNTIF(event_name ='add_to_cart') AS add_to_cart,
COUNTIF(event_name ='begin_checkout') AS begin_checkout,
COUNTIF(event_name ='select_item') AS select_item,
COUNTIF(event_name ='add_shipping_info') AS add_shipping_info,
COUNTIF(event_name ='add_payment_info') AS add_payment_info,
COUNTIF(event_name ='select_promotion') AS select_promotion,
COUNTIF(event_name ='purchase') AS purchase,
COUNTIF(event_name ='first_visit') AS new_user 
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_date BETWEEN '20200101' AND '20211231'
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,15,16 
ORDER BY purchase DESC
),
time_on_page AS (
SELECT
  event_date,
  user_pseudo_id AS user_id,
  ga_session_id.value.int_value as session_id,
  page_location.value.string_value AS page_location,
  AVG(event_params.value.int_value)/1000 AS time_on_page,
  TIMESTAMP_DIFF(TIMESTAMP_MICROS(MAX(event_timestamp)), TIMESTAMP_MICROS(MIN(event_timestamp)), SECOND) as time_on_session 
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST (event_params) as ga_session_id,
  UNNEST(event_params) AS page_location,
  UNNEST(event_params) AS event_params
  
WHERE
  page_location.key = 'page_location' 
  AND ga_session_id.key = 'ga_session_id' 
  AND event_params.key = 'engagement_time_msec'
GROUP BY ALL 
ORDER BY time_on_page, time_on_session DESC 
),
engagement AS (
  SELECT
    event_date,
    user_pseudo_id AS user_id,
    (
      SELECT
        value.string_value
      FROM
        UNNEST(event_params)
      WHERE
        key = 'session_engaged'
    ) AS session_engaged
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_date BETWEEN '20200101' AND '20211231'
    AND event_name = 'first_visit' -- Assuming 'first_visit' event indicates session engagement
  GROUP BY 1, 2, 3
)

/* JOIN MODE */ 
SELECT t.*, p.time_on_page, p.time_on_session,
ROUND(100 * COUNT(e.user_id) / COUNT(DISTINCT t.user_id), 2) AS engagement_rate
FROM traffic t 
LEFT JOIN time_on_page p ON t.event_date = p.event_date AND t.Session_id = p.session_id AND t.Page_location = p.page_location 
LEFT JOIN engagement e ON t.event_date = e.event_date AND t.user_id = e.user_id
GROUP BY ALL
