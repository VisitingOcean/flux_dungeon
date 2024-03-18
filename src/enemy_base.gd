extends Node2D

class_name EnemyBase

@onready var health  = $HealthComponent
@onready var sprite = $AnimatedSprite2D

@export var stats: EnemyResource :
	get:
		return stats
	set(new_stats):
		stats = new_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	var health = $HealthComponent
	health.max_health = stats.health
	health.damage_dealt.connect(_damage_effect)
	health.death_event.connect(_death_effect)

	
func _damage_effect():
	flash_red()
	

func _death_effect():
	print("--------------------deadd---------------------")
	# Ensure this is emitted only once, after the animation is complete
	var animation_complete_emitted = false
	
	emit_signal("death_animation_complete")
	var original_color = modulate
	var flash_color = Color(1, 0, 0, 1) # Flash to red
	var fade_color = Color(1, 0, 0, 0) # Fade to transparent red
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	# Flash to red quickly
	tween.tween_property(self, "modulate", flash_color, 0.1, ).set_ease(Tween.EASE_OUT)
	
	
	# Then fade out after a very brief moment
	tween.tween_property(self, "modulate", fade_color, 0.5,).set_ease(Tween.EASE_IN)
	
	# Optionally, connect to the tween's finished signal to perform actions after the animation
	tween.connect("finished", _on_fade_out_complete)
	
	await tween.finished
	if not animation_complete_emitted:
		emit_signal("death_animation_complete")
		animation_complete_emitted = true


func _on_fade_out_complete():
	pass

	
	
func flash_red():
	# Assuming the node has a material that allows for modulating color
	var original_color = self.modulate
	self.modulate = Color.RED
	
	# Wait for 0.2 seconds
	await get_tree().create_timer(0.2).timeout
	
	self.modulate = original_color



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
