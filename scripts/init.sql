--
-- Esquema de base de datos: Fábrica de Productos
-- Tablas para ventas, productos, recetas, ingredientes y precios
--

-- Tabla de ingredientes
CREATE TABLE IF NOT EXISTS ingredientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    unidad VARCHAR(50) NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    stock DECIMAL(12,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_venta DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de recetas (producto -> ingredientes)
CREATE TABLE IF NOT EXISTS recetas (
    id SERIAL PRIMARY KEY,
    producto_id INTEGER NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
    ingrediente_id INTEGER NOT NULL REFERENCES ingredientes(id) ON DELETE CASCADE,
    cantidad DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS ventas (
    id SERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL,
    cliente VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de detalle de ventas
CREATE TABLE IF NOT EXISTS detalle_ventas (
    id SERIAL PRIMARY KEY,
    venta_id INTEGER NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id INTEGER NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL
);

-- Vistas útiles

-- Vista: costo de producción por producto
CREATE OR REPLACE VIEW vista_costo_producto AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto,
    SUM(r.cantidad * i.precio_unitario) AS costo_total,
    p.precio_venta,
    (p.precio_venta - SUM(r.cantidad * i.precio_unitario)) AS margen_ganancia
FROM productos p
JOIN recetas r ON r.producto_id = p.id
JOIN ingredientes i ON i.id = r.ingrediente_id
GROUP BY p.id, p.nombre, p.precio_venta;

-- Vista: ingredientes más usados
CREATE OR REPLACE VIEW vista_ingredientes_populares AS
SELECT
    i.id,
    i.nombre,
    i.unidad,
    COUNT(r.producto_id) AS cantidad_productos
FROM ingredientes i
LEFT JOIN recetas r ON r.ingrediente_id = i.id
GROUP BY i.id, i.nombre, i.unidad
ORDER BY cantidad_productos DESC;

-- Datos de ejemplo

INSERT INTO ingredientes (nombre, unidad, precio_unitario, stock) VALUES
    ('Harina 000', 'kg', 1.50, 100),
    ('Azúcar', 'kg', 2.00, 80),
    ('Huevos', 'unidad', 0.30, 200),
    ('Leche', 'L', 1.20, 50),
    ('Manteca', 'kg', 4.50, 30),
    ('Levadura', 'kg', 3.00, 15),
    ('Sal', 'kg', 0.50, 40),
    ('Esencia de Vainilla', 'L', 8.00, 10),
    ('Cacao en Polvo', 'kg', 5.00, 25),
    ('Dulce de Leche', 'kg', 3.50, 35),
    ('Crema de Leche', 'L', 4.00, 20),
    ('Fruta (Frutilla)', 'kg', 6.00, 15);

INSERT INTO productos (nombre, descripcion, precio_venta) VALUES
    ('Pan Francés', 'Pan clásico de harina, agua y levadura', 2.50),
    ('Medialuna', 'Factura de manteca', 1.00),
    ('Torta de Chocolate', 'Torta húmeda de chocolate con cobertura', 25.00),
    ('Pastafrola', 'Tarta rellena de dulce de leche', 18.00),
    ('Pan de Miga', 'Pan blanco sin corteza para sandwiches', 3.00),
    ('Churros', 'Churros fritos con azúcar', 1.50),
    ('Flan Casero', 'Flan con caramelo y crema', 12.00),
    ('Brownie', 'Porción de brownie de chocolate con nueces', 8.00);

INSERT INTO recetas (producto_id, ingrediente_id, cantidad) VALUES
    -- Pan Francés
    (1, 1, 0.5),   -- Harina
    (1, 7, 0.01),  -- Sal
    (1, 6, 0.02),  -- Levadura
    -- Medialuna
    (2, 1, 0.15),  -- Harina
    (2, 2, 0.03),  -- Azúcar
    (2, 5, 0.08),  -- Manteca
    (2, 3, 1),     -- Huevo
    (2, 4, 0.05),  -- Leche
    -- Torta de Chocolate
    (3, 1, 0.3),   -- Harina
    (3, 2, 0.25),  -- Azúcar
    (3, 3, 3),     -- Huevos
    (3, 5, 0.15),  -- Manteca
    (3, 4, 0.2),   -- Leche
    (3, 9, 0.1),   -- Cacao
    (3, 8, 0.01),  -- Vainilla
    -- Pastafrola
    (4, 1, 0.25),  -- Harina
    (4, 5, 0.12),  -- Manteca
    (4, 2, 0.05),  -- Azúcar
    (4, 3, 1),     -- Huevo
    (4, 10, 0.3),  -- Dulce de Leche
    -- Pan de Miga
    (5, 1, 0.4),   -- Harina
    (5, 5, 0.02),  -- Manteca
    (5, 4, 0.1),   -- Leche
    (5, 7, 0.01),  -- Sal
    (5, 6, 0.015), -- Levadura
    -- Churros
    (6, 1, 0.2),   -- Harina
    (6, 2, 0.05),  -- Azúcar
    (6, 7, 0.005), -- Sal
    -- Flan Casero
    (7, 3, 4),     -- Huevos
    (7, 4, 0.5),   -- Leche
    (7, 2, 0.15),  -- Azúcar
    (7, 8, 0.01),  -- Vainilla
    (7, 11, 0.1),  -- Crema de Leche
    -- Brownie
    (8, 9, 0.08),  -- Cacao
    (8, 5, 0.1),   -- Manteca
    (8, 2, 0.15),  -- Azúcar
    (8, 3, 2),     -- Huevos
    (8, 1, 0.08),  -- Harina
    (8, 12, 0.05); -- Frutilla

-- Datos de ventas de ejemplo
INSERT INTO ventas (fecha, total, cliente) VALUES
    ('2025-01-15 09:30:00', 12.50, 'Juan Pérez'),
    ('2025-01-15 10:15:00', 8.00, 'María García'),
    ('2025-01-16 08:45:00', 35.00, 'Pedro López'),
    ('2025-01-16 11:00:00', 27.00, 'Ana Martínez'),
    ('2025-01-17 09:00:00', 15.50, 'Carlos Rodríguez'),
    ('2025-01-17 10:30:00', 50.00, 'Lucía Fernández'),
    ('2025-01-18 08:30:00', 22.00, 'Jorge González'),
    ('2025-01-18 09:45:00', 18.00, 'Sofía Díaz'),
    ('2025-01-18 11:15:00', 33.50, 'Diego Sánchez');

INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
    (1, 1, 3, 2.50, 7.50),
    (1, 2, 5, 1.00, 5.00),
    (2, 8, 1, 8.00, 8.00),
    (3, 3, 1, 25.00, 25.00),
    (3, 2, 10, 1.00, 10.00),
    (4, 4, 1, 18.00, 18.00),
    (4, 6, 6, 1.50, 9.00),
    (5, 1, 2, 2.50, 5.00),
    (5, 5, 1, 3.00, 3.00),
    (5, 2, 5, 1.00, 5.00),
    (5, 8, 1, 8.00, 8.00),
    (6, 3, 2, 25.00, 50.00),
    (7, 4, 1, 18.00, 18.00),
    (7, 2, 4, 1.00, 4.00),
    (8, 7, 1, 12.00, 12.00),
    (8, 6, 4, 1.50, 6.00),
    (9, 1, 5, 2.50, 12.50),
    (9, 8, 2, 8.00, 16.00),
    (9, 5, 1, 3.00, 3.00),
    (9, 2, 2, 1.00, 2.00);
