extends TextureProgressBar

func _process(delta):
	update()

func update():
	value = Global.playerHealth * Global.playerHealthMax / Global.playerHealthMax
	$"healthvalue".text = str(value, " / ", Global.playerHealthMax)
