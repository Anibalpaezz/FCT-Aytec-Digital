-- Eliminar tablas si existen
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS recipes;

-- Crear tabla users
CREATE TABLE users (
     id SERIAL PRIMARY KEY,
     name VARCHAR(30) NOT NULL UNIQUE,
     password VARCHAR(30) NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla products
CREATE TABLE products (
     id SERIAL PRIMARY KEY,
     name VARCHAR(50) NOT NULL,
     supercategory VARCHAR(50),
     category VARCHAR(50),
     subcategory VARCHAR(50),
     price NUMERIC(10, 2) NOT NULL,
     photo TEXT,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla stock
CREATE TABLE stock (
     id SERIAL PRIMARY KEY,
     name VARCHAR(50) NOT NULL,
     supercategory VARCHAR(50),
     category VARCHAR(50),
     subcategory VARCHAR(50),
     price NUMERIC(10, 2) NOT NULL,
     photo TEXT,
     amount INT NOT NULL CHECK (amount >= 0),
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla menus
CREATE TABLE menus (
     id SERIAL PRIMARY KEY,
     name VARCHAR(50) NOT NULL,
     diners INT NOT NULL CHECK (diners > 0),
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla recipes
CREATE TABLE recipes (
     id SERIAL PRIMARY KEY,
     name VARCHAR(50) NOT NULL,
     diners INT NOT NULL CHECK (diners > 0),
     ingredients TEXT NOT NULL,
     nutritional_value TEXT NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agregar columna uid en users como clave foránea de la tabla users en supabase de auth
ALTER TABLE users ADD COLUMN uid UUID REFERENCES auth.users(id);
