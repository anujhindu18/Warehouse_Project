CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Inserting Data Into: silver.crm_cust_info';
			insert into silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)

			select 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			case 
				when UPPER(TRIM(cst_gndr)) ='S' then 'Single'
				when UPPER(TRIM(cst_gndr)) ='M' then 'Married'
				else 'Unknown'
			end cst_marital_status,
			case 
				when UPPER(TRIM(cst_gndr)) ='F' then 'Female'
				when UPPER(TRIM(cst_gndr)) ='M' then 'Male'
				else 'Unknown'
			end cst_gndr,
			cst_create_date
			from (
			select * ,
			row_number() over (partition by cst_id order by cst_create_date desc ) as flag_list
			from bronze.crm_cust_info 
			where cst_id is not null  
			)t 
			where flag_list =1 ;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Inserting Data Into: silver.crm_prd_info';
	
		insert into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt)


		SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
		SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost,0) as prd_cost,
		case 
			when upper(Trim(prd_line)) = 'M' then 'Mountain'
			when upper(Trim(prd_line)) = 'R' then 'Road'
			when upper(Trim(prd_line)) = 'S' then 'Other Sales'
			when upper(Trim(prd_line)) = 'T' then 'Touring'
			else 'n/a'
		end prd_line,
		cast(prd_start_dt as Date) as prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as Date) as prd_end_dt
		FROM bronze.crm_prd_info
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;
	PRINT '>> Inserting Data Into: silver.crm_sales_details';
	insert  into  silver.crm_sales_details(
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
   )
select 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case when sls_order_dt =0 or len(sls_order_dt) != 8 then null
    else cast(cast(sls_order_dt as nvarchar(40)) as date)
    end sls_order_dt ,
    case when sls_ship_dt =0 or len(sls_ship_dt) != 8 then null
    else cast(cast(sls_ship_dt as nvarchar(40)) as date)
    end sls_ship_dt ,
    case when sls_due_dt =0 or len(sls_due_dt) != 8 then null
    else cast(cast(sls_due_dt as nvarchar(40)) as date)
    end sls_due_dt ,
case 
    when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)
        then sls_quantity*abs(sls_price)
        else sls_sales
    end  as sls_sales,
    sls_quantity,
    case
        when sls_price is null or sls_price <=0 
        then sls_sales /nullif(sls_quantity,0)
        else sls_price
    end as sls_price
    from bronze.crm_sales_details
	SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;
	PRINT '>> Inserting Data Into: silver.erp_cust_az12';
	insert into silver.erp_CUST_AZ12(cid,bdate,gen)
		select 
			case when cid like 'NAS%' THEN SUBSTRING(cid,4,len(cid))
			else cid
		end cid,
		case 
			when bdate >getdate()  then null
			else bdate
		end bdate,
		 case when  gen = null or gen =' ' then 'n\a'
				when gen ='F' THEN  'Female'
				when gen ='M' THEN  'Male'
			else gen
		end gen
		FROM bronze.erp_cust_az12;
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting Data Into: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101(cid, cntry)

			SELECT
				CASE
					WHEN LEN(REPLACE(cid, '-', '')) < 6 THEN NULL
					ELSE REPLACE(cid, '-', '')
				END AS cid,

				CASE
					WHEN country IN ('US', 'USA') THEN 'United State of America'
					WHEN country = 'DE' THEN 'Germany'
					WHEN TRIM(country) = '' OR country IS NULL THEN 'n/a'
					ELSE country
				END AS cntry
				FROM bronze.erp_loc_a101;
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
		insert into silver.erp_px_cat_g1v2(
		id ,
		cat,
		subcat,
		maintenance)

		select id ,
		cat,
		subcat,
		maintenance
		from bronze.erp_px_cat_g1v2
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

