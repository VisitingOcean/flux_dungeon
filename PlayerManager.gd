# PlayerManager.gd
extends Node

var players = {} # Dictionary to store player states by player id

func register_player(player_id: String, initial_state: Dictionary):
	players[player_id] = initial_state

func get_player_state(player_id: String) -> Character:
	var character = load_character(player_id)
	if character:
		return character
	else:
		print("---------creating new character")
		character = Character.new()
		character.name = player_id
		save_character(character)
		return character

func update_player_state(player_id: String, new_state: Dictionary) -> void:
	players[player_id] = new_state

func remove_player(player_id: String) -> void:
	players.erase(player_id)


var save_file_path = "user://save/"

func load_character(character_name : String):
	var character_resource = ResourceLoader.load(save_file_path + character_name + ".tres")
	if character_resource:
		# Resource exists, make a duplicate to ensure modifications don't affect the original
		var character = character_resource.duplicate(true)
		return character

func save_character(character : Character):
	ResourceSaver.save(character, save_file_path + character.name + ".tres")
	return true
