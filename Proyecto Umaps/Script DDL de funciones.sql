
/*Función para calcular el total a pagar de una factura, tomando en cuenta los pagos parciales y el saldo pendiente*/

DELIMITER $$


/* ejecutar el drop si se desea realizar el procedimiento por segunda vez 
DROP FUNCTION IF EXISTS calcular_total_a_pagar;
*/
CREATE FUNCTION calcular_total_a_pagar(id_factura INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE saldo DECIMAL(10,2);
    DECLARE total_pagado DECIMAL(10,2);

    -- Obtener el total de la factura (LIMIT 1 para evitar más de una fila)
    SELECT total_a_pagar INTO total
    FROM facturas
    WHERE id_factura = id_factura
    LIMIT 1;

    -- Obtener el saldo pendiente (LIMIT 1 para evitar más de una fila)
    SELECT saldo_pendiente INTO saldo
    FROM facturas
    WHERE id_factura = id_factura
    LIMIT 1;

    -- Obtener el total pagado hasta el momento
    SELECT SUM(monto_pagado) INTO total_pagado
    FROM recibos_de_pago
    WHERE id_factura = id_factura;

    -- Calcular el total a pagar considerando el saldo pendiente y los pagos realizados
    RETURN total - total_pagado + saldo;
END $$

DELIMITER ;
SELECT calcular_total_a_pagar(1); -- Donde 1 es el ID de la factura.





/* Función para obtener el consumo total de agua de un usuario específico entre dos fechas */


DELIMITER $$
/* ejecutar el drop si se desea realizar el procedimiento por segunda vez 
DROP FUNCTION IF EXISTS obtener_consumo_usuario;
*/
CREATE FUNCTION obtener_consumo_usuario(id_usuario INT, fecha_inicio DATE, fecha_fin DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_consumo INT;

    -- Sumar el consumo de agua entre las lecturas de las fechas proporcionadas
    SELECT SUM(consumo_m3) INTO total_consumo
    FROM lecturas
    WHERE id_usuario = id_usuario 
    AND fecha_lectura BETWEEN fecha_inicio AND fecha_fin;

    RETURN total_consumo;
END $$

DELIMITER ;

SELECT obtener_consumo_usuario(1, '2024-01-01', '2024-03-01'); -- Donde 1 es el ID del usuario


/* Función para obtener el descuento aplicado a un usuario (en caso de tener descuento por adulto mayor o algún otro concepto)*/

DELIMITER $$
/* ejecutar el drop si se desea realizar el procedimiento por segunda vez 
DROP FUNCTION IF EXISTS obtener_descuento_usuario;
*/
CREATE FUNCTION obtener_descuento_usuario(id_usuario INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE descuento DECIMAL(10,2);
    
    -- Sumar los descuentos aplicados al usuario desde el detalle de la factura
    SELECT SUM(monto) INTO descuento
    FROM detalle_factura df
    JOIN conceptos c ON df.id_concepto = c.id_concepto
    WHERE df.id_factura IN (SELECT id_factura FROM facturas WHERE id_usuario = id_usuario)
    AND c.nombre LIKE '%Desc.%'; -- Asumiendo que los descuentos tienen "Desc." en el nombre del concepto

    IF descuento IS NULL THEN
        SET descuento = 0;
    END IF;

    RETURN descuento;
END $$

DELIMITER ;


SELECT obtener_descuento_usuario(1); -- Donde 1 es el ID del usuario
