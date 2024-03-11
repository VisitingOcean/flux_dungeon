extends Node2D

class_name HealthComponent

signal health_change_event
signal death_event
signal damage_dealt
signal status_damage_dealt



@export var max_health: float:

	get:
		return max_health
	set(value):

		max_health = value
		if current_health > max_health:
			current_health = max_health

@export var current_health: float:
	get:
		return current_health
	set(value):

		var _previous_health = current_health
		current_health = clampf(value, 0, max_health)
		var healthUpdate = HealthUpdate.new(
			_previous_health,
			current_health,
			max_health,
			current_health_percent,
			current_health >= _previous_health
			
		)
		emit_signal("health_change_event", healthUpdate)


		if !has_health_remaining and !has_died:
			has_died = true
			emit_signal("death_event")

var has_died: bool

var is_damaged: bool:
	get:
		return current_health < max_health

var has_health_remaining: bool:
	get:
		return !is_equal_approx(current_health, 0.0)

var current_health_percent: float:
	get:
		return current_health / max_health * 100

#class HealthUpdate:
#	func _init(_previous_health, _current_health, max_health, health_precent, is_heal):
#		pass

func damage(amount):
	print("damage ", amount)
	var string = "max: %f - current %f - damage amount %f" % [max_health, current_health, amount]
	current_health -= amount


func heal(amount):
	current_health += amount


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_health()
	
func initialize_health():
	current_health = max_health

func do_damage(amount):
	if has_health_remaining:
		emit_signal("damage_dealt")
		damage(amount)
		DamageNumbers.display_number(amount, global_position + Vector2(randf_range(-.05, .05), -20))

func _on_hurt_box_hurt(amount, _angle, _knockback):
	emit_signal("damage_dealt")
	do_damage(amount)

	


func _on_status_effect_hurt(damage):
	#print("doing damage", damage)
	do_damage(damage)


func _on_hurt_box_status_hurt(damage):
	do_damage(damage)
	print("effect collision damage")
	
