extends Node2D

const bulletScene: PackedScene = preload("res://Scenes/bullet.tscn")
const grenadeScene: PackedScene = preload("res://Scenes/grenade.tscn")
const enemy_scene: PackedScene = preload("res://Scenes/flying_enemy.tscn")

# Called when the node enters the scene tree for the first time.

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended: bool

var wave_starting = true;

signal enemyConnect(enemy: CharacterBody2D);

func _ready() -> void:
	set_process(true);
	starting_nodes = $Enemies.get_child_count();
	current_nodes = $Enemies.get_child_count();
	trigger_wave();

func trigger_wave():
	var wave_count: int = round(0.7*(Global.currentWave)*(log(Global.currentWave)) + 1);
	$"CanvasLayer/Enemies Remaining".text = str("Remaining Enemies: ", wave_count)
	print(str("wavecount:",wave_count))
	print(Global.currentWave)
	for i in range(wave_count):
		print("in loop")
		await get_tree().create_timer(1).timeout
		spawn_enemy();
	wave_starting = false;

func spawn_enemy():
	var enemy = enemy_scene.instantiate();
	$Enemies.add_child(enemy);
	enemyConnect.emit(enemy);
	print("adding enemy")
	var spawnPoint: Marker2D = choose([
		$SpawnPoints/Spawn1,
		$SpawnPoints/Spawn2,
		$SpawnPoints/Spawn3,
		$SpawnPoints/Spawn4,
		$SpawnPoints/Spawn5,
		$SpawnPoints/Spawn6,
		$SpawnPoints/Spawn7,
	])
	enemy.global_position = spawnPoint.global_position;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_nodes = $Enemies.get_child_count();
	
	# Disable wave button if enemies > 0
	if current_nodes != 0:
		$"CanvasLayer/WaveButton".visible = false
		$"CanvasLayer/WaveButton".disabled = true
	else:
		$"CanvasLayer/WaveButton".visible = true
		$"CanvasLayer/WaveButton".disabled = false
	
	# Change enemy/enemies spelling if enemies == 1
	if current_nodes == 1:
		$"CanvasLayer/Enemies Remaining".text = str("WAVE ", Global.currentWave, "  -  ", current_nodes, " ENEMY REMAINING")
	else:
		$"CanvasLayer/Enemies Remaining".text = str("WAVE ", Global.currentWave, "  -  ", current_nodes, " ENEMIES REMAINING")

	# Hotkey to close the game with ESC
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();


func _on_player_shoot(pos: Vector2, dir: float, secondary: bool) -> void:
	if !secondary:
		var bullet = bulletScene.instantiate();
		$Bullets.add_child(bullet);
		bullet.position = pos;
		bullet.position.y = bullet.position.y - 50;
		bullet.direction = dir;
		bullet.damage = Global.primaryDamage;

	else:
		var bullet = bulletScene.instantiate();
		$Bullets.add_child(bullet);
		bullet.position = pos;
		bullet.position.y = bullet.position.y - 50;
		bullet.direction = dir;
		bullet.damage = Global.secondaryDamage;
		bullet.scale = Vector2(1.5, 1.5);

func _on_player_grenade(pos: Vector2, dir: float) -> void:
	print("launch grenade")
	var grenade = grenadeScene.instantiate();
	$grenades.add_child(grenade);
	grenade.position = pos;
	grenade.position.y = grenade.position.y - 50;
	grenade.position.x = grenade.position.x + (50 * dir);
	grenade.direction = dir;
	grenade.linear_velocity.x = 500 * dir;

# Chooses a random element from an array
func choose(randArray):
	# Shuffle array
	randArray.shuffle();
	# Return the first element
	return randArray.front();


func _on_button_pressed() -> void:
	if !wave_starting and starting_nodes == current_nodes:
		await get_tree().create_timer(1).timeout
		Global.currentWave += 1;
		wave_starting = true;
		starting_nodes = $Enemies.get_child_count();
		current_nodes = $Enemies.get_child_count();
		trigger_wave();
