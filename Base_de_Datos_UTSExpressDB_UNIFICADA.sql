USE master;
GO

IF DB_ID('UTSExpressDB') IS NOT NULL
BEGIN
    ALTER DATABASE UTSExpressDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE UTSExpressDB;
END
GO

CREATE DATABASE UTSExpressDB;
GO
USE UTSExpressDB;
GO

CREATE TABLE Usuarios
(
    Id_Usuario INT IDENTITY(1,1) PRIMARY KEY,
    Matricula VARCHAR(50) NOT NULL UNIQUE,
    [Contraseña] VARCHAR(50) NOT NULL,
    Rol VARCHAR(20) NOT NULL DEFAULT 'Cliente'
);
GO

CREATE TABLE Metodo_Pago
(
    Id_MetodoPago INT IDENTITY(1,1) PRIMARY KEY,
    Efectivo BIT NOT NULL,
    Tarjeta BIT NOT NULL
);
GO

CREATE TABLE Menu
(
    Id_Menu INT IDENTITY(1,1) PRIMARY KEY,
    Dia VARCHAR(15) NOT NULL UNIQUE,
    Id_Admin INT NOT NULL FOREIGN KEY REFERENCES Usuarios(Id_Usuario)
);
GO

CREATE TABLE Categoria
(
    Id_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Id_Menu INT NOT NULL FOREIGN KEY REFERENCES Menu(Id_Menu),
    Id_CategoriaPadre INT NULL
);
GO
ALTER TABLE Categoria
ADD CONSTRAINT FK_Categoria_CategoriaPadre
FOREIGN KEY (Id_CategoriaPadre) REFERENCES Categoria(Id_Categoria);
GO

CREATE TABLE Producto
(
    Id_Producto INT IDENTITY(1,1) PRIMARY KEY,
    Id_Categoria INT NOT NULL FOREIGN KEY REFERENCES Categoria(Id_Categoria),
    Nombre VARCHAR(50) NOT NULL,
    [Descripción] VARCHAR(150) NULL,
    Precio DECIMAL(8,2) NOT NULL,
    Imagen VARCHAR(225) NULL
);
GO

-- Relación del proyecto de menú semanal de tu amiga.
CREATE TABLE Menu_Producto
(
    Id_Menu INT NOT NULL FOREIGN KEY REFERENCES Menu(Id_Menu),
    Id_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(Id_Producto),
    CONSTRAINT PK_Menu_Producto PRIMARY KEY (Id_Menu, Id_Producto)
);
GO

CREATE TABLE Pedido
(
    Id_Pedido INT IDENTITY(1,1) PRIMARY KEY,
    Fecha_Pedido DATETIME NOT NULL,
    Total DECIMAL(8,2) NOT NULL,
    Estado VARCHAR(20) NULL,
    Id_Usuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(Id_Usuario),
    Id_MetodoPago INT NULL FOREIGN KEY REFERENCES Metodo_Pago(Id_MetodoPago)
);
GO

CREATE TABLE DetallePedido
(
    Id_Detalle INT IDENTITY(1,1) PRIMARY KEY,
    Id_Pedido INT NOT NULL FOREIGN KEY REFERENCES Pedido(Id_Pedido),
    Id_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(Id_Producto),
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(8,2) NOT NULL,
    Subtotal DECIMAL(8,2) NOT NULL
);
GO

CREATE TABLE [Reseña]
(
    [Id_Reseña] INT IDENTITY(1,1) PRIMARY KEY,
    Comentario VARCHAR(50) NOT NULL,
    Id_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(Id_Producto),
    Id_Usuario INT NOT NULL FOREIGN KEY REFERENCES Usuarios(Id_Usuario)
);
GO

CREATE TABLE Carrito
(
    Id_Carrito INT IDENTITY(1,1) PRIMARY KEY,
    Id_Usuario INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Usuarios(Id_Usuario)
);
GO

CREATE TABLE Proveedor
(
    Id_Proveedor INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Empresa VARCHAR(50) NOT NULL,
    Contacto VARCHAR(50) NULL,
    Telefono VARCHAR(15) NOT NULL,
    Correo VARCHAR(50) NULL,
    Direccion VARCHAR(100) NULL
);
GO

CREATE TABLE Inventario
(
    Id_Inventario INT IDENTITY(1,1) PRIMARY KEY,
    Id_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(Id_Producto),
    Cantidad_Disponible INT NOT NULL,
    Stock_Minimo INT NOT NULL,
    Stock_Maximo INT NOT NULL,
    Ultima_Actualizacion DATETIME NOT NULL,
    Id_Proveedor INT NULL FOREIGN KEY REFERENCES Proveedor(Id_Proveedor)
);
GO

-- Usuarios que ya estaban en las bases del equipo.
INSERT INTO Usuarios (Matricula, [Contraseña], Rol)
VALUES
('ADMIN-UTS', 'admin123', 'Administrador'),
('20240001', 'alumno123', 'Cliente');
GO

INSERT INTO Metodo_Pago (Efectivo, Tarjeta)
VALUES (1,0), (0,1);
GO

-- Los cinco días del proyecto de tu amiga.
INSERT INTO Menu (Dia, Id_Admin)
VALUES
('Lunes', 1),
('Martes', 1),
('Miércoles', 1),
('Jueves', 1),
('Viernes', 1);
GO

