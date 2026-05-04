# SALES_STORE_RETAIL
Liempieza de datos, analisis de ventas mediante consulta SQL, dashboard.
# Proyecto de Análisis y Limpieza de Datos - Ventas de Retail (SALES_STORE_RETAIL)

Este repositorio contiene el proyecto completo de análisis, limpieza y visualización de datos de ventas de una tienda de retail, utilizando **SQL**, **Power BI** y **GitHub**.

# Proyecto de Business Intelligence: Análisis de Ventas y Comportamiento de Clientes

## 1. Descripción del Proyecto
Este proyecto de Business Intelligence (BI) y análisis de datos se desarrolló para modelar, analizar y visualizar las ventas de una tienda de retail, con el objetivo de identificar oportunidades de mejora en la gestión de inventarios, optimización de ingresos y fidelización de clientes.

### 📋 Objetivos del Negocio
* **Optimización de Inventario:** Analizar el rendimiento de las categorías de productos para priorizar stock de alto margen.
* **Segmentación de Clientes:** Identificar clientes de alto valor (VIP) a través del análisis de frecuencia y ticket promedio.
* **Evaluación de Promociones:** Medir la incidencia real de los descuentos en las ventas totales.

---

## 2. Proceso de Extracción, Transformación y Carga (ETL) con SQL
Antes de conectar la data a Power BI, se realizó la limpieza y estandarización en SQL Server para asegurar la calidad de la información:
* **Manejo de nulos:** Se reemplazaron valores vacíos en la columna de productos con la etiqueta `'DESCONOCIDO'`.
* **Cálculo de precios unitarios:** Se derivó el precio unitario a partir del total gastado y la cantidad cuando este faltaba.
* **Estandarización de categorías y formatos:** Se imputaron valores estándar a los nulos en la columna `Discount_Applied` (asignando `'N/A'`).

---

## 3. Modelo de Datos y Medidas DAX
En Power BI, se implementaron medidas para un análisis dinámico y profundo:
* **Ventas Totales:** `Ventas Totales = SUM(SALES_CLEANED[Total Spent])`
* **Análisis de Categorías:** Se aisló la categoría *Butchers* debido a su alto impacto, calculando su contribución porcentual.
* **Métricas de Clientes:**
  * `Cantidad de Transacciones = DISTINCTCOUNT(SALES_CLEANED[Transaction ID])`
  * `Porcentaje Ventas con Descuento = DIVIDE([Ventas con Descuento], SUM(SALES_CLEANED[Total Spent]), 0)`

---

## 4. Estructura del Dashboard
El reporte se organizó para contar una historia de datos efectiva (Storytelling):

1. **Visión General (KPIs):** Ventas totales, clientes únicos y cantidad de transacciones.
2. **Análisis Operativo:** Comparativo de ventas por canal (Online e In-store) y por categoría.
3. **Comportamiento del Cliente:** Relación entre el gasto total y la frecuencia de compras de los clientes.

---

## 5. Hallazgos Clave y Conclusiones

### Hallazgos
* **Categoría Estrella:** La categoría *Butchers* representa casi el 50% del valor total de las ventas a pesar de no tener el mayor volumen de transacciones, demostrando un alto margen y preferencia.
* **Canales Equilibrados:** Las ventas se encuentran casi en un 50/50 entre el canal *Online* e *In-store*, lo que indica que ambos canales deben mantener un stock estandarizado.
* **Segmentación de Clientes:** Se observa un comportamiento donde los clientes que más gastan (VIP) realizan compras menos frecuentes pero de mayor valor.

### Recomendaciones para Mejorar las Ventas
1. **Estrategia de Inventario:** Garantizar el stock constante de la categoría *Butchers* y productos relacionados para no perder ventas.
2. **Programa de Fidelización:** Diseñar ofertas exclusivas para clientes con alto ticket promedio pero baja frecuencia, para incrementar su recurrencia.
3. **Registro de Descuentos:** Estandarizar la recolección de datos sobre la aplicación de descuentos para evaluar si impactan positivamente en el volumen de ventas.

---

## 6. Visualizaciones Principales
El dashboard desarrollado incluye las siguientes vistas para el análisis:
* Tarjetas de KPIs principales (Ventas, Cantidad de transacciones, Clientes).
* Gráfico de barras horizontales mostrando la venta por categoría.
* Gráfico combinado de columnas y líneas para el Top 5 de Clientes.
* Gráfico de anillos para la distribución de ventas por ubicación (Location).
        WHEN Discount_Applied IS NULL THEN 'N/A'
        ELSE CAST(Discount_Applied AS CHAR) 
    END AS Discount_Applied_cleaned
INTO SALES_CLEANED
FROM retail_store_sales;