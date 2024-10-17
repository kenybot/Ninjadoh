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
	var save_game = FileAccess.open_encrypted_with_pass("user://savegame.save",FileAccess.WRITE,"Kenbot")
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)
	print(json_string)

func reset_game():
	if FileAccess.file_exists("user://savegame.save"):
		
		
		# Open the file in a way that deletes it
		var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		file.close()  # Close the file immediately to remove it

		# Alternatively, you can just reset the file like this
		# Note: `FileAccess.open()` does not actually delete the file; 
		# it just opens it in write mode.
		# The way to ensure it is removed is to just avoid writing to it.

	# Reset player health and position
		character.update_hp(100)  # Set to initial health value
		character.update_pos(Vector2(96, 496))  # Reset to initial position
	
func load_game():
	#check if the file exists
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_game = FileAccess.open_encrypted_with_pass("user://savegame.save",FileAccess.READ,"Kenbot")
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		for i in node_data["global_position"].keys():
			var pos = Vector2(node_data["global_position"][i][0],node_data["global_position"][i][1])
			character.update_pos(pos)
			
		
		for i in node_data["health"].keys():
			var hp = node_data["health"][i]
			print("myhp",hp)
			character.update_hp(hp)
			
	save_game.close() #close the file


