--Analisis Avanzado, Procedures, etc

-- Procedimiento almacenado que permite obtener los 
-- top productos por marca y descuento mínimo
CREATE PROCEDURE GetTopProductsByBrand
    @brand_name VARCHAR(7),
    @min_discount FLOAT
AS
BEGIN
    SELECT product_name, revenue, discount
    FROM vw_product_data
    WHERE brand = @brand_name AND discount >= @min_discount
    ORDER BY revenue DESC;
END;


-- Ingresos totales y participación por producto (%)
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


-- Top productos por marca:
SELECT *
FROM (
    SELECT brand,
           product_name,
           revenue,
           RANK() OVER (PARTITION BY brand ORDER BY revenue DESC) AS rnk
    FROM vw_product_data
	where revenue > 0
) AS ranked
WHERE rnk <= 3;


-- Lo convertimos en un procedure
CREATE PROCEDURE GetTopNProducts
	@n_products int
AS
BEGIN
	SELECT *
	FROM (
		SELECT brand,
				product_name,
				revenue,
				RANK() OVER (PARTITION BY brand ORDER BY revenue DESC) AS rnk
		FROM vw_product_data
		where revenue > 0
	) AS ranked
	WHERE rnk <= @n_products;
END

EXEC GetTopNProducts 4


-- Función para reutilizar lógicas complejas como clasificación
-- de productos:
CREATE FUNCTION dbo.fn_ProductCategory (@rating FLOAT, @revenue FLOAT)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN (
        SELECT CASE
            WHEN @rating >= 4 AND @revenue >= 4000 THEN 'Estrella'
            WHEN @rating >= 4 AND @revenue < 4000 THEN 'Prometedor'
            WHEN @rating < 4 AND @revenue < 4000 THEN 'Bajo desempeño'
            ELSE 'Otros' END
    );
END;
-- La consulta usada en el análisis principal se puede reducir a esto
SELECT product_name, dbo.fn_ProductCategory(rating, revenue) AS categoria
FROM vw_product_data;


-- Triggers para auditoría, por ejemplo para revisar cuando se realicen
-- cambios en el precio de algún producto
CREATE TABLE audit_price_change (
    product_id VARCHAR(11),
    old_price FLOAT,
    new_price FLOAT,
    change_date DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_price_change
ON finance
AFTER UPDATE
AS
BEGIN
    INSERT INTO audit_price_change (product_id, old_price, new_price)
    SELECT d.product_id, d.sale_price, i.sale_price
    FROM deleted d
    JOIN inserted i ON d.product_id = i.product_id
    WHERE d.sale_price <> i.sale_price;
END;


-- Creación de indices para optimización de consultas
CREATE NONCLUSTERED INDEX idx_finance_discount
ON finance(discount);


-- Manejo de errores

BEGIN TRY
    EXEC GetTopNProducts 3;
END TRY
BEGIN CATCH
    PRINT 'Error en análisis: ' + ERROR_MESSAGE();
END CATCH;