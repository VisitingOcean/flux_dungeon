# RoomFactory.gd
extends Node

var room_data = []

func _ready():
	# Use FileAccess for file operations in Godot 4.2
	var file_access = FileAccess.open("res://data/rooms.json", FileAccess.READ)
	if file_access:
		var json_text = file_access.get_as_text()
		room_data = JSON.parse_string(json_text)
		file_access.close() # Ensure we close the file after reading
	else:
		print("Failed to load rooms.json")

# Assuming `create_room` is called with a specific room type
func create_room(type: String) -> BaseRoom:
	# Fallback: Create a default room instance if the type is not found
	var default_room_resource = load("res://game_objects/rooms/%s.tscn" % [type]) # Change to your actual path
	return default_room_resource.instantiate()
