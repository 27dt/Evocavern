extends Node2D

@onready var parallax_background: ParallaxBackground = $ParallaxBackground

const SCROLL_SPEED: float = 200.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(parallax_background.scroll_offset.x)
	parallax_background.scroll_offset.x -= delta * SCROLL_SPEED
	
