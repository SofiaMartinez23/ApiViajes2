DROP TABLE IF EXISTS CHAT;
DROP TABLE IF EXISTS COMENTARIOS;
DROP TABLE IF EXISTS SEGUIDORES;
DROP TABLE IF EXISTS LUGARESFAVORITOS;
DROP TABLE IF EXISTS LUGARES;
DROP TABLE IF EXISTS USUARIOLOGIN;
DROP TABLE IF EXISTS LOG_IN;
DROP TABLE IF EXISTS USUARIOS;

-- Crear tabla USUARIOS
CREATE TABLE USUARIOS (
    ID_USUARIO INT PRIMARY KEY,
    NOMBRE NVARCHAR(255) NOT NULL,
    EMAIL NVARCHAR(255) UNIQUE NOT NULL,
    EDAD INT NOT NULL,
    NACIONALIDAD NVARCHAR(100) NOT NULL,
    PREFERENCIASDEVIAJE NVARCHAR(MAX) NOT NULL,
    IMAGEN NVARCHAR(255) NOT NULL,
    FECHADEREGISTRO DATE NOT NULL
);

-- Crear tabla LOGIN
CREATE TABLE LOG_IN (
    ID_USUARIO INT PRIMARY KEY,
    CORREO NVARCHAR(255) UNIQUE NOT NULL,
    CLAVE NVARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO)
);

-- Crear tabla USUARIOLOGIN
CREATE TABLE USUARIOLOGIN (
    ID_USUARIO INT PRIMARY KEY,
    CORREO NVARCHAR(255) UNIQUE NOT NULL,
	NOMBRE NVARCHAR(255) NOT NULL,
    CLAVE NVARCHAR(255) NOT NULL,
    CONFIRMARCLAVE NVARCHAR(255) NOT NULL,
    PREFERENCIASDEVIAJE NVARCHAR(MAX) NOT NULL,
    AVATARURL NVARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO)
);

-- Crear tabla LUGARES
CREATE TABLE LUGARES (
    ID_LUGAR INT PRIMARY KEY,
    NOMBRE NVARCHAR(255) NOT NULL,
    DESCRIPCION NVARCHAR(MAX) NOT NULL,
    UBICACION NVARCHAR(255) NOT NULL,
    CATEGORIA NVARCHAR(255) NOT NULL,
    HORARIO DATETIME NOT NULL,
    IMAGEN NVARCHAR(255) NOT NULL,
    TIPO NVARCHAR(50) NOT NULL,
    ID_USUARIO INT NOT NULL,  -- Relacionamos cada lugar con un usuario
    CONSTRAINT FK_LUGARES_USUARIOS FOREIGN KEY (ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO) -- Definimos la clave foránea
);
-- Crear tabla SEGUIDORES

CREATE TABLE SEGUIDORES (
    ID_SEGUIDOR INT PRIMARY KEY,
    ID_USUARIO_SEGUIDOR INT NOT NULL,
    ID_USUARIO_SEGUIDO INT NOT NULL,
    FECHA_SEGUIMIENTO DATETIME NOT NULL,
    CONSTRAINT FK_SEGUIDORES_SEGUIDO FOREIGN KEY (ID_USUARIO_SEGUIDO) REFERENCES USUARIOS(ID_USUARIO)
);

-- Crear tabla LUGARESFAVORITOS
CREATE TABLE LUGARESFAVORITOS (
	ID_FAVORITO INT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    ID_LUGAR INT NOT NULL,
    FECHADEVISITA_LUGAR DATE NOT NULL,
    IMAGEN_LUGAR NVARCHAR(255) NOT NULL,
    NOMBRE_LUGAR NVARCHAR(255) NOT NULL,
    DESCRIPCION_LUGAR NVARCHAR(MAX) NOT NULL,
    UBICACION_LUGAR NVARCHAR(255) NOT NULL,
    TIPO_LUGAR NVARCHAR(50) NOT NULL,
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO),
    FOREIGN KEY (ID_LUGAR) REFERENCES LUGARES(ID_LUGAR)
);

