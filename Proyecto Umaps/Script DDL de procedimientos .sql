/*Proceso 1       ResumenAnual*/




DELIMITER $$

/* ejecutar el drop si se desea realizar el procedimiento por segunda vez 
DROP PROCEDURE IF EXISTS ResumenAnual;

*/
CREATE PROCEDURE ResumenAnual(
    IN p_anio INT
)
BEGIN
    SELECT 
        u.id_usuario,
        u.nombre AS Nombre,
        p_anio AS Anio,
        COALESCE(SUM(l.consumo_m3), 0) AS Consumo_Total_m3,
        COALESCE(SUM(f.total_a_pagar), 0) AS Total_Facturado,
        COALESCE(SUM(r.monto_pagado), 0) AS Total_Pagado
    FROM usuarios u
    LEFT JOIN lecturas l ON u.id_usuario = l.id_usuario AND YEAR(l.fecha_lectura) = p_anio
    LEFT JOIN facturas f ON u.id_usuario = f.id_usuario AND YEAR(f.fecha_emision) = p_anio
    LEFT JOIN recibos_de_pago r ON u.id_usuario = r.id_usuario AND YEAR(r.fecha_pago) = p_anio
    GROUP BY u.id_usuario, u.nombre
    ORDER BY Total_Facturado DESC;
END $$

DELIMITER ;

CALL ResumenAnual(2025);






/* procedimiento 2  ListarUsuariosPorCategoriaYAnio */




DELIMITER $$
/* ejecutar el drop si se desea realizar el procedimiento por segunda vez 
DROP PROCEDURE IF EXISTS ListarUsuariosPorCategoriaYAnio;
*/
CREATE PROCEDURE ListarUsuariosPorCategoriaYAnio(
    IN p_categoria ENUM('Residencial', 'Comercial', 'Industrial'),
    IN p_anio INT
)
BEGIN
    SELECT 
        id_usuario,
        nombre,
        direccion,
        categoria,
        YEAR(fecha_registro) AS anio_registro
    FROM usuarios
    WHERE categoria = p_categoria
      AND YEAR(fecha_registro) = p_anio;
END $$

DELIMITER ;

CALL ListarUsuariosPorCategoriaYAnio('Residencial', 2024);




/*Procedimiento 3*/


DELIMITER $$

/* ejecutar el drop si se desea realizar el procedimiento por segunda vez 
DROP PROCEDURE IF EXISTS montosporaños;
*/
CREATE PROCEDURE montosporaños(
    IN p_anio INT
)
BEGIN

    SELECT 
        u.nombre AS nombre_usuario,
        f.total_a_pagar,
        YEAR(f.fecha_emision) AS anio_factura
    FROM usuarios u
    JOIN facturas f ON u.id_usuario = f.id_usuario
    WHERE YEAR(f.fecha_emision) = p_anio;
END $$

DELIMITER ;

CALL montosporaños(2024);