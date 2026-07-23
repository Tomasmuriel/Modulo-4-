-- ============================================================
-- m5_consultas_joins.sql
-- Pre-entrega: Consultas con JOINs para el proyecto — RetailPro
-- Base de datos: Ventas_Tech_DB
-- ============================================================
-- NOTA: La consigna de M5 pide datos que no estaban en el esquema
-- original de M3 (segmento de cliente, región/territorios, canal
-- de venta). Esta sección los agrega antes de las consultas.
-- Si en algún momento del curso te dieron un esquema distinto para
-- estos campos, avisame y lo ajusto.
-- ============================================================


-- ============================================================
-- SETUP: Extensión del esquema
-- ============================================================

-- Tabla territorios (región)
CREATE TABLE territorios (
    id_territorio   INT PRIMARY KEY,
    region          VARCHAR(50) NOT NULL
);

INSERT INTO territorios VALUES (1, 'AMBA');
INSERT INTO territorios VALUES (2, 'Centro');
INSERT INTO territorios VALUES (3, 'NOA');
INSERT INTO territorios VALUES (4, 'Cuyo');
INSERT INTO territorios VALUES (5, 'Patagonia');

-- Columna segmento en clientes
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);
ALTER TABLE clientes ADD COLUMN id_territorio INT;
ALTER TABLE clientes ADD FOREIGN KEY (id_territorio) REFERENCES territorios(id_territorio);

UPDATE clientes SET segmento = 'Premium',  id_territorio = 1 WHERE id_cliente = 1; -- María López (Buenos Aires -> AMBA)
UPDATE clientes SET segmento = 'Standard', id_territorio = 2 WHERE id_cliente = 2; -- Carlos Ruiz (Córdoba -> Centro)
UPDATE clientes SET segmento = 'Standard', id_territorio = 2 WHERE id_cliente = 3; -- Ana Gómez (Rosario -> Centro)
UPDATE clientes SET segmento = 'Premium',  id_territorio = 4 WHERE id_cliente = 4; -- Pedro Sanz (Mendoza -> Cuyo)
UPDATE clientes SET segmento = 'Standard', id_territorio = 3 WHERE id_cliente = 5; -- Laura Torres (Tucumán -> NOA)

-- Un cliente adicional sin ventas, para poder resolver la Consulta 2
INSERT INTO clientes VALUES (6, 'Julián Ferreyra', 'julian@mail.com', 'Neuquén', '2024-03-20', 'Standard', 5);

-- Un producto adicional sin ventas, para poder resolver la Consulta 3
INSERT INTO productos VALUES (7, 'Webcam Full HD', 2, 65.00, 20, 1);

-- Columna canal en ventas (Online / Presencial)
ALTER TABLE ventas ADD COLUMN canal VARCHAR(20);

UPDATE ventas SET canal = 'Online'     WHERE id_venta IN (1, 2, 4, 6, 8, 10);
UPDATE ventas SET canal = 'Presencial' WHERE id_venta IN (3, 5, 7, 9);


-- ============================================================
-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Fecha, cliente, segmento, región, producto, categoría, cantidad,
-- precio unitario, total de venta y canal
-- ============================================================
SELECT
    v.fecha_venta                          AS fecha,
    c.nombre                               AS nombre_cliente,
    c.segmento                             AS segmento,
    t.region                               AS region,
    p.nombre_producto                      AS nombre_producto,
    cat.nombre_categoria                   AS categoria,
    v.cantidad                             AS cantidad,
    v.precio_unitario                      AS precio_unitario,
    v.cantidad * v.precio_unitario         AS total_venta,
    v.canal                                AS canal
FROM ventas v
INNER JOIN clientes c    ON v.id_cliente = c.id_cliente
INNER JOIN territorios t ON c.id_territorio = t.id_territorio
INNER JOIN productos p   ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- ============================================================
-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
-- ============================================================
SELECT
    c.nombre           AS nombre_cliente,
    c.email            AS email,
    c.fecha_registro   AS fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- ============================================================
-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- ============================================================
SELECT
    p.nombre_producto  AS nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio           AS precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- ============================================================
-- Consulta 4 — Consolidado por canal (UNION ALL)
-- ============================================================
SELECT 'Online' AS canal, v.id_venta, v.cantidad * v.precio_unitario AS total
FROM ventas v
WHERE v.canal = 'Online'

UNION ALL

SELECT 'Presencial' AS canal, v.id_venta, v.cantidad * v.precio_unitario AS total
FROM ventas v
WHERE v.canal = 'Presencial';

-- Total facturado por canal
SELECT
    canal,
    SUM(total_por_venta) AS total_facturado
FROM (
    SELECT canal, cantidad * precio_unitario AS total_por_venta
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT canal, cantidad * precio_unitario AS total_por_venta
    FROM ventas
    WHERE canal = 'Presencial'
) AS ventas_por_canal
GROUP BY canal;
