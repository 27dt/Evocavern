extends Node

var playerBody: CharacterBody2D;

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
