-- Función para calcular el valor total del inventario
CREATE OR REPLACE FUNCTION calcular_valor_inventario()
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(stock * precio_unitario) INTO total
    FROM productos;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;
