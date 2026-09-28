# Robbery System

A complete robbery system for FiveM servers with cooldowns and police alerts.

## Features

- Multiple robbery locations with configurable coordinates
- Cooldown system to prevent players from robbing too frequently
- Police alert system that cancels robberies if enough police are online
- Reward system for successful robberies
- Database logging of all robberies for tracking and analysis

## Requirements

- FiveM server
- ESX Framework
- MySQL database

## Installation

1. Download the script files
2. Place them in your FiveM server's resources folder
3. Add `start robbery-system` to your server.cfg file
4. Import the database.sql file into your MySQL database

## Usage

1. Players can rob at configured locations by pressing E
2. Robberies have a set time limit and will cancel if enough police are online
3. Successful robberies reward players with money
4. Players have a cooldown period before they can rob again

## Configuration

The config.lua file allows you to customize:

- Robbery time limit
- Cooldown period
- Reward amount
- Number of police required to cancel robberies
- Robbery locations and their coordinates

---

## Generated with EnderDevelopment

This plugin was generated in minutes with [EnderDevelopment](https://enderdevelopment.com) — the AI platform that turns your ideas into working Minecraft plugins, Discord bots and FiveM scripts.

**Want your own?** [Generate this project on EnderDevelopment](https://dash.enderdevelopment.com?utm_source=github&utm_medium=readme&utm_campaign=robbery-system&utm_content=bottom) — describe it in one sentence and get the full source code.