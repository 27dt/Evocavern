extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Hotkey to close the game with ESC
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();
