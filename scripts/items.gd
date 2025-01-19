extends Node
#
#const items: PackedScene = preload("res://Scenes/testcollectable.tscn");
#
#func doubleJump():
	#items.instantiate();
	#self.add_child()
##func jumpVelocity():
##func totalHealth():
##func damageScaleGun():
##func damageScaleNade():
##func movementSpeed():
#
#func _on_expbar_spawn_item() -> void:
	#var rng = RandomNumberGenerator.new();
	#var itemspawn = rng.randi_range(0,5);
	#
	#match itemspawn:
		#0:
			#doubleJump()
		#1:
			#jumpVelocity()
		#2:
			#totalHealth()
		#3:
			#damageScaleGun()
		#4:
			#damageScaleNade()
		#5:
			#movementSpeed();
		#_:
			#print("issue")
#
## Chooses a random element from an array
#func choose(randArray):
	## Shuffle array
	#randArray.shuffle();
	## Return the first element
	#return randArray.front();
