CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP DEFAULT NOW(),
    description TEXT,
    title TEXT,
    category TEXT,
    price NUMERIC
);