-- Creación de Tablas

IF OBJECT_ID('info', 'U') IS NOT NULL
BEGIN
    DROP TABLE info;
END;

CREATE TABLE info
(
    product_id VARCHAR(11) PRIMARY KEY,
	product_name VARCHAR(250),
    description VARCHAR(2000)
);


IF OBJECT_ID('finance', 'U') IS NOT NULL
BEGIN
    DROP TABLE finance;
END;

CREATE TABLE finance
(
    product_id VARCHAR(11) PRIMARY KEY,
    listing_price FLOAT,
    sale_price FLOAT,
    discount FLOAT,
    revenue FLOAT
);


IF OBJECT_ID('reviews', 'U') IS NOT NULL
BEGIN
    DROP TABLE reviews;
END;

CREATE TABLE reviews
(
    product_id VARCHAR(11) PRIMARY KEY,
    rating FLOAT,
    reviews FLOAT
);


IF OBJECT_ID('traffic', 'U') IS NOT NULL
BEGIN
    DROP TABLE traffic;
END;

CREATE TABLE traffic
(
    product_id VARCHAR(11) PRIMARY KEY,
    last_visited DATETIME
);


IF OBJECT_ID('brands', 'U') IS NOT NULL
BEGIN
    DROP TABLE brands;
END;

CREATE TABLE brands
(
    product_id VARCHAR(11) PRIMARY KEY,
    brand VARCHAR(7)
);
