CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

CREATE TABLE IF NOT EXISTS restaurant_clients (
	client_id CHAR(36) PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	surname VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	phone VARCHAR(50) NOT NULL,
	address TEXT NOT NULL,
	status ENUM('new', 'regular', 'vip') NOT NULL
);

CREATE TABLE IF NOT EXISTS restaurant_tables (
	table_id INT AUTO_INCREMENT PRIMARY KEY,
	table_number INT NOT NULL,
    capacity INT NOT NULL CHECK (capacity BETWEEN 1 AND 20),
    location ENUM('main_hall', 'terrace', 'vip_zone') NOT NULL,
	status ENUM('available', 'reserved') NOT NULL
);

CREATE TABLE IF NOT EXISTS restaurant_reservations (
	reservation_id INT AUTO_INCREMENT PRIMARY KEY,
	reservation_date DATE NOT NULL,
	reservation_time TIME NOT NULL,
	client_id CHAR(36),
	table_id INT,
	guests_count INT NOT NULL CHECK (guests_count BETWEEN 1 AND 20),
	status ENUM('confirmed', 'canceled', 'pending') NOT NULL,
	FOREIGN KEY (client_id) REFERENCES restaurant_clients(client_id),
	FOREIGN KEY (table_id) REFERENCES restaurant_tables(table_id)
);
