drop table usuarios;
create table usuarios (
     id INT AUTO_INCREMENT PRIMARY KEY,
     nombre VARCHAR(30),
     pass VARCHAR(30)
);

drop table productos;
create table productos (
     id INT AUTO_INCREMENT PRIMARY KEY,
     nombre VARCHAR(30),
     supercategoria VARCHAR(50),
     categoria VARCHAR(50),
     subcategoria VARCHAR(50),
     precio DOUBLE,
     fotografia VARCHAR(255)
);

drop table stock;
create table stock (
     id INT AUTO_INCREMENT PRIMARY KEY,
     nombre VARCHAR(30),
     supercategoria VARCHAR(50),
     categoria VARCHAR(50),
     subcategoria VARCHAR(50),
     precio DOUBLE,
     fotografia VARCHAR(255),
     cantidad INT
);

drop table menus;
create table menus (
     id INT AUTO_INCREMENT PRIMARY KEY,
     nombre VARCHAR(50),
     comensales INT,
);

drop table recetas;
create table recetas (
     id INT AUTO_INCREMENT PRIMARY KEY,
     nombre VARCHAR(50),
     comensales INT,
     ingredientes TEXT,
     valor_nutricional TEXT
);

