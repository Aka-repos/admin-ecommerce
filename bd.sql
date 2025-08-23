-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS pharmapty;
USE pharmapty;

-- Crear la tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    contraseña VARCHAR(100) NOT NULL,
    rol ENUM('admin', 'cliente') NOT NULL DEFAULT 'cliente',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar usuarios de prueba
INSERT INTO usuarios (nombre_usuario, email, contraseña, rol) VALUES
('admin', 'admin@pharmapty.com', 'admin123', 'admin'),
('cliente1', 'cliente1@gmail.com', 'cliente123', 'cliente'),
('cliente2', 'cliente2@gmail.com', 'cliente456', 'cliente'),
('farmaceutico', 'farmaceutico@pharmapty.com', 'farma123', 'admin');

-- Verificar que los datos se insertaron correctamente
SELECT * FROM usuarios;



-- Usar la base de datos pharmapty
USE pharmapty;

-- Crear tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    imagen VARCHAR(255),
    categoria ENUM('medicamentos', 'vitaminas', 'cuidado_personal', 'bebes', 'primeros_auxilios', 'otros') DEFAULT 'medicamentos',
    marca VARCHAR(50),
    codigo_barras VARCHAR(50) UNIQUE,
    prescripcion_requerida BOOLEAN DEFAULT FALSE,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insertar productos de ejemplo
INSERT INTO productos (nombre, descripcion, precio, stock, imagen, categoria, marca, codigo_barras, prescripcion_requerida) VALUES
-- Medicamentos
('Paracetamol 500mg', 'Analgésico y antipirético para alivio del dolor y fiebre. Caja con 20 tabletas.', 15.50, 100, 'img/productos/paracetamol.jpg', 'medicamentos', 'Bayer', '7501234567890', FALSE),
('Ibuprofeno 400mg', 'Antiinflamatorio no esteroideo para dolor e inflamación. Caja con 10 cápsulas.', 22.75, 75, 'img/productos/ibuprofeno.jpg', 'medicamentos', 'Pfizer', '7501234567891', FALSE),
('Amoxicilina 500mg', 'Antibiótico de amplio espectro. Caja con 12 cápsulas. Requiere receta médica.', 45.80, 50, 'img/productos/amoxicilina.jpg', 'medicamentos', 'GlaxoSmithKline', '7501234567892', TRUE),
('Omeprazol 20mg', 'Inhibidor de bomba de protones para acidez estomacal. Caja con 14 cápsulas.', 28.90, 60, 'img/productos/omeprazol.jpg', 'medicamentos', 'AstraZeneca', '7501234567893', FALSE),
('Loratadina 10mg', 'Antihistamínico para alergias. Caja con 10 tabletas.', 18.25, 80, 'img/productos/loratadina.jpg', 'medicamentos', 'Merck', '7501234567894', FALSE),
('Metformina 850mg', 'Antidiabético oral para diabetes tipo 2. Caja con 30 tabletas.', 38.60, 40, 'img/productos/metformina.jpg', 'medicamentos', 'Novartis', '7501234567895', TRUE),
('Atorvastatina 20mg', 'Medicamento para reducir colesterol. Caja con 30 tabletas.', 48.20, 35, 'img/productos/atorvastatina.jpg', 'medicamentos', 'Pfizer', '7501234567896', TRUE),

-- Vitaminas y Suplementos
('Vitamina C 1000mg', 'Suplemento de vitamina C para fortalecer el sistema inmune. Frasco con 60 tabletas.', 25.75, 120, 'img/productos/vitamina_c.jpg', 'vitaminas', 'Centrum', '7501234567897', FALSE),
('Multivitamínico', 'Complejo vitamínico completo para toda la familia. Frasco con 90 tabletas.', 45.75, 90, 'img/productos/multivitaminico.jpg', 'vitaminas', 'Centrum', '7501234567898', FALSE),
('Vitamina D3 1000 UI', 'Suplemento de vitamina D para huesos fuertes. Frasco con 100 cápsulas.', 32.60, 85, 'img/productos/vitamina_d3.jpg', 'vitaminas', 'Nature Made', '7501234567899', FALSE),
('Omega 3', 'Ácidos grasos esenciales para la salud cardiovascular. Frasco con 60 cápsulas.', 55.40, 70, 'img/productos/omega3.jpg', 'vitaminas', 'Nordic Naturals', '7501234567800', FALSE),

