extends BaseRoom


func _room_event(player):
	await get_tree().create_timer(1).timeout
	get_parent().anim.play("open_door")
	var amount = randi_range(50, 500)
	player.stats.coins -= amount
	var message = "You lost %d coins to a thief!" % [amount]
	gift.chat(str(message))
	await get_tree().create_timer(1).timeout
	get_parent().queue_free()
