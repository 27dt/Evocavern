extends CharacterBody2D

class_name Player

var SPEED = 300.0
var JUMP_VELOCITY = -620.0

@export var inv: Inv
@export var maxHealth = 100
@onready var currentHealth: int = maxHealth

#AudioSteamPlayer2D references for SFX
@onready var footsteps_sfx = $"Footsteps SFX"
@onready var jump_sfx = $"Jump SFX"
@onready var level_up_sfx = $"Level Up SFX"
@onready var pickup_sfx = $"Pickup SFX"

signal shoot(pos: Vector2);
signal grenade(pos: Vector2);

var canShootPrim := true;
var canShootSec := true;
var walking := false;

var doubleJump := true;
var facingDir := 1;

#used to check how many times a bullet has been fired for cooldown
var primFireCount := 0;

func _ready():
	Global.playerBody = self;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_sfx.play()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		doubleJump = true;

	# Handle jump.
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		if doubleJump == true:
			velocity.y = JUMP_VELOCITY/1.3
			doubleJump = false;
		else:
			velocity += get_gravity() * delta
	
	# Handle primary fire.
	if Input.is_action_just_pressed("primary_fire") and canShootPrim:
		# Send a firing signal to the bullet
		shoot.emit(global_position, facingDir, false);
		canShootPrim = false;
		canShootSec = false;
		$Timers/PrimaryFireTimer.start();
		primFireCount = 1;

	# Handle secondary fire.
	if Input.is_action_just_pressed("secondary_fire") and canShootSec:
		# Send a firing signal to the bullet
		shoot.emit(global_position, facingDir, true);
		canShootPrim = false;
		canShootSec = false;
		$Timers/SecondaryFireTimer.start();
	
		# Handle secondary fire.
	if Input.is_action_just_pressed("unique_ability"):
		# Send a firing signal to the bullet
		if !Global.thrownGrenade and !Global.grenadeCooldown:
			Global.grenadeCooldown = true;
			grenade.emit(global_position, facingDir);

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		facingDir = direction;
		walking = true;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walking = false;
	
	if direction and !walking:
		footsteps_sfx.play()
		walking = true;

	move_and_slide()

func _on_primary_fire_timer_timeout() -> void:
	if primFireCount < 3:
		$Timers/PrimaryFireTimer.start()
		shoot.emit(global_position, facingDir, false);
		
		primFireCount += 1;
	else:
		primFireCount = 0;
		canShootPrim = true;
		canShootSec = true;
		$Timers/PrimaryFireTimer.stop();

func _on_secondary_fire_timer_timeout() -> void:
	$Timers/PrimaryFireTimer.stop();
	canShootSec = true;
	canShootPrim = true;

func _on_flying_enemy_deal_damage(damage: int) -> void:
	print("deal damage")
	Global.playerHealth -= Global.flyingDamage;
	print(Global.playerHealth);
	if Global.playerHealth <= 0:
		visible = false
		SPEED = 0
		JUMP_VELOCITY = 0
		canShootPrim = false
		canShootSec = false
	$Label.text = str("-", Global.flyingDamage);
	await get_tree().create_timer(1).timeout
	$Label.text = "";

func _on_testcollectable_collect(item: InvItem) -> void:
	inv.insert(item)
	pickup_sfx.play()

func _on_world_enemy_connect(enemy: CharacterBody2D) -> void:
	enemy.dealDamage.connect(_on_flying_enemy_deal_damage);