-- Cuidado Personal
('Alcohol en Gel 500ml', 'Gel antibacterial con 70% de alcohol para higiene de manos.', 12.50, 200, 'img/productos/alcohol_gel.jpg', 'cuidado_personal', 'Lysol', '7501234567801', FALSE),
('Protector Solar FPS 50', 'Bloqueador solar de amplio espectro. Envase de 120ml.', 35.90, 65, 'img/productos/protector_solar.jpg', 'cuidado_personal', 'La Roche Posay', '7501234567802', FALSE),
('Shampoo Anticaspa 400ml', 'Shampoo medicinal contra la caspa y dermatitis seborreica.', 28.75, 45, 'img/productos/shampoo_anticaspa.jpg', 'cuidado_personal', 'Head & Shoulders', '7501234567803', FALSE),

-- Productos para Bebés
('Pañales Recién Nacido', 'Pañales ultra absorbentes para bebés de 2-5kg. Paquete de 30 unidades.', 42.30, 150, 'img/productos/panales_rn.jpg', 'bebes', 'Huggies', '7501234567804', FALSE),
('Toallas Húmedas Bebé', 'Toallas húmedas hipoalergénicas sin alcohol. Paquete de 80 unidades.', 18.90, 100, 'img/productos/toallas_bebe.jpg', 'bebes', 'Johnson\'s', '7501234567805', FALSE),
('Crema Anti-Rozaduras', 'Crema protectora contra rozaduras para bebés. Tubo de 100g.', 24.60, 75, 'img/productos/crema_rozaduras.jpg', 'bebes', 'Johnson\'s', '7501234567806', FALSE),

-- Primeros Auxilios
('Vendas Elásticas 10cm', 'Vendas elásticas para inmovilización y soporte. Rollo de 4.5m.', 15.80, 60, 'img/productos/vendas_elasticas.jpg', 'primeros_auxilios', 'ACE', '7501234567807', FALSE),
('Gasas Estériles 10x10cm', 'Gasas estériles para curaciones. Caja con 25 unidades.', 22.40, 80, 'img/productos/gasas_esteriles.jpg', 'primeros_auxilios', '3M', '7501234567808', FALSE),
('Termómetro Digital', 'Termómetro digital con pantalla LCD y alarma de fiebre.', 85.50, 25, 'img/productos/termometro_digital.jpg', 'primeros_auxilios', 'Omron', '7501234567809', FALSE),
('Curitas Surtidas', 'Curitas adhesivas en diferentes tamaños. Caja con 40 unidades.', 12.75, 120, 'img/productos/curitas.jpg', 'primeros_auxilios', 'Band-Aid', '7501234567810', FALSE),

-- Otros
('Jeringa 5ml', 'Jeringa desechable estéril para administración de medicamentos.', 3.50, 200, 'img/productos/jeringa_5ml.jpg', 'otros', 'BD', '7501234567811', FALSE),
('Mascarillas N95', 'Mascarillas de protección respiratoria. Caja con 20 unidades.', 65.00, 50, 'img/productos/mascarillas_n95.jpg', 'otros', '3M', '7501234567812', FALSE),
('Tensiómetro Digital', 'Tensiómetro automático para medición de presión arterial.', 125.00, 15, 'img/productos/tensiometro.jpg', 'otros', 'Omron', '7501234567813', FALSE);

