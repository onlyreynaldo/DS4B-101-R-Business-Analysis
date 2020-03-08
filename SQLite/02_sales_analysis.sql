SELECT * FROM orderlines
SELECT * FROM bikeshops
SELECT * FROM bikes


-- JOINING TABLES
CREATE TABLE orderlines_joined AS 
SELECT order_id, order_line, order_date, product_id, quantity,
       bikeshop_name, location,
       model, description, price
FROM orderlines AS T1
LEFT JOIN bikeshops AS T2 ON T1.customer_id = T2.bikeshop_id
LEFT JOIN bikes AS T3 ON T1.product_id = T3.bike_id;

SELECT * FROM orderlines_joined;


-- WRANGLING TABLE orderlines_joined
CREATE TABLE orderlines_wrangled AS
SELECT DATE(order_date) AS order_date, order_id, order_line, 
       quantity, price, (quantity * price) AS total_price,
       product_id, model, category_1, 
       substr(leftover_desc, 1, sep_pos_leftover_desc-2) AS category_2,
       substr(leftover_desc, sep_pos_leftover_desc+1) AS frame_material, 
       bikeshop_name, city, state
FROM (
    SELECT order_id, order_line, order_date, product_id, quantity,
           bikeshop_name, model, description, price,
           substr(location, 1, sep_pos_location-1) AS city,
           substr(location, sep_pos_location+2) AS state,
           substr(description, 1, sep_pos_description-1) AS category_1,
           substr(description, sep_pos_description+3) AS leftover_desc,
           instr(substr(description, sep_pos_description+3), '-') AS sep_pos_leftover_desc
    FROM (
        SELECT *,
            instr(location, ',') AS sep_pos_location,
            instr(description, ' ') AS sep_pos_description
        FROM orderlines_joined
    ) AS TBL
) AS TBL;

SELECT * FROM orderlines_wrangled;


-- VENDAS POR ANO
SELECT year,
       SUM(total_price) AS sales
FROM (
    SELECT total_price, 
           strftime('%Y', order_date) AS year 
    FROM orderlines_wrangled
)
GROUP BY year;

-- VENDAS POR ANO E CATEGORIA_2
SELECT category_2,
       SUM(CASE WHEN year = '2011' THEN sales END) AS "2011",
       SUM(CASE WHEN year = '2012' THEN sales END) AS "2012",
       SUM(CASE WHEN year = '2015' THEN sales END) AS "2013",
       SUM(CASE WHEN year = '2015' THEN sales END) AS "2014",
       SUM(CASE WHEN year = '2015' THEN sales END) AS "2015"
FROM (
    SELECT year,
           category_2,
           SUM(total_price) AS sales
    FROM (
        SELECT strftime('%Y', order_date) AS year,
               category_2, 
               total_price
        FROM orderlines_wrangled
    )
    GROUP BY year, category_2
)
GROUP BY category_2;
