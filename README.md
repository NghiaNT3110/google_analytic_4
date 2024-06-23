# google_analytic_4
- Data Source: GA4 Sample Dataset on Big Query. The dataset have a range of date from 01-11-2020 to 31-01-2021 (3 months). Here is the dataset name that you can copy when querying: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
(`big-query-378507.analytics_402516150.events_*` is the dataset that exported from my GA4 Account to my Big Query Account to test metrics and tables) 
- Data Storage: The data after transformed will be save as Big Query table format, expired in 60 days (Big Query SandBox/Free Tier only)
- Data Schema Details: You can check more at here: [Data Schema Guide](https://support.google.com/analytics/answer/7029846?hl=en&sjid=5908776957046870674-AP#zippy=%2Cdevice%2Cgeo%2Capp-info%2Ccollected-traffic-source%2Ctraffic-source%2Cstream-v%C3%A0-platform%2Cecommerce%2Citems)
- Discrepancy between Big Query & GA4 Data: [Discrepancy between Event Data Guide](https://support.google.com/analytics/answer/13578783?hl=en#zippy=%2Cin-this-article) & [Differences in session counts](https://support.google.com/analytics/answer/9191807) & [Unique count approximation in Google Analytics](https://developers.google.com/analytics/blog/2022/hll)
- Transform Data Methods: SQL - You can check SQL code in the folders Table Query (Still Updating)
- Dashboard link: [Looker Studio Dashboard Link](https://lookerstudio.google.com/u/0/reporting/340387ca-9899-443f-9c5a-ec1888f3738b/page/iJatD) (Outline and visuals are done; only the discrepancy between BigQuery & GA4 data about Time on Page, and Time on Session needs to be checked again)
- DA Document: [Case 4 Document](https://docs.google.com/document/d/1xxNSRvjalUrD3OdPDSYltqy2LV4jfPSkEjiMXYyDdTY)
