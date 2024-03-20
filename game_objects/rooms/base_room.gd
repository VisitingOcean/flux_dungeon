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
var difficulty_level := 1
var monster_strength_multiplier := 1.0
var reward_multiplier := 1.0

func _ready():

	connect("room_complete", clean_up)

func initialize(data: Dictionary) -> void:
	#room_name = data["name"]
	#room_description = data["description"]
	#room_eventType = data["eventType"]
	pass
	# Setup difficulty


func calculate_difficulty_multipliers() -> void:
	# Adjust multipliers based on the difficulty level
	monster_strength_multiplier = 1.0 + (0.1 * difficulty_level)
	reward_multiplier = 1.0 + (0.15 * difficulty_level)

func trigger_event(player) -> void:
	current_player = player
	difficulty_level = player.stats.dungeon_level
	calculate_difficulty_multipliers()
	#var handle_return = _room_event()
	#gift.chat(handle_return)
	_room_event(player)
	var screenSize = get_viewport().size
	var screen_middle = screenSize / 2
	player.global_position = screen_middle + Vector2i(100, 100)
	player.health_bar.position = player.global_position + Vector2(-100, 150)
	player.health_bar.show()
	room_complete.connect(clean_up)


func _room_event(player):
	await get_tree().create_timer(1).timeout
	# Example of setting a sprite based on room type or difficulty
	
	get_parent().anim.play("open_door")
	handle_event_based_on_type(player)


func handle_event_based_on_type(player):
	return
	match room_eventType:
		"trap":
			handle_trap(player)
		"monster":
			handle_monster(player)
		"room_rest":
			handle_rest(player)
		_:
			print("Unknown room event type: ", room_eventType)

func handle_trap(player):
	pass

func handle_monster(player):
	pass


func handle_rest(player):
	pass

func clean_up():
	print("cleaning up")
	PlayerManager.save_character(current_player)
	var dungeon_level = get_tree().get_first_node_in_group("DungeonLevelLabel")
	dungeon_level.text = "DUNGEON LEVEL %s" % current_player.stats.dungeon_level
	current_player.queue_free()
	current_player.health_bar.hide()
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
