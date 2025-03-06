DELIMITER //

DROP PROCEDURE IF EXISTS sp_new_currency_case;

CREATE PROCEDURE sp_new_currency_case(
    IN p_currency_name VARCHAR(45),
    IN p_currency_symbol VARCHAR(45), 
    IN p_exchange_rate DECIMAL(15,2),
    IN p_country VARCHAR(45), 
    IN p_iso_code VARCHAR(45)
) 
BEGIN  
    DECLARE v_currency_symbol VARCHAR(45);

    -- Asignar símbolo de moneda según el nombre
    CASE 
        WHEN p_currency_name LIKE '%dolar%' THEN SET v_currency_symbol = '$';
        WHEN p_currency_name LIKE '%peso%' THEN SET v_currency_symbol = 'P';
        WHEN p_currency_name LIKE '%yen%' THEN SET v_currency_symbol = '¥';
        WHEN p_currency_name LIKE '%euro%' THEN SET v_currency_symbol = '€';
        ELSE SET v_currency_symbol = p_currency_symbol;
    END CASE;

    -- Insertar valores en la tabla
    INSERT INTO currencies (
        currency_name, currency_symbol, exchange_rate, country, ISO_CODE
    )
    VALUES (p_currency_name, v_currency_symbol, p_exchange_rate, p_country, p_iso_code);

    COMMIT;  
END //

DELIMITER ;
CALL sp_new_currency_case(
    "YEN",
    "¥", 
    0, 
    "JAPON",
    "JPY"
);
