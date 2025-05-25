Use copa;

CREATE TABLE Business (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    legal_name VARCHAR(255),
    cnpj VARCHAR(20),
    email VARCHAR(255),
    phone VARCHAR(20),
    logo_url VARCHAR(255),
    industry VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE Customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    document VARCHAR(50),
    birth_date DATE,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (business_id) REFERENCES Business(id)
);

CREATE TABLE Unit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT,
    name VARCHAR(255),
    phone VARCHAR(20),
    postal_code VARCHAR(10),
    street_name VARCHAR(255),
    street_number VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    neighborhood VARCHAR(100),
    complement VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (business_id) REFERENCES Business(id)
);

CREATE TABLE Product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT,
    name VARCHAR(255),
    description TEXT,
    brl_price DECIMAL(10, 2),
    category VARCHAR(100),
    image_url VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (business_id) REFERENCES Business(id)
);

CREATE TABLE Channel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE `Order` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    unit_id INT,
    channel_id INT,
    status VARCHAR(50),
    notes TEXT,
    payment_method VARCHAR(100),
    created_at DATETIME,
    updated_at DATETIME,
    finished_at DATETIME,
    canceled_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customer(id),
    FOREIGN KEY (unit_id) REFERENCES Unit(id),
    FOREIGN KEY (channel_id) REFERENCES Channel(id)
);

CREATE TABLE ProductNotInUnit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    unit_id INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (product_id) REFERENCES Product(id),
    FOREIGN KEY (unit_id) REFERENCES Unit(id)
);

CREATE TABLE ProductOrder (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    order_id INT,
    amount INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (product_id) REFERENCES Product(id),
    FOREIGN KEY (order_id) REFERENCES `Order`(id)
);
