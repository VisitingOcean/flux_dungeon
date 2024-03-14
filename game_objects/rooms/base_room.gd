# BaseRoom.gd
extends Node2D
class_name BaseRoom

var room_name := ""
var room_description := ""
var room_eventType := ""
@onready var gift = get_tree().get_first_node_in_group("gift")
#@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim = $AnimationPlayer

func initialize(data: Dictionary) -> void:
	room_name = data["name"]
	room_description = data["description"]
	room_eventType = data["eventType"]
	print(room_eventType)

func trigger_event(player) -> void:
	#var handle_return = _room_event()
	#gift.chat(handle_return)
	_room_event(player)
	PlayerManager.save_character(player)

func _room_event(player):
	pass

func handle_chest():
	return "chest"
	# Logic for handling chest event

func handle_monster(player_id: String):
	pass
