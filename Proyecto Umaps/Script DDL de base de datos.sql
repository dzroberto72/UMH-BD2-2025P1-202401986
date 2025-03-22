/*
Codigo de creación
Se crea una base de datos para guardar nuestras tablas
Se crean las diferentes tablas basadas en nuestro modelo
*/

DROP DATABASE IF EXISTS sistema_facturacion_agua;
CREATE DATABASE sistema_facturacion_agua;
USE sistema_facturacion_agua;

-- Tabla de Usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    direccion TEXT NOT NULL,
    categoria ENUM('Residencial', 'Comercial', 'Industrial') NOT NULL,
    fecha_registro DATE NOT NULL
);

-- Tabla de Lecturas de Consumo de Agua
CREATE TABLE lecturas (
    id_lectura INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    lectura_anterior INT NOT NULL,
    lectura_actual INT NOT NULL,
    consumo_m3 INT GENERATED ALWAYS AS (lectura_actual - lectura_anterior) STORED,
    fecha_lectura DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabla de Facturas
CREATE TABLE facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    total_a_pagar DECIMAL(10,2) NOT NULL,
    saldo_pendiente DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Nueva Tabla de Conceptos
CREATE TABLE conceptos (
    id_concepto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    descripcion TEXT
);


-- Tabla de Recibos de Pago
CREATE TABLE recibos_de_pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_factura INT NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_factura) REFERENCES facturas(id_factura)
);



-- Nueva Tabla de Detalle de Factura para asociar conceptos con facturas
CREATE TABLE detalle_factura (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT NOT NULL,
    id_concepto INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_factura) REFERENCES facturas(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (id_concepto) REFERENCES conceptos(id_concepto) ON DELETE CASCADE
);

select * from sistema_facturacion_agua.conceptos;




