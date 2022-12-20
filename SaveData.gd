extends Node

const SAVE_PATH = "user://savegame.save"

var game_data := {}

func reset_data():
	var save_game_file = File.new()
	save_game_file.open(SAVE_PATH, File.WRITE)
	print("Save File Path: %s" % save_game_file.get_path_absolute())
	
	var level_count := 1
	game_data = {}
	for packedLevelScene in SceneManager.levels:
		game_data[level_count as String] = { "is_locked": true, "is_difficult": false, "is_fully_cleared": false }
		if level_count == 1:
			game_data[level_count as String].is_locked = false
		level_count += 1
	save_game_file.store_line(to_json(game_data))
	save_game_file.close()


func init_save_data():
	var save_game_file = File.new()
	if not save_game_file.file_exists(SAVE_PATH):
		save_game_file.close()
		reset_data()


func load_levels_data():
	var save_file := File.new()
	save_file.open(SAVE_PATH, File.READ)
	game_data = parse_json(save_file.get_line())
	save_file.close()
	return game_data


func save():
	var save_game_file = File.new()
	save_game_file.open(SAVE_PATH, File.WRITE)
	print("Saving Game Data: %s" % game_data)
	save_game_file.store_line(to_json(game_data))
	save_game_file.close()


func complete_current_level() -> void:
	var next_level_s = (SceneManager.current_level + 1) as String
	if game_data.has(next_level_s):
		print("Updating %s (%s)" % [next_level_s, game_data[next_level_s]])
		game_data[next_level_s].is_locked = false
		save()
