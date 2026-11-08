# Warehouse_Project

## Warehouse Data Analysis Project

A Data Warehouse project built using **SQL Server and Power BI** to manage, clean, transform, and analyze warehouse data. The project follows the Medallion Architecture (Bronze, Silver, and Gold layers) to organize data and prepare it for meaningful analysis.

## Tools & Technologies
- SQL Server (SSMS)
- Power BI
- Git & GitHub

## Project Architecture

The project follows the Medallion Architecture:

- **Bronze Layer:** Stores raw CRM and ERP data loaded from CSV files.
- **Silver Layer:** Cleans, transforms, and standardizes data from the Bronze Layer.
- **Gold Layer:** Will contain business-ready data for reporting and analytics.

## Progress — November 2, 2026
- Created `Warehouse` database.
- Created Bronze, Silver, and Gold schemas.
- Developed the `bronze.load_bronze` stored procedure.
- Loaded CRM and ERP CSV files using `BULK INSERT`.
- Implemented error handling and load-duration tracking.
- Created the data flow diagram.

## Progress — November 8, 2026
- Created the `silver.load_silver` stored procedure.
- Implemented data transformation from Bronze to Silver.
- Cleaned CRM customer, product, and sales data.
- Transformed ERP customer, location, and product category data.
- Handled NULL values, duplicate records, and inconsistent data.
- Applied SQL functions such as `TRIM()`, `CASE`, `ISNULL()`, `ROW_NUMBER()`, and `LEAD()`.
- Implemented `TRY...CATCH` error handling.
- Added individual table start time, end time, and execution duration tracking.
- Organized the Silver loading process into separate CRM and ERP sections.

## Next Steps
- Validate Silver Layer data.
- Build Gold Layer tables and views.
- Perform business analysis using SQL.
- Develop interactive Power BI dashboards.
- Generate insights into inventory, stock levels, product movement, and warehouse performance.

## Project Goal

To build an end-to-end Data Warehouse solution using SQL Server and Power BI, following industry-standard ETL processes and Medallion Architecture to transform raw data into meaningful business insights.
