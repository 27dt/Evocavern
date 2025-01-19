extends TextureProgressBar

@onready var level_up_sfx = $"Level Up SFX"

signal spawnItem();

func _process(delta):
	update()

func update():
	if Global.exp >= Global.expMax:
		Global.currentLevel += 1
		Global.expMax += 80
		max_value += 80
		Global.exp = 0
		level_up_sfx.play()
		spawnItem.emit();
	value = Global.exp
	
	$"expvalue".text = str(value, " / ", Global.expMax)
	$"exp".text = str("LEVEL ", Global.currentLevel)
