-- Create new users table for storing username, password
CREATE TABLE users (
    username VARCHAR(50) PRIMARY KEY,
    pass VARCHAR(255) NOT NULL
);

-- Adding data
INSERT INTO users (username, pass) VALUES
('john_doe', 'P@ssw0rd1'),
('jane_smith', 'SecurePwd123'),
('robert_jackson', 'Pass123word'),
('emily_williams', 'MyPwd!2023'),
('michael_brown', 'Secret@567'),
('olivia_jones', 'P@ssw0rd2'),
('david_miller', 'StrongPwd!'),
('sophia_davis', 'Pa$$w0rd#1'),
('william_taylor', 'SecurePwd987'),
('ava_martinez', 'MyP@ssw0rd'),
('james_anderson', 'Passw0rd!789'),
('emma_thomas', 'StrongP@ss!'),
('alexander_hall', 'SecurePwd456'),
('mia_wilson', 'Pa$$w0rd!3'),
('benjamin_martin', 'MySecretPwd'),
('chloe_clark', 'Pwd123!'),
('daniel_adams', 'StrongP@ss567'),
('grace_cook', 'SecurePwd!999'),
('matthew_baker', 'Pa$$w0rd789'),
('sophie_white', 'SecretPwd456');

-- Modifying airlines table to have user_rating column with default value of 0
ALTER TABLE airlines
ADD COLUMN user_rating FLOAT DEFAULT 0.0;

-- Create user_ratings table for CRUD operations
CREATE TABLE user_ratings (
    username VARCHAR(50) ,
    IATA_CODE VARCHAR(2) ,
    rating INT,
    PRIMARY KEY(USERNAME, IATA_CODE),
    FOREIGN KEY (IATA_CODE) REFERENCES airlines (IATA_CODE)
);

-- Adding data to user_ratings
INSERT INTO user_ratings (username, IATA_CODE, rating) VALUES
('john_doe', 'AA', 8),
('jane_smith', 'AS', 7),
('robert_jackson', 'B6', 9),
('emily_williams', 'DL', 6),
('michael_brown', 'EV', 5),
('olivia_jones', 'F9', 8),
('david_miller', 'HA', 7),
('sophia_davis', 'MQ', 9),
('william_taylor', 'NK', 6),
('ava_martinez', 'OO', 8),
('james_anderson', 'UA', 7),
('emma_thomas', 'US', 9),
('alexander_hall', 'VX', 6),
('mia_wilson', 'WN', 5),
('benjamin_martin', 'AA', 8),
('chloe_clark', 'AS', 7),
('daniel_adams', 'B6', 9),
('grace_cook', 'DL', 6),
('matthew_baker', 'EV', 8),
('sophie_white', 'F9', 7);

-- SQL query to update the user_rating column in airlines based on values populated in the user_ratings table
UPDATE airlines
SET user_rating = (
    SELECT AVG(rating)
    FROM user_ratings
    WHERE user_ratings.IATA_CODE = airlines.IATA_CODE
);
