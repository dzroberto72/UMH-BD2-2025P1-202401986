-- Creación de tablas
CREATE TABLE IF NOT EXISTS Cuentas (
    Cuenta INT PRIMARY KEY,
    TotalCreditos DECIMAL(10, 2) DEFAULT 0.00,
    TotalDebitos DECIMAL(10, 2) DEFAULT 0.00,
    Saldo DECIMAL(10, 2) DEFAULT 0.00
);

CREATE TABLE IF NOT EXISTS cj_Transacciones (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Cuenta INT,
    Fecha DATE,
    Credito DECIMAL(10, 2) DEFAULT 0.00,
    Debito DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (Cuenta) REFERENCES Cuentas(Cuenta)
);

-- Procedimiento almacenado para registrar transacciones
DELIMITER //

CREATE PROCEDURE RegistrarTransaccion(
    IN p_Cuenta INT,
    IN p_Fecha DATE,
    IN p_Credito DECIMAL(10, 2),
    IN p_Debito DECIMAL(10, 2)
)
BEGIN
    DECLARE v_CuentaExiste INT;
    
    -- Validar que los montos no sean negativos
    IF p_Credito < 0 OR p_Debito < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Los montos de crédito y débito no pueden ser negativos';
    END IF;
    
    -- Verificar si la cuenta existe
    SELECT COUNT(*) INTO v_CuentaExiste FROM Cuentas WHERE Cuenta = p_Cuenta;
    
    -- Si la cuenta no existe, crearla
    IF v_CuentaExiste = 0 THEN
        INSERT INTO Cuentas (Cuenta, TotalCreditos, TotalDebitos, Saldo) 
        VALUES (p_Cuenta, 0.00, 0.00, 0.00);
    END IF;
    
    -- Insertar la transacción
    INSERT INTO cj_Transacciones (Cuenta, Fecha, Credito, Debito)
    VALUES (p_Cuenta, p_Fecha, p_Credito, p_Debito);
    
    -- Actualizar los totales en la tabla Cuentas
    UPDATE Cuentas
    SET TotalCreditos = TotalCreditos + p_Credito,
        TotalDebitos = TotalDebitos + p_Debito,
        Saldo = TotalCreditos - TotalDebitos
    WHERE Cuenta = p_Cuenta;
    
    -- Mostrar la información actualizada de la cuenta
    SELECT 
        Cuenta,
        FORMAT(TotalCreditos, 2) AS 'Total Créditos',
        FORMAT(TotalDebitos, 2) AS 'Total Débitos',
        FORMAT(Saldo, 2) AS 'Saldo Actual'
    FROM Cuentas
    WHERE Cuenta = p_Cuenta;
END //

DELIMITER ;

-- Procedimiento para ingresar los datos alas cuentas
CALL RegistrarTransaccion(20010001, '2025-03-08', 5000.00, 0.00);
CALL RegistrarTransaccion(20010002, '2025-03-08', 5000.00, 0.00);
CALL RegistrarTransaccion(20010003, '2025-03-08', 6000.00, .00);
CALL RegistrarTransaccion(20010007, '2025-03-08', 3000.00, 0.00);

-- elimnacion de cuenta 
DELIMITER //

CREATE PROCEDURE EliminarCuenta(
    IN p_Cuenta INT
)
BEGIN
    DECLARE v_CuentaExiste INT;
    
    -- Verificar si la cuenta existe
    SELECT COUNT(*) INTO v_CuentaExiste
    FROM Cuentas
    WHERE Cuenta = p_Cuenta;
    
    IF v_CuentaExiste = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cuenta especificada no existe';
    ELSE
        -- Eliminar transacciones asociadas
        DELETE FROM cj_Transacciones WHERE Cuenta = p_Cuenta;
        
        -- Eliminar la cuenta
        DELETE FROM Cuentas WHERE Cuenta = p_Cuenta;
        
        SELECT 'Cuenta y transacciones eliminadas correctamente' AS Resultado;
    END IF;
END //

DELIMITER ;

CALL EliminarCuenta(2001000666);

-- Procedimiento para llamar las tablas de las cuentas
SELECT * FROM Cuentas;
SELECT * FROM cj_Transacciones;

-- lista primera parte

-- Procedimiento para visualizar todas las cuentas con formato
DELIMITER //
CREATE PROCEDURE VerCuentas()
BEGIN
    SELECT 
        Cuenta,
        FORMAT(TotalCreditos, 2) AS 'Total Créditos',
        FORMAT(TotalDebitos, 2) AS 'Total Débitos',
        FORMAT(Saldo, 2) AS 'Saldo Actual'
    FROM Cuentas
    ORDER BY Cuenta;
END //

DELIMITER ;

-- segunda parte lista
 
-- Procedimiento para visualizar transacciones 
DELIMITER //
CREATE PROCEDURE VerTransacciones(IN p_Cuenta INT)
BEGIN
    SELECT 
        ID,
        Cuenta,
        Fecha,
        FORMAT(Credito, 2) AS 'Crédito',
        FORMAT(Debito, 2) AS 'Débito'
    FROM cj_Transacciones
    WHERE Cuenta = p_Cuenta OR p_Cuenta IS NULL
    ORDER BY Fecha, ID;
END //

DELIMITER ;
-- tercera parte lista

-- Procedimiento para debito
DELIMITER //

