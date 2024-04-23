SELECT 
  event_name, 
  COUNT (event_name) as event_count,
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY 1
ORDER BY 
  event_count desc 
