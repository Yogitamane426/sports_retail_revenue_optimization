CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    brand VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2),
    description TEXT,
    stock_quantity INT,
    rating DECIMAL(3,2),
    review_count INT,
    discount_percentage DECIMAL(5,2)
);

INSERT INTO Products (product_id, product_name, brand, category, price, description, stock_quantity, rating, review_count, discount_percentage)
VALUES
(1, 'Nike Air Max', 'Nike', 'Footwear', 120.00, 'A comfortable running shoe with modern features', 100, 4.5, 150, 10),
(2, 'Adidas UltraBoost', 'Adidas', 'Footwear', 150.00, 'High-performance shoes for athletes', 80, 4.7, 200, 15),
(3, 'Nike Dri-FIT T-shirt', 'Nike', 'Clothing', 30.00, 'Breathable and moisture-wicking fabric for workout', 300, 4.2, 100, 5),
(4, 'Adidas Sports Shorts', 'Adidas', 'Clothing', 25.00, 'Lightweight shorts for training', 250, 4.0, 90, 10);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    quantity_sold INT,
    revenue DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Sales (sale_id, product_id, sale_date, quantity_sold, revenue)
VALUES
(1, 1, '2024-11-01', 10, 1200.00),
(2, 2, '2024-11-02', 5, 750.00),
(3, 3, '2024-11-03', 15, 450.00),
(4, 4, '2024-11-04', 20, 500.00);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    product_id INT,
    review_date DATE,
    review_text TEXT,
    review_rating DECIMAL(3,2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Reviews (review_id, product_id, review_date, review_text, review_rating)
VALUES
(1, 1, '2024-11-05', 'Great shoes for running', 4.5),
(2, 2, '2024-11-06', 'Very comfortable, but a bit expensive', 4.7),
(3, 3, '2024-11-07', 'Good for gym workouts, fits well', 4.2),
(4, 4, '2024-11-08', 'Lightweight and breathable, excellent for running', 4.0);

CREATE TABLE WebsiteTraffic (
    traffic_id INT PRIMARY KEY,
    date DATE,
    page_views INT,
    unique_visitors INT
);

INSERT INTO WebsiteTraffic (traffic_id, date, page_views, unique_visitors)
VALUES
(1, '2024-11-01', 200, 150),
(2, '2024-11-02', 250, 180),
(3, '2024-11-03', 180, 160),
(4, '2024-11-04', 220, 190);

---- 1. How do the price points of Nike and Adidas products differ?

SELECT brand, ROUND(AVG(price),2) AS avg_price
FROM Products
WHERE brand IN ('Nike', 'Adidas')
GROUP BY brand;

---- 2. Is there a difference in the amount of discount offered between the brands?

SELECT brand, AVG(discount_percentage) AS average_discount
FROM Products
WHERE brand IN ('Nike', 'Adidas')
GROUP BY brand;

---- 3. Is there any correlation between revenue and reviews?

SELECT p.product_name, SUM(s.revenue) AS total_revenue, AVG(r.review_rating) AS average_review_rating
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_name;

---- 4. Does the length of a product's description influence a product's rating and reviews?

SELECT LENGTH(description) AS description_length, ROUND(AVG(rating),2) AS average_rating, ROUND(AVG(review_count),2) AS average_reviews
FROM Products
GROUP BY LENGTH(description);

---- 5. Are there any trends or gaps in the volume of reviews by month?

SELECT EXTRACT(MONTH FROM review_date) AS month, COUNT(review_id) AS total_reviews
FROM Reviews
GROUP BY EXTRACT(MONTH FROM review_date)
ORDER BY month;

---- 6. How does footwear's median revenue differ from clothing products?

SELECT category, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.revenue) AS median_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
WHERE p.category IN ('Footwear', 'Clothing')
GROUP BY category;

---- 7. How much of the company's stock consists of footwear items? What is the median revenue generated by these products?

SELECT 
    CASE
        WHEN category = 'Footwear' THEN 'Footwear'
        WHEN category = 'Clothing' THEN 'Clothing'
        ELSE 'Other Categories'
    END AS category_group,
    SUM(stock_quantity) AS total_stock
FROM Products
GROUP BY category_group;

-- Median Revenue from Footwear Products

SELECT 
    category, 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.revenue) AS median_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
WHERE p.category = 'Footwear'
GROUP BY category;






