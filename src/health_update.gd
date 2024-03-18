class_name HealthUpdate
extends RefCounted  # or another appropriate base class

var current_health : int
var max_health : int
var _previous_health : int
var current_health_percent
var is_damage : bool

func _init(previous_health, current, max, current_percent, is_health_increased):
	_previous_health = previous_health
	current_health = current
	max_health = max
	current_health_percent = current_percent
	if previous_health > current_health:
		is_damage = true
	else:
		is_damage = false
