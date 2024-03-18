# player_character.gd
extends Resource
class_name Stats

@export var name: String = "Player Name"
@export var level: int = 1
@export var inventory: Array = []
@export var experience: float = 0
@export var stance: int
@export var luck: float = 1.2 # Luck will be a float between 0 and 1
@export var health: int = 10
@export var attack_power: int = 10
@export var defense_level: int = 1
@export var speed: int = 10
@export var strategy: int = 1
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
	ihealth = health,
	iattack_power = attack_power,
	idefense_level = defense_level,
	ispeed = speed,
	istrategy_choice = strategy,
	i_name = "Undefined", 
	i_level = level, 
	i_inventory = [], 
	i_experience = experience, 
	i_coins = coins, 
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
	strategy = istrategy_choice
