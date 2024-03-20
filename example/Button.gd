extends Button

func _pressed():
	var gift = get_tree().get_first_node_in_group("gift")
	var line_edit = get_tree().get_first_node_in_group("LineEdit")
	gift.chat(line_edit.text)
	var channel : String = gift.channels.keys()[0]
	gift.handle_command(SenderData.new(gift.username, channel, gift.last_state[channel]), (":" + line_edit.text).split(" ", true, 1))
	line_edit.text = ""
