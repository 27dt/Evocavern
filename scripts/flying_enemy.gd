extends CharacterBody2D

const speed = 100;
var dir: Vector2;

var player: CharacterBody2D;

var health = Global.flyingHealth;

var dead = false;
var takingDamage = false;

# Chasing player variable
var chasingPlayer: bool = true;

func _process(delta):
	move(delta);

func move(delta):
	player = Global.playerBody;
	if !dead:
		# Move randomly if not chasing player
		if chasingPlayer and !takingDamage:
			velocity = position.direction_to(player.position) * speed;
		elif chasingPlayer and takingDamage:
			var knockback_dir = position.direction_to(player.position) * -50;
			velocity = knockback_dir;
			await get_tree().create_timer(0.75).timeout
			takingDamage = false;
		elif !chasingPlayer and takingDamage:
			var knockback_dir = position.direction_to(player.position) * -50;
			velocity = knockback_dir;
			await get_tree().create_timer(0.75).timeout
			takingDamage = false;
			chasingPlayer = true;
		else:
			velocity += dir * speed * delta;
	else:
		await get_tree().create_timer(0.75).timeout
		queue_free();
	move_and_slide();

# Function connected to the Timer object's signal
func _on_timer_timeout() -> void:
	# Sets a random timeout for the timer (random flying movement)
	$RoamingTimer.wait_time = choose([0.25, 0.5, 0.75, 1.0]);

	# Choose a random direction if not chasing player
	if !chasingPlayer:
		dir = choose([Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]);

# Chooses a random element from an array
func choose(randArray):
	# Shuffle array
	randArray.shuffle();
	# Return the first element
	return randArray.front();

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		takeDamage(area.damage);

func takeDamage(damage: int):
	health -= damage;
	takingDamage = true;
	if health <= 0:
		health = 0;
		dead = true;
