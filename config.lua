Config = {}

-- Robbery settings
Config.RobberyTime = 300 -- Time in seconds for robbery to complete
Config.RobberyCooldown = 1800 -- Cooldown time in seconds between robberies
Config.RobberyReward = 5000 -- Reward for successful robbery
Config.RobberyPoliceAlert = 3 -- Number of police required to cancel robbery

-- Robbery locations
Config.RobberyLocations = {
    {name = 'Bank', coords = vector3(256.1, 220.1, 106.2), heading = 160.0},
    {name = 'Store', coords = vector3(25.7, -1347.3, 29.4), heading = 269.5}
}