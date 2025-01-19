extends RigidBody2D

var speed = 100;
var direction: int = 1;

func _ready() -> void:
	await get_tree().create_timer(1).timeout;
	$GrenadeSprite.visible = false;
	$Explode.emitting = true;
	await get_tree().create_timer(0.5).timeout;
	$Explode.emitting = false;
	Global.thrownGrenade = true;
	$Poison.emitting = true;
	$Area2D.monitorable = true;
	await get_tree().create_timer(5).timeout;
	Global.thrownGrenade = false;
	Global.grenadeCooldown = false;
	self.queue_free();
