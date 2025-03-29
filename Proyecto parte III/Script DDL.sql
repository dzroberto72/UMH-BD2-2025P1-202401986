-- SELECCIONAR O CREAR BASE DE DATOS
CREATE DATABASE IF NOT EXISTS sistema_facturacion;
USE sistema_facturacion;

-- CREACIÓN DE TABLA RECIBOS DE PAGO
CREATE TABLE Recibos_De_Pago (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_factura INT NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL
);

-- CREACIÓN DE TABLA DE LOGS
CREATE TABLE logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_evento VARCHAR(50) NOT NULL,
    data TEXT NOT NULL
);

-- PROCEDIMIENTO ALMACENADO PARA REGISTRAR UN NUEVO RECIBO DE PAGO
DELIMITER $$
CREATE PROCEDURE RegistrarRecibo (
    IN p_id_usuario INT,
    IN p_id_factura INT,
    IN p_monto_pagado DECIMAL(10,2),
    IN p_fecha_pago DATE
)
BEGIN
    -- Insertar el recibo de pago
    INSERT INTO Recibos_De_Pago (id_usuario, id_factura, monto_pagado, fecha_pago) 
    VALUES (p_id_usuario, p_id_factura, p_monto_pagado, p_fecha_pago);
END$$
DELIMITER ;

-- TRIGGER PARA REGISTRAR LOG CUANDO SE INSERTA UN NUEVO RECIBO
DELIMITER $$
CREATE TRIGGER after_insert_recibo
AFTER INSERT ON Recibos_De_Pago
FOR EACH ROW
BEGIN
    INSERT INTO logs (tipo_evento, data) 
    VALUES ('Inserción de Recibo', CONCAT('Pago registrado: ID ', NEW.id_pago, ', Usuario ', NEW.id_usuario, ', Monto ', NEW.monto_pagado, ', Fecha ', NEW.fecha_pago));
END$$
DELIMITER ;

-- INSERCIÓN DE DATOS DE PRUEBA
INSERT INTO Recibos_De_Pago (id_usuario, id_factura, monto_pagado, fecha_pago) VALUES
(1, 101, 150.00, CURDATE()),
(2, 102, 200.00, CURDATE());

-- CONSULTA PARA VER LOS RESULTADOS DE LOS LOGS
SELECT * FROM logs;
