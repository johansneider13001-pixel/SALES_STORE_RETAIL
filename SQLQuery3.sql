-- 1. Revisar registros donde la fecha de transacción sea nula
SELECT * FROM retail_store_sales
WHERE Transaction_Date IS NULL;

-- 2. Rellenar los valores nulos en la columna de productos con 'DESCONOCIDO'
UPDATE retail_store_sales
SET Item = 'DESCONOCIDO'
WHERE Item IS NULL;
--Se reemplazan los valores NULL en la columna Item por la cadena 'DESCONOCIDO' para mantener la integridad de los datos sin eliminar las filas.


-- 3. Calcular y rellenar los 'Price_Per_Unit' nulos dividiendo el total gastado entre la cantidad
UPDATE retail_store_sales
SET Price_Per_Unit = Total_Spent / Quantity
WHERE Price_Per_Unit IS NULL;
--Recuperamos los precios unitarios vacíos utilizando la relación matemática del dataset ($Precio \ Unitario = Total \ Gastado / Cantidad$).


-- 4. Eliminar registros donde la cantidad sea nula
DELETE FROM retail_store_sales
WHERE Quantity IS NULL;
--Dado que no es posible calcular un precio unitario o un total sin conocer la cantidad, se eliminan estas filas (representan una cantidad mínima de registros).


-- 5. Reemplazar los valores nulos en la columna de descuentos con 'N/A'
UPDATE retail_store_sales 
SET Discount_Applied = 'N/A'
WHERE Discount_Applied IS NULL;
--Asignamos 'N/A' (No Aplica) a las celdas nulas en lugar de borrarlas. Esto nos permite conservar aproximadamente un tercio del volumen de datos para el análisis.


-- 6. Crear la tabla 'SALES_CLEANED' con datos transformados y limpios
SELECT 
    Transaction_ID,
    Customer_ID,
    Category, 
    CASE 
        WHEN Item = 'DESCONOCIDO' THEN 'DESCONOCIDO'
        ELSE SUBSTRING(Item, CHARINDEX('_', Item) + 1, 10)
    END AS Item_format,
    Price_Per_Unit,
    Quantity,
    Total_Spent,
    Payment_Method,
    Location,
    Transaction_Date, 
    CASE 
        WHEN Discount_Applied IS NULL THEN 'N/A'
        ELSE CAST(Discount_Applied AS CHAR) 
    END AS Discount_Applied_cleaned
INTO SALES_CLEANED
FROM retail_store_sales;
--Estandarizamos el formato del nombre del producto extrayendo los caracteres después del guion bajo. Además, guardamos todos los datos limpios y transformados en una nueva tabla llamada SALES_CLEANED.


-- 7. Verificar los datos de la nueva tabla limpia
SELECT * FROM SALES_CLEANED;
--Consulta rápida para comprobar que la creación de la tabla se ha realizado correctamente.


-- 8. Calcular el total de ventas generadas por cada cliente
SELECT 
    Customer_ID, 
    SUM(Total_Spent) AS venta_por_cliente
FROM SALES_CLEANED
GROUP BY Customer_ID
ORDER BY 2 DESC;
--Agrupamos los datos por cliente para identificar quiénes son los compradores que más ingresos aportan a la tienda (ordenados de mayor a menor).


-- 9. Calcular el total de ventas por categoría de producto
SELECT 
    Category, 
    SUM(Total_Spent) AS venta_por_categoria,
    count(*) as cantidad_ventas
FROM SALES_CLEANED
GROUP BY Category
ORDER BY 2 DESC;
--Permite observar qué categorías de productos son las más populares o rentables para el negocio.


-- 10. Agrupar el total de ventas por año
SELECT 
    YEAR(Transaction_Date) AS Año, 
    SUM(Total_Spent) AS ventas_por_año
FROM SALES_CLEANED
GROUP BY YEAR(Transaction_Date)
ORDER BY YEAR(Transaction_Date) ASC;
--Muestra el comportamiento histórico de los ingresos anuales de la tienda.

-- 11. Detallar las ventas por año y mes
SELECT 
    YEAR(Transaction_Date) AS Año, 
    MONTH(Transaction_Date) AS Mes, 
    SUM(Total_Spent) AS ventas_por_mes
FROM SALES_CLEANED
GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date)
ORDER BY YEAR(Transaction_Date), MONTH(Transaction_Date) ASC;
--Permite detectar estacionalidad o meses con mayor volumen de ventas a lo largo del tiempo.


-- 12. Identificar la cantidad de la compra de mayor valor para cada cliente usando DENSE_RANK
WITH CTE_N1_VENTAS AS (
    SELECT
        Transaction_ID, 
        Customer_ID, 
        Total_Spent,
        DENSE_RANK() OVER (PARTITION BY Customer_ID ORDER BY Total_Spent DESC) AS ranking_ventas
    FROM SALES_CLEANED
)
SELECT Customer_ID, COUNT(*) AS CANTIDAD_DE_VENTAS_MAXIMAS, Total_Spent
FROM CTE_N1_VENTAS
WHERE ranking_ventas = 1
GROUP BY Customer_ID, Total_Spent
order by CANTIDAD_DE_VENTAS_MAXIMAS DESC
--Utiliza una expresión de tabla común (CTE) y la función de ventana DENSE_RANK para obtener únicamente la transacción de mayor valor de cada cliente.

-- 13. Análisis de ingresos y transacciones por método de pago
SELECT 
    Payment_Method, 
    SUM(Total_Spent) AS total_ventas,
    COUNT(*) AS cantidad_transaciones
FROM SALES_CLEANED
GROUP BY Payment_Method
ORDER BY total_ventas DESC;
--Analiza las preferencias de los clientes al momento de pagar y su impacto en los ingresos.


-- 14. Análisis de ingresos y transacciones según la ubicación (ej. Online vs In-store)
SELECT 
    Location, 
    SUM(Total_Spent) AS total_ventas, 
    COUNT(*) AS cantidad_ventas
FROM SALES_CLEANED
GROUP BY Location
ORDER BY total_ventas DESC;
--Evalúa la participación en ventas de los diferentes canales o ubicaciones físicas/digitales.



