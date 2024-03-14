extends Node

class_name CombatSystem
# Signals to communicate combat outcomes
signal combat_won(player_name, coins_awarded)
signal combat_lost(player_name, coins_lost)

func initiate_combat(player, enemy_resource) -> void:
	# Assume player and enemy_resource have been initialized with their stats
	
	var first_attacker : String
	# Basic comparison of speed to determine who attacks first
	if player.speed > enemy_resource.stats.speed:
		first_attacker = "player"
	else:
		first_attacker = "enemy"
	
		# Simulate combat taking into account the pre-set strategy.
	# The combat is resolved in a single interaction, based on player's and enemy's stats.
	if first_attacker == "player":
		resolve_attack(player, enemy_resource, true)
		if enemy_resource.health > 0:
			resolve_attack(player, enemy_resource, false) # Enemy's turn if it survives.
	else:
		resolve_attack(player, enemy_resource, false)
		if player.health > 0:
			resolve_attack(player, enemy_resource, true) # Player's turn if they survive.
	
	# Check outcomes
	if enemy_resource.stats.health <= 0:
		# Player wins
		finalize_combat(player, true)
	elif player.health <= 0:
		# Player loses
		finalize_combat(player, false)

func resolve_attack(attacker, defender, is_player_attacking):
	# Calculate effective attack considering strategy and defense.
	var effective_attack = attacker.attack_power * strategy_multiplier(attacker.strategy_choice, defender.stats.strategy_weakness) - defender.stats.defense_level
	effective_attack = max(effective_attack, 0) # Ensure attack value is not negative.
	print("his for: ", effective_attack)
	# Apply damage
	if is_player_attacking:
		defender.health -= effective_attack
	else:
		attacker.health -= effective_attack

func finalize_combat(player, won_combat: bool) -> void:
	if won_combat:
		var coins_awarded = randi_range(50, 150)
		player.coins += coins_awarded
		PlayerManager.save_character(player)
		emit_signal("combat_won", player.name, coins_awarded)
	else:
		var coins_lost = randi_range(10, 50)
		player.coins = max(player.coins - coins_lost, 0)
		PlayerManager.save_character(player)
		emit_signal("combat_lost", player.name, coins_lost)

func strategy_multiplier(player_strategy, enemy_weakness) -> float:
	# Adjusts the effectiveness of an attack based on strategy choice and enemy weakness.
	return 1.5 if player_strategy == enemy_weakness else 1.0
