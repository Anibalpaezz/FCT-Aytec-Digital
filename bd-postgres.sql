-- Eliminación de tablas existentes (en el orden correcto para evitar problemas de claves foráneas)
DROP TABLE IF EXISTS Recetas_Menus;
DROP TABLE IF EXISTS Ingredientes;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS Menus;
DROP TABLE IF EXISTS Recetas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Subcategorias;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Supercategorias;
DROP TABLE IF EXISTS Usuarios;
-- Creación de tablas
CREATE TABLE Usuarios (
     usuario_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     correo VARCHAR(255) UNIQUE NOT NULL,
     contraseña VARCHAR(255) NOT NULL,
     fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     rol VARCHAR(50) CHECK (
          rol IN ('administrador', 'usuario')
     ) DEFAULT 'usuario'
);
CREATE TABLE Categorias (
     categoria_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL
);
CREATE TABLE Subcategorias (
     subcategoria_id SERIAL PRIMARY KEY,
     categoria_id INT NOT NULL,
     nombre VARCHAR(255) NOT NULL,
     FOREIGN KEY (categoria_id) REFERENCES Categorias (categoria_id)
);
CREATE TABLE Productos (
     producto_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     marca VARCHAR(50),
     descripcion TEXT,
     categoria_id INT,
     subcategoria_id INT,
     unidad_medida VARCHAR(50),
     precio NUMERIC(10, 2),
     foto VARCHAR(255),
     FOREIGN KEY (categoria_id) REFERENCES Categorias (categoria_id),
     FOREIGN KEY (subcategoria_id) REFERENCES Subcategorias (subcategoria_id)
);
CREATE TABLE Stock (
     stock_id SERIAL PRIMARY KEY,
     producto_id INT NOT NULL,
     cantidad_disponible NUMERIC(10, 2),
     fecha_actualizacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (producto_id) REFERENCES Productos (producto_id)
);
CREATE TABLE Recetas (
     receta_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     descripcion TEXT,
     usuario_id INT NOT NULL,
     fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (usuario_id) REFERENCES Usuarios (usuario_id)
);
CREATE TABLE Ingredientes (
     ingrediente_id SERIAL PRIMARY KEY,
     receta_id INT NOT NULL,
     producto_id INT NOT NULL,
     cantidad_requerida NUMERIC(10, 2),
     FOREIGN KEY (receta_id) REFERENCES Recetas (receta_id),
     FOREIGN KEY (producto_id) REFERENCES Productos (producto_id)
);
CREATE TABLE Menus (
     menu_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     descripcion TEXT,
     usuario_id INT NOT NULL,
     fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (usuario_id) REFERENCES Usuarios (usuario_id)
);
CREATE TABLE Recetas_Menus (
     receta_menu_id SERIAL PRIMARY KEY,
     menu_id INT NOT NULL,
     receta_id INT NOT NULL,
     FOREIGN KEY (menu_id) REFERENCES Menus (menu_id),
     FOREIGN KEY (receta_id) REFERENCES Recetas (receta_id)
);
-- Índices opcionales para mejorar el rendimiento de búsqueda
CREATE INDEX idx_usuarios_correo ON Usuarios (correo);
CREATE INDEX idx_productos_nombre ON Productos (nombre);
CREATE INDEX idx_recetas_nombre ON Recetas (nombre);
CREATE INDEX idx_menus_nombre ON Menus (nombre);
-- Funciones y triggers para gestionar actualizaciones automáticas en Stock (opcional)
CREATE OR REPLACE FUNCTION actualizar_fecha_actualizacion() RETURNS TRIGGER AS $$ BEGIN NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_actualizar_fecha_actualizacion BEFORE
UPDATE ON Stock FOR EACH ROW EXECUTE FUNCTION actualizar_fecha_actualizacion ();
-- Insertar supercategorías
INSERT INTO Categorias (nombre)
VALUES ('Fruta y verdura'),
     ('Marisco y pescado'),
     ('Carne'),
     ('Charcutería y quesos'),
     ('Panadería y pastelería'),
     ('Huevos, leche y mantequilla'),
     ('Cereales y galletas'),
     ('Cacao, café e infusiones'),
     ('Azúcar, caramelos y chocolate'),
     ('Zumos'),
     ('Postres y yogures'),
     ('Aceite, especias y salsas'),
     ('Arroz, legumbres y pasta'),
     ('Conservas, caldos y cremas'),
     ('Aperitivos'),
     ('Pizzas y platos preparados'),
     ('Congelados'),
     ('Agua y refrescos'),
     ('Bodega'),
     ('Cuidado facial y corporal'),
     ('Cuidado del cabello'),
     ('Maquillaje'),
     ('Fitoterapia y parafarmacia'),
     ('Bebé'),
     ('Mascotas'),
     ('Limpieza y hogar');
