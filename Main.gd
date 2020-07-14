extends CenterContainer

enum { STOPPED, PLAYING, PAUSED, STOP, PLAY, PAUSE }
enum { ROTATE_LEFT, ROTATE_RIGHT }

const DISABLED = true
const ENABLED = false

var gui
var state = STOPPED
var grid = []
var cols
var shape: ShapeData
var pos = 0
var music_position = 0.0

func _ready():
	gui = $GUI
	gui.connect("button_pressed", self, "_button_pressed")
	gui.set_button_states(ENABLED)
	cols = gui.grid.get_columns()

func _button_pressed(button_name):
	match button_name:
		"NewGame":
			gui.set_button_states(DISABLED)
			_start_game()

		"Pause":
			if state == PLAYING:
				gui.set_button_text("PauseToggle", "Resume")
				state = PAUSED
				_music(PAUSE)
			else:
				gui.set_button_text("PauseToggle", "Pause")
				state = PLAYING
				_music(PLAY)

		"Sound":
			print("Changed sound setting")

		"Music":
			if state == PLAYING:
				if gui.music:
					_music(PLAY)
				else:
					_music(STOP)

		"About":
			gui.set_button_state("About", DISABLED)

# Reset grid at the start of the game
func clear_grid():
	grid.clear()
	grid.resize(gui.grid.get_child_count())
	for i in grid.size():
		grid[i] = false
	gui.clear_all_cells()

func _start_game():
	print('Game Playing')
	state = PLAYING
	music_position = 0.0
	_music(PLAY)
	
func add_shape_to_grid():
	place_shape(pos, true, false, shape.color)
	
func remove_shape_from_grid():
	place_shape(pos, true)
	
func lock_shape_to_grid():
	place_shape(pos, false, true)

func rotate(dir):
	match dir:
		ROTATE_LEFT:
			shape.rotate_left()
			dir = ROTATE_RIGHT
		ROTATE_RIGHT:
			shape.rotate_left()
			dir = ROTATE_LEFT
	return dir

func move_shape(new_pos, dir = null):
	remove_shape_from_grid()
	# Rotate shape and store undo direction
	dir = rotate(dir)
	# If we can place the shape then update the position, else undo rotation
	var ok = place_shape(new_pos)
	if ok:
		pos = new_pos
	else:
		rotate(dir)
	add_shape_to_grid()
	return ok



## TODO: Change color parameter based on element
func place_shape(index, add_tiles = false, lock = false, color = Color(0)):
	var ok = true
	var size = shape.coors.size()
	var offset = shape.coors[0]
	var y = 0
	while y < size and ok:
		for x in size:
			if shape.grid[y][x]:
				var grid_pos = index + (y + offset) * cols + x + offset
				#print(grid_pos)
				if lock:
					grid[grid_pos] = true
				else:
					var gx = index % cols + x + offset
					if gx < 0 or gx >= cols or grid_pos >= grid.size() or grid_pos >= 0 and grid[grid_pos]:
						ok = !ok
						break
					if add_tiles and grid_pos >= 0:
						gui.grid.get_child(grid_pos).modulate = color
		y += 1
	return ok

func _music(action):
	if gui.music and action == PLAY:
		$MusicPlayer.play(music_position)
		print("Music started")
	else:
		music_position = $MusicPlayer.get_playback_position()
		$MusicPlayer.stop()
		print("Music stopped")
