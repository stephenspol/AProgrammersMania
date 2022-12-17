extends Node2D

export (bool) var is_active := false setget set_active  # setget set_func, get_func

func set_active(new_value):
	is_active = new_value
	if is_active:
		$AnimatedSprite.play("activating")
		$FlagActivatingSound.play()
	else:
		$AnimatedSprite.play("activating", true) # play backwards


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.has_method("update_checkpoint"):
		body.update_checkpoint(self)


func _on_AnimatedSprite_animation_finished():
	if is_active:
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("not set")
