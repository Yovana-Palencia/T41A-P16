# 📘 Introducción a Triggers en PostgreSQL

## 🔍 ¿Qué es un Trigger?
Un **trigger** en PostgreSQL es un mecanismo que permite ejecutar automáticamente una función cuando ocurre un evento específico en una tabla, como una **inserción**, **actualización** o **eliminación**.

### 🔄 ¿Cómo funciona?
Un trigger se compone de:
- **Evento que lo activa**: `INSERT`, `UPDATE`, `DELETE`, o `TRUNCATE`.
- **Momento de activación**:
  - `BEFORE`: antes de que se ejecute la operación.
  - `AFTER`: después de que se ejecute la operación.
  - `INSTEAD OF`: reemplaza la operación (usado en vistas).
- **Función asociada**: el trigger llama a una función que contiene la lógica a ejecutar.

### 🧪 Ejemplo práctico
Supongamos que tenemos una tabla `productos` y queremos registrar cada vez que se actualiza el stock:

```sql
CREATE OR REPLACE FUNCTION registrar_auditoria_stock()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria_stock (producto_id, stock_anterior, stock_nuevo)
    VALUES (OLD.id, OLD.stock, NEW.stock);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auditoria_stock
AFTER UPDATE OF stock ON productos
FOR EACH ROW
WHEN (OLD.stock IS DISTINCT FROM NEW.stock)
EXECUTE FUNCTION registrar_auditoria_stock();
```

Este trigger se activa **después** de que se actualice el campo `stock` en la tabla `productos`, y registra el cambio en la tabla `auditoria_stock`.

---

# 📦 Proyecto Didáctico: Control de Inventario Automatizado con PostgreSQL

## 🎯 Objetivo

Diseñar y desarrollar una base de datos para gestionar el inventario de una empresa industrial, utilizando **procedimientos almacenados**, **funciones** y **triggers** en **PostgreSQL** para automatizar tareas comunes como actualizaciones de stock, auditorías y cálculos de valor de inventario.

---

## 🧩 Modelo de Datos

### Tablas principales:

```sql
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    stock INT NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL
);

CREATE TABLE movimientos_inventario (
    id SERIAL PRIMARY KEY,
    producto_id INT REFERENCES productos(id),
    tipo_movimiento TEXT CHECK (tipo_movimiento IN ('entrada', 'salida')),
    cantidad INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE auditoria_stock (
    id SERIAL PRIMARY KEY,
    producto_id INT,
    stock_anterior INT,
    stock_nuevo INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## ⚙️ Procedimiento Almacenado

### registrar_movimiento

Registra un movimiento de inventario y actualiza el stock del producto.


---

## 🧮 Función

### calcular_valor_inventario

Calcula el valor total del inventario actual.



---

## 🔄 Trigger

### Auditoría de cambios en el stock

Registra automáticamente los cambios en el stock de productos.


---

## 🧪 Pruebas y Simulación

```sql
-- Insertar productos
INSERT INTO productos (nombre, stock, precio_unitario) VALUES ('Tornillo', 100, 0.50);
INSERT INTO productos (nombre, stock, precio_unitario) VALUES ('Tuerca', 200, 0.30);

-- Registrar movimientos
CALL registrar_movimiento(1, 'salida', 20);
CALL registrar_movimiento(2, 'entrada', 50);

-- Calcular valor del inventario
SELECT calcular_valor_inventario();

-- Ver auditoría
SELECT * FROM auditoria_stock;
```

---

## 📚 Conclusión

Este proyecto permite a los estudiantes:

- Comprender el uso de **procedimientos almacenados** para encapsular lógica de negocio.
- Aplicar **funciones** para cálculos reutilizables.
- Implementar **triggers** para automatizar auditorías y mejorar la trazabilidad.

Ideal para reforzar conceptos clave de PostgreSQL en un contexto industrial realista.



