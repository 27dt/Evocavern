extends TextureProgressBar

func _process(delta):
	update()

func update():
	value = Global.playerHealth * 100 / Global.playerHealthMax
	$"healthvalue".text = str(value, " / 100")
