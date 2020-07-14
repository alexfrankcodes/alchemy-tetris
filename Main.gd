extends Node2D

enum { STOPPED, PLAYING, PAUSED, STOP, PLAY, PAUSE }

const DISABLED = true
const ENABLED = false

var gui
var state = STOPPED
var music_position = 0.0

func _ready():
	gui = $GUI
	gui.connect("button_pressed", self, "_button_pressed")
	gui.set_button_states(ENABLED)

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


func _start_game():
	print('Game Playing')
	state = PLAYING
	music_position = 0.0
	_music(PLAY)
	
	

func _music(action):
	if gui.music and action == PLAY:
		$MusicPlayer.play(music_position)
		print("Music started")
	else:
		music_position = $MusicPlayer.get_playback_position()
		$MusicPlayer.stop()
		print("Music stopped")
