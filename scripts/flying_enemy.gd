extends CharacterBody2D

const speed = 100;
var dir: Vector2;

var player: CharacterBody2D;

var health = Global.flyingHealth;

signal dealDamage(damage: int);

var dead = false;
var takingDamage = false;

@onready var enemy_hit_sfx = $"Enemy Hit SFX"
@onready var enemy_death_sfx = $"Enemy Death SFX"

@onready var navAgent = $NavigationAgent2D

# Chasing player variable
var chasingPlayer: bool = true;

func _ready() -> void:
	$AnimatedSprite2D.play("default");

func _process(delta):
	if Global.thrownGrenade and !takingDamage and !dead:
		poisonDamage();
		
	move(delta);

func move(delta):
	dir = to_local(navAgent.get_next_path_position()).normalized();
	if !dead:
		# Move randomly if not chasing player
		if chasingPlayer and !takingDamage:
			velocity = dir * speed;
		elif chasingPlayer and takingDamage:
			var oldvelocity = velocity;
			var knockback_dir = dir * -100;
			velocity = knockback_dir;
			await get_tree().create_timer(1).timeout
			velocity = oldvelocity;
			takingDamage = false;
		elif !chasingPlayer and takingDamage:
			var oldvelocity = velocity;
			var knockback_dir = dir * -100;
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

	move_and_slide();

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
		takeDamage(round(area.damage * Global.gunDamageScale));
	if area.is_in_group("player") and !takingDamage:
		dealDamage.emit(Global.flyingDamage);
		takeDamage(3)

func takeDamage(damage: int):
	enemy_hit_sfx.play()

	health -= damage;
	takingDamage = true;
	if health <= 0:
		health = 0;
		dead = true;
		enemy_death_sfx.play()
	if dead:
		Global.exp += 20
		Global.enemyKills += 1
		queue_free();
	$Label.text = str("-", damage);
	await get_tree().create_timer(1).timeout
	$Label.text = "";

func poisonDamage():
	for i: Area2D in $Hitbox.get_overlapping_areas():
		if i.is_in_group("PoisonCloud"):
			takeDamage(round(5 * Global.nadeDamageScale));
			await get_tree().create_timer(1).timeout

func _on_path_timeout_timeout() -> void:
	player = Global.playerBody;
	navAgent.target_position = player.global_position;
