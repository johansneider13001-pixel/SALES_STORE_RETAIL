# SALES_STORE_RETAIL
Liempieza de datos, analisis de ventas mediante consulta SQL, dashboard.
# Proyecto de Análisis y Limpieza de Datos - Ventas de Retail (SALES_STORE_RETAIL)

Este repositorio contiene el proyecto completo de análisis, limpieza y visualización de datos de ventas de una tienda de retail, utilizando **SQL**, **Power BI** y **GitHub**.

## 📌 Descripción del Proyecto
El objetivo de este proyecto es estandarizar, limpiar y analizar un conjunto de datos de transacciones de ventas para obtener información clave (KPIs) que ayuden a la toma de decisiones estratégicas.

## 🛠️ Herramientas Utilizadas
- **SQL Server / SQL** (para la limpieza, transformación y consulta de datos).
- **Power BI Desktop** (para la creación de dashboards interactivos).

---

## 📂 Estructura del Proyecto

- `README.md`: Este archivo que explica la documentación del proyecto.
- `limpieza_datos.sql`: Scripts con las consultas SQL de limpieza, transformación y análisis.
- `Dashboard_Ventas_Retail.pbix`: Archivo visual del reporte.

---

## 🧹 1. Limpieza y Transformación de Datos (SQL)

El proceso de limpieza realizado en la base de datos incluyó los siguientes pasos:

1. **Inspección de nulos:** Se revisaron las fechas nulas y los valores faltantes.
2. **Imputación de productos:** Se reemplazaron los valores nulos en la columna `Item` con 'DESCONOCIDO'.
3. **Cálculo de Precios:** Se rellenaron los precios unitarios faltantes dividiendo el total gastado entre la cantidad.
4. **Limpieza de descuentos:** Se reemplazaron los valores nulos por 'N/A' (No Aplica).
5. **Creación de tabla limpia:** Se guardó la información estandarizada en la tabla `SALES_CLEANED`.

📊 2. Análisis y KPIs
Una vez limpia la información, se extrajeron las siguientes métricas clave:

Ventas Totales: Suma acumulada de Total_Spent.

Ventas por Categoría: Identificación de las categorías de producto más rentables.

Análisis temporal: Evolución de ventas por año y mes.

🚀 3. Conclusiones y Hallazgos del Dashboard
El dashboard generado permite visualizar de forma interactiva:

Los clientes que más ingresos generan.

La distribución de métodos de pago (destacando el uso de tarjetas frente a efectivo).

La diferencia de ventas entre ubicaciones (tienda física vs. online).



        WHEN Discount_Applied IS NULL THEN 'N/A'
        ELSE CAST(Discount_Applied AS CHAR) 
    END AS Discount_Applied_cleaned
INTO SALES_CLEANED
FROM retail_store_sales;