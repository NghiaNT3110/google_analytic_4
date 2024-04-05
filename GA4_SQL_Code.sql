SELECT
  event_date,
  ga_session_id.value.int_value as session_id,/* Select data type for GA session ID */ 
  traffic_source.name AS traffic_name,
  traffic_source.source AS traffic_source,
  traffic_source.medium AS traffic_medium,
  page_title.value.string_value AS page_title, /* Select data type for page title */
  page_location.value.string_value AS page_location, /* Select data type for page location */
  page_referrer.value.string_value AS page_referrer, /* Select data type for page reffer */
  
  /* Select Device and Geography Field */ 
  device.category AS device_category,
  device.web_info.browser,
  geo.country, geo.city,
  event_name,

  /* Select Items Field */ 
  items.item_name AS items_name,
  items.item_brand AS items_brand,
  items.price AS items_price,
  items.quantity AS items_quantity,
  
  /* Calculate revenue from price and quantity */
  CASE WHEN 
    event_name = 'purchase' THEN items.price * items.quantity 
  ELSE 0
  END AS items_revenue, 
  ecommerce.purchase_revenue,
  items.item_category AS items_category,

  COUNT('page_location') AS page_view, /* Count if to filter only page_view event - Check lại */

  AVG(event_params.value.int_value)/1000 AS avg_time_on_page, /* Calculate time on page */
  TIMESTAMP_DIFF(TIMESTAMP_MICROS(MAX(event_timestamp)), TIMESTAMP_MICROS(MIN(event_timestamp)), SECOND) AS session_duration_second,/* Calculate Time on Session */
  COUNT(DISTINCT(user_pseudo_id)) AS total_users, /* Calculate Total User */ 
  Count(DISTINCT(ga_session_id.value.int_value)) as total_session, /* Calculate Total Session */ 

FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS page_title, /* Unnest event_params to get page title */
  UNNEST(event_params) AS page_location, /* Unnest event_params to get page location */
  UNNEST(event_params) AS page_referrer, /* Unnest event_params to get page reffer */
  UNNEST (event_params) as ga_session_id, /* Unnest event_params to get session_id */
  UNNEST(event_params) AS event_params, /* Unnest event_params to get event filed */
  UNNEST(items) AS items  /* Unnest items to get items filed */

WHERE
  event_date BETWEEN '20200101' AND '20211231' /* Date range filter */
  AND page_title.key = 'page_title' /* Get the page title filed */
  AND page_location.key = 'page_location' /* Get the page location field */
  AND page_referrer.key = 'page_referrer' /* Get the page reffer field */ 
  AND ga_session_id.key = 'ga_session_id' /* Get GA session ID */ 
  AND event_params.key = 'engagement_time_msec'/* Get the engagement time field */

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
ORDER BY
  items_revenue DESC;
