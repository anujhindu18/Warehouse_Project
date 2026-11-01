-- Create database
CREATE DATABASE Warehouse;
GO

-- Use database
USE Warehouse;
GO

-- Create schemas
CREATE SCHEMA bronze; -- Raw data
GO

CREATE SCHEMA silver; -- Cleaned data
GO

CREATE SCHEMA gold; -- Business-ready data
GO
