-- Eliminar tablas si existen
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS recetas;
-- Crear tabla usuarios
CREATE TABLE usuarios (
     id SERIAL PRIMARY KEY,
     nombre VARCHAR(30) NOT NULL UNIQUE,
     pass VARCHAR(30) NOT NULL
);
-- Crear tabla productos
CREATE TABLE productos (
     id SERIAL PRIMARY KEY,
     nombre VARCHAR(50) NOT NULL,
     supercategoria VARCHAR(50),
     categoria VARCHAR(50),
     subcategoria VARCHAR(50),
     precio NUMERIC(10, 2) NOT NULL,
     fotografia TEXT
);
-- Crear tabla stock
CREATE TABLE stock (
     id SERIAL PRIMARY KEY,
     nombre VARCHAR(50) NOT NULL,
     supercategoria VARCHAR(50),
     categoria VARCHAR(50),
     subcategoria VARCHAR(50),
     precio NUMERIC(10, 2) NOT NULL,
     fotografia TEXT,
     cantidad INT NOT NULL CHECK (cantidad >= 0)
);
-- Crear tabla menus
CREATE TABLE menus (
     id SERIAL PRIMARY KEY,
     nombre VARCHAR(50) NOT NULL,
     comensales INT NOT NULL CHECK (comensales > 0)
);
-- Crear tabla recetas
CREATE TABLE recetas (
     id SERIAL PRIMARY KEY,
     nombre VARCHAR(50) NOT NULL,
     comensales INT NOT NULL CHECK (comensales > 0),
     ingredientes TEXT NOT NULL,
     valor_nutricional TEXT NOT NULL
);