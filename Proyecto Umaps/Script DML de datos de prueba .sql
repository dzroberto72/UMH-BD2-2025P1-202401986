/* 
Datos de prueba  
Codigo para insertar diferentes datos en las tablas ya existentes para realizar procedimientos
*/


USE sistema_facturacion_agua;

-- Insertar usuarios
INSERT INTO usuarios (nombre, direccion, categoria, fecha_registro) VALUES
('Juan Pérez', 'Av. Principal #123, Ciudad', 'Residencial', '2024-01-10'),
('María López', 'Calle Secundaria #456, Ciudad', 'Comercial', '2023-11-25'),
('Carlos Ramírez', 'Colonia Centro #789, Ciudad', 'Residencial', '2022-07-05');


-- Insertar lecturas de consumo de agua
INSERT INTO lecturas (id_usuario, lectura_anterior, lectura_actual, fecha_lectura) VALUES
(1, 100, 120, '2024-03-01'), -- Consumo: 20 m3
(2, 250, 270, '2024-03-01'), -- Consumo: 20 m3
(3, 500, 530, '2024-03-01'); -- Consumo: 30 m3



-- Insertar facturas de los usuarios
INSERT INTO facturas (id_usuario, fecha_emision, fecha_vencimiento, total_a_pagar, saldo_pendiente) VALUES
(1, '2024-03-05', '2024-03-20', 300.50, 0.00),
(2, '2024-03-05', '2024-03-20', 450.75, 50.00),  -- Saldo pendiente de meses anteriores
(3, '2024-03-05', '2024-03-20', 600.25, 20.00);

INSERT INTO conceptos (nombre, descripcion) VALUES
('Agua potable', 'Cobro por el consumo de agua potable'),
('Alcantarillado sanitario', 'Servicio de alcantarillado'),
('Mantenimiento medidor', 'Costo de mantenimiento del medidor'),
('Intereses moratorios', 'Intereses por mora en el pago'),
('Costo fijo', 'Tarifa fija mensual'),
('(-) Desc. adulto mayor', 'Descuento para adultos mayores'),
('Acta de compromiso', 'Pago de acuerdo a acta de compromiso'),
('Otros', 'Otros cobros adicionales'),
('Consumo del mes', 'Cargo por el consumo del mes'),
('Saldo Pendiente', 'Monto no pagado de periodos anteriores')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- Insertar detalles de facturas con conceptos
INSERT INTO detalle_factura (id_factura, id_concepto, monto) VALUES
(1, 1, 150.00), -- Agua potable
(1, 2, 50.00),  -- Alcantarillado sanitario
(1, 5, 100.50), -- Costo fijo

(2, 1, 200.00), -- Agua potable
(2, 2, 75.00),  -- Alcantarillado sanitario
(2, 4, 25.75),  -- Intereses moratorios
(2, 5, 100.00), -- Costo fijo

(3, 1, 300.00), -- Agua potable
(3, 2, 100.00), -- Alcantarillado sanitario
(3, 5, 150.25); -- Costo fijo








-- Insertar pagos de usuarios
INSERT INTO recibos_de_pago (id_usuario, id_factura, monto_pagado, fecha_pago) VALUES
(1, 1, 300.50, '2024-03-10'), -- Pago total
(2, 2, 400.00, '2024-03-15'), -- Pago parcial
(3, 3, 600.25, '2024-03-18'); -- Pago total






/*
Mostrar Datos insertados
en las tablas
por medio de un  select from que mostrara la información registrada
*/

select * from sistema_facturacion_agua.usuarios;


select * from sistema_facturacion_agua.lecturas;


select * from sistema_facturacion_agua.detalle_factura;


select * from sistema_facturacion_agua.facturas;


select * from sistema_facturacion_agua.conceptos;

