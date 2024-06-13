This folder contains SQL files for querying tables required for analytics and visualization purposes. The dashboard has 3 main Section: Traffic Overview, Page URL Review, E-com Review 
1 - Event Table - Section 2 - Done: 
Columns in the Table: User ID, Session ID, Date, URL, traffic name, traffic source, traffic medium, country, city, device, browser, event name 
2 - Purchase Table - Section 3 - Done: 
Columns in the Table: User ID, Date, URL, items name, brand, price, quantity, revenue, Transaction ID, tax, traffic name, source, medium, Session ID, Country, City, Device, Browser
3 - Traffic Table - Section 1 & Section 2 - Done: 
Columns in the Table: User ID, date, Page name, URL, traffic name, source, medium, Session ID, Country, City, Device, Browser, event name, Transaction ID, is conversion event, page view
4 - Time Web Table - Section 1 & Section 2 - Ongoing: 
Columns in the Table: = Traffic Table + Time on Page + Time on Session + Engagement Rate + Bounce Rate 
(Still Updating with these metrics: time on page, time on session, engagement rate when joining with the traffic table)
- Cohort Analysis Table - Section 2 - Ongoing: 
Columns in the Table: Still updating
===
Note about Discrepancy between Big Query & GA4 Data: https://support.google.com/analytics/answer/13578783?hl=en#zippy=%2Cin-this-article
