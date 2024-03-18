extends Node

var screen_middle : Vector2
var fade_out_duration = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var screenSize = get_viewport().size
	screen_middle = screenSize / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func create_wavy_text(message):
	# Create a new instance of RichTextLabel
	#var rich_text_label = RichTextLabel.new()
	var rich_text_label = get_tree().get_first_node_in_group("wavealert")
	rich_text_label.show()
	# Enable BBCode parsing
	rich_text_label.set_use_bbcode(true)
	rich_text_label.add_theme_font_size_override("normal_font_size", 30)

	# Assuming [wave] is a valid BBCode tag for waving effect in your setup
	var wavy_text = "[center][wave amp=50 freq=2]%s[/wave][/center]" % message
	
	# Set the BBCode text
	rich_text_label.bbcode_text = wavy_text
	return
	# Add the RichTextLabel to the current scene
	add_child(rich_text_label)

	# Optionally, adjust the position or properties of the RichTextLabel
	##rich_text_label.custom_minimum_size = Vector2(400, 100)
	rich_text_label.size = Vector2(800, 200)
	rich_text_label.global_position = _Utility.screen_middle + Vector2(-400, 200)
	#rich_text_label.position = _Utility.screen_middle + Vector2(0, 10) # Adjust position as needed