-- Insertar categorías
INSERT INTO Subcategorias (nombre, categoria_id)
VALUES ('Fruta', 1),
     (
          'Lechuga y ensalada preparada',
          1
     ),
     ('Verdura', 1),
     ('Pescado fresco', 2),
     ('Marisco', 2),
     ('Pescado en bandeja', 2),
     ('Pescado congelado', 2),
     ('Salazones y ahumados', 2),
     ('Sushi', 2),
     ('Cerdo', 3),
     ('Aves y pollo', 3),
     ('Vacuno', 3),
     ('Conejo y cordero', 3),
     ('Embutido', 4),
     (
          'Hamburguesas y carne picada',
          3
     ),
     ('Empanados y elaborados', 3),
     ('Arreglos', 3),
     ('Carne congelada', 3),
     ('Aves y jamón cocido', 4),
     ('Chopped y mortadela', 4),
     ('Jamón serrano', 4),
     ('Embutido curado', 4),
     ('Bacón y salchichas', 4),
     ('Queso untable y fresco', 4),
     (
          'Queso curado, semicurado y tierno',
          4
     ),
     (
          'Queso lonchas, rallado y en porciones',
          4
     ),
     ('Paté y sobrasada', 4),
     ('Pan de horno', 5),
     (
          'Pan de molde y otras especialidades',
          5
     ),
     ('Pan tostado y rallado', 5),
     (
          'Picos, rosquilletas y picatostes',
          5
     ),
     ('Bollería de horno', 5),
     ('Bollería envasada', 5),
     ('Tartas y pasteles', 5),
     (
          'Harina y preparado repostería',
          5
     ),
     ('Velas y decoración', 5),
     (
          'Leche y bebidas vegetales',
          6
     ),
     ('Mantequilla y margarina', 6),
     ('Huevos', 6),
     ('Cereales', 7),
     ('Tortitas', 7),
     ('Galletas', 7),
     ('Café cápsula y monodosis', 8),
     ('Café molido y en grano', 8),
     (
          'Café soluble y otras bebidas',
          8
     ),
     (
          'Cacao soluble y chocolate a la taza',
          8
     ),
     ('Té e infusiones', 8),
     ('Azúcar y edulcorante', 9),
     ('Mermelada y miel', 9),
     ('Chocolate', 9),
     ('Chicles y caramelos', 9),
     ('Golosinas', 9),
     ('Tomate y otros sabores', 10),
     ('Fruta variada', 10),
     ('Melocotón y piña', 10),
     ('Naranja', 10),
     ('Yogures desnatados', 11),
     (
          'Yogures naturales y sabores',
          11
     ),
     ('Yogures bífidus', 11),
     ('Yogures de soja', 11),
     (
          'Yogures y postres infantiles',
          11
     ),
     ('Yogures líquidos', 11),
     ('Yogures griegos', 11),
     ('Flan y natillas', 11),
     (
          'Gelatina y otros postres',
          11
     ),
     ('Aceite, vinagre y sal', 12),
     ('Especias', 12),
     (
          'Mayonesa, ketchup y mostaza',
          12
     ),
     ('Otras salsas', 12),
     ('Arroz', 13),
     ('Pasta y fideos', 13),
     ('Legumbres', 13),
     (
          'Atún y otras conservas de pescado',
          14
     ),
     (
          'Berberechos y mejillones',
          14
     ),
     ('Tomate', 14),
     (
          'Conservas de verdura y frutas',
          14
     ),
     ('Sopa y caldo', 14),
     ('Gazpacho y cremas', 14),
     ('Patatas fritas y snacks', 15),
     (
          'Frutos secos y fruta desecada',
          15
     ),
     ('Aceitunas y encurtidos', 15),
     ('Pizzas', 16),
     (
          'Platos preparados calientes',
          16
     ),
     ('Platos preparados fríos', 16),
     ('Verdura', 17),
     ('Arroz y pasta', 17),
     ('Carne', 17),
     ('Pescado', 17),
     ('Marisco', 17),
     ('Pizzas', 17),
     ('Tartas y churros', 17),
     ('Helados', 17),
     ('Hielo', 17),
     ('Agua', 18),
     ('Refresco de cola', 18),
     (
          'Refresco de naranja y de limón',
          18
     ),
     ('Tónica y bitter', 18),
     (
          'Refresco de té y sin gas',
          18
     ),
     ('Isotónico y energético', 18),
     ('Cerveza', 19),
     ('Cerveza sin alcohol', 19),
     (
          'Tinto de verano y sangría',
          19
     ),
     ('Vino tinto', 19),
     ('Vino blanco', 19),
     ('Vino rosado', 19),
     (
          'Vino lambrusco y espumoso',
          19
     ),
     ('Sidra y cava', 19),
     ('Licores', 19),
     (
          'Cuidado e higiene facial',
          20
     ),
     ('Higiene bucal', 20),
     ('Gel y jabón de manos', 20),
     ('Desodorante', 20),
     ('Cuidado corporal', 20),
     ('Higiene íntima', 20),
     ('Depilación', 20),
     (
          'Afeitado y cuidado para hombre',
          20
     ),
     ('Manicura y pedicura', 20),
     ('Perfume y colonia', 20),
     (
          'Protector solar y aftersun',
          20
     ),
     ('Neceseres', 20),
     ('Champú', 21),
     (
          'Acondicionador y mascarilla',
          21
     ),
     ('Fijación cabello', 21),
     ('Coloración cabello', 21),
     ('Peines y accesorios', 21),
     (
          'Bases de maquillaje y corrector',
          22
     ),
     ('Colorete y polvos', 22),
     ('Labios', 22),
     ('Ojos', 22),
     ('Pinceles y brochas', 22),
     ('Fitoterapia', 23),
     ('Parafarmacia', 23),
     ('Alimentación infantil', 24),
     ('Toallitas y pañales', 24),
     ('Higiene y cuidado', 24),
     (
          'Biberón, chupete y menaje',
          24
     ),
     ('Perro', 25),
     ('Gato', 25),
     ('Pez y otros', 25),
     (
          'Detergente y suavizante ropa',
          26
     ),
     ('Limpieza vajilla', 26),
     ('Limpieza cocina', 26),
     ('Limpieza baño y WC', 26),
     (
          'Limpieza muebles y multiusos',
          26
     ),
     (
          'Limpiahogar y fregasuelos',
          26
     ),
     (
          'Lejía y líquidos fuertes',
          26
     ),
     ('Limpiacristales', 26),
     (
          'Estropajo, bayeta y guantes',
          26
     ),
     (
          'Papel higiénico y celulosa',
          26
     ),
     (
          'Pilas y bolsas de basura',
          26
     ),
     (
          'Insecticida y ambientador',
          26
     ),
     (
          'Menaje y conservación de alimentos',
          26
     ),
     (
          'Utensilios de limpieza y calzado',
          26
     );

