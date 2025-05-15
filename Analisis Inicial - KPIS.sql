-- Análisis inicial
select * from brands;
select * from info;
select * from traffic;
select * from reviews; -- Reseñas de productos (numéricas) y cantidad de reseñas por cada producto
select * from finance; -- Precio de lista, precio de venta, descuentos e ingresos por producto


-- Valores atípicos
SELECT COUNT(*) AS DescripciónNula FROM info WHERE description IS NULL;
SELECT COUNT(*) AS PreciosNegativos FROM finance WHERE listing_price < 0 OR sale_price < 0;
SELECT * FROM traffic WHERE last_visited IS NULL;
SELECT distinct(YEAR(last_visited)) from traffic


-- Detectar registros aislados (sin match en otras tablas, aca puedes cambiar las tablas)
SELECT product_id FROM finance
EXCEPT
SELECT product_id FROM info;


-- Creación de una vista consolidada que reune todos los datos
CREATE VIEW vw_product_data AS
SELECT
    i.product_id,
    i.product_name,
    i.description,
    f.listing_price,
    f.sale_price,
    f.discount,
    f.revenue,
    r.rating,
    r.reviews,
    t.last_visited,
    b.brand
FROM info i
JOIN finance f ON i.product_id = f.product_id
LEFT JOIN reviews r ON i.product_id = r.product_id
LEFT JOIN traffic t ON i.product_id = t.product_id
LEFT JOIN brands b ON i.product_id = b.product_id;

select * from vw_product_data
-- Nos servirá para analizar los datos pues el volumen de data no es tan grande
-- podemos hacer las consultas en esta vista


-- KPI's para análisis de revenue

-- Productos con más revenue
SELECT TOP 10 product_name, revenue
FROM vw_product_data
ORDER BY revenue DESC;


-- Productos con alto revenue y con descuento
SELECT *
FROM vw_product_data
WHERE discount > 0.3
ORDER BY revenue DESC;


-- Relación entre calificación y revenue
SELECT rating, SUM(reviews) as reviews, AVG(revenue) AS avg_revenue
FROM vw_product_data
GROUP BY rating
ORDER BY rating desc;
-- Podemos concluir que no necesariamente productos mejores puntuados tienen
-- un mayor ingreso promedio


-- Análisis por marca
SELECT brand, SUM(revenue) AS total_revenue
FROM vw_product_data
GROUP BY brand
having SUM(revenue)>0
ORDER BY total_revenue DESC;
-- Adidas tiene mayores ventas


-- Productos más vendidos por marca:
SELECT brand, product_name, revenue
FROM vw_product_data
WHERE revenue = (
    SELECT MAX(revenue)
    FROM vw_product_data b
    WHERE b.brand = vw_product_data.brand
	having MAX(Revenue) != 0
)
ORDER BY brand;


-- Tráfico Web, productos visistados más recientemente:
SELECT product_name, DATEDIFF(DAY, last_visited, GETDATE()) AS days_since_visit, revenue
FROM vw_product_data
ORDER BY days_since_visit ASC;


-- Clasificación de productos por performance
SELECT product_name,
       CASE 
         WHEN rating >= 4 AND revenue >= 4000 THEN 'Estrella'
         WHEN rating >= 4 AND revenue < 4000 THEN 'Prometedor'
         WHEN rating < 4 AND revenue < 4000 THEN 'Bajo desempeño'
         ELSE 'Otros'
       END AS categoria_producto
FROM vw_product_data;
-- Esta clasificación es solo un ejemplo y depende del negocio


-- Ventas y porcentaje del total por producto
WITH total_revenue AS (
    SELECT SUM(revenue) AS total_rev FROM vw_product_data
),
product_revenue AS (
    SELECT product_id, product_name, revenue FROM vw_product_data
)
SELECT pr.product_name,
       pr.revenue,
       ROUND((pr.revenue / tr.total_rev) * 100, 2) AS percent_of_total
FROM product_revenue pr
CROSS JOIN total_revenue tr
ORDER BY percent_of_total DESC;


-- Identificar productos con "descuentos poco retables", ordenado del menos
-- rentable al más rentable, se puede recomendar eliminar los primeros productos
-- o revisar su estrategia de precios.
SELECT 
    f.product_id,
    i.product_name,
    f.listing_price,
    f.sale_price,
    f.discount,
    f.revenue,
    ROUND(f.revenue / NULLIF(f.discount, 0), 2) AS revenue_per_discount
FROM finance f
JOIN info i ON f.product_id = i.product_id
WHERE f.discount > 0.1 -- al menos 10% de descuento
and revenue > 0
ORDER BY revenue_per_discount ASC; -- menos eficiencia al inicio


-- ¿Qué marca rinde más en promedio?
-- para identificar quién debería tener más visibilidad o stock
SELECT 
    b.brand,
    COUNT(f.product_id) AS total_products,
    ROUND(AVG(f.revenue), 2) AS avg_revenue_per_product
FROM finance f
JOIN brands b ON f.product_id = b.product_id
GROUP BY b.brand
ORDER BY avg_revenue_per_product DESC;


-- Productos que venden bien sin descuentos, podemos priorizar marketing
-- o stock en estos
SELECT 
    i.product_name,
    f.revenue,
    f.discount
FROM finance f
JOIN info i ON f.product_id = i.product_id
WHERE f.discount < 0.05 AND f.revenue > 500
ORDER BY f.revenue DESC;


-- Productos que no reciben visitas, podrian estar quedando obsoletos
-- y se podría dar más visibilidad en las tiendas, proponer ofertas
SELECT 
    i.product_name,
    f.revenue,
    t.last_visited
FROM finance f
JOIN info i ON f.product_id = i.product_id
JOIN traffic t ON f.product_id = t.product_id
WHERE t.last_visited < DATEADD(DAY, -30, GETDATE()) -- no vistos hace 30 días
  AND f.revenue > 0
ORDER BY t.last_visited ASC;
