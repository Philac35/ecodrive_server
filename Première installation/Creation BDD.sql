CREATE DATABASE EcorideBDD ;
USE EcorideBDD;

CREATE TABLE address (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    number INT,
    type VARCHAR(64),
    address VARCHAR(255),
    AddressComplement VARCHAR(256),
    postcode VARCHAR(5),
    city VARCHAR(64),
    country VARCHAR(64),
    createdAt DATETIME
);

CREATE TABLE photo (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    title VARCHAR(64),
    url VARCHAR(128),
    description VARCHAR(256),
    createdAt DATETIME
);

CREATE TABLE authUser (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    identifiant VARCHAR(64),
    password VARCHAR(128),
    role VARCHAR(64)
);

CREATE TABLE notice (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    title VARCHAR(64),
    description VARCHAR(256),
    note INT,
    createdAt DATETIME
);

CREATE TABLE user (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    firstname VARCHAR(64),
    lastname VARCHAR(64),
    pseudo VARCHAR(64),
    age INT,
    gender VARCHAR(8),
    credit FLOAT,
    address_id INT,
    role VARCHAR(64),
    email VARCHAR(128),
    photo_id INT,
    authUser_id INT,
    createdAt DATETIME,
    FOREIGN KEY (address_id) REFERENCES address(id),
    FOREIGN KEY (photo_id) REFERENCES photo(id),
    FOREIGN KEY (authUser_id) REFERENCES authUser(id)
);

CREATE TABLE driver (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    firstname VARCHAR(64),
    lastname VARCHAR(64),
    pseudo VARCHAR(64),
    age TINYINT,
    gender VARCHAR(8),
    credit FLOAT,
    address_id INT,
    role VARCHAR(64),
    email VARCHAR(128),
    photo_id INT,
    authUser_id INT,
    createdAt DATETIME,
    notice_id INT,
    preferences JSON,
    drivingLicense VARCHAR(128),
    FOREIGN KEY (address_id) REFERENCES address(id),
    FOREIGN KEY (photo_id) REFERENCES photo(id),
    FOREIGN KEY (authUser_id) REFERENCES authUser(id),
    FOREIGN KEY (notice_id) REFERENCES notice(id)
);

CREATE TABLE employee (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    firstname VARCHAR(64),
    lastname VARCHAR(64),
    age INT,
    gender VARCHAR(8),
    balance FLOAT,
    address_id INT,
    email VARCHAR(128),
    photo_id INT,
    authUser_id INT,
    createdAt DATETIME,
    FOREIGN KEY (address_id) REFERENCES address(id),
    FOREIGN KEY (photo_id) REFERENCES photo(id),
    FOREIGN KEY (authUser_id) REFERENCES authUser(id)
);

CREATE TABLE administrator (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    firstname VARCHAR(64),
    lastname VARCHAR(64),
    age INT,
    gender VARCHAR(8),
    credit FLOAT,
    address_id INT,
    email VARCHAR(128),
    photo_id INT,
    authUser_id INT,
    createdAt DATETIME,
    FOREIGN KEY (address_id) REFERENCES address(id),
    FOREIGN KEY (photo_id) REFERENCES photo(id),
    FOREIGN KEY (authUser_id) REFERENCES authUser(id)
);

CREATE TABLE itinerary (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    price FLOAT,
    addressDeparture_id INT,
    addressArrival_id INT,
    dateDeparture DATETIME,
    dateArrival DATETIME,
    eco BOOLEAN,
    DURATION DATETIME,
    createdAt DATETIME,
    FOREIGN KEY (addressDeparture_id) REFERENCES address(id),
    FOREIGN KEY (addressArrival_id) REFERENCES address(id)
);

CREATE TABLE vehicule (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    brand VARCHAR(64),
    model VARCHAR(64),
    color VARCHAR(64),
    energy VARCHAR(64),
    immatriculation VARCHAR(64),
    firstImmatriculation DATETIME,
    nbPlace INT,
    preferences VARCHAR(255),
    assurance_url VARCHAR(128)
);

CREATE TABLE travel (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    driver_id INT,
    itinerary_id INT,
    vehicule_id INT,
    userList JSON,
    validate JSON,
    createdAt DATETIME,
    updatedAt DATETIME,
    FOREIGN KEY (driver_id) REFERENCES driver(id),
    FOREIGN KEY (itinerary_id) REFERENCES itinerary(id),
    FOREIGN KEY (vehicule_id) REFERENCES vehicule(id)
);

CREATE TABLE commande (
    id INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id),
    user_id INT,
    reference VARCHAR(64),
    Credits FLOAT,
    unitaryPrice FLOAT,
    totalHT FLOAT,
    totalTTC FLOAT,
    FOREIGN KEY (user_id) REFERENCES user(id)
);