-- Crear tabla COMENTARIOS
CREATE TABLE COMENTARIOS (
    ID_COMENTARIO INT PRIMARY KEY,
    ID_LUGAR INT NOT NULL,
    ID_USUARIO INT NOT NULL,
    COMENTARIO NVARCHAR(MAX) NOT NULL,
    FECHA_COMENTARIO DATETIME NOT NULL,
	NOMBRE_USUARIO VARCHAR(255),
    FOREIGN KEY (ID_LUGAR) REFERENCES LUGARES(ID_LUGAR),
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIOS(ID_USUARIO)
);

-- Crear tabla CHAT
CREATE TABLE CHAT (
    ID_MENSAJE INT PRIMARY KEY,
    ID_USUARIO_REMITENTE INT NOT NULL,
    ID_USUARIO_DESTINATARIO INT NOT NULL,
    MENSAJE NVARCHAR(MAX) NOT NULL,
    FECHA_ENVIO DATETIME NOT NULL,
    FOREIGN KEY (ID_USUARIO_REMITENTE) REFERENCES USUARIOS(ID_USUARIO),
    FOREIGN KEY (ID_USUARIO_DESTINATARIO) REFERENCES USUARIOS(ID_USUARIO)
);





------------------------------------------VISTAS-------------------------------------

CREATE OR ALTER VIEW VISTAUSUARIOCOMPLETO AS
SELECT
    U.ID_USUARIO,
    U.NOMBRE,
    U.EMAIL,
    U.EDAD,
    U.NACIONALIDAD,
    U.PREFERENCIASDEVIAJE,
    UL.CLAVE,
    UL.CONFIRMARCLAVE,
    UL.AVATARURL
FROM
    USUARIOS U
INNER JOIN
    USUARIOLOGIN UL ON U.ID_USUARIO = UL.ID_USUARIO;
GO


select * from VISTAUSUARIOCOMPLETO

--------------------------------------------------------


CREATE OR ALTER VIEW VISTA_USUARIOS_SEGUIDOS_PERFIL AS
SELECT DISTINCT
    S.ID_SEGUIDOR,
    S.ID_USUARIO_SEGUIDOR,
    S.ID_USUARIO_SEGUIDO,
    U.NOMBRE AS NOMBRE_SEGUIDO,
    U.AVATARURL AS IMAGEN_SEGUIDO,
    S.FECHA_SEGUIMIENTO
FROM
    SEGUIDORES S
JOIN
    USUARIOS U ON S.ID_USUARIO_SEGUIDO = U.ID_USUARIO;
GO

select * from USUARIOS
------------------------------------------------LUGARES----------------------------------------------------------


-- SP_INSERT_LUGARES (Modificado con CATEGORIA y HORARIO)
CREATE OR ALTER PROCEDURE SP_INSERT_LUGARES
    (
        @nombre NVARCHAR(255),
        @descripcion NVARCHAR(MAX),
        @ubicacion NVARCHAR(255),
        @categoria NVARCHAR(255),
        @horario DATETIME,
        @imagen NVARCHAR(255),
        @tipo NVARCHAR(50),
        @id_usuario INT  
    )
AS
BEGIN
    DECLARE @id_lugar INT;
    SELECT @id_lugar = ISNULL(MAX(ID_LUGAR), 0) + 1 FROM LUGARES;

    INSERT INTO LUGARES (ID_LUGAR, NOMBRE, DESCRIPCION, UBICACION, CATEGORIA, HORARIO, IMAGEN, TIPO, ID_USUARIO)
    VALUES (@id_lugar, @nombre, @descripcion, @ubicacion, @categoria, @horario, @imagen, @tipo, @id_usuario);
END
GO


-----------------------------------------------------------


-- SP_GET_COMENTARIOS_LUGAR (Modificado)
CREATE OR ALTER PROCEDURE SP_GET_COMENTARIOS_LUGAR
    (@id_lugar INT)
AS
BEGIN
    SELECT C.*, U.NOMBRE AS NombreUsuario
    FROM COMENTARIOS C
    INNER JOIN USUARIOS U ON C.ID_USUARIO = U.ID_USUARIO
    WHERE C.ID_LUGAR = @id_lugar
    ORDER BY C.FECHA_COMENTARIO DESC;
END
GO
-----------------------------------------------------------