INSERT INTO Productos (nombre, marca, descripcion, categoria_id, subcategoria_id, unidad_medida, precio, foto)
VALUES 
('Sal gruesa', 'Hacendado', 'Sal gruesa para sazonar y cocinar tus platos favoritos.', 12, 66, 'unidades', 0.19, 'https://prod-mercadona.imgix.net/20190521/33/19733/vlc1/19733_00_02.jpg?fit=crop&h=206&w=206'),
('Sal de mesa', 'Hacendado', 'Sal de mesa para uso diario en la cocina y la mesa.', 12, 66, 'unidades', 0.38, 'https://prod-mercadona.imgix.net/20190521/15/19715/vlc1/19715_00_02.jpg?fit=crop&h=206&w=206'),
('Sal yodada fina', 'Hacendado', 'Sal fina enriquecida con yodo para promover la salud.', 12, 66, 'unidades', 0.18, 'https://prod-mercadona.imgix.net/20190521/32/19732/vlc1/19732_00_02.jpg?fit=crop&h=206&w=206'),
('Sal de mesa fina', 'Hacendado', 'Sal de mesa fina para sazonar y cocinar con precisión.', 12, 66, 'unidades', 0.21, 'https://prod-mercadona.imgix.net/20190521/31/19731/vlc1/19731_00_02.jpg?fit=crop&h=206&w=206'),
('Sal gruesa para hornear', 'Hacendado', 'Sal gruesa especialmente diseñada para hornear y cocinar.', 12, 66, 'unidades', 0.71, 'https://prod-mercadona.imgix.net/20190521/34/19734/vlc1/19734_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva intenso', 'Hacendado', 'Aceite de oliva intenso para dar un sabor profundo a tus platos.', 12, 66, 'unidades', 12.95, 'https://prod-mercadona.imgix.net/20190521/41/4641/vlc1/4641_00_02.jpg?fit=crop&h=206&w=206'),
('Bicarbonato sódico', 'Hacendado', 'Bicarbonato sódico para uso en la cocina y limpieza del hogar.', 12, 66, 'unidades', 0.69, 'https://prod-mercadona.imgix.net/20190521/06/29006/vlc1/29006_00_02.jpg?fit=crop&h=206&w=206'),
('Sal de frutas sabor limón', 'Hacendado', 'Sal de frutas con sabor a limón, refrescante y deliciosa.', 12, 66, 'unidades', 1.59, 'https://prod-mercadona.imgix.net/20190521/16/29016/vlc1/29016_00_02.jpg?fit=crop&h=206&w=206'),
('Bicarbonato sódico', 'Hacendado', 'Bicarbonato sódico para uso en la cocina y limpieza del hogar.', 12, 66, 'unidades', 1.19, 'https://prod-mercadona.imgix.net/20190521/07/29007/vlc1/29007_00_02.jpg?fit=crop&h=206&w=206'),
('Molinillo sal marina con hierbas', 'Hacendado', 'Molinillo con sal marina y hierbas aromáticas para sazonar tus platos.', 12, 66, 'unidades', 1.60, 'https://prod-mercadona.imgix.net/20190521/87/34187/vlc1/34187_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra de calidad premium para tus platos.', 12, 66, 'unidades', 2.35, 'https://prod-mercadona.imgix.net/20190521/56/4756/vlc1/4756_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva suave', 'Hacendado', 'Aceite de oliva suave ideal para cocinar y aliñar tus platos.', 12, 66, 'unidades', 12.95, 'https://prod-mercadona.imgix.net/20190521/41/4241/vlc1/4241_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen', 'Hacendado', 'Aceite de oliva virgen de calidad para realzar el sabor de tus comidas.', 12, 66, 'unidades', 3.20, 'https://prod-mercadona.imgix.net/20190521/49/4749/vlc1/4749_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de girasol refinado', 'Hacendado', 'Aceite de girasol refinado para todo tipo de usos culinarios.', 12, 66, 'unidades', 4.79, 'https://prod-mercadona.imgix.net/20190521/41/4041/vlc1/4041_00_02.jpg?fit=crop&h=206&w=206'),
('Limón exprimido', 'Hacendado', 'Jugo de limón exprimido para dar un toque cítrico a tus platos.', 12, 66, 'unidades', 0.88, 'https://prod-mercadona.imgix.net/20190521/03/4903/vlc1/4903_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva, vinagre y sal', 'Merry', 'Mezcla de aceite de oliva, vinagre y sal para aliñar tus platos.', 12, 66, 'unidades', 1.32, 'https://prod-mercadona.imgix.net/20190521/62/4962/vlc1/4962_00_02.jpg?fit=crop&h=206&w=206'),
('Bebida aromatizada a base de vino para cocinar', 'Abuela Carola', 'Bebida aromatizada a base de vino para agregar sabor a tus platos al cocinar.', 12, 66, 'unidades', 1.99, 'https://prod-mercadona.imgix.net/20190521/05/66905/vlc1/66905_00_02.jpg?fit=crop&h=206&w=206'),
('Sal de ajo', 'Hacendado', 'Sal con ajo añadido para darle un sabor distintivo a tus platos.', 12, 66, 'unidades', 1.00, 'https://prod-mercadona.imgix.net/20190521/30/34130/vlc1/34130_00_02.jpg?fit=crop&h=206&w=206'),
('Sal marina en escamas', 'Polasal', 'Escamas de sal marina natural, perfectas para añadir textura y sabor a tus comidas.', 12, 66, 'unidades', 1.95, 'https://prod-mercadona.imgix.net/20190521/40/19740/vlc1/19740_00_03.jpg?fit=crop&h=206&w=206'),
('Sal 60% menos de sodio', 'Hacendado', 'Sal con un 60% menos de sodio, ideal para aquellos que buscan reducir su consumo de sal.', 12, 66, 'unidades', 1.20, 'https://prod-mercadona.imgix.net/20190521/13/19713/vlc1/19713_00_02.jpg?fit=crop&h=206&w=206'),
('Sal rosa del Himalaya', 'Hacendado', 'Sal mineral rosa del Himalaya, con un sabor único y una textura distintiva.', 12, 66, 'unidades', 1.95, 'https://prod-mercadona.imgix.net/20190521/39/19739/vlc1/19739_00_02.jpg?fit=crop&h=206&w=206'),
('Preparado para salmón ahumado', 'Hacendado', 'Mezcla de sal y especias especialmente formulada para sazonar y preparar salmón ahumado.', 12, 66, 'unidades', 2.00, 'https://prod-mercadona.imgix.net/20190521/26/19726/vlc1/19726_00_02.jpg?fit=crop&h=206&w=206'),
('Sal sin sodio', 'Hacendado', 'Sal sin adición de sodio, ideal para aquellos que necesitan controlar su consumo de sal.', 12, 66, 'unidades', 1.90, 'https://prod-mercadona.imgix.net/20190521/10/19710/vlc1/19710_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen', 'Casalbert', 'Aceite de oliva virgen de alta calidad, perfecto para aderezar ensaladas y platos.', 12, 66, 'unidades', 11.95, 'https://prod-mercadona.imgix.net/20190521/45/4845/vlc1/4845_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen extra', 'Casa Juncal', 'Aceite de oliva virgen extra con un sabor intenso y aroma frutado, ideal para realzar tus platos.', 12, 66, 'unidades', 3.95, 'https://prod-mercadona.imgix.net/20190521/50/4850/vlc1/4850_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva suave', 'Hacendado', 'Aceite de oliva suave y equilibrado, perfecto para todo tipo de usos culinarios.', 12, 66, 'unidades', 2.79, 'https://prod-mercadona.imgix.net/20190521/40/4240/vlc1/4240_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de girasol refinado', 'Hacendado', 'Aceite de girasol refinado de alta calidad, ideal para cocinar y freír.', 12, 66, 'unidades', 0.99, 'https://prod-mercadona.imgix.net/20190521/40/4040/vlc1/4040_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de girasol refinado', 'Hacendado', 'Aceite de girasol refinado de alta calidad para tus recetas favoritas.', 12, 66, 'unidades', 4.79, 'https://prod-mercadona.imgix.net/20190521/41/4041/vlc1/4041_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de semillas refinado', 'Hacendado', 'Aceite de semillas refinado perfecto para freír y cocinar.', 12, 66, 'unidades', 1.53, 'https://prod-mercadona.imgix.net/20190521/42/4442/vlc1/4442_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de semillas refinado', 'Hacendado', 'Aceite de semillas refinado de alta calidad para tus preparaciones culinarias.', 12, 66, 'unidades', 7.15, 'https://prod-mercadona.imgix.net/20190521/43/4443/vlc1/4443_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de coco virgen extra', 'Nat Sanno', 'Aceite de coco virgen extra para cocinar, hornear y cuidado personal.', 12, 66, 'unidades', 4.50, 'https://prod-mercadona.imgix.net/20190521/93/4193/vlc1/4193_00_03.jpg?fit=crop&h=206&w=206'),
('Aceite de aguacate', 'Ethnos', 'Aceite de aguacate 100% natural, perfecto para ensaladas y platos gourmet.', 12, 66, 'unidades', 5.00, 'https://prod-mercadona.imgix.net/20190521/21/4721/vlc1/4721_00_02.jpg?fit=crop&h=206&w=206'),
('Vinagre de vino tinto', 'Hacendado', 'Vinagre de vino tinto para aderezar ensaladas y dar un toque especial a tus platos.', 12, 66, 'unidades', 0.57, 'https://prod-mercadona.imgix.net/20190521/42/4942/vlc1/4942_00_02.jpg?fit=crop&h=206&w=206'),
('Reducción de vinagre Pedro Ximénez', 'Hacendado', 'Reducción de vinagre Pedro Ximénez para dar un toque dulce y sofisticado a tus platos.', 12, 66, 'unidades', 2.00, 'https://prod-mercadona.imgix.net/20190521/05/4905/vlc1/4905_00_02.jpg?fit=crop&h=206&w=206'),
('Crema de vinagre balsámico de Módena', 'Hacendado', 'Crema de vinagre balsámico de Módena para aderezar ensaladas y platos gourmet.', 12, 66, 'unidades', 2.15, 'https://prod-mercadona.imgix.net/20190521/08/4908/vlc1/4908_00_02.jpg?fit=crop&h=206&w=206'),
('Vinagre de vino blanco', 'Hacendado', 'Vinagre de vino blanco para aderezar ensaladas y dar un toque fresco a tus platos.', 12, 66, 'unidades', 0.49, 'https://prod-mercadona.imgix.net/20190521/40/4940/vlc1/4940_00_02.jpg?fit=crop&h=206&w=206'),
('Vinagre de Jerez reserva', 'Hacendado', 'Vinagre de Jerez reserva para dar un sabor único y especial a tus platos.', 12, 66, 'unidades', 1.25, 'https://prod-mercadona.imgix.net/20190521/53/4953/vlc1/4953_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra de alta calidad para tus recetas favoritas.', 12, 66, 'unidades', 9.97, 'https://prod-mercadona.imgix.net/20190521/17/4717/vlc1/4717_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra perfecto para aliñar ensaladas y platos fríos.', 12, 66, 'unidades', 3.59, 'https://prod-mercadona.imgix.net/20190521/40/4740/vlc1/4740_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra de alta calidad para tus platos favoritos.', 12, 66, 'unidades', 3.69, 'https://prod-mercadona.imgix.net/20190521/06/4706/vlc1/4706_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva', 'Hacendado', 'Aceite de oliva de calidad para cocinar tus recetas preferidas.', 12, 66, 'unidades', 2.79, 'https://prod-mercadona.imgix.net/20190521/40/4640/vlc1/4640_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen', 'Hacendado', 'Aceite de oliva virgen para resaltar el sabor de tus platos.', 12, 66, 'unidades', 8.70, 'https://prod-mercadona.imgix.net/20190521/11/4711/vlc1/4711_00_02.jpg?fit=crop&h=206&w=206'),
('Vinagre de manzana', 'Hacendado', 'Vinagre de manzana para dar un toque refrescante a tus ensaladas.', 12, 66, 'unidades', 0.69, 'https://prod-mercadona.imgix.net/20190521/57/4957/vlc1/4957_00_02.jpg?fit=crop&h=206&w=206'),
('Vinagre balsámico de Módena', 'Hacendado', 'Vinagre balsámico de Módena para aderezar tus platos con un toque gourmet.', 12, 66, 'unidades', 1.30, 'https://prod-mercadona.imgix.net/20190521/54/4954/vlc1/4954_00_02.jpg?fit=crop&h=206&w=206'),
('Vinagre de vino añejo', 'Hacendado', 'Vinagre de vino añejo para dar un sabor único a tus platos.', 12, 66, 'unidades', 1.25, 'https://prod-mercadona.imgix.net/20190521/55/4955/vlc1/4955_00_02.jpg?fit=crop&h=206&w=206'),
('Crema de vinagre balsámico de manzana', 'Hacendado', 'Crema de vinagre balsámico de manzana para una experiencia gourmet en tus recetas.', 12, 66, 'unidades', 2.15, 'https://prod-mercadona.imgix.net/20190521/65/4965/vlc1/4965_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra de alta calidad para tus platos favoritos.', 12, 66, 'unidades', 2.15, 'https://prod-mercadona.imgix.net/20190521/18/4718/vlc1/4718_00_02.jpg?fit=crop&h=206&w=206'),
('Aceite de oliva 0,4º', 'Hacendado', 'Aceite de oliva con un grado de acidez de 0,4º perfecto para cocinar.', 12, 66, 'unidades', 8.00, 'https://prod-mercadona.imgix.net/images/1a84cd7052b68873985104ac24b87043.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra premium para realzar el sabor de tus platos.', 12, 66, 'unidades', 29.55, 'https://prod-mercadona.imgix.net/images/c6ce7821078acb0f45c45ef2b36ee4c6.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra de calidad superior para tus preparaciones especiales.', 12, 66, 'unidades', 9.90, 'https://prod-mercadona.imgix.net/images/bed0b39f9e3a67b1f6bfb8f4f04e5694.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva virgen extra', 'Hacendado Gran Selección', 'Aceite de oliva virgen extra de la selección premium de Hacendado, para paladares exigentes.', 12, 66, 'unidades', 8.10, 'https://prod-mercadona.imgix.net/images/ca971ebf519d62b535e1d0ad05ebd394.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva 1º', 'Hacendado', 'Aceite de oliva de primera prensada para dar sabor y calidad a tus platos.', 12, 66, 'unidades', 8.00, 'https://prod-mercadona.imgix.net/images/b57ae00beedb23ec86686fa3651fd448.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva virgen', 'Hacendado', 'Aceite de oliva virgen de alta calidad para tus recetas gourmet.', 12, 66, 'unidades', 26.30, 'https://prod-mercadona.imgix.net/images/e58a263f9514576e38a96724b3104f9b.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva virgen', 'Hacendado', 'Aceite de oliva virgen de sabor intenso y auténtico.', 12, 66, 'unidades', 8.95, 'https://prod-mercadona.imgix.net/images/7a14986c6a536dcd485b8bb8b8e24e33.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva suave', 'Hacendado', 'Aceite de oliva suave para platos delicados y sabrosos.', 12, 66, 'unidades', 23.90, 'https://prod-mercadona.imgix.net/images/617bf49db3b4f79f5e311007e8cee4ab.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva intenso', 'Hacendado', 'Aceite de oliva de sabor intenso para realzar el sabor de tus comidas.', 12, 66, 'unidades', 23.90, 'https://prod-mercadona.imgix.net/images/bbfe2ec5cc49633c1e2d9988feb58932.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva virgen extra', 'Hacendado', 'Aceite de oliva virgen extra de alta calidad para tus platos favoritos.', 12, 66, 'unidades', 3.30, 'https://prod-mercadona.imgix.net/images/2dd497b89f607de5efde08d7b1585888.jpg?fit=crop&h=300&w=300'),
('Aceite de oliva virgen extra Picual', 'Casa Juncal', 'Aceite de oliva virgen extra de la variedad Picual, con un sabor intenso y característico.', 12, 66, 'unidades', 7.85, 'https://prod-mercadona.imgix.net/images/57c541a2fdb98be59dd3c91185658181.jpg?fit=crop&h=300&w=300'),
('Aceite de girasol refinado 0,2º', 'Hacendado', 'Aceite de girasol refinado de primera calidad con un grado de acidez de 0,2º.', 12, 66, 'unidades', 6.75, 'https://prod-mercadona.imgix.net/images/8c16a9c5fe8126141815ce55e50cbcba.jpg?fit=crop&h=300&w=300'),
('Aceite de girasol refinado 0,2º', 'Hacendado', 'Aceite de girasol refinado de alta calidad con un grado de acidez de 0,2º.', 12, 66, 'unidades', 1.45, 'https://prod-mercadona.imgix.net/images/38334513c2db1608117eb6c2759439f2.jpg?fit=crop&h=300&w=300'),
('Aceite de coco virgen', 'Hacendado', 'Aceite de coco virgen prensado en frío para conservar todas sus propiedades naturales.', 12, 66, 'unidades', 4.40, 'https://prod-mercadona.imgix.net/images/4b73d0063a13ed91219d84e7dd70d22d.jpg?fit=crop&h=300&w=300'),
('Vinagre de vino blanco', 'Hacendado', 'Vinagre de vino blanco de alta calidad para aliñar tus ensaladas y platos favoritos.', 12, 68, 'unidades', 0.70, 'https://prod-mercadona.imgix.net/images/998aae3f62fda2b1e90ecd4e835357e3.jpg?fit=crop&h=300&w=300'),
('Vinagre de manzana', 'Hacendado', 'Vinagre de manzana natural y saludable, ideal para aderezar y marinar.', 12, 68, 'unidades', 0.85, 'https://prod-mercadona.imgix.net/images/98d5a34a0d30798bbdc520993f63e542.jpg?fit=crop&h=300&w=300'),
('Limón exprimido', 'Hacendado', 'Zumo de limón exprimido fresco y natural, sin conservantes ni colorantes añadidos.', 12, 69, 'unidades', 1.00, 'https://prod-mercadona.imgix.net/images/802d61bae30f424fa8315698f9f245db.jpg?fit=crop&h=300&w=300'),
('Crema de vinagre balsámico de Módena', 'Hacendado', 'Crema de vinagre balsámico de Módena, perfecta para aderezar ensaladas y platos gourmet.', 12, 68, 'unidades', 1.75, 'https://prod-mercadona.imgix.net/images/d23cb7535fe0a9e9e053713faff31b93.jpg?fit=crop&h=300&w=300'),
('Vinagre de Jerez reserva', 'Hacendado', 'Vinagre de Jerez reserva de alta calidad, ideal para realzar el sabor de tus platos.', 12, 68, 'unidades', 2.00, 'https://prod-mercadona.imgix.net/images/bfa0c4aabf80adf4cd9a390df6aa7184.jpg?fit=crop&h=300&w=300'),
('Reducción de vinagre Pedro Ximénez', 'Hacendado', 'Reducción de vinagre de Pedro Ximénez, perfecta para dar un toque especial a tus recetas.', 12, 68, 'unidades', 2.25, 'https://prod-mercadona.imgix.net/images/0f2f3566dedc310f8330782da97cff7b.jpg?fit=crop&h=300&w=300'),
('Vinagre balsámico de Módena', 'Hacendado', 'Vinagre balsámico de Módena, perfecto para realzar el sabor de tus platos.', 12, 68, 'unidades', 2.45, 'https://prod-mercadona.imgix.net/images/f65c196d0aae6388f9e6852c381f8da4.jpg?fit=crop&h=300&w=300');

