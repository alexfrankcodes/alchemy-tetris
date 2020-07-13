extends Control

var shape: ShapeData

func _on_PickShape_button_down():
	shape = Shapes.get_shape()
	$ShapeName.text = shape.name
	_show_grid()


func _on_RLeft_button_down():
	shape.rotate_left()
	_show_grid()


func _on_RRight_button_down():
	shape.rotate_right()
	_show_grid()


func _show_grid():
	$Grid.text = ""
	for row in shape.grid:
		for col in row:
			if col:
				$Grid.text += "x "
			else:
				$Grid.text += "_ "
		$Grid.text += "\n"
