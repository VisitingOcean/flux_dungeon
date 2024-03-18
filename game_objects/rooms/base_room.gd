# BaseRoom.gd
extends Node2D
class_name BaseRoom
signal room_complete

var room_name := ""
var room_description := ""
var room_eventType := ""
@onready var gift = get_tree().get_first_node_in_group("gift")
#@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim = $AnimationPlayer
var current_player


func _ready():

	connect("room_complete", clean_up)

func initialize(data: Dictionary) -> void:
	room_name = data["name"]
	room_description = data["description"]
	room_eventType = data["eventType"]


func trigger_event(player) -> void:
	current_player = player
	#var handle_return = _room_event()
	#gift.chat(handle_return)
	_room_event(player)
	var screenSize = get_viewport().size
	var screen_middle = screenSize / 2
	player.global_position = screen_middle + Vector2i(100, 100)
	room_complete.connect(clean_up)

func _room_event(player):
	pass

func handle_chest():
	return "chest"
	# Logic for handling chest event

func handle_monster(player_id: String):
	pass


func clean_up():
	print("cleaning up")
	PlayerManager.save_character(current_player.stats)
	current_player.queue_free()
	get_parent().queue_free()
	var rich_text_label = get_tree().get_first_node_in_group("wavealert")
	rich_text_label.hide()
	



var fade_out_duration = .5

func alert_fade_out():
	# Ensure the node is visible
	self.show()
	var tween = get_tree().create_tween()
	
	var label = get_tree().get_first_node_in_group("wavealert")
	
	tween.tween_property(label, "modulate", modulate.a, 0)
	
	
	await tween.finished
	print("iaenrst")
	queue_free()

func _on_fade_out_completed(object, key):
	# Optionally, do something after the fade out is completed, like hiding the node
	object.hide()
	# Remove the Tween node after the animation is complete to clean up
	object.queue_free()
