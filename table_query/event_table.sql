SELECT
  event_date,
  user_pseudo_id AS user_id,
  traffic_source.source ||"/"|| traffic_source.medium AS traffic_name,
  traffic_source.source AS traffic_source,
  traffic_source.medium AS traffic_medium,
  device.category AS device_category,
  device.web_info.browser AS browser,
  geo.country, geo.city,
  event_name,
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
  FROM
  `big-query-378507.analytics_402516150.events_*`
  ORDER BY event_date DESC