-- Categorías que ya existían en el proyecto visual.
INSERT INTO Categoria (Nombre, Id_Menu, Id_CategoriaPadre)
VALUES
('Dulces', 1, NULL),
('Bebidas', 1, NULL),
('Galletas', 1, NULL),
('Cafés', 1, NULL),
('Comidas', 1, NULL),
('Snacks', 1, NULL),
('Combos', 1, NULL);
GO

INSERT INTO Categoria (Nombre, Id_Menu, Id_CategoriaPadre)
VALUES
('Refrescos', 1, 2),
('Jugos', 1, 2),
('Lácteos', 1, 2),
('Naturales', 1, 2),
('Clásicas', 1, 3),
('Con Chips', 1, 3),
('Avena', 1, 3),
('Rellenas', 1, 3);
GO

-- Productos que ya estaban en el proyecto visual del compañero.
INSERT INTO Producto (Id_Categoria, Nombre, [Descripción], Precio, Imagen)
VALUES
(1, 'Muffin de Chocolate', 'Panquecito suave de chocolate', 28.00, 'muffin_chocolate.jpg'),
(2, 'Frappe de Vainilla', 'Bebida fria de vainilla', 40.00, 'frappe_vainilla.jpg'),
(3, 'Galleta Surtida', 'Seleccion de galletas', 18.00, 'galleta_avena.jpg'),
(4, 'Cafe Americano', 'Cafe negro clasico', 25.00, 'cafe_americano.jpg'),
(4, 'Capuchino', 'Cafe con espuma de leche', 35.00, 'capuchino.jpg'),
(4, 'Latte de Vainilla', 'Cafe con leche y vainilla', 38.00, 'latte_vainilla.jpg'),
(5, 'Sandwich de Pollo', 'Pollo, queso y vegetales', 55.00, 'sandwich_pollo.jpg'),
(5, 'Burrito de Frijol', 'Burrito con frijol y queso', 45.00, 'burrito_frijol.jpg'),
(6, 'Snack Express', 'Snack para acompañar', 20.00, 'producto_sin_imagen.jpg'),
(7, 'Combo Desayuno', 'Cafe, sandwich y galleta', 75.00, 'combo_desayuno.jpg'),
(7, 'Combo Express', 'Burrito, bebida y snack', 90.00, 'combo_express.jpg'),
(8, 'Coca Cola 600 ml', 'Refresco sabor cola original', 22.00, 'refresco_cola.jpg'),
(9, 'Jumex Mango', 'Jugo natural de mango', 20.00, 'producto_sin_imagen.jpg'),
(10, 'Bebida de Chocolate', 'Bebida lactea de chocolate', 24.00, 'producto_sin_imagen.jpg'),
(11, 'Agua Natural', 'Botella de agua natural', 15.00, 'agua_natural.jpg'),
(12, 'Galleta Canelitas', 'Galleta con sabor a canela', 20.00, 'galleta_avena.jpg'),
(13, 'Galleta ChocoChips', 'Galleta con trozos de chocolate', 15.50, 'muffin_chocolate.jpg'),
(14, 'Galleta Avena Express', 'Galleta de avena con pasas', 12.00, 'galleta_avena.jpg'),
(15, 'Galleta Rellena', 'Galleta rellena de chocolate', 18.00, 'muffin_chocolate.jpg');
GO

-- Los cinco productos que quedaron en el menú semanal de tu amiga.
INSERT INTO Producto (Id_Categoria, Nombre, [Descripción], Precio, Imagen)
VALUES
(5, 'Enchiladas verdes', 'Orden de enchiladas verdes', 55.00, 'enchiladas.png'),
(5, 'Tacos dorados', 'Orden de tacos dorados', 50.00, 'tacos.png'),
(5, 'Hamburguesa', 'Hamburguesa con papas', 70.00, 'hamburguesa.png'),
(5, 'Milanesa de pollo', 'Milanesa acompañada', 65.00, 'pollo.png'),
(5, 'Espagueti rojo', 'Espagueti con salsa de tomate', 45.00, 'espagueti.png');
GO

-- La asignación original de esos cinco productos: uno por día.
INSERT INTO Menu_Producto (Id_Menu, Id_Producto)
SELECT M.Id_Menu, P.Id_Producto
FROM (VALUES
    ('Lunes', 'Enchiladas verdes'),
    ('Martes', 'Tacos dorados'),
    ('Miércoles', 'Hamburguesa'),
    ('Jueves', 'Milanesa de pollo'),
    ('Viernes', 'Espagueti rojo')
) AS X(Dia, Producto)
INNER JOIN Menu M ON M.Dia = X.Dia
INNER JOIN Producto P ON P.Nombre = X.Producto;
GO

-- El proyecto visual ya manejaba inventario para todos sus productos.
-- Se aplica la misma estructura a los productos del menú semanal para que ambos módulos funcionen juntos.
INSERT INTO Inventario
    (Id_Producto, Cantidad_Disponible, Stock_Minimo, Stock_Maximo, Ultima_Actualizacion, Id_Proveedor)
SELECT Id_Producto, 30, 5, 100, GETDATE(), NULL
FROM Producto;
GO

SELECT 'Base creada correctamente' AS Resultado;
SELECT COUNT(*) AS TotalProductos FROM Producto;
SELECT M.Dia, P.Nombre
FROM Menu M
LEFT JOIN Menu_Producto MP ON MP.Id_Menu = M.Id_Menu
LEFT JOIN Producto P ON P.Id_Producto = MP.Id_Producto
ORDER BY M.Id_Menu;
GO
