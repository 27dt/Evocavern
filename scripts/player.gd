extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

signal shoot(pos: Vector2);

var canShootPrim := true;

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
		velocity.y = JUMP_VELOCITY

	# Handle primary fire.
	if Input.is_action_just_pressed("primary_fire") and canShootPrim:
		# Send a firing signal to the bullet
		shoot.emit(global_position, facingDir);
		canShootPrim = false;
		$Timers/PrimaryFireTimer.start();
		primFireCount = 1;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		facingDir = direction;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_primary_fire_timer_timeout() -> void:
	if primFireCount < 3:
		$Timers/PrimaryFireTimer.start()
		shoot.emit(global_position, facingDir);
		primFireCount += 1;
	else:
		primFireCount = 0;
		canShootPrim = true;
		$Timers/PrimaryFireTimer.stop();
