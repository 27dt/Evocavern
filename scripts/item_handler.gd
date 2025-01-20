extends Node

const items: PackedScene = preload("res://scenes/item.tscn");

signal attatchItemSignal(item: StaticBody2D);

func jumpVelocity():
	Global.jumpScale += 0.15

func totalHealth():
	Global.playerHealthMax = round(Global.playerHealthMax * 1.3);
	$"../CanvasLayer/healthbar".max_value = Global.playerHealthMax

func damageScaleGun():
	Global.gunDamageScale += 0.2;

func damageScaleNade():
	Global.nadeDamageScale += 0.2;

func movementSpeed():
	Global.speedMultiplier += 0.15;

func chooseSpawn():
	var spawnPoint: Marker2D = choose([
		$ItemSpawns/Spawn1,
		$ItemSpawns/Spawn2,
		$ItemSpawns/Spawn3,
		$ItemSpawns/Spawn4,
	])
	return spawnPoint.global_position;

func chooseItem():
	var myResource = load("res://inventory/items/movementspeed.tres")
	print(myResource)
	print(myResource.name)
	print(myResource.texture)
	var dir_name = "res://inventory/items";
	var dir = DirAccess.open(dir_name);
	var file_names = dir.get_files();
	
	var rng = RandomNumberGenerator.new();
	var randomInt = rng.randi_range(0,4);
	
	print(file_names)
	var item: InvItem = load(str("res://inventory/items/", file_names[randomInt]));
	print(item)
	print(item.name)
	print(item.texture)
	return item;

func _on_expbar_spawn_item() -> void:
	print("spawn");
	var item = items.instantiate();
	var pos = chooseSpawn();
	self.add_child(item)
	item.global_position = pos;
	item.item = chooseItem();
	print("chose item");
	item.get_child(0).texture = item.item.texture
	attatchItemSignal.emit(item);
	print(item.item.name);
	print(item.item.texture);

# Chooses a random element from an array
func choose(randArray):
	# Shuffle array
	randArray.shuffle();
	# Return the first element
	return randArray.front();

func _on_player_item_pickup(name: String) -> void:
	print("playerpickup");
	totalHealth()
	#match name:
		#"jumpvelocity":
			#jumpVelocity()
		#"totalhealth":
			#totalHealth()
		#"scalegun":
			#damageScaleGun()
		#"scalenade":
			#damageScaleNade()
		#"movementspeed":
			#movementSpeed();
		#_:
			#print("issue")
