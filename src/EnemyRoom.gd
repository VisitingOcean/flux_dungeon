extends BaseRoom

var player_obj

func _room_event(player):
	await get_tree().create_timer(1).timeout
	get_parent().anim.play("open_door")
	player_obj = player
	handle_monster(player)




func handle_monster(player):
	await get_parent().anim.animation_finished
	var monster = select_monster_based_on_difficulty()
	var enemy = MobFactory.create_mob(monster)
	calculate_difficulty_multipliers()
	print("monster str mult ", monster_strength_multiplier)
	enemy.stats.health *= monster_strength_multiplier
	enemy.stats.attack_power *= monster_strength_multiplier
	enemy.stats.defense_level *= monster_strength_multiplier
	# TODO add in strength multiplier
	add_child(enemy)

	
	var combat_system = CombatSystem.new()
	combat_system.connect("combat_won", _on_combat_won)
	combat_system.connect("combat_lost", _on_combat_lost)
	combat_system.initiate_combat(player, enemy)
	
	
func select_monster_based_on_difficulty() -> String:
	# Example logic for selecting a monster based on difficulty
	var monsters = {
		1: ["skeleton_warrior", "orc_warrior"],
		2: ["ufo"],
		3: ["ufo"]
	}
	
	var possible_monsters = monsters.get(difficulty_level, ["skeleton_warrior"])
	return possible_monsters.pick_random()

	
func _on_combat_won(player, renown_awarded: int):
	player.stats.dungeon_level += 1
	var message = "%s won and was awarded %d renown." % [player.stats.name, renown_awarded]
	_Utility.create_wavy_text(message)
	await get_tree().create_timer(3).timeout
	
	emit_signal("room_complete")

func _on_combat_lost(player, renown_lost: int):
	player.stats.dungeon_level = 1
	var message = "%s was defeated and lost %d renown." % [player.stats.name, renown_lost]
	_Utility.create_wavy_text(message)
	await get_tree().create_timer(3).timeout
	emit_signal("room_complete")

	

