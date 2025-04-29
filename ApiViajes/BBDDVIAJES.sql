/****** Object:  Table [dbo].[CHAT]    Script Date: 29/04/2025 12:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHAT](
	[ID_MENSAJE] [int] NOT NULL,
	[ID_USUARIO_REMITENTE] [int] NOT NULL,
	[ID_USUARIO_DESTINATARIO] [int] NOT NULL,
	[MENSAJE] [nvarchar](max) NOT NULL,
	[FECHA_ENVIO] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_MENSAJE] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COMENTARIOS]    Script Date: 29/04/2025 12:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMENTARIOS](
	[ID_COMENTARIO] [int] NOT NULL,
	[ID_LUGAR] [int] NOT NULL,
	[ID_USUARIO] [int] NOT NULL,
	[COMENTARIO] [nvarchar](max) NOT NULL,
	[FECHA_COMENTARIO] [datetime] NOT NULL,
	[NOMBRE_USUARIO] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_COMENTARIO] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOG_IN]    Script Date: 29/04/2025 12:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOG_IN](
	[ID_USUARIO] [int] NOT NULL,
	[CORREO] [nvarchar](255) NOT NULL,
	[CLAVE] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_USUARIO] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CORREO] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LUGARES]    Script Date: 29/04/2025 12:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LUGARES](
	[ID_LUGAR] [int] NOT NULL,
	[NOMBRE] [nvarchar](255) NOT NULL,
	[DESCRIPCION] [nvarchar](max) NOT NULL,
	[UBICACION] [nvarchar](255) NOT NULL,
	[CATEGORIA] [nvarchar](255) NOT NULL,
	[HORARIO] [datetime] NOT NULL,
	[IMAGEN] [nvarchar](255) NOT NULL,
	[TIPO] [nvarchar](50) NOT NULL,
	[ID_USUARIO] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_LUGAR] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LUGARESFAVORITOS]    Script Date: 29/04/2025 12:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LUGARESFAVORITOS](
	[ID_FAVORITO] [int] NOT NULL,
	[ID_USUARIO] [int] NOT NULL,
	[ID_LUGAR] [int] NOT NULL,
	[FECHADEVISITA_LUGAR] [date] NOT NULL,
	[IMAGEN_LUGAR] [nvarchar](255) NOT NULL,
	[NOMBRE_LUGAR] [nvarchar](255) NOT NULL,
	[DESCRIPCION_LUGAR] [nvarchar](max) NOT NULL,
	[UBICACION_LUGAR] [nvarchar](255) NOT NULL,
	[TIPO_LUGAR] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_FAVORITO] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SEGUIDORES]    Script Date: 29/04/2025 12:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SEGUIDORES](
	[ID_SEGUIDOR] [int] NOT NULL,
	[ID_USUARIO_SEGUIDOR] [int] NOT NULL,
	[ID_USUARIO_SEGUIDO] [int] NOT NULL,
	[FECHA_SEGUIMIENTO] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_SEGUIDOR] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USUARIOS]    Script Date: 29/04/2025 12:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USUARIOS](
	[ID_USUARIO] [int] NOT NULL,
	[EMAIL] [nvarchar](255) NOT NULL,
	[NOMBRE] [nvarchar](255) NOT NULL,
	[EDAD] [int] NOT NULL,
	[NACIONALIDAD] [nvarchar](100) NOT NULL,
	[CLAVE] [nvarchar](255) NOT NULL,
	[CONFIRMARCLAVE] [nvarchar](255) NOT NULL,
	[PREFERENCIASDEVIAJE] [nvarchar](max) NOT NULL,
	[AVATARURL] [nvarchar](255) NOT NULL,
	[FECHADEREGISTRO] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_USUARIO] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EMAIL] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CHAT]  WITH CHECK ADD FOREIGN KEY([ID_USUARIO_REMITENTE])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[CHAT]  WITH CHECK ADD FOREIGN KEY([ID_USUARIO_DESTINATARIO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[COMENTARIOS]  WITH CHECK ADD FOREIGN KEY([ID_LUGAR])
REFERENCES [dbo].[LUGARES] ([ID_LUGAR])
GO
ALTER TABLE [dbo].[COMENTARIOS]  WITH CHECK ADD FOREIGN KEY([ID_USUARIO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[LOG_IN]  WITH CHECK ADD FOREIGN KEY([ID_USUARIO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[LUGARES]  WITH CHECK ADD  CONSTRAINT [FK_LUGARES_USUARIOS] FOREIGN KEY([ID_USUARIO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[LUGARES] CHECK CONSTRAINT [FK_LUGARES_USUARIOS]
GO
ALTER TABLE [dbo].[LUGARESFAVORITOS]  WITH CHECK ADD FOREIGN KEY([ID_LUGAR])
REFERENCES [dbo].[LUGARES] ([ID_LUGAR])
GO
ALTER TABLE [dbo].[LUGARESFAVORITOS]  WITH CHECK ADD FOREIGN KEY([ID_USUARIO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[SEGUIDORES]  WITH CHECK ADD  CONSTRAINT [FK_SEGUIDORES_SEGUIDO] FOREIGN KEY([ID_USUARIO_SEGUIDO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[SEGUIDORES] CHECK CONSTRAINT [FK_SEGUIDORES_SEGUIDO]
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



