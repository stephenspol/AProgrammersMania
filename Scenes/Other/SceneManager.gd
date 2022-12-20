extends CanvasLayer

export (PackedScene) var main_menu_scene
const main_menu = 'res://Scenes/GUI/MainMenu.tscn'

export (Array, PackedScene) var levels

var current_level : int

func reload_current_scene() -> void:
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()
	$AnimationPlayer.play_backwards("dissolve")


func load_level(level:int) -> void:
	current_level = level
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(levels[level-1])
	$AnimationPlayer.play_backwards("dissolve")


func go_to_main_menu() -> void:
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	if main_menu_scene != null:
		get_tree().change_scene_to(main_menu_scene)
	else:
		get_tree().change_scene(main_menu)
	$AnimationPlayer.play_backwards("dissolve")