-- Verificar los datos insertados
SELECT COUNT(*) as total_productos FROM productos;
SELECT categoria, COUNT(*) as cantidad FROM productos GROUP BY categoria;


-- Crear la tabla ventas
CREATE TABLE IF NOT EXISTS ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fecha_venta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
    FOREIGN KEY (producto) REFERENCES productos(nombre)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

-- Insertar datos de ejemplo en ventas
INSERT INTO ventas (producto_id, cantidad, total, fecha_venta, metodo_pago) VALUES
(1, 1, 15.50, CURDATE(), 'efectivo'),
(2, 2, 45.50, CURDATE(), 'tarjeta'),
(3, 1, 45.80, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'transferencia'),
(4, 3, 86.70, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'efectivo'),
(5, 4, 73.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'tarjeta'),
(6, 2, 77.20, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'transferencia'),
(7, 3, 144.60, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'tarjeta'),
(1, 2, 31.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'efectivo'),
(2, 1, 22.75, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'efectivo'),
(3, 3, 137.40, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'transferencia'),
(4, 2, 57.80, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'efectivo'),
(5, 2, 36.50, DATE_SUB(CURDATE(), INTERVAL 7 DAY), 'tarjeta'),
(6, 1, 38.60, DATE_SUB(CURDATE(), INTERVAL 8 DAY), 'transferencia'),
(7, 1, 48.20, DATE_SUB(CURDATE(), INTERVAL 9 DAY), 'tarjeta'),
(1, 5, 77.50, DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'efectivo'),
(2, 4, 91.00, DATE_SUB(CURDATE(), INTERVAL 11 DAY), 'tarjeta'),
(3, 2, 91.60, DATE_SUB(CURDATE(), INTERVAL 12 DAY), 'efectivo'),
(4, 1, 28.90, DATE_SUB(CURDATE(), INTERVAL 13 DAY), 'transferencia'),
(5, 3, 54.75, DATE_SUB(CURDATE(), INTERVAL 14 DAY), 'tarjeta'),
(6, 2, 77.20, DATE_SUB(CURDATE(), INTERVAL 15 DAY), 'efectivo'),
(7, 1, 48.20, DATE_SUB(CURDATE(), INTERVAL 16 DAY), 'transferencia'),
(1, 3, 46.50, CURDATE(), 'efectivo'),
(2, 2, 45.50, CURDATE(), 'tarjeta'),
(3, 1, 45.80, CURDATE(), 'transferencia'),
(4, 3, 86.70, CURDATE(), 'efectivo'),
(5, 4, 73.00, CURDATE(), 'tarjeta'),
(6, 2, 77.20, CURDATE(), 'transferencia'),
(7, 3, 144.60, CURDATE(), 'tarjeta'),
(1, 2, 31.00, CURDATE(), 'efectivo'),
(2, 1, 22.75, CURDATE(), 'efectivo'),
(3, 3, 137.40, CURDATE(), 'transferencia'),
(4, 2, 57.80, CURDATE(), 'efectivo'),
(5, 2, 36.50, CURDATE(), 'tarjeta'),
(6, 1, 38.60, CURDATE(), 'transferencia'),
(7, 1, 48.20, CURDATE(), 'tarjeta'),
(1, 5, 77.50, CURDATE(), 'efectivo'),
(2, 1, 22.75, CURDATE(), 'efectivo'),
(2, 3, 68.25, CURDATE(), 'efectivo'),
(2, 2, 45.50, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'efectivo'),
(2, 4, 91.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'efectivo'),
(2, 5, 113.75, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'efectivo'),
(2, 1, 22.75, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'efectivo'),
(2, 2, 45.50, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'efectivo'),
(2, 3, 68.25, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'efectivo'),
(2, 1, 22.75, DATE_SUB(CURDATE(), INTERVAL 7 DAY), 'efectivo'),
(2, 2, 45.50, DATE_SUB(CURDATE(), INTERVAL 8 DAY), 'efectivo');
