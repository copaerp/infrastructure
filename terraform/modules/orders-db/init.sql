DROP DATABASE IF EXISTS orders;
CREATE DATABASE orders;
USE orders;

CREATE TABLE business (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255),
    legal_name VARCHAR(255),
    cnpj VARCHAR(20),
    email VARCHAR(255),
    phone VARCHAR(20),
    logo_url VARCHAR(255),
    industry VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE customer (
    id CHAR(36) PRIMARY KEY,
    business_id CHAR(36),
    full_name VARCHAR(255),
    phone VARCHAR(20),
    instagram_user VARCHAR(255),
    email VARCHAR(255),
    document VARCHAR(50),
    birth_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES business(id)
);

CREATE TABLE unit (
    id CHAR(36) PRIMARY KEY,
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES business(id)
);

CREATE TABLE product (
    id CHAR(36) PRIMARY KEY,
    business_id CHAR(36),
    name VARCHAR(255),
    description TEXT,
    brl_price DECIMAL(19, 4),
    category VARCHAR(100),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES business(id)
);

CREATE TABLE channel (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `order` (
    id CHAR(36) PRIMARY KEY,
    customer_id CHAR(36),
    unit_id CHAR(36),
    channel_id CHAR(36),
    status VARCHAR(50),
    notes TEXT,
    payment_method VARCHAR(100),
    used_menu BLOB,
    last_message_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    finished_at TIMESTAMP NULL,
    canceled_at TIMESTAMP NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (unit_id) REFERENCES unit(id),
    FOREIGN KEY (channel_id) REFERENCES channel(id)
);

CREATE TABLE product_in_unit (
    id CHAR(36) PRIMARY KEY,
    product_id CHAR(36),
    unit_id CHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (unit_id) REFERENCES unit(id)
);

CREATE TABLE product_order (
    id CHAR(36) PRIMARY KEY,
    product_id CHAR(36),
    order_id CHAR(36),
    amount INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (order_id) REFERENCES `order`(id)
);

CREATE TABLE whatsapp_number (
    id CHAR(36) PRIMARY KEY,
    unit_id CHAR(36),
    number VARCHAR(20),
    description VARCHAR(255),
    meta_number_id CHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (unit_id) REFERENCES unit(id)
);

INSERT channel (id, name) VALUES
('1c918a23-4ad2-4ec1-8dc9-7785c6b10561', 'WhatsApp'),
('83f3f976-8be2-4e27-8406-baae013f1668', 'Instagram'),
('1394b549-7976-4f85-b26d-09fd2a7618d4', 'Facebook'),
('8b848fb0-2b67-405c-998e-51df7324b665', 'iFood'),
('a05ab3bb-b30e-469b-9445-a5bf7322cad9', 'Phone'),
('c7f14cd1-7e26-47b5-ae54-4808ddd673ac', 'Site');

INSERT business (id, name, legal_name, cnpj, email, phone, logo_url, industry) VALUES
('593db8e0-c46c-4e6e-9699-9e12f259e840', 'Pará Lanches', 'Para Lanches', '51.513.888/0001-05', 'paralanches@gmail.com', '15556382629', '', 'Food');

INSERT unit (id, business_id, name, phone, postal_code, street_name, street_number, city, state, country, neighborhood, complement) VALUES
('cc7a84b8-6a4d-42ff-bc37-efc00268ffd5', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Loja Principal', '15556382629', '12345678', 'Rua das Flores', '123', 'São Paulo', 'SP', 'Brasil', 'Jardim das Rosas', '');

INSERT product (id, business_id, name, description, brl_price, category, image_url) VALUES
('3f279d5d-5f64-43da-9ef7-538444d31a93', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'X-Burguer', 'Delicioso X-Burguer com queijo e bacon', 19.90, 'Lanches', ''),
('b6f4b6a2-5738-4f64-9054-bcdb9611326c', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Batata Rústica', 'Batatas cortadas com casca e levemente temperadas', 9.90, 'Acompanhamentos', ''),
('86bc8208-f84e-45fd-9eb1-0668b9f6a2c5', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Anéis de Cebola', 'Anéis de cebola empanados e crocantes', 9.90, 'Acompanhamentos', ''),
('3e95e6e1-db35-4e01-9472-f7092a43a0e9', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Mandioca Frita', 'Porção de mandioca frita crocante por fora e macia por dentro', 9.90, 'Acompanhamentos', ''),
('ebae84d7-5051-4e8c-afc8-e2d2d5dea0ea', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Chips de Batata Doce', 'Batata doce crocante, uma opção mais saudável', 9.90, 'Acompanhamentos', ''),
('3c21b014-5ce0-4bbe-9431-2e5e5e17f7af', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Mini Coxinhas', 'Porção com mini coxinhas crocantes de frango', 9.90, 'Acompanhamentos', ''),
('c32f0f6d-2ddc-41f2-a605-c1bdc648ed0f', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Bolinho de Queijo', 'Bolinho frito recheado com queijo derretido', 9.90, 'Acompanhamentos', ''),
('4eb15b99-05b6-4e3f-8109-14683b282692', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Nuggets de Frango', 'Croquetes de frango empanado', 9.90, 'Acompanhamentos', ''),
('1f363c55-34db-4dca-b586-fcbd5d7f8804', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Batata Smile', 'Batatinhas em formato de smiley, ótima para crianças', 9.90, 'Acompanhamentos', ''),
('a1ef019b-a724-45c3-a1ca-40e32f57a60a', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Batata Recheada', 'Batata com recheio de cheddar e bacon', 9.90, 'Acompanhamentos', ''),
('10d7adc1-2b24-40c3-a599-a7241a7e786e', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Polenta Frita', 'Tirinhas de polenta crocantes', 9.90, 'Acompanhamentos', ''),
('2185006f-8489-4197-a640-dc0f6b0cc3b6', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Batata Espiral', 'Batata em espiral no palito, temperada e frita', 9.90, 'Acompanhamentos', '');

INSERT product_in_unit (id, product_id, unit_id) VALUES
('69bbfc19-10e4-45f0-bef1-e6df47a9324f', '3f279d5d-5f64-43da-9ef7-538444d31a93', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('f6beccdb-8bda-4ff7-9554-6d247cfc29a8', 'b6f4b6a2-5738-4f64-9054-bcdb9611326c', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('b15ac5fc-269f-4f5a-b1a1-8889e299f1cf', '86bc8208-f84e-45fd-9eb1-0668b9f6a2c5', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('7db04417-9b85-49d7-bee5-94f93c108887', '3e95e6e1-db35-4e01-9472-f7092a43a0e9', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('01be7b2d-fd7f-48b9-b2ed-8a709cfb9b04', 'ebae84d7-5051-4e8c-afc8-e2d2d5dea0ea', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('0c3caa4a-4bdc-4130-8b16-0edb0ce371eb', '3c21b014-5ce0-4bbe-9431-2e5e5e17f7af', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('5911da39-adc2-4b9f-b3f2-9de8d1dc2eb7', 'c32f0f6d-2ddc-41f2-a605-c1bdc648ed0f', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('e7f60143-4db5-4cc3-89e7-e0204deeecea', '4eb15b99-05b6-4e3f-8109-14683b282692', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('0bc6e8ff-a228-4a83-9d77-075861594d37', '1f363c55-34db-4dca-b586-fcbd5d7f8804', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('90edb56f-cd58-4496-9154-b07583fc3424', 'a1ef019b-a724-45c3-a1ca-40e32f57a60a', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('08bf02f9-fdf8-40e8-96b6-1476fc48535d', '10d7adc1-2b24-40c3-a599-a7241a7e786e', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5'),
('cde61d9e-5b5e-4a65-ae12-9e2af6eacabb', '2185006f-8489-4197-a640-dc0f6b0cc3b6', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5');

INSERT whatsapp_number (id, unit_id, number, description, meta_number_id) VALUES
('dac4da05-05dd-4716-96d7-a29dd7ca81a9', 'cc7a84b8-6a4d-42ff-bc37-efc00268ffd5', '15556382629', 'WhatsApp Principal', '622466564276838');

INSERT customer (id, business_id, full_name, phone, instagram_user, email, document, birth_date) VALUES
('6186b034-cb04-4f3b-a029-1ac716af6a84', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Joaquim Pires', '5517997355173', 'jocasrc', 'joaqu1m.pires@hotmail.com', '65463821054', '1990-01-01'),
('a029c004-7369-40c4-86c1-b9dbe7cee514', '593db8e0-c46c-4e6e-9699-9e12f259e840', 'Erick Pio', '5511963107396', 'sloninsk', 'erick.pio@sptech.school', '60625937015', '1990-01-01');
