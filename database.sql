CREATE TABLE IF NOT EXISTS robberies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    location VARCHAR(50) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    success BOOLEAN NOT NULL,
    reward INT NOT NULL
);

CREATE TABLE IF NOT EXISTS robbery_cooldowns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    cooldown_end DATETIME NOT NULL
);