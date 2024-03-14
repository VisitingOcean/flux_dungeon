# player_character.gd
extends Resource
class_name Character

@export var name: String = "Player Name"
@export var level: int = 1
@export var inventory: Array = []
@export var experience: float = 0
@export var stance: int

@export var health: int = 100
@export var attack_power: int = 10
@export var defense_level: int = 10
@export var speed: int = 10
@export var strategy_choice: int = 1
@export var coins: float:
	get:
		return coins

	set(value):
		coins = value
		if coins < 0:
			coins = 0

# New property for quest data
# Quest data will be stored as a Dictionary where the key is the quest resource path, and the value is the current step
@export var active_quests: Dictionary



func _init(
	ihealth = 0,
	iattack_power = 0,
	idefense_level = 0,
	ispeed = 0,
	istrategy_choice = 0,
	i_name = "Undefined", 
	i_level = 1, 
	i_inventory = [], 
	i_experience = 0, 
	i_coins = 0, 
	i_active_quests = {}):
	
	name = i_name
	level = i_level
	inventory = i_inventory
	experience = i_experience
	coins = i_coins
	active_quests = i_active_quests

	health = ihealth
	attack_power = iattack_power
	defense_level = idefense_level
	speed = ispeed
	strategy_choice = istrategy_choice
