extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -620.0

@export var inv: Inv
@export var maxHealth = 100
@onready var currentHealth: int = maxHealth

#AudioSteamPlayer2D references for SFX
@onready var footsteps_sfx = $"Footsteps SFX"
@onready var jump_sfx = $"Jump SFX"
@onready var pickup_sfx = $"Pickup SFX"

signal shoot(pos: Vector2);
signal grenade(pos: Vector2);
signal itemPickup(name: String);

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
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sfx.play()
		velocity.y = JUMP_VELOCITY*Global.jumpScale
		doubleJump = true;

	# Handle jump.
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		if doubleJump == true:
			jump_sfx.play()
			velocity.y = JUMP_VELOCITY*Global.jumpScale/1.3
			doubleJump = false;
		else:
			velocity += get_gravity() * delta
	
	# Handle primary fire.
	if Input.is_action_just_pressed("primary_fire") and canShootPrim:
		# Send a firing signal to the bullet
		shoot.emit(global_position, facingDir, false);
		canShootPrim = false;
		canShootSec = false;
		
		if facingDir > 0:
			$AnimatedSprite2D.play("shoot_right")
		else:
			$AnimatedSprite2D.play("shoot_left")
			
		$Timers/PrimaryFireTimer.start();
		primFireCount = 1;

	# Handle secondary fire.
	if Input.is_action_just_pressed("secondary_fire") and canShootSec:
		# Send a firing signal to the bullet
		shoot.emit(global_position, facingDir, true);
		canShootPrim = false;
		canShootSec = false;
		
		if facingDir > 0:
			$AnimatedSprite2D.play("shoot_right")
			await get_tree().create_timer(1).timeout
		else:
			$AnimatedSprite2D.play("shoot_left")
		
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
		velocity.x = direction * SPEED * Global.speedMultiplier
		facingDir = direction;
		walking = true;
		if facingDir > 0 and canShootPrim and canShootSec:
			$AnimatedSprite2D.play("move_right")
		elif canShootPrim and canShootSec:
			$AnimatedSprite2D.play("move_left")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if facingDir > 0 and canShootPrim and canShootSec:
			$AnimatedSprite2D.play("idle_right")
		elif canShootPrim and canShootSec:
			$AnimatedSprite2D.play("idle_left")
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
	var damageToDeal = round(0.3*(Global.currentWave)*(log(Global.currentWave)) + 5);
	Global.playerHealth -= damageToDeal;
	print(Global.playerHealth);
	if Global.playerHealth <= 0:
		visible = false
		SPEED = 0
		JUMP_VELOCITY = 0
		canShootPrim = false	
		canShootSec = false
	$Label.text = str("-", damageToDeal);
	await get_tree().create_timer(1).timeout
	$Label.text = "";

func _on_world_enemy_connect(enemy: CharacterBody2D) -> void:
	enemy.dealDamage.connect(_on_flying_enemy_deal_damage);

func _on_item_collect(item: InvItem) -> void:
	print("item collect signal")
	itemPickup.emit(item.name)
	inv.insert(item)
	pickup_sfx.play()

func _on_items_attatch_item_signal(item: StaticBody2D) -> void:
	print("items atatch item signal")
	item.collect.connect(_on_item_collect)
