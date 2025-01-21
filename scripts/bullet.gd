extends Area2D

var direction: int = 1;
@export var speed := 300;
@export var damage: int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * direction * delta;

func _on_body_entered(body: Node2D) -> void:
	if body.name == "TileMapLayer":
		self.queue_free();
