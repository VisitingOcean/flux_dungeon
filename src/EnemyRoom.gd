extends BaseRoom

var player_obj

func _room_event(player):
	await get_tree().create_timer(1).timeout
	get_parent().anim.play("open_door")
	player_obj = player
	handle_monster(player)

# Assuming this is in BaseRoom.gd or a specific room script
func handle_monster(player):
	await get_parent().anim.animation_finished
	var monsters = [
		"skeleton_warrior",
		"orc_warrior",
		"ufo"
	]
	var monster = monsters.pick_random()
	var enemy = MobFactory.create_mob(monster)
	
	add_child(enemy)
	
	
	#player.global_position = Vector2(450, 250)

	var combat_system = CombatSystem.new()
	combat_system.connect("combat_won", _on_combat_won)
	combat_system.connect("combat_lost", _on_combat_lost)
	
	combat_system.initiate_combat(player, enemy)

func _on_combat_won(player_name, coins_awarded: int):
	var message = "%s won and was awarded %d coins." % [player_name, coins_awarded]
	_Utility.create_wavy_text(message)
	await get_tree().create_timer(3).timeout
	emit_signal("room_complete")

func _on_combat_lost(player_name, coins_lost: int):
	var message = "%s was defeated and lost %d coins." % [player_name, coins_lost]
	_Utility.create_wavy_text(message)
	await get_tree().create_timer(3).timeout
	emit_signal("room_complete")

	

