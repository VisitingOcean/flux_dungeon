extends Node

class_name CombatSystem
# Signals to communicate combat outcomes
signal combat_won(player_name, coins_awarded)
signal combat_lost(player_name, coins_lost)

func initiate_combat(player, enemy_resource) -> void:

	var first_attacker : String
	# Basic comparison of speed to determine who attacks first

	if player.stats.speed > enemy_resource.stats.speed:
		first_attacker = "player"
	else:
		first_attacker = "enemy"
	
	var turn = first_attacker
	# Loop until one is defeated
	
	print_debug("player ", player.health)
	print_debug("enemy  ", enemy_resource.health)
	while !player.health.has_died and !enemy_resource.health.has_died:
		if turn == "player":
			resolve_attack(player, enemy_resource, true)  # Player attacks
			if enemy_resource.health.current_health > 0:
				turn = "enemy"  # Next turn is enemy's if they survive
		else:
			resolve_attack(enemy_resource, player, false)  # Enemy attacks
			if player.health.current_health > 0:
				turn = "player"  # Next turn is player's if they survive
		await player.get_tree().create_timer(1).timeout

	# Check outcomes
	if enemy_resource.health.has_died:
		# Player wins
		finalize_combat(player, true)
	elif player.health.has_died:
		# Player loses
		finalize_combat(player, false)

func is_critical_hit(attacker, defender) -> bool:
	# Check if the attack is a critical hit based on the attacker's luck and the defender's strategy. is 1.5 if the attacker's strategy is the defender's weakness, otherwise it is 1.0. The critical hit chance is the attacker's luck multiplied by the strategy multiplier. If the random number is less than the critical hit chance, the attack is a critical hit. Otherwise, it is not a critical hit
	var critical_hit_chance = attacker.stats.luck * strategy_multiplier(attacker.stats.strategy, defender.stats.strategy)
	var rand = randf_range(1.0, 2.0)

	return  rand > (critical_hit_chance)

func resolve_attack(attacker, defender, is_player_attacking):
	var _is_crit = false
	# Calculate effective attack considering strategy and defense.
	var effective_attack = attacker.stats.attack_power * strategy_multiplier(attacker.stats.strategy, defender.stats.strategy) - defender.stats.defense_level
	effective_attack = max(effective_attack, 0) # Ensure attack value is not negative.
	# Apply damage
	#if is_player_attacking:
	if is_critical_hit(attacker, defender):
		_is_crit = true
		effective_attack *= 1.5 * attacker.stats.luck
	#effective_attack = 10
	print("is-player attacker: %s ---  defender: %s   " % [attacker.name, defender.name])
	defender.health.damage(effective_attack, _is_crit)
	#else:
	#	print("enemy his for: ", effective_attack)
	#	if is_critical_hit(attacker, defender):
	#		_is_crit = true
	#		effective_attack *= 1.5 * attacker.stats.luck
	#	#effective_attack = 15
	#	print("attacker: %s ---  defender: %s   " % [attacker.name, defender.name])
	#	attacker.health.damage(effective_attack, _is_crit)

func finalize_combat(player, won_combat: bool) -> void:
	if won_combat:
		var coins_awarded = randi_range(50, 150)
		player.stats.coins += coins_awarded
		PlayerManager.save_character(player.stats)
		emit_signal("combat_won", player.stats.name, coins_awarded)
	else:
		var coins_lost = randi_range(10, 50)
		player.stats.coins = max(player.stats.coins - coins_lost, 0)
		PlayerManager.save_character(player.stats)
		emit_signal("combat_lost", player.stats.name, coins_lost)

func strategy_multiplier(player_strategy, enemy_weakness) -> float:
	# Adjusts the effectiveness of an attack based on strategy choice and enemy weakness.
	return 1.5 if player_strategy == enemy_weakness else 1.0
