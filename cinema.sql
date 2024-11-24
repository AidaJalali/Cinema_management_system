-- 401106674 :یسنا نوشیروانی 
-- آیدا جلالی : 401170542

CREATE DATABASE cinema_database;

CREATE TYPE screening_status_enum AS ENUM ('available', 'unavailable');
CREATE TYPE ticket_status_enum AS ENUM ('active', 'inactive', 'refunded');
CREATE TYPE day_enum AS ENUM ('sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri');
CREATE TYPE genre_enum AS ENUM ('romance', 'action', 'horror', 'comedy', 'drama', 'fiction', 'documentry', 'musical', 'western', 'historical', 'biography');

CREATE TABLE cinema (
    cinema_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location POINT NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    ticket_price DECIMAL(8, 2)
);

CREATE TABLE hall (
    hall_id SERIAL PRIMARY KEY,
    cinema_id INT,
    number INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    map_url VARCHAR(50),
    capacity INT,
    utilities VARCHAR(300),
    FOREIGN KEY (cinema_id) REFERENCES cinema(cinema_id) ON DELETE CASCADE,
    CONSTRAINT cinema_hall_id UNIQUE (cinema_id, number)
);

CREATE TABLE film (
    film_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    genre genre_enum[],
    release_date DATE NOT NULL,
    director VARCHAR(100) NOT NULL,
    writer VARCHAR(100) NOT NULL,
    producer VARCHAR(100) NOT NULL,
    description VARCHAR(300)
);

CREATE TABLE screening (
    screening_id SERIAL PRIMARY KEY,
    film_id INT NOT NULL,
    hall_id INT NOT NULL,
    status screening_status_enum DEFAULT 'available' NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    from_hour TIME NOT NULL,
    to_hour TIME NOT NULL,
    days day_enum[],
    FOREIGN KEY (film_id) REFERENCES film(film_id) ON DELETE CASCADE,
    FOREIGN KEY (hall_id) REFERENCES hall(hall_id) ON DELETE RESTRICT
);

CREATE TABLE seat (
    row_number INT NOT NULL,
    col_number INT NOT NULL,
    hall_id INT NOT NULL,
    is_vip BOOLEAN NOT NULL DEFAULT FALSE,
    position POINT NOT NULL,
    CONSTRAINT seat_id PRIMARY KEY (row_number, col_number, hall_id),
    FOREIGN KEY (hall_id) REFERENCES hall(hall_id) ON DELETE CASCADE
);

CREATE TABLE cinema_user (
    username VARCHAR(50) PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    national_number VARCHAR(20) UNIQUE,
    CONSTRAINT phone_format CHECK (phone_number ~  '^(0|\\+98)?9[0-9]{9}$'),
    CONSTRAINT email_format CHECK (email ~ '^[^@]+@[^@]+\.[^@]+$'),
    CONSTRAINT national_number_format CHECK (national_number ~ '^\d+$')
);

CREATE TABLE ticket (
    screening_id INT NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    seat_row_number INT NOT NULL,
    seat_col_number INT NOT NULL,
    seat_hall_id INT NOT NULL,
    ticket_date DATE NOT NULL,
    price DECIMAL(8, 2) NOT NULL,
    status ticket_status_enum NOT NULL,
    FOREIGN KEY (screening_id) REFERENCES screening(screening_id) ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES cinema_user(username) ON DELETE RESTRICT,
    FOREIGN KEY (seat_row_number, seat_col_number, seat_hall_id) REFERENCES seat(row_number, col_number, hall_id) ON DELETE RESTRICT
);


INSERT INTO cinema (name, location, address, city, ticket_price) VALUES
('Grand Cinema', POINT(35.6892, 51.3890), '123 Main St', 'Tehran', 15.50),
('City Lights', POINT(35.7378, 51.5143), '456 Elm St', 'Tehran', 20.00);


INSERT INTO hall (cinema_id, number, name, map_url, capacity, utilities) VALUES
(1, 1, 'Hall A', 'http://example.com/map1', 150, 'Dolby Atmos, Recliner Seats'),
(1, 2, 'Hall B', 'http://example.com/map2', 100, 'Standard Seating'),
(2, 1, 'Hall C', 'http://example.com/map3', 120, '3D Projector, Standard Seating');


INSERT INTO film (name, genre, release_date, director, writer, producer, description) VALUES
('Love in the Air', ARRAY['romance', 'drama']::genre_enum[], '2024-02-14', 'Alice Johnson', 'Alice Johnson', 'Alice Johnson Films', 'A beautiful love story.'),
('Epic Battle', ARRAY['action', 'drama']::genre_enum[], '2024-05-20', 'John Smith', 'Jane Doe', 'Smith Productions', 'An action-packed epic journey.');


INSERT INTO screening (film_id, hall_id, status, from_date, to_date, from_hour, to_hour, days) VALUES
(1, 1, 'available', '2024-02-14', '2024-02-20', '18:00', '20:30', ARRAY['fri', 'sat', 'sun']::day_enum[]),
(2, 2, 'available', '2024-05-20', '2024-05-25', '15:00', '17:30', ARRAY['mon', 'tue', 'wed']::day_enum[]);


INSERT INTO seat (row_number, col_number, hall_id, is_vip, position) VALUES
(1, 1, 1, TRUE, POINT(0.5, 0.5)),
(1, 2, 1, FALSE, POINT(1.0, 0.5)),
(2, 1, 1, FALSE, POINT(0.5, 1.0));


INSERT INTO cinema_user (username, phone_number, email, name, national_number) VALUES
('user1', '09121234567', 'user1@example.com', 'Ali Reza', '1234567890'),
('user2', '09129876543', 'user2@example.com', 'Sara Karim', '0987654321');


INSERT INTO ticket (screening_id, user_id, seat_row_number, seat_col_number, seat_hall_id, ticket_date, price, status) VALUES
(1, 'user1', 1, 1, 1, '2024-02-14', 15.50, 'active'),
(2, 'user2', 1, 2, 1, '2024-05-20', 20.00, 'active');
