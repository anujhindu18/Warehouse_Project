EXEC bronze.load_bronze
create or alter procedure bronze.load_bronze as 
begin 
	DECLARE @Start_time datetime, @end_time datetime;
	BEGIN TRY
		PRINT'========================================================'
		PRINT'Loading Bronze Layer'
		PRINT'========================================================'
	
		PRINT'--------------------------------------------------------'
		PRINT'Loading crm tables'
		PRINT'--------------------------------------------------------'
		set @start_time = getdate();
		PRINT 'TRUNCATING TABLE : bronze.crm_cust_info'
		truncate table bronze.crm_cust_info;
		PRINT 'INSERT DATA INTO : bronze.crm_cust_info'
		bulk insert bronze.crm_cust_info
		from 'C:\Users\anujs\Downloads\sql-data-warehouse-project\datasets\source_crm/cust_info.csv'
		with (
			firstrow =2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> Duration time'+ cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'----------------------------------------'

		set @start_time = getdate();
		PRINT 'TRUNCATING TABLE : bronze.crm_prd_info '
		truncate table bronze.crm_prd_info;

		PRINT 'INSERT DATA INTO :bronze.crm_prd_info '
		bulk insert bronze.crm_prd_info
		from 'C:\Users\anujs\Downloads\sql-data-warehouse-project\datasets\source_crm/prd_info.csv'
		with (
			firstrow =2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> Duration time'+ cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'----------------------------------------'

		set @start_time = getdate();
		PRINT 'TRUNCATING TABLE : crm_sales_details '
		truncate table bronze.crm_sales_details;
		PRINT 'INSERT DATA INTO : bronze.crm_sales_details '
		bulk insert bronze.crm_sales_details
		from 'C:\Users\anujs\Downloads\sql-data-warehouse-project\datasets\source_crm/sales_details.csv'
		with (
			firstrow =2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> Duration time'+ cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'----------------------------------------'
		PRINT'--------------------------------------------------------'
		PRINT'loading erp tables'
		PRINT'--------------------------------------------------------'
		set @start_time = getdate();
		PRINT 'TRUNCATING TABLE : bronze.erp_CUST_AZ12  '
		truncate table bronze.erp_CUST_AZ12;
		PRINT 'INSERT DATA INTO : bronze.erp_CUST_AZ12 '
		bulk insert bronze.erp_CUST_AZ12
		from 'C:\Users\anujs\Downloads\sql-data-warehouse-project\datasets\source_erp/CUST_AZ12.csv'
		with (
			firstrow =2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> Duration time'+ cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'----------------------------------------'

		set @start_time = getdate();
		PRINT 'TRUNCATING TABLE : bronze.erp_px_cat_g1v2  '
		truncate table bronze.erp_px_cat_g1v2;
		PRINT 'INSERT DATA INTO : bronze.erp_px_cat_g1v2  '
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\anujs\Downloads\sql-data-warehouse-project\datasets\source_erp/px_cat_g1v2.csv'
		with (
			firstrow =2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> Duration time'+ cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'----------------------------------------'

		set @start_time = getdate();
		PRINT 'TRUNCATING TABLE : bronze.erp_loc_a101; '
		truncate table bronze.erp_loc_a101;
		PRINT 'INSERT DATA INTO : bronze.erp_loc_a101  '
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\anujs\Downloads\sql-data-warehouse-project\datasets\source_erp/px_cat_g1v2.csv'
		with (
			firstrow =2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = getdate();
		print '>> Duration time'+ cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'----------------------------------------'
	END TRY
	BEGIN CATCH
		PRINT'============================================='
		PRINT'ERROR OCCUPIED DURING LOADING BRONZE LAYER'
		PRINT'ERROR MESSAGE' +CAST( ERROR_MESSAGE() AS NVARCHAR);
		PRINT'ERROR NUMBER' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'============================================='
	END CATCH

end
