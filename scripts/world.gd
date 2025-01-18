extends Node2D

const bulletScene: PackedScene = preload("res://Scenes/bullet.tscn")
const grenadeScene: PackedScene = preload("res://Scenes/grenade.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Hotkey to close the game with ESC
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();


func _on_player_shoot(pos: Vector2, dir: float, secondary: bool) -> void:
	if !secondary:
		var bullet = bulletScene.instantiate();
		$Bullets.add_child(bullet);
		bullet.position = pos;
		bullet.direction = dir;
		bullet.damage = Global.primaryDamage;

	else:
		var bullet = bulletScene.instantiate();
		$Bullets.add_child(bullet);
		bullet.position = pos;
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
	grenade.linear_velocity.x = 1000 * dir;
