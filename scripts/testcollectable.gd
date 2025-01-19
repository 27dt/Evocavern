extends StaticBody2D

@export var item: InvItem
var player = null

signal collect(item: InvItem)

func _on_interactable_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print ("bro")
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollect():
	#player.collect(item)
	collect.emit(item)
