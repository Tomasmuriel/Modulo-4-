-- ============================================================
-- m4_consultas_negocio.sql
-- Pre-entrega: Consultas SQL de negocio — RetailPro
-- Base de datos: Ventas_Tech_DB (tabla: ventas)
-- ============================================================

-- ============================================================
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes
-- ============================================================
SELECT
    EXTRACT(MONTH FROM fecha_venta)                       AS mes,
    SUM(cantidad * precio_unitario)                        AS total_facturado,
    COUNT(*)                                                AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*)              AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;


-- ============================================================
-- Consulta 2 — Ranking de productos (Top 5 por facturación)
-- ============================================================
SELECT
    id_producto,
    SUM(cantidad)                      AS unidades_vendidas,
    SUM(cantidad * precio_unitario)    AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;


-- ============================================================
-- Consulta 3 — Clientes recurrentes
-- Clientes con más de un pedido: cantidad de pedidos y total gastado
-- ============================================================
SELECT
    id_cliente,
    COUNT(*)                            AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)     AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- ============================================================
-- Consulta 4 — Meses por encima/por debajo del promedio
-- Total facturado por mes, comparado contra el promedio mensual general
-- ============================================================
WITH facturacion_mensual AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta)     AS mes,
        SUM(cantidad * precio_unitario)     AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
),
promedio_general AS (
    SELECT AVG(total_facturado) AS promedio
    FROM facturacion_mensual
)
SELECT
    fm.mes,
    fm.total_facturado,
    CASE
        WHEN fm.total_facturado > pg.promedio THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual fm
CROSS JOIN promedio_general pg
ORDER BY fm.mes;


-- ============================================================
-- Hallazgos
-- ============================================================
-- 1. El producto 1 (Laptop Pro 15) concentra el 56% de la facturación
--    total del período (3600 de 6444), muy por delante del producto 2,
--    que ocupa el segundo lugar con apenas el 20%.
-- 2. Los 5 clientes registrados son recurrentes: cada uno realizó
--    exactamente 2 pedidos, lo que sugiere una base de clientes chica
--    pero fiel en este período.
-- 3. Todas las ventas del dataset caen en marzo de 2024, por lo que
--    el análisis mensual todavía no muestra variación entre meses;
--    esto va a cobrar sentido cuando se carguen más períodos.
