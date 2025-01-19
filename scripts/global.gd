extends Node

var playerBody: CharacterBody2D;

var currentWave = 1;
var currentLevel = 1;
var enemyKills = 0;
var expMax = 60;
var exp = 0;

# Player Stats
var primaryDamage = 10;
var secondaryDamage = 25;
var playerHealth = 100;
var playerHealthMax = 100;
var palyerHealthMin = 0;

# Enemy Stats
var flyingDamage = 10;
var flyingHealth = 25;
var flyingHealthMax = 25;
var flyingHealthMin = 0;

var thrownGrenade = false;
var grenadeCooldown = false;