-- SP_INSERT_COMENTARIO (Modificado)
CREATE OR ALTER PROCEDURE SP_INSERT_COMENTARIO
    (
        @idLugar INT,
        @idUsuario INT,
        @comentario NVARCHAR(MAX)
    )
AS
BEGIN
    DECLARE @idcomentario INT;
    SELECT @idcomentario = ISNULL(MAX(ID_COMENTARIO), 0) + 1 FROM COMENTARIOS;

    INSERT INTO COMENTARIOS (ID_COMENTARIO, ID_LUGAR, ID_USUARIO, COMENTARIO, FECHA_COMENTARIO)
    VALUES (@idcomentario, @idLugar, @idUsuario, @comentario, GETDATE());
END
GO

-----------------------------------------------------------

-- SP_FAVORITOS_BY_USUARIO (Modificado)
CREATE OR ALTER PROCEDURE SP_FAVORITOS_BY_USUARIO
    (@idusuario INT)
AS
BEGIN 
    SELECT  
       *
    FROM
        LUGARESFAVORITOS 
    WHERE  
        ID_USUARIO = @idusuario;
END
GO
-----------------------------------------------------------


-- SP_AGREGAR_FAVORITO (Modificado)
CREATE OR ALTER PROCEDURE SP_AGREGAR_FAVORITO
    (@idusuario INT, @idlugar INT, @fecha DATE, @imagen NVARCHAR(255), 
     @nombre NVARCHAR(255), @descripcion NVARCHAR(MAX), @ubicacion NVARCHAR(255), @tipo NVARCHAR(50))
AS
BEGIN
    DECLARE @nuevoIDFavorito INT;

    SELECT @nuevoIDFavorito = ISNULL(MAX(ID_FAVORITO), 0) + 1 FROM LUGARESFAVORITOS;

    IF NOT EXISTS (SELECT 1 FROM LUGARESFAVORITOS WHERE ID_USUARIO = @idusuario AND ID_LUGAR = @idlugar)
    BEGIN
        INSERT INTO LUGARESFAVORITOS (ID_FAVORITO, ID_USUARIO, ID_LUGAR, FECHADEVISITA_LUGAR, IMAGEN_LUGAR, NOMBRE_LUGAR, 
                                      DESCRIPCION_LUGAR, UBICACION_LUGAR, TIPO_LUGAR)
        VALUES (@nuevoIDFavorito, @idusuario, @idlugar, @fecha, @imagen, @nombre, @descripcion, @ubicacion, @tipo);
    END
    ELSE
    BEGIN
        PRINT 'Este lugar ya está en tus favoritos.';
    END
END
GO


------------------------------------------------USUARIOS----------------------------------------------------------

CREATE OR ALTER PROCEDURE SP_GET_LUGARES_POR_USUARIO
   ( @id_usuario INT)
AS
BEGIN
    SELECT L.ID_LUGAR, L.NOMBRE, L.DESCRIPCION, L.UBICACION, L.CATEGORIA, L.HORARIO, L.IMAGEN, L.TIPO
    FROM LUGARES L
    WHERE L.ID_USUARIO = @id_usuario;
END
GO

-----------------------------------------------------------


CREATE OR ALTER PROCEDURE SP_ADD_SEGUIR
    @idusuarioseguidor INT,
    @idusuarioseguido INT,
    @fechaseguimiento DATETIME
AS
BEGIN
    DECLARE @ID_SEGUIDOR INT;

    SELECT @ID_SEGUIDOR = ISNULL(MAX(ID_SEGUIDOR), 0) + 1 FROM SEGUIDORES;

    INSERT INTO SEGUIDORES (ID_SEGUIDOR, ID_USUARIO_SEGUIDOR, ID_USUARIO_SEGUIDO, FECHA_SEGUIMIENTO)
    VALUES (@ID_SEGUIDOR, @idusuarioseguidor, @idusuarioseguido, @fechaseguimiento);

    SELECT @ID_SEGUIDOR AS ID_SEGUIDOR;
END
GO
-----------------------------------------------------------HOME----------------------------------------------------------



CREATE OR ALTER PROCEDURE SP_GET_LUGARES_POR_USUARIO
   ( @id_usuario INT)
AS
BEGIN
    SELECT L.ID_LUGAR, L.NOMBRE, L.DESCRIPCION, L.UBICACION, L.CATEGORIA, L.HORARIO, L.IMAGEN, L.TIPO
    FROM LUGARES L
    WHERE L.ID_USUARIO = @id_usuario;
END
GO

-----------------------------------------------------------


CREATE OR ALTER PROCEDURE SP_UPDATE_LUGAR
    (
        @id_lugar INT,
        @nombre NVARCHAR(255),
        @descripcion NVARCHAR(MAX),
        @ubicacion NVARCHAR(255),
        @categoria NVARCHAR(255),
        @horario DATETIME,
        @imagen NVARCHAR(255), -- Podrías usar NVARCHAR(MAX) si esperas cadenas más largas
        @tipo NVARCHAR(50)
    )
AS
BEGIN
    -- Si @imagen es NULL o vacío, no actualizamos la columna IMAGEN
    UPDATE LUGARES
    SET 
        NOMBRE = @nombre,
        DESCRIPCION = @descripcion,
        UBICACION = @ubicacion,
        CATEGORIA = @categoria,
        HORARIO = @horario,
        IMAGEN = @imagen
    WHERE ID_LUGAR = @id_lugar;
END
GO



-----------------------------------------------------------

CREATE OR ALTER PROCEDURE SP_DELETE_LUGAR
    (
        @idlugar INT
    )
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM COMENTARIOS
        WHERE ID_LUGAR = @idlugar;

        DELETE FROM LUGARESFAVORITOS
        WHERE ID_LUGAR = @idlugar;

        DELETE FROM LUGARES
        WHERE ID_LUGAR = @idlugar;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END
GO

-------------------------------------------------
CREATE OR ALTER PROCEDURE SP_INSERT_CHAT (
    @IdUsuarioRemitente INT,
    @IdUsuarioDestinatario INT,
    @Mensaje VARCHAR(MAX)
)
AS
BEGIN
    DECLARE @id_mensaje INT;
    SELECT @id_mensaje = ISNULL(MAX(ID_MENSAJE), 0) + 1 FROM CHAT;

    INSERT INTO CHAT (ID_MENSAJE, ID_USUARIO_REMITENTE, ID_USUARIO_DESTINATARIO, MENSAJE, FECHA_ENVIO)
    VALUES (@id_mensaje, @IdUsuarioRemitente, @IdUsuarioDestinatario, @Mensaje, GETDATE());
END
GO

-------------------------------------------------

CREATE OR ALTER PROCEDURE SP_UPDATE_PERFIL
    @id_usuario INT,
    @nombre VARCHAR(255),
    @correo VARCHAR(255),
    @clave VARCHAR(255),
    @confirmarclave VARCHAR(255),
    @preferenciaviaje VARCHAR(255),
    @avatarurl VARCHAR(255),
    @edad INT, 
    @nacionalidad VARCHAR(100) 
AS
BEGIN
    UPDATE USUARIOLOGIN
    SET
        NOMBRE = @nombre,
        CORREO = @correo,
        CLAVE = @clave,
        CONFIRMARCLAVE = @confirmarclave,
        PREFERENCIASDEVIAJE = @preferenciaviaje,
        AVATARURL = @avatarurl
    WHERE ID_USUARIO = @id_usuario;

    UPDATE USUARIOS
    SET
        EDAD = @edad,
        NACIONALIDAD = @nacionalidad
    WHERE ID_USUARIO = @id_usuario;
END;
GO

-------------------------------------------------



CREATE OR ALTER PROCEDURE SP_DELETE_FAVORITO
    (@idusuario INT, @idlugar INT)
AS
BEGIN
    DELETE FROM LUGARESFAVORITOS
    WHERE ID_USUARIO = @idusuario AND ID_LUGAR = @idlugar;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No se encontró este lugar en los favoritos del usuario.';
    END
    ELSE
    BEGIN
        PRINT 'Lugar eliminado de los favoritos correctamente.';
    END
END
GO

---------------------------------------------------------


CREATE OR ALTER PROCEDURE SP_DELETE_SEGUIDOR
    (@idusuarioseguidor INT, @idusuarioseguido INT)
AS
BEGIN
    DELETE FROM SEGUIDORES
    WHERE ID_USUARIO_SEGUIDOR = @idusuarioseguidor 
      AND ID_USUARIO_SEGUIDO = @idusuarioseguido;
END
GO

---------------------------------------------------------

CREATE OR ALTER PROCEDURE SP_SEGUIDORES_BY_USUARIO
    @idusuario INT
AS
BEGIN
    SELECT
        ID_SEGUIDOR,
        ID_USUARIO_SEGUIDOR,
        ID_USUARIO_SEGUIDO,
        NOMBRE_SEGUIDO,
        IMAGEN_SEGUIDO,
        FECHA_SEGUIMIENTO
    FROM
        VISTA_USUARIOS_SEGUIDOS_PERFIL
    WHERE
        ID_USUARIO_SEGUIDOR = @idusuario;
END
GO

-------------------------------------------------------


CREATE OR ALTER PROCEDURE SP_UPDATE_PERFIL
    @id_usuario INT,
    @nombre VARCHAR(255),
    @correo VARCHAR(255),
    @clave VARCHAR(255),
    @confirmarclave VARCHAR(255),
    @preferenciaviaje VARCHAR(255),
    @avatarurl VARCHAR(255),
    @edad INT, -- Añadimos el parámetro para la edad
    @nacionalidad VARCHAR(100) -- Añadimos el parámetro para la nacionalidad
AS
BEGIN
    -- Actualizar USUARIOLOGIN
    UPDATE USUARIOLOGIN
    SET
        NOMBRE = @nombre,
        CORREO = @correo,
        CLAVE = @clave,
        CONFIRMARCLAVE = @confirmarclave,
        PREFERENCIASDEVIAJE = @preferenciaviaje,
        AVATARURL = @avatarurl
    WHERE ID_USUARIO = @id_usuario;

    -- Actualizar USUARIOS
    UPDATE USUARIOS
    SET
        EDAD = @edad,
        NACIONALIDAD = @nacionalidad
    WHERE ID_USUARIO = @id_usuario;
END;
GO

-------------------------------------------

CREATE OR ALTER PROCEDURE SP_INSERT_USER
    (
        @nombre NVARCHAR(255),
        @correo NVARCHAR(255),
        @clave NVARCHAR(255),
        @confirmarclave NVARCHAR(255),
        @preferenciasdeviaje NVARCHAR(MAX),
        @avatarurl NVARCHAR(255)
    )
AS
BEGIN
    -- Obtener el último ID_USUARIO y sumarle 1
    DECLARE @id_usuario INT;
    SELECT @id_usuario = ISNULL(MAX(ID_USUARIO), 0) + 1 FROM USUARIOS;

    -- Insertar en la tabla USUARIOS
    INSERT INTO USUARIOS (ID_USUARIO, NOMBRE, EMAIL, EDAD, NACIONALIDAD, PREFERENCIASDEVIAJE, IMAGEN, FECHADEREGISTRO)
    VALUES (@id_usuario, @nombre, @correo, 0, 'Nacionalidad', @preferenciasdeviaje, '', GETDATE()); -- Valores por defecto para EDAD, NACIONALIDAD e IMAGEN

    -- Insertar en la tabla USUARIOLOGIN
    INSERT INTO USUARIOLOGIN (ID_USUARIO, CORREO, NOMBRE, CLAVE, CONFIRMARCLAVE, PREFERENCIASDEVIAJE, AvatarUrl)
    VALUES (@id_usuario, @correo, @nombre, @clave, @confirmarclave, @preferenciasdeviaje, @avatarurl);

    -- Insertar en la tabla LOG_IN
    INSERT INTO LOG_IN (ID_USUARIO, CORREO, CLAVE)
    VALUES (@id_usuario, @correo, @clave);

END
GO




