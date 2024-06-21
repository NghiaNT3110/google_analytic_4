with prep as (
select
    /* Select User field */ 
    user_pseudo_id,
    event_date,
    event_name,
    traffic_source.name AS traffic_name,
    traffic_source.source AS traffic_source,
    traffic_source.medium AS traffic_medium,
    device.category AS device_category,
    device.web_info.browser AS browser,
    geo.country as country, 
    geo.city as city,

    /* Select Session field */ 
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    CASE WHEN 
    (select value.string_value from unnest(event_params) where key = 'session_engaged') = '1' 
    THEN (select value.int_value from unnest(event_params) where key = 'ga_session_id')
    ELSE NULL
    END AS session_engaged_id,
    max((select value.int_value from unnest(event_params) where key = 'ga_session_number')) as session_number,
    min(parse_date('%Y%m%d',event_date)) as session_date,
    sum((select value.int_value from unnest(event_params) where key = 'engagement_time_msec')) as engagement_time_msec,
    first_value(min(parse_date('%Y%m%d',event_date))) over (partition by user_pseudo_id order by min(event_date) rows between unbounded preceding and unbounded following) as first_session_date,
from
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
group by ALL )

select
    distinct concat(extract(isoyear from first_session_date),'-',format('%02d',extract(isoweek from first_session_date))) as year_week,
    concat('week ',date_diff(session_date,first_session_date,isoweek)) as retention_week,
    user_pseudo_id as active_users,
    session_engaged_id as engaged_session,
    session_id as total_session, 
    event_name, traffic_name,traffic_source,traffic_medium,device_category,browser, country, city,event_date 
from
    prep
group by
    ALL
order by
    year_week
