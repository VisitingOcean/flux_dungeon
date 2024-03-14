extends Node2D

class_name EnemyBase

@export var stats: EnemyResource :
	get:
		return stats
	set(new_stats):
		stats = new_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
