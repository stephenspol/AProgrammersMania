extends Node2D

onready var finish := $World/Finish

# Called when the node enters the scene tree for the first time.
func _ready():
	finish.connect("level_finished", self, "complete_level")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
