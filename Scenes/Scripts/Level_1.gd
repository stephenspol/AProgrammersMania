extends Node2D

onready var finish := $World/Finish

var tempCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	finish.connect("level_finished", self, "complete_level")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func complete_level():
	if tempCounter > 0:
		SceneManager.go_to_main_menu()
	tempCounter += 1
