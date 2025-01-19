extends CharacterBody2D

const speed = 100;
var dir: Vector2;

var player: CharacterBody2D;

var health = Global.flyingHealth;

signal dealDamage(damage: int);

var dead = false;
var takingDamage = false;

# Chasing player variable
var chasingPlayer: bool = true;

func _process(delta):
	if Global.thrownGrenade and !takingDamage:
		poisonDamage();
	move(delta);

func move(delta):
	player = Global.playerBody;
	if !dead:
		# Move randomly if not chasing player
		if chasingPlayer and !takingDamage:
			velocity = position.direction_to(player.position) * speed;
		elif chasingPlayer and takingDamage:
			var oldvelocity = velocity;
			var knockback_dir = position.direction_to(player.position) * -100;
			velocity = knockback_dir;
			await get_tree().create_timer(1).timeout
			velocity = oldvelocity;
			takingDamage = false;
		elif !chasingPlayer and takingDamage:
			var oldvelocity = velocity;
			var knockback_dir = position.direction_to(player.position) * -100;
			velocity = knockback_dir;
			await get_tree().create_timer(1).timeout
			velocity = oldvelocity;
			takingDamage = false;
			chasingPlayer = true;
		else:
			velocity += dir * speed * delta;
	else:

		await get_tree().create_timer(0.75).timeout
		queue_free();
		print("exp: ", Global.exp)
		print("enemy kills: ", Global.enemyKills)
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
	print(area.is_in_group("player"))
	print(area.get_groups())
	if area.is_in_group("Bullets"):
		takeDamage(area.damage);
	if area.is_in_group("player") and !takingDamage:
		dealDamage.emit(Global.flyingDamage);
		takeDamage(3)

func takeDamage(damage: int):
	
	# this nasty chop-shop of nested if statments prevents poision damage from incrementing the level xp like crazy, 
	# due to calling takeDamage numerous times.
	# i swear, i poisoned 1 enemy without "if !dead" and went up 9 levels.
	
	if !dead:
		health -= damage;
		takingDamage = true;
		if health <= 0:
			health = 0;
			dead = true;
		if dead:
			Global.exp += 20
			Global.enemyKills += 1
			return
	$Label.text = str("-", damage);
	await get_tree().create_timer(1).timeout
	$Label.text = "";


func poisonDamage():
	for i: Area2D in $Hitbox.get_overlapping_areas():
		if i.is_in_group("PoisonCloud"):
			takeDamage(5);
			await get_tree().create_timer(1).timeout


func _on_roam_trigger_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		chasingPlayer = true;
