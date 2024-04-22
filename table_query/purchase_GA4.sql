SELECT
  event_date,
  user_pseudo_id AS user_id,
  traffic_source.name AS traffic_name,
  traffic_source.source AS traffic_source,
  traffic_source.medium AS traffic_medium,
  device.category AS device_category,
  device.web_info.browser AS browser,
  geo.country, geo.city,

  /* Unnest page URL */ 
  (SELECT value.string_value
    FROM
      UNNEST (event_params)
    WHERE
      key='page_location'
  ) as `Page_location`,

  /* Get items field */ 
  items.item_name AS items_name,
  items.item_brand AS items_brand,
  items.price AS items_price,
  items.quantity AS items_quantity,
  items.item_category AS items_category,
  
 /* Add Item revenue and Transaction ID when event name = purchase */  
  CASE WHEN 
    event_name = 'purchase' THEN items.price * items.quantity 
  ELSE NULL 
  END AS items_revenue,

  CASE WHEN 
    event_name = 'purchase' THEN ecommerce.transaction_id 
    ELSE NULL 
    END AS transaction_ID,
    ecommerce.tax_value as tax_value 
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
/* Unnest items field and filter purchase event only */ 
  UNNEST (items) as items
  WHERE event_name ='purchase'
GROUP BY ALL 
ORDER BY
  items_revenue DESC
