use applicationdatabase;

CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    UNIQUE KEY idx_username (username),
    INDEX idx_username_index (username)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS address (
    username VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    FOREIGN KEY (username) REFERENCES user(username)
) ENGINE=InnoDB;
