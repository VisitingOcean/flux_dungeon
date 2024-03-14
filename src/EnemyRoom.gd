extends BaseRoom

var player_obj : Character

func _room_event(player):
	player_obj = player
	handle_monster(player)

# Assuming this is in BaseRoom.gd or a specific room script
func handle_monster(player):
	var enemy = preload("res://scenes/skeleton_warrior.tscn").instantiate()
	get_parent().add_child(enemy)
	var combat_system = CombatSystem.new()
	combat_system.connect("combat_won", _on_combat_won)
	combat_system.connect("combat_lost", _on_combat_lost)
	
	combat_system.initiate_combat(player, enemy)

func _on_combat_won(player_name, coins_awarded: int):
	print("Player %s won the combat and was awarded %d coins." % [player_name, coins_awarded])

func _on_combat_lost(player_name, coins_lost: int):
	print("Player %s lost the combat and lost %d coins." % [player_name, coins_lost])