---------------------------------------------------------INSERT-------------------------------------------------
-- Insertar usuarios
INSERT INTO USUARIOS (ID_USUARIO, NOMBRE, EMAIL, EDAD, NACIONALIDAD, PREFERENCIASDEVIAJE, IMAGEN, FECHADEREGISTRO)
VALUES 
(1, 'Juan Pérez', 'juan.perez@example.com', 30, 'México', 'Playa, Aventura, Naturaleza', 'imagen1.jpg', '2025-03-14'),
(2, 'Ana García', 'ana.garcia@example.com', 28, 'España', 'Cultura, Montañas, Historia', 'imagen2.jpg', '2025-03-15'),
(3, 'Carlos Martínez', 'carlos.martinez@example.com', 25, 'Argentina', 'Aventura, Playa, Cultura', 'imagen3.jpg', '2025-03-16'),
(4, 'María López', 'maria.lopez@example.com', 32, 'Chile', 'Montañas, Historia, Naturaleza', 'imagen4.jpg', '2025-03-17'),
(5, 'Pedro Sánchez', 'pedro.sanchez@example.com', 35, 'Colombia', 'Cultura, Playas, Historia', 'imagen5.jpg', '2025-03-18'),
(6, 'Lucía Fernández', 'lucia.fernandez@example.com', 26, 'España', 'Cultura, Naturaleza, Montañas', 'imagen6.jpg', '2025-03-19');

-- Insertar logins
INSERT INTO LOG_IN (ID_USUARIO, CORREO, CLAVE)
VALUES 
(1, 'juan.perez@example.com', 'clave123'),
(2, 'ana.garcia@example.com', 'clave456'),
(3, 'carlos.martinez@example.com', 'clave789'),
(4, 'maria.lopez@example.com', 'clave1011'),
(5, 'pedro.sanchez@example.com', 'clave1213'),
(6, 'lucia.fernandez@example.com', 'clave1415');

-- Insertar usuario login
INSERT INTO USUARIOLOGIN (ID_USUARIO, CORREO, NOMBRE, CLAVE, CONFIRMARCLAVE, PREFERENCIASDEVIAJE, AVATARURL)
VALUES 
(1, 'juan.perez@example.com', 'Juan Pérez', 'clave123', 'clave123', 'Playa, Aventura, Naturaleza', 'http://example.com/avatar1.jpg'),
(2, 'ana.garcia@example.com', 'Ana García', 'clave456', 'clave456', 'Cultura, Montañas, Historia', 'http://example.com/avatar2.jpg'),
(3, 'carlos.martinez@example.com', 'Carlos Martínez', 'clave789', 'clave789', 'Aventura, Playa, Cultura', 'http://example.com/avatar3.jpg'),
(4, 'maria.lopez@example.com', 'María López', 'clave1011', 'clave1011', 'Montañas, Historia, Naturaleza', 'http://example.com/avatar4.jpg'),
(5, 'pedro.sanchez@example.com', 'Pedro Sánchez', 'clave1213', 'clave1213', 'Cultura, Playas, Historia', 'http://example.com/avatar5.jpg'),
(6, 'lucia.fernandez@example.com', 'Lucía Fernández', 'clave1415', 'clave1415', 'Cultura, Naturaleza, Montañas', 'http://example.com/avatar6.jpg');

-- Insertar lugares
INSERT INTO LUGARES (ID_LUGAR, NOMBRE, DESCRIPCION, UBICACION, CATEGORIA, HORARIO, IMAGEN, TIPO, ID_USUARIO)
VALUES 
(1, 'Playa del Carmen', 'Hermosa playa en la Riviera Maya.', 'Riviera Maya, México', 'Playa', 2025-03-15, 'playa1.jpg', 'Privado', 1),
(2, 'Museo del Prado', 'Museo con una extensa colección de arte europeo.', 'Madrid, España', 'Cultura', 2025-03-16, 'museo1.jpg', 'Publico', 2),
(3, 'Parque Nacional Torres del Paine', 'Parque nacional de Chile, ideal para el trekking.', 'Patagonia, Chile', 'Aventura', 2025-03-17, 'torres_paine.jpg', 'Privado', 4),
(4, 'La Alhambra', 'Palacio histórico de Granada, España.', 'Granada, España', 'Cultura', 2025-03-18, 'alhambra.jpg', 'Publico', 3),
(5, 'Machu Picchu', 'Antigua ciudad inca ubicada en los Andes.', 'Cusco, Perú', 'Historia', 2025-03-19, 'machu_picchu.jpg', 'Privado', 5),
(6, 'Islas Galápagos', 'Islas volcánicas en Ecuador, hogar de especies únicas.', 'Ecuador', 'Naturaleza', 2025-03-20, 'galapagos.jpg', 'Publico', 6);

