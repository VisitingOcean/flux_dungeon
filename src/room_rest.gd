extends BaseRoom


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func trigger_event(player):
	get_parent().anim.play("open_door")
	await get_parent().anim.animation_finished
	player.health.current_health = player.health.max_health
	current_player = player
	_Utility.create_wavy_text("Health restored...")
	await get_tree().create_timer(2).timeout
	
	clean_up()
