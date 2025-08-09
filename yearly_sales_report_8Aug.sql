CREATE OR REPLACE PROCEDURE create_sales_report(p_group_by VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Drop existing report table if exists
    DROP TABLE IF EXISTS sales_report;

    -- Create report based on parameter
    IF p_group_by = 'YEAR_ORDER' THEN
        CREATE TABLE sales_report AS
        SELECT 
            EXTRACT(YEAR FROM order_date)::INT AS report_year,
            COUNT(DISTINCT order_id) AS total_orders,
            SUM(qty) AS total_qty,
            SUM(sales) AS total_sales,
            SUM(discount) AS total_discount,
            SUM(profit) AS total_profit
        FROM sales
        GROUP BY EXTRACT(YEAR FROM order_date)
        ORDER BY report_year;

    ELSIF p_group_by = 'YEAR_SHIP' THEN
        CREATE TABLE sales_report AS
        SELECT 
            EXTRACT(YEAR FROM ship_date)::INT AS report_year,
            COUNT(DISTINCT order_id) AS total_orders,
            SUM(qty) AS total_qty,
            SUM(sales) AS total_sales,
            SUM(discount) AS total_discount,
            SUM(profit) AS total_profit
        FROM sales
        GROUP BY EXTRACT(YEAR FROM ship_date)
        ORDER BY report_year;

    ELSIF p_group_by = 'PRODUCT' THEN
        CREATE TABLE sales_report AS
        SELECT 
            product_id,
            COUNT(DISTINCT order_id) AS total_orders,
            SUM(qty) AS total_qty,
            SUM(sales) AS total_sales,
            SUM(discount) AS total_discount,
            SUM(profit) AS total_profit
        FROM sales
        GROUP BY product_id
        ORDER BY total_sales DESC;
    END IF;
END;
$$;

CALL create_sales_report('YEAR_ORDER');
CALL create_sales_report('YEAR_SHIP');
CALL create_sales_report('PRODUCT');

SELECT * FROM sales_report;