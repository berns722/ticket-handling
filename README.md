# Ticket Handling Analytics

SQL analysis and Power BI dashboard exploring operational performance 
of a customer support platform across 1,000 tickets, 50 agents, and 
300 customers across the US, Canada, and Mexico.

## Key Findings

- **Agent workload is uneven** — top agent handled 36 tickets while 
the lowest handled 11, a 3x difference suggesting imbalanced distribution.
- **Global satisfaction averages 3.04/5** — moderate performance with 
131 customers (43.6%) giving at least one score below 3.
- **Resolution rate is low at 20.2%** — only 1 in 5 tickets reaches 
resolved status. Two agents show 0% resolution rate.
- **Ticket volume declined in 2023** — peaking in May 2022, suggesting 
either improved platform stability or reduced customer activity.
- **US generates ~50% of ticket volume** — proportional to customer base, 
indicating no country-specific support issues.

## Dashboard

Four analytical views built in Power BI connected directly to MySQL:

```
Workload      — agent ticket distribution (top/bottom 10)
Satisfaction  — global avg, agent performance, geographic demand map
Resolution    — resolution rates by agent (top/bottom 10)
Trends        — monthly volume 2022-2023, volume by country
```

## Data Model

Star schema with `tickets` as the central fact table linking `agents` 
and `customers` dimension tables. Enables cross-filtering across all 
dashboard visuals. Customer location data spans 20 cities across 
US, Canada, and Mexico.

## Project Structure

```
ticket-handling/
├── data/                        # gitignored
├── queries/
│   └── analysis.sql             # 15 SQL queries, exploratory and analytical
├── dashboard/
│   └── helpdesk_dashboard.pbix  # Power BI dashboard
└── README.md
```

## SQL Techniques Used

Window functions, CTEs, subqueries, JOINs, aggregate functions, 
date functions, conditional aggregation.

## Tools

MySQL, Power BI Desktop, DAX