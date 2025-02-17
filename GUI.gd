extends CenterContainer

const GRID_SIZE = 100

var grid
var next

# Music/Sound
var music = 0
var sound = 0
var min_vol

# Level/Scoring
var level = 1 setget set_level
var score = 0 setget set_score
var high_score = 0 setget set_high_score
var lines = 0 setget set_lines

signal button_pressed(button_name)

###################### SETUP ######################
func _ready():
	grid = find_node("Grid")
	next = find_node("NextBlock")
	find_node("Play").hide()
	find_node("Music_Off").hide()
	find_node("Sound_Off").hide()
	generate_cells(grid, GRID_SIZE)
	clear_all_cells()
	$WelcomeBox.popup_centered()

func generate_cells(node, n):
	var num_cells = node.get_child_count()
	while num_cells < n:
		node.add_child(node.get_child(0).duplicate())
		num_cells += 1

func clear_cells(node):
	for cell in node.get_children():
		cell.modulate = Color(0)

func clear_all_cells():
	clear_cells(grid)	
	#clear_cells(next)

###################### GAME STATE ######################
func set_level(value):
	#find_node("Level").text = str(value)
	level = value

func set_score(value):
	#find_node("Score").text = str(value)
	score = value

func set_high_score(value):
	#find_node("HighScore").text = "%08d" % value
	high_score = value

func set_lines(value):
	#find_node("Lines").text = str(value)
	lines = value

func reset_stats(_high_score = 0, _score = 0, _lines = 0, _level = 1):
	self.high_score = _high_score
	self.score = _score
	self.find_node("FireProgress").value = _score
	self.find_node("WaterProgress").value = _score
	self.find_node("LightningProgress").value = _score
	self.find_node("PlantProgress").value = _score
	self.find_node("MainProgress").value = _score
	self.lines = _lines
	self.level = _level
	

func settings(data):
	self.high_score = data.high_score
	
func lose():
	$LoseBox.popup_centered()	

func win():
	$WinBox.popup_centered()		

###################### BUTTON MUTATORS ######################
func set_button_state(button, state):
	find_node(button).set_disabled(state)
	find_node(button).release_focus()
	
func set_button_text(button, text):
	find_node(button).set_text(text)

func set_button_states(playing):
	set_button_state("NewGame", playing)
	set_button_state("Pause", !playing)



###################### BUTTON SIGNALS ######################
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


func _on_Pause_button_up():
	find_node("Pause").hide()
	find_node("Play").show()
	emit_signal("button_pressed", "Pause")

func _on_Play_button_up():
	find_node("Play").hide()
	find_node("Pause").show()
	emit_signal("button_pressed", "Pause")

func _on_Music_button_up():
	find_node("Music").hide()
	find_node("Music_Off").show()
	emit_signal("button_pressed", "Music")

func _on_Music_Off_button_up():
	find_node("Music_Off").hide()
	find_node("Music").show()
	emit_signal("button_pressed", "Music")

func _on_Sound_button_up():
	find_node("Sound").hide()
	find_node("Sound_Off").show()
	emit_signal("button_pressed", "Sound")

func _on_Sound_Off_button_up():
	find_node("Sound_Off").hide()
	find_node("Sound").show()
	emit_signal("button_pressed", "Sound")


func _on_NewGame_pressed():
	emit_signal("button_pressed", "NewGame")
