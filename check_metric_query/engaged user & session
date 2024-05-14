WITH engagement AS (
    SELECT 
    event_date, 
   case when (select value.string_value from unnest(event_params) where key = 'session_engaged') >= '1' 
   then (select value.int_value from unnest(event_params) where key = 'ga_session_id')
   end as engaged_sessions,
   case when (select value.string_value from unnest(event_params) where key = 'session_engaged') >= '1' 
   then (select user_pseudo_id)
   end as engaged_user
from
    `big-query-378507.analytics_402516150.events_*`
)
SELECT 
event_date, 
COUNT(DISTINCT(engaged_sessions)) as engage_s,
COUNT(DISTINCT(engaged_user)) as engage_u
FROM engagement 
GROUP BY 1
ORDER BY 3 DESC 
