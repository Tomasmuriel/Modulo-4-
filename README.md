# RetailPro — Análisis de Ventas

**Autor:** Tomas Muriel — (https://docs.google.com/document/d/1yTemMfwnB5ViPVzvaV0HSA-qJhGnQ4dyT6g_j_7mxnI/edit?tab=t.0)

Proyecto de Data Analytics (Coderhouse) que modela y analiza los datos de ventas de RetailPro, desde la base de datos relacional hasta un dashboard en Power BI.

## Tecnologías utilizadas
- **SQL** (consultas de negocio, JOINs, CTEs) — ejecutadas sobre `Ventas_Tech_DB`
- **Power BI Desktop** — modelado de datos y visualizaciones
- **Power Query (M)** — limpieza y transformación del pipeline ETL

## Estructura del repositorio
- `Modulo 3/ventas_tech_db.sql` — esquema base de la base de datos (tablas clientes, productos, categorías, ventas)
- `m4_consultas_negocio.sql` — consultas de negocio: facturación mensual, ranking de productos, clientes recurrentes
- `m5_consultas_joins.sql` — extensión del esquema (territorios, segmentos, canal) y consultas con INNER/LEFT JOIN y UNION
- `Modulo 4/Pipeline_ETL_Muriel_Tomas.pbix` — pipeline ETL en Power BI con las 4 tablas relacionadas y visualizaciones
- `Modulo 4/Vista de modelo.png` — diagrama entidad-relación (DER) del modelo de datos
- `Muriel_Tomas_Checkpoint2.pbix.pbix` — versión anterior del checkpoint de Power BI, conservada como historial; la versión vigente es `Modulo 4/Pipeline_ETL_Muriel_Tomas.pbix`
- `Proposito_y_Justificaciones (1).docx` — documento de propósito y justificaciones del proyecto

## Cómo ejecutar los scripts SQL
1. Crear la base de datos y correr `ventas_tech_db.sql` primero (define el esquema base).
2. Correr `m5_consultas_joins.sql` (agrega las tablas y columnas adicionales: territorios, segmento, canal). **Nota:** este script incluye los INSERT manuales que cargan los valores de segmento y territorio para cada cliente — son necesarios para que las consultas posteriores funcionen.
3. Correr `m4_consultas_negocio.sql` para obtener los reportes de negocio.
4. Abrir el `.pbix` en Power BI Desktop para ver el modelo y las visualizaciones.
