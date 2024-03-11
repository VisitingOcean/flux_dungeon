extends BaseRoom


func _room_event():
	var amount = randi_range(50, 100)
	player.stats.coins -= amount
	var message = "A thief has stolen %d coins!" % [amount]
	
	gift.chat(message)
