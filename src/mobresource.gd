extends Resource
class_name EnemyResource

# Using `export` allows you to edit these properties in the Godot Editor.
@export var name: String = "Enemy Name"
@export var health: int = 100
@export var attack_power: int = 10
@export var defense_level: int = 10
@export var speed: int = 5
# Strategy weakness: 0 for Charge, 1 for Guard, 2 for Sneak
@export var strategy_weakness: int = 0

# Optionally, add functionality or initialization logic here.
func _init(iname = "", ihealth = 0, iattack_power = 0, idefense_level = 0, ispeed = 0, istrategy_weakness = 0):
	name = iname
	health = ihealth
	attack_power = iattack_power
	defense_level = idefense_level
	speed = ispeed
	istrategy_weakness = istrategy_weakness
	
	
