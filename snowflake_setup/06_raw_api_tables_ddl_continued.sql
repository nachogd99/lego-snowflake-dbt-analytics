-- Create Tables in Snowflake
-- These steps were reverse-engineered, as the actual loading of data was done using Snowflake's UI and Load Wizard

create or replace TABLE API_MISSING_PART_CATEGORIES (
	ID NUMBER(38,0),
	NAME VARCHAR(16777216)
);