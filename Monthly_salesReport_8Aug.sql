CREATE OR REPLACE PROCEDURE create_monthly_sales_report(p_group_by VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Drop old report table if exists
    DROP TABLE IF EXISTS monthly_sales_report;

    -- Monthly report by order date
    IF p_group_by = 'MONTH_ORDER' THEN
        CREATE TABLE monthly_sales_report AS
        SELECT 
            EXTRACT(YEAR FROM order_date)::INT AS report_year,
            EXTRACT(MONTH FROM order_date)::INT AS report_month,
            TO_CHAR(order_date, 'Mon YYYY') AS month_name,
            COUNT(DISTINCT order_id) AS total_orders,
            SUM(qty) AS total_qty,
            SUM(sales) AS total_sales,
            SUM(discount) AS total_discount,
            SUM(profit) AS total_profit
        FROM sales
        GROUP BY report_year, report_month, month_name
        ORDER BY report_year, report_month;

    -- Monthly report by ship date
    ELSIF p_group_by = 'MONTH_SHIP' THEN
        CREATE TABLE monthly_sales_report AS
        SELECT 
            EXTRACT(YEAR FROM ship_date)::INT AS report_year,
            EXTRACT(MONTH FROM ship_date)::INT AS report_month,
            TO_CHAR(ship_date, 'Mon YYYY') AS month_name,
            COUNT(DISTINCT order_id) AS total_orders,
            SUM(qty) AS total_qty,
            SUM(sales) AS total_sales,
            SUM(discount) AS total_discount,
            SUM(profit) AS total_profit
        FROM sales
        GROUP BY report_year, report_month, month_name
        ORDER BY report_year, report_month;
    END IF;
END;
$$;

-- Monthly report based on order_date
CALL create_monthly_sales_report('MONTH_ORDER');

-- Monthly report based on ship_date
CALL create_monthly_sales_report('MONTH_SHIP');

-- View the report
SELECT * FROM monthly_sales_report;