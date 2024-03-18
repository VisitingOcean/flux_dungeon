extends Resource
class_name EnemyResource

# Using `export` allows you to edit these properties in the Godot Editor.
@export var name: String = "Enemy Name"
@export var health: int = 10
@export var attack_power: int = 10
@export var defense_level: int = 10
@export var luck: int = 1.05
@export var speed: int = 5

enum Strategy {Charge, Guard, Sneak}
#    Sneak outmaneuvers Defend,
#   Defend withstands Charge,
#    Charge overwhelms Sneak.
# Now, you can use the Strategy enum to set the strategy with more readable names

@export var strategy: int = Strategy.Charge


# Optionally, add functionality or initialization logic here.
func _init(iname = "", ihealth = 0, iattack_power = 0, idefense_level = 0, ispeed = 0, istrategy = 0, i_luck=1.05):
	name = iname
	health = ihealth
	attack_power = iattack_power
	defense_level = idefense_level
	speed = ispeed
	strategy = istrategy
	luck = i_luck
	
	
