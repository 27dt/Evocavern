extends TextureProgressBar

func _process(delta):
	update()

func update():
	if Global.exp >= Global.expMax:
		Global.currentLevel += 1
		Global.expMax += 80
		max_value += 80
		Global.exp = 0
	
	value = Global.exp
	
	$"expvalue".text = str(value, " / ", Global.expMax)
	$"exp".text = str("LEVEL ", Global.currentLevel)
