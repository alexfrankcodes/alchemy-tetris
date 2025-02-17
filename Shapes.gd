extends GridContainer


var _shapes = []
var _index = 0


func get_shape() -> ShapeData:
	if _index == 0:
		_shapes.shuffle()
		_index = _shapes.size()
	_index -= 1
	var s = ShapeData.new()
	s.name = _shapes[_index].name
	s.color = _shapes[_index].color 
	#Color is provided in the name and some shapes have mutilple colors so if I find something thet relies on 
	#this we will need to find another solution.
	s.coors = _shapes[_index].coors
	s.grid = _shapes[_index].grid
	s.texture = _shapes[_index].texture
	return s


# Called when the node enters the scene tree for the first time.
func _ready():
	for shape in get_children():
		var data = ShapeData.new()
		data.name = shape.name
		data.color = shape.modulate
		#I anticipate we will need a function which will tally up the number of cells of each color on each row of the shape.
		#For the row clearing function.
		var size = shape.columns
		var s2 = size / 2
		data.coors = range(-s2, s2 + 1)
		data.texture = shape.get_children().pop_front().texture
		#Remove the zero coordinate for even sized grids
		if size % 2 ==0:
			data.coors.remove(s2)
		#print(data.coors) # For testing
		data.grid = _get_grid(size, shape.get_children())
		_shapes.append(data)
		

func _get_grid(n, cells):
	var grid = []
	var row = []
	var i = 0
	for cell in cells:
		row.append(cell.modulate.a > 0.1)
		i += 1
		if i == n:
			grid.append(row)
			i = 0
			row = []
	return grid
