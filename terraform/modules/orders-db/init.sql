Use copa;

CREATE TABLE business (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
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

CREATE TABLE customer (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    business_id CHAR(36),
    full_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    document VARCHAR(50),
    birth_date DATE,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (business_id) REFERENCES business(id)
);

CREATE TABLE unit (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    business_id CHAR(36),
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
    FOREIGN KEY (business_id) REFERENCES business(id)
);

CREATE TABLE product (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    business_id CHAR(36),
    name VARCHAR(255),
    description TEXT,
    brl_price DECIMAL(19, 4),
    category VARCHAR(100),
    image_url VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (business_id) REFERENCES business(id)
);

CREATE TABLE channel (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE `order` (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    customer_id CHAR(36),
    unit_id CHAR(36),
    channel_id CHAR(36),
    status VARCHAR(50),
    notes TEXT,
    payment_method VARCHAR(100),
    created_at DATETIME,
    updated_at DATETIME,
    finished_at DATETIME,
    canceled_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (unit_id) REFERENCES unit(id),
    FOREIGN KEY (channel_id) REFERENCES channel(id)
);

CREATE TABLE product_in_unit (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    product_id CHAR(36),
    unit_id CHAR(36),
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (unit_id) REFERENCES unit(id)
);

CREATE TABLE product_order (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    product_id CHAR(36),
    order_id CHAR(36),
    amount INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (order_id) REFERENCES `order`(id)
);

CREATE TABLE whatsapp_number (
    id CHAR(36) AUTO_INCREMENT PRIMARY KEY,
    unit_id CHAR(36),
    number VARCHAR(20),
    description VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (unit_id) REFERENCES unit(id)
)