-- Insertar seguidores
INSERT INTO SEGUIDORES (ID_SEGUIDOR, ID_USUARIO_SEGUIDOR, ID_USUARIO_SEGUIDO, FECHA_SEGUIMIENTO)
VALUES 
(1, 1, 2, 2025-03-14),
(2, 2, 1, 2025-03-15),
(3, 3, 4, 2025-03-16),
(4, 4, 5, 2025-03-17),
(5, 5, 6, 2025-03-18),
(6, 6, 3, 2025-03-19);


-- Insertar lugares favoritos
INSERT INTO LUGARESFAVORITOS (ID_FAVORITO, ID_USUARIO, ID_LUGAR, FECHADEVISITA_LUGAR, IMAGEN_LUGAR, NOMBRE_LUGAR, DESCRIPCION_LUGAR, UBICACION_LUGAR, TIPO_LUGAR)
VALUES 
(1, 1, 1, '2025-03-16', 'playa_favorita.jpg', 'Playa del Carmen', 'Hermosa playa en la Riviera Maya.', 'Riviera Maya, México', 'Playa'),
(2, 2, 2, '2025-03-17', 'museo_favorito.jpg', 'Museo del Prado', 'Museo con una extensa colección de arte europeo.', 'Madrid, España', 'Cultura'),
(3, 3, 3, '2025-03-18', 'torres_paine_favorito.jpg', 'Parque Nacional Torres del Paine', 'Parque nacional de Chile, ideal para el trekking.', 'Patagonia, Chile', 'Aventura'),
(4, 4, 4, '2025-03-19', 'alhambra_favorito.jpg', 'La Alhambra', 'Palacio histórico de Granada, España.', 'Granada, España', 'Cultura'),
(5, 5, 5, '2025-03-20', 'machu_picchu_favorito.jpg', 'Machu Picchu', 'Antigua ciudad inca ubicada en los Andes.', 'Cusco, Perú', 'Historia'),
(6, 6, 6, '2025-03-21', 'galapagos_favorito.jpg', 'Islas Galápagos', 'Islas volcánicas en Ecuador, hogar de especies únicas.', 'Ecuador', 'Naturaleza');

-- Insertar comentarios
INSERT INTO COMENTARIOS (ID_COMENTARIO, ID_LUGAR, ID_USUARIO, COMENTARIO, FECHA_COMENTARIO)
VALUES 
(1, 1, 1, 'Una de las mejores playas que he visitado. Muy recomendada.', '2025-03-16'),
(2, 2, 2, 'El museo tiene una colección impresionante. Definitivamente vale la pena visitarlo.', '2025-03-17'),
(3, 3, 3, 'Increíble paisaje, ideal para los amantes del trekking.', '2025-03-18'),
(4, 4, 4, 'La Alhambra es un lugar lleno de historia. ¡No te lo puedes perder!', '2025-03-19'),
(5, 5, 5, 'Una maravilla histórica que te transporta al pasado. Imperdible.', '2025-03-20'),
(6, 6, 6, 'Las Islas Galápagos son un paraíso natural. ¡Un destino único!', '2025-03-21');

-- Insertar chat
INSERT INTO CHAT (ID_MENSAJE, ID_USUARIO_REMITENTE, ID_USUARIO_DESTINATARIO, MENSAJE, FECHA_ENVIO)
VALUES 
(1, 1, 2, '¡Hola Ana! ¿Cómo estás? Quiero saber más sobre tu viaje a Madrid.', 2025-03-16),
(2, 2, 1, '¡Hola Juan! Todo bien, gracias. Te contaré más detalles pronto.', 2025-03-16 ),
(3, 3, 3, 'Increíble paisaje, ideal para los amantes del trekking.', 2025-03-18),
(4, 4, 4, 'La Alhambra es un lugar lleno de historia. ¡No te lo puedes perder!', 2025-03-19),
(5, 5, 5, 'Una maravilla histórica que te transporta al pasado. Imperdible.', 2025-03-20),
(6, 6, 6, 'Las Islas Galápagos son un paraíso natural. ¡Un destino único!', 2025-03-21);



