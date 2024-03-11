# player_character.gd
extends Resource
class_name Character

@export var name: String = "Player Name"
@export var level: int = 1
@export var inventory: Array = []
@export var experience: float = 0
@export var coins: float:
	get:
		return coins

	set(value):
		coins = value
		if coins < 0:
			coins = 0


func _init(i_name = "Undefined", i_level = 1, i_inventory = [], i_experience = 0, i_coins = 0):
	name = i_name
	level = i_level
	inventory = i_inventory
	experience = i_experience
	coins = i_coins
