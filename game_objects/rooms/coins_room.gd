extends TreasureRoom


# Called when the node enters the scene tree for the first time.
func _room_event(player):
	await get_tree().create_timer(1).timeout
	get_parent().anim.play("open_door")
	var amount = randi_range(50, 500)
	player.stats.renown += amount
	var message = "You gained %d renown!" % [amount]
	_Utility.create_wavy_text(message)
	await get_tree().create_timer(3).timeout
	emit_signal("room_complete")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



