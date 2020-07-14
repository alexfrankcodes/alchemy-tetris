extends CenterContainer

var grid
var next
var music setget _music_set, _music_get
var sound setget _sound_set, _sound_get

signal button_pressed(button_name)

func _ready():
	grid = find_node("Grid")
	next = find_node("NextBlock")
	
	# Set up playspace grid
	generate_cells(grid, 400)
	
	# Clear cells
	clear_all_cells()

# Generate cells for grid
func generate_cells(node, n):
	
	# Get number of existing cells
	var num_cells = node.get_child_count()
	
	# Fill in cells up to n
	while num_cells < n:
		node.add_child(node.get_child(0).duplicate())
		num_cells += 1

# Clear cells
func clear_cells(node):
	
	# Loop through cells and set color
	for cell in node.get_children():
		cell.modulate = Color(0)
		

func clear_all_cells():
	clear_cells(grid)	
	clear_cells(next)


# Methods to change button
func set_button_state(button, state):
	find_node(button).set_disabled(state)
	
func set_button_text(button, text):
	find_node(button).set_text(text)


# Handle button states
func set_button_states(playing):
	set_button_state("NewGame", playing)
	set_button_state("About", playing)
	set_button_state("PauseToggle", !playing)


func _music_set(value):
	find_node("Music").set_pressed(value)

func _music_get():
	return find_node("MusicToggle").is_pressed()

func _sound_set(value):
	find_node("Sound").set_pressed(value)

func _sound_get():
	return find_node("SoundToggle").is_pressed()
	

# Preview Next shape:
func set_next_shape(shape: ShapeData):
	clear_cells(next)
	var i = 0
	for col in shape.coors.size():
		for row in [0, 1]:
			if shape.grid[row][col]:
				next.get_child(i).modulate = shape.color
			i += 1


# TODO: Handle button presses
func _on_NewGame_button_down():
	emit_signal("button_pressed", "NewGame")

func _on_PauseToggle_button_down():
	emit_signal("button_pressed", "Pause")

func _on_About_button_down():
	$AboutBox.popup_centered()
	emit_signal("button_pressed", "About")

func _on_SoundToggle_pressed():
	emit_signal("button_pressed", "Sound")

func _on_MusicToggle_pressed():
	music = true
	emit_signal("button_pressed", "Music")


func _on_AboutBox_popup_hide():
	set_button_state("About", false)


