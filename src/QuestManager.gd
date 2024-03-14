# QuestManager.gd
class_name QuestManager

# Assuming QuestManager is a singleton for simplicity
func add_quest_to_player(player_id: String, quest_resource_path: String):
	var player = PlayerManager.get_player_state(player_id)
	player.active_quests[quest_resource_path] = 0 # Initialize with 0 steps completed
	PlayerManager.save_character(player)

func progress_quest(player_id: String, quest_resource_path: String):
	var player = PlayerManager.get_player_state(player_id).duplicate()
	if quest_resource_path in player.active_quests:
		print("-----questfound")
		player.active_quests[quest_resource_path] += 1 # Increment the current step
		
		print("---------", player.active_quests[quest_resource_path])
		var quest = load(quest_resource_path)
		if player.active_quests[quest_resource_path] >= quest.steps_required:
			# Quest completed
			print("Quest completed: %s" % quest.quest_name)
			give_reward(player_id, quest.reward_coins)
			player.active_quests.erase(quest_resource_path) # Remove the completed quest
		PlayerManager.save_character(player)


func give_reward(player_id: String, coins: int):
	var player = PlayerManager.get_player_state(player_id)
	player.coins += coins
	PlayerManager.save_character(player)
