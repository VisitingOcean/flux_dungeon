extends Gift

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	var save_file_path = "user://save/"
	verify_save_dir(save_file_path)
	cmd_no_permission.connect(no_permission)
	chat_message.connect(on_chat)
	event.connect(on_event)

	# I use a file in the working directory to store auth data
	# so that I don't accidentally push it to the repository.
	# Replace this or create a auth file with 3 lines in your
	# project directory:
	# <client_id>
	# <client_secret>
	# <initial channel>
	var authfile := FileAccess.open("./example/auth.txt", FileAccess.READ)
	client_id = authfile.get_line()
	client_secret = authfile.get_line()
	var initial_channel = authfile.get_line()

	# When calling this method, a browser will open.
	# Log in to the account that should be used.
	await(authenticate(client_id, client_secret))
	var success = await(connect_to_irc())
	if (success):
		request_caps()
		join_channel(initial_channel)
		await(channel_data_received)
	await(connect_to_eventsub()) # Only required if you want to receive EventSub events.
	# Refer to https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types/ for details on
	# what events exist, which API versions are available and which conditions are required.
	# Make sure your token has all required scopes for the event.
	subscribe_event("channel.follow", 2, {"broadcaster_user_id": user_id, "moderator_user_id": user_id})

	# Adds a command with a specified permission flag.
	# All implementations must take at least one arg for the command info.
	# Implementations that recieve args requrires two args,
	# the second arg will contain all params in a PackedStringArray
	# This command can only be executed by VIPS/MODS/SUBS/STREAMER
	add_command("test", command_test, 0, 0, PermissionFlag.NON_REGULAR)

	# These two commands can be executed by everyone
	add_command("helloworld", hello_world)
	add_command("greetme", greet_me)
	add_command("explore", explore)

	add_command("quest_status", quest_status)


	add_command('renown', renown)
	add_command('save', save)
	add_command('load', load)
	add_command("rest", rest)
	# This command can only be executed by the streamer
	add_command("streamer_only", streamer_only, 0, 0, PermissionFlag.STREAMER)

	# Command that requires exactly 1 arg.
	add_command("greet", greet, 1, 1)

	# Command that prints every arg seperated by a comma (infinite args allowed), at least 2 required
	add_command("list", list, -1, 2)

	# Adds a command alias
	add_alias("test","test1")
	add_alias("test","test2")
	add_alias("test","test3")
	# Or do it in a single line
	# add_aliases("test", ["test1", "test2", "test3"])

	# Remove a single command
	remove_command("test2")

	# Now only knows commands "test", "test1" and "test3"
	remove_command("test")
	# Now only knows commands "test1" and "test3"

	# Remove all commands that call the same function as the specified command
	purge_command("test1")
	# Now no "test" command is known

	# Send a chat message to the only connected channel (<channel_name>)
	# Fails, if connected to more than one channel.
#	chat("TEST")

	# Send a chat message to channel <channel_name>
#	chat("TEST", initial_channel)

	# Send a whisper to target user (requires user:manage:whispers scope)
#	whisper("TEST", initial_channel)

func on_event(type : String, data : Dictionary) -> void:
	match(type):
		"channel.follow":
			("%s followed your channel!" % data["user_name"])

func on_chat(data : SenderData, msg : String) -> void:
	%ChatContainer.put_chat(data, msg)

	
# Check the CommandInfo class for the available info of the cmd_info.
func command_test(cmd_info : CommandInfo) -> void:
	print("A")

func hello_world(cmd_info : CommandInfo) -> void:
	chat("HELLO WORLD!")

func streamer_only(cmd_info : CommandInfo) -> void:
	chat("Streamer command executed")

func no_permission(cmd_info : CommandInfo) -> void:
	chat("NO PERMISSION!")

func greet(cmd_info : CommandInfo, arg_ary : PackedStringArray) -> void:
	chat("Greetings, " + arg_ary[0])

func greet_me(cmd_info : CommandInfo) -> void:
	chat("Greetings, " + cmd_info.sender_data.tags["display-name"] + "!")

func list(cmd_info : CommandInfo, arg_ary : PackedStringArray) -> void:
	var msg = ""
	for i in arg_ary.size() - 1:
		msg += arg_ary[i]
		msg += ", "
	msg += arg_ary[arg_ary.size() - 1]
	chat(msg)

func rest(cmd_info : CommandInfo) -> void:
	var player = PlayerManager.get_player_state(cmd_info.sender_data.user)
	player.hide()
	var base_room = RoomFactory.create_room("base_room")
	#base_room.global_position = Vector2(400, 200)
	var screenSize = get_viewport().size
	base_room.global_position = screenSize / 2
	add_child(base_room)
	var room = RoomFactory.create_room("room_rest")
	print(room)
	base_room.add_child(room) # Add the room instance to the scene tree
	room.trigger_event(player)



func renown(cmd_info : CommandInfo) -> void:
	var player = PlayerManager.get_player_state(cmd_info.sender_data.user)
	player.hide()
	chat("You have %d renown." % player.stats.renown)


func explore(cmd_info : CommandInfo) -> void:
	var player = PlayerManager.get_player_state(cmd_info.sender_data.user)
	#var rooms = ['coins_room', 'thief', 'enemy_room']
	var rooms = ['enemy_room']

	var room = RoomFactory.create_room(rooms.pick_random()) # Assuming "treasure_room" is a valid type
	print(room)
	if room:
		var base_room = RoomFactory.create_room("base_room")
		#base_room.global_position = Vector2(400, 200)
		var screenSize = get_viewport().size
		base_room.global_position = screenSize / 2
		add_child(base_room)
		base_room.add_child(room) # Add the room instance to the scene tree
		room.trigger_event(player)
	


func quest_status(cmd_info: CommandInfo) -> void:
	var player_id = cmd_info.sender_data.user
	var player = PlayerManager.get_player_state(player_id)
	
	if player.active_quests.size() == 0:
		chat("You currently have no quests.")
		return

	# Assuming each player can have multiple quests, iterate through all
	for quest_resource_path in player.active_quests.keys():
		var quest = load(quest_resource_path) # Load the quest resource
		var current_step = player.active_quests[quest_resource_path]
		var message = "Quest: %s - %s/%s steps completed." % [quest.quest_name, str(current_step), str(quest.steps_required)]
		chat(message)


func save(cmd_info : CommandInfo) -> void:
	var character  = Stats.new()
	var character_name = cmd_info.sender_data.user
	character.name = character_name
	#ResourceSaver.save(character, save_file_path + character_name + ".tres")
	chat("Character Saved")
	

func load(cmd_info : CommandInfo) -> void:
	var character  = Stats.new()
	var character_name = cmd_info.sender_data.user
	#character = load_character(character_name)
	chat("Character Loaded: " + character.name)


	
func verify_save_dir(path: String):
	
	DirAccess.make_dir_absolute(path)


