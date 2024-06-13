WITH traffic AS (
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

  /* Mark Engaged Session ID */ 
  CASE WHEN 
    (select value.string_value from unnest(event_params) where key = 'session_engaged') = '1' 
    THEN (select value.int_value from unnest(event_params) where key = 'ga_session_id')
    ELSE NULL
    END AS session_engaged_id,

  traffic_source.source ||"/"|| traffic_source.medium AS traffic_name,
  traffic_source.source AS traffic_source,
  traffic_source.medium AS traffic_medium,
  device.category AS device_category,
  device.web_info.browser AS browser,
  geo.country, geo.city,
  event_name,
  
/* Mark Conversion Event is TRUE */ 
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
FROM
  `big-query-378507.analytics_402516150.events_*`
GROUP BY ALL 
ORDER BY page_view DESC
),
time_on_page AS (
  select
    event_date, 
    user_pseudo_id,
    (SELECT value.string_value
    FROM
      UNNEST (event_params)
    WHERE
      key='page_location'
  ) as `Page_location`,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    sum((select value.int_value from unnest(event_params) where key = 'engagement_time_msec'))/1000 as time_on_page,
     (max(event_timestamp)-min(event_timestamp))/1000000 as time_on_session
from
   `big-query-378507.analytics_402516150.events_*`
group by
    event_date,
    user_pseudo_id,
    Page_location,
    session_id
)
SELECT t.*, p.time_on_page, p.time_on_session, 
ROUND(100 * COUNT(DISTINCT t.session_engaged_id) / COUNT(DISTINCT t.Session_id), 2) AS engagement_rate,
100 - ROUND(100 * COUNT(DISTINCT t.session_engaged_id) / COUNT(DISTINCT t.Session_id), 2) AS bounce_rate
FROM traffic t
LEFT JOIN time_on_page p ON t.Session_id = p.session_id AND t.Page_location = p.Page_location AND t.event_date = p.event_date 
GROUP BY ALL
ORDER BY t.page_view DESC 