CREATE PROCEDURE RegistrarDebito(
    IN p_Cuenta INT,
    IN p_Fecha DATE,
    IN p_Monto DECIMAL(10, 2)
)
BEGIN
    DECLARE v_CuentaExiste INT;
    DECLARE v_SaldoActual DECIMAL(10, 2);
    
    -- Validar que el monto sea positivo
    IF p_Monto <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto del débito debe ser mayor que cero';
    END IF;
    
    -- Verificar si la cuenta existe
    SELECT COUNT(*) INTO v_CuentaExiste 
    FROM Cuentas 
    WHERE Cuenta = p_Cuenta;
    
    -- Si la cuenta no existe, mostrar error
    IF v_CuentaExiste = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cuenta especificada no existe. No se puede realizar el débito.';
    END IF;
    
    -- Verificar si hay saldo suficiente
    SELECT Saldo INTO v_SaldoActual 
    FROM Cuentas 
    WHERE Cuenta = p_Cuenta;
    
    IF v_SaldoActual < p_Monto THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo insuficiente para realizar el débito';
    END IF;
    
    -- Insertar la transacción de débito
    INSERT INTO cj_Transacciones (Cuenta, Fecha, Credito, Debito)
    VALUES (p_Cuenta, p_Fecha, 0.00, p_Monto);
    
    -- Actualizar los totales en la tabla Cuentas
    UPDATE Cuentas
    SET TotalDebitos = TotalDebitos + p_Monto,
        Saldo = Saldo - p_Monto
    WHERE Cuenta = p_Cuenta;
    
    -- Mostrar la información actualizada de la cuenta
    SELECT 
        Cuenta,
        FORMAT(TotalCreditos, 2) AS 'Total Créditos',
        FORMAT(TotalDebitos, 2) AS 'Total Débitos',
        FORMAT(Saldo, 2) AS 'Saldo Actual'
    FROM Cuentas
    WHERE Cuenta = p_Cuenta;
END //

-- Ejemplo de uso del procedimiento de débito
CALL RegistrarDebito(20010001, CURDATE(), 200.00);
CALL RegistrarDebito(20010002, CURDATE(), 200.00);
CALL RegistrarDebito(20010003, CURDATE(), 200.00);

-- cuarta parte lista

-- Saldo actual
DELIMITER //

CREATE PROCEDURE ConsultarSaldoActual(
    IN p_Cuenta INT
)
BEGIN
    DECLARE v_CuentaExiste INT;
    
    -- Verificar si la cuenta existe
    SELECT COUNT(*) INTO v_CuentaExiste 
    FROM Cuentas 
    WHERE Cuenta = p_Cuenta;
    
    -- Si la cuenta no existe, mostrar error
    IF v_CuentaExiste = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cuenta especificada no existe';
    ELSE
        -- Mostrar información completa de la cuenta con formato adecuado
        SELECT 
            Cuenta,
            FORMAT(TotalCreditos, 2) AS 'Total Créditos',
            FORMAT(TotalDebitos, 2) AS 'Total Débitos',
            FORMAT(Saldo, 2) AS 'Saldo Actual',
            CASE 
                WHEN Saldo > 5000 THEN 'EXCELENTE'
                WHEN Saldo BETWEEN 1000 AND 5000 THEN 'BUENO'
                WHEN Saldo BETWEEN 1 AND 999.99 THEN 'REGULAR'
                ELSE 'CRÍTICO'
            END AS 'Estado de Cuenta'
        FROM Cuentas
        WHERE Cuenta = p_Cuenta;
        
        -- Mostrar las últimas 5 transacciones de la cuenta
        SELECT 
            ID,
            Fecha,
            FORMAT(Credito, 2) AS 'Crédito',
            FORMAT(Debito, 2) AS 'Débito',
            CASE 
                WHEN Credito > 0 THEN 'INGRESO'
                WHEN Debito > 0 THEN 'RETIRO'
                ELSE 'OTRO'
            END AS 'Tipo'
        FROM cj_Transacciones
        WHERE Cuenta = p_Cuenta
        ORDER BY Fecha DESC, ID DESC
        LIMIT 5;
    END IF;
END //

DELIMITER ;

-- quinta parte lista

-- Procedimiento para consultar saldos de todas las cuentas
DELIMITER //

CREATE PROCEDURE ConsultarTodasLasCuentas()
BEGIN
    -- Mostrar información de todas las cuentas con formato
    SELECT 
        ROW_NUMBER() OVER (ORDER BY Cuenta) AS 'N°',
        Cuenta,
        FORMAT(TotalCreditos, 2) AS 'Total Créditos',
        FORMAT(TotalDebitos, 2) AS 'Total Débitos',
        FORMAT(Saldo, 2) AS 'Saldo Actual',
        CASE 
            WHEN Saldo > 5000 THEN 'EXCELENTE'
            WHEN Saldo BETWEEN 1000 AND 5000 THEN 'BUENO'
            WHEN Saldo BETWEEN 1 AND 999.99 THEN 'REGULAR'
            ELSE 'CRÍTICO'
        END AS 'Estado de Cuenta'
    FROM Cuentas
    ORDER BY Cuenta;
    
    -- Mostrar estadísticas generales
    SELECT 
        COUNT(*) AS 'Total de Cuentas',
        FORMAT(SUM(TotalCreditos), 2) AS 'Total Créditos Sistema',
        FORMAT(SUM(TotalDebitos), 2) AS 'Total Débitos Sistema',
        FORMAT(SUM(Saldo), 2) AS 'Saldo Total Sistema'
    FROM Cuentas;
END //
DELIMITER ;

-- Ejemplo de uso
-- Para consultar una cuenta específica
CALL ConsultarSaldoActual(20010001);
CALL ConsultarSaldoActual(20010006);
CALL ConsultarSaldoActual(20010007);

-- Para consultar todas las cuentas
 CALL ConsultarTodasLasCuentas();

