extends StaticBody2D

@export var item: InvItem
var player = null

signal collect(item: InvItem)

func _on_interact_area_body_entered(body: Node2D) -> void:
	print("here")
	playercollect()
	await get_tree().create_timer(0.1).timeout
	self.queue_free()

func playercollect():
	collect.emit(item)
