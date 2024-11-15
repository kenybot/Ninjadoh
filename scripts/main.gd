extends Node2D
var health
var pos_dict = {}
var hp_dict = {}
@onready var character = $Character

func _ready():
	pass

func save():
	var save_dict = {
		"health": hp_dict,
		"global_position": pos_dict
	}
	return save_dict

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_game.store_line(json_string)
	print("Saved data:", json_string)  # Debug
	save_game.close()

func reset_game():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		file.close()  # Closes immediately to reset file contents

	# Reset player health and position
	character.update_hp(100)  # Set to initial health value
	character.update_pos(Vector2(96, 496))  # Reset to initial position

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		
		if json.parse(json_string) == OK:
			var node_data = json.get_data()
			print("Loaded data:", node_data)  # Debug
		
			for i in node_data["global_position"].keys():
				var pos = Vector2(node_data["global_position"][i][0], node_data["global_position"][i][1])
				character.update_pos(pos)
			
			for i in node_data["health"].keys():
				var hp = node_data["health"][i]
				print("Loaded health:", hp)  # Debug
				character.update_hp(hp)
	save_game.close()
