# 📊 Analyzing Online Sports Revenue

Este proyecto aplica técnicas avanzadas de **SQL Server** y procesos ETL con **SSIS** para analizar y optimizar los ingresos en un entorno de retail deportivo en línea. Desde la carga y limpieza de datos hasta consultas analíticas complejas, este trabajo demuestra habilidades técnicas orientadas a generar insights clave sobre el rendimiento de productos, marcas y estrategias de descuentos.

---

## 📌 DESCRIPCIÓN DEL PROYECTO

El análisis se basa en un conjunto de cinco tablas que contienen información sobre productos, precios, tráfico web, calificaciones y marcas. El flujo de trabajo completo incluye:

- Extracción y carga de datos desde archivos CSV usando **SSIS**.
- Modelado relacional y limpieza básica.
- Creación de vistas y consultas avanzadas con funciones de ventana, CTEs, joins, filtros y rankings.
- Optimización de consultas con **índices** y vistas con `SCHEMABINDING`.
- Respuesta a preguntas de negocio reales, con foco en maximizar el revenue y tomar decisiones basadas en datos.

---

## ❓ DUDAS QUE RESPONDÍ

Las siguientes preguntas de negocio se respondieron mediante consultas en SQL avanzado:

- ¿Qué productos generan altos ingresos sin necesidad de descuento?
- ¿Qué marcas tienen mayor revenue?
- ¿Qué productos tienen descuentos poco eficientes (bajo revenue por porcentaje de descuento)?
- ¿Qué productos tienen buen performance pero no reciben tráfico recientemente?
entre otras...

---

## 📊 VISUALIZACIONES

Además de las consultas y desarrollo del análisis elaborado en T-SQL/SQL Server, se realizó un proceso de ETL desde SQL Server Integration Services, algunos de procesos se muestran a continuación:

### 🔌 Conexiones de Datos

![Conexiones de Datos](images/Conexiones%20de%20Datos.png)  
*Configuración de orígenes y destinos para la carga de archivos CSV en SQL Server.*


### 📐 Estructura Base

![Estructura Base](images/Estructura%20Base.png)  
*Vista general del diseño del paquete SSIS con sus contenedores de control y flujo de datos.*


### 📁 Carga de Columnas de Archivo CSV

![Carga de Columnas de Archivo csv](images/Carga%20de%20Columnas%20de%20Archivo%20csv.png)  
*Mapeo de columnas desde los archivos CSV hacia las tablas destino en SQL Server.*


### 🔄 Flujo de Datos

![Flujo de Datos](images/Flujo%20de%20Datos.png)  
*Representación del pipeline completo del flujo de datos dentro de SSIS.*


### 🧹 Limpieza Inicial de Tablas

![Limpieza Inicial de Tablas](images/Limpieza%20Inicial%20de%20Tablas.png)  
*Paso intermedio donde se realizan tareas de limpieza antes de la transformación.*


### 🔧 Transformación de Datos

![Transformación de Datos](images/Transformación%20de%20Datos.png)  
*Aplicación de transformaciones sobre los datos antes de ser insertados en tablas definitivas.*


---
## 🛠️ HERRAMIENTAS UTILIZADAS

- **SQL Server Management Studio (SSMS)** – modelado, consultas, vistas, CTEs, optimización con índices.
- **SQL Server Integration Services (SSIS)** – carga de archivos CSV a tablas de SQL Server.
- **Kaggle Dataset (CSV)** – fuente de datos sintéticos para análisis.

---

## 📁 ESTRUCTURA DEL REPOSITORIO

Analyzing-Online-Sports-Revenue/

│

├── Analisis Inicial - KPIS.sql

├── Analysis Avanzado.sql

├── Creación de Tablas.sql

│

├── images/

│ ├── Carga de Columnas de Archivo csv.png

│ ├── Conexiones de Datos.png

│ ├── Estructura Base.png

│ ├── Flujo de Datos.png

│ ├── Limpieza Inicial de Tablas.png

│ └── Transformación de Datos.png

│

├── data/

│ ├── info.csv

│ ├── finance.csv

│ ├── traffic.csv

│ ├── brands.csv

│ └── reviews.csv

│

└── README.md


---

## 📝 NOTAS

- La data en su mayoría limpia fue tomada de un dataset de Kaggle.
- Se evitaron herramientas externas como Power BI o Python para enfocarse exclusivamente en SQL avanzado y procesos ETL nativos con Microsoft SQL Server.
- El uso de `WITH SCHEMABINDING` fue explorado para posibles vistas indexadas, aunque no se implementó por requerimientos de diseño.

---

## 📂 DATASET

- Fuente: Kaggle – [Optimizing Online Sports Retail Revenue](https://www.kaggle.com/datasets/irenewidyastuti/datacamp-optimizing-online-sports-retail-revenue/data)
- Tipo de datos: sintéticos, representativos de un entorno de e-commerce enfocado en productos deportivos.

---

## 📬 CONTACTO

¿Tienes sugerencias o quieres colaborar?  
¡Contáctame por LinkedIn o revisa más proyectos en mi portafolio!

🔗 [Mi LinkedIn](https://www.linkedin.com/in/eduardo-alfonso-haro-villanueva-baa50a261/)  
🌐 [Mi portafolio](https://portafolio-eharo.carrd.co/)

---
