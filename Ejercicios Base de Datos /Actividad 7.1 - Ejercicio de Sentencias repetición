-- Crear tabla para almacenar los resultados del simulador
CREATE TABLE IF NOT EXISTS SimuladorAhorro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mes INT,
    monto_mensual DECIMAL(10, 2),
    saldo_acumulado DECIMAL(10, 2)
);

-- Procedimiento almacenado para simular el ahorro
DELIMITER //
CREATE PROCEDURE SimularAhorro(
    IN p_monto DECIMAL(10, 2),
    IN p_meses INT
)
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_saldo_acumulado DECIMAL(10, 2) DEFAULT 0;
    
    -- Limpiar tabla antes de insertar nuevos datos
    TRUNCATE TABLE SimuladorAhorro;
    
    -- Generar registros para cada mes
    WHILE v_contador <= p_meses DO
        -- Calcular saldo acumulado
        SET v_saldo_acumulado = v_saldo_acumulado + p_monto;
        
        -- Insertar registro en la tabla
        INSERT INTO SimuladorAhorro (mes, monto_mensual, saldo_acumulado)
        VALUES (v_contador, p_monto, v_saldo_acumulado);
        
        -- Incrementar contador
        SET v_contador = v_contador + 1;
    END WHILE;
    
    -- Mostrar resultados con formato de miles
    SELECT 
        mes AS 'Mes', 
        FORMAT(monto_mensual, 2) AS 'Monto Mensual', 
        FORMAT(saldo_acumulado, 2) AS 'Saldo Acumulado'
    FROM SimuladorAhorro
    ORDER BY mes;
END //
DELIMITER ;


CALL SimularAhorro(850.00, 12);

SELECT * FROM SimuladorAhorro;
