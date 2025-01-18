extends RigidBody2D

var speed = 100;
var direction: int = 1;

var thrown = false;

#func _process(delta: float) -> void:
	#move(delta)
#
#func move(delta):
	#if thrown:
		#velocity = speed * delta * direction;
	#
	#move_and_collide()
