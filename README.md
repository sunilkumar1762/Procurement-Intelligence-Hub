# Procurement-Intelligence-Hub

## Business Problem

A large enterprise was managing procurement activities across multiple departments and vendors. Procurement data was scattered across transactional systems and Excel reports, making it difficult for leadership to gain a consolidated view of spending patterns and procurement performance.

As a result, the organization faced several challenges:

1. Limited visibility into procurement spending: Decision-makers could not easily identify where money was being spent across categories, departments, and vendors.
2. Inefficient vendor management: There was no structured way to monitor vendor performance, evaluate preferred vendor utilization, or identify high-spend vendors contributing significantly to procurement costs.
3. Delayed reporting and manual effort: Procurement teams relied heavily on manually prepared reports, leading to delays, inconsistencies, and increased chances of reporting errors.
4. Difficulty in tracking procurement efficiency: Stakeholders lacked insights into purchase order statuses, emergency purchases, payment trends, and operational bottlenecks.
Inability to monitor trends proactively: Without historical comparisons and time-based analysis, leadership could not assess whether procurement performance was improving or deteriorating over time.

These challenges limited the organization's ability to control costs, optimize vendor relationships, and make timely, data-driven procurement decisions.

## Objective

To design and develop an interactive Procurement Analytics Dashboard that transforms raw procurement data into actionable insights, enabling stakeholders to monitor performance, identify trends, and make data-driven decisions.

---

## Solution Approach

### Data Modeling

* Designed a Star Schema data model consisting of Fact and Dimension tables.
* Established relationships between Procurement, Vendor, Date, Department, Category, and Payment Status dimensions.
* Ensured efficient filter propagation and scalable reporting.

### Data Transformation

* Prepared and structured the dataset using Power Query.
* Created calculated measures using DAX to support business KPIs.

### Dashboard Development

Developed multiple report pages tailored to different stakeholder needs:

#### Executive Overview

Provided a high-level snapshot of:

* Total Spend
* Total Paid Amount
* Invoice Amount
* Transaction Volume
* Vendor Count
* Department and Category-wise Spend

#### Payment Analytics

Enabled monitoring of:

* Open, Closed, Approved, and Cancelled Purchase Orders
* Payment trends and status distribution
* Procurement efficiency metrics

#### Procurement Analytics

Focused on:

* Purchase order trends
* Emergency purchase analysis
* Preferred vendor utilization
* Category-wise procurement insights

#### Vendor Analytics

Delivered insights into:

* Top vendors by spend
* Vendor ratings and distribution
* Preferred vs Non-Preferred vendor analysis
* Vendor spend contribution

#### Trends Analysis

Used advanced DAX calculations to identify:

* Year-to-Date (YTD) Spend
* Month-to-Date (MTD) Spend
* Previous Year comparisons
* Rolling 3-Month Spend
* Year-over-Year (YoY) Growth trends

---

## Advanced Power BI Features Implemented

* Star Schema Data Modeling
* DAX-based Time Intelligence
* Rolling Window Calculations
* Context Transition using CALCULATE
* Drill Through Navigation
* Static Row-Level Security (RLS)
* Dynamic RLS Concepts and Security Design
* Interactive Slicers and Cross-filtering

---

## Business Outcomes

1. Reduced manual reporting effort by ~70% by consolidating procurement, payment, and vendor data into a centralized Power BI analytics solution.
2. Improved reporting turnaround time from hours to minutes through interactive self-service dashboards and automated DAX-driven calculations.
3. Enabled 100% visibility into procurement operations, providing stakeholders with real-time insights into spend, payment status, vendor performance, and purchase order trends.
4. Accelerated decision-making by implementing drill-through analysis and time-intelligence metrics (YTD, MTD, Rolling 3-Month, and YoY), enabling faster identification of spending patterns and procurement bottlenecks.
---

## Technologies Used

* Power BI Desktop
* DAX
* Power Query
* Microsoft Excel
* Star Schema Modeling

