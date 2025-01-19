extends Node

const items: PackedScene = preload("res://Scenes/testcollectable.tscn");

func jumpVelocity():
	print("jump upgrade")
	var item = items.instantiate();
	var pos = chooseSpawn();
	self.add_child(item)
	item.global_position = pos;
	Global.jumpScale += 1.15
func totalHealth():
	print("health upgrade")
	var item = items.instantiate();
	var pos = chooseSpawn();
	self.add_child(item)
	item.global_position = pos;
	Global.playerHealthMax = round(Global.playerHealthMax * 1.3);
func damageScaleGun():
	print("gun upgrade")
	var item = items.instantiate();
	var pos = chooseSpawn();
	self.add_child(item)
	item.global_position = pos;
	Global.gunDamageScale += 1.2;
func damageScaleNade():
	print("nade upgrade")
	var item = items.instantiate();
	var pos = chooseSpawn();
	self.add_child(item)
	item.global_position = pos;
	Global.nadeDamageScale += 1.2;
func movementSpeed():
	print("move upgrade")
	var item = items.instantiate();
	var pos = chooseSpawn();
	self.add_child(item)
	item.global_position = pos;
	Global.speedMultiplier += 1.15;

func chooseSpawn():
	var spawnPoint: Marker2D = choose([
		$ItemSpawns/Spawn1,
		$ItemSpawns/Spawn2,
		$ItemSpawns/Spawn3,
		$ItemSpawns/Spawn4,
	])
	return spawnPoint.global_position;

func _on_expbar_spawn_item() -> void:
	var item = items.instantiate();
	var pos = chooseSpawn();
	self.add_child(item)
	item.global_position = pos;
	

# Chooses a random element from an array
func choose(randArray):
	# Shuffle array
	randArray.shuffle();
	# Return the first element
	return randArray.front();

func _on_player_item_pickup() -> void:
	var rng = RandomNumberGenerator.new();
	var itemspawn = rng.randi_range(1,6);
	
	match itemspawn:
		1:
			jumpVelocity()
		2:
			totalHealth()
		3:
			damageScaleGun()
		4:
			damageScaleNade()
		5:
			movementSpeed();
		_:
			print("issue")
