extends CenterContainer

const CELL_BG1 = Color(0.1, 0.1, 0.1)

var grid
var next

func _ready():
	grid = find_node("Grid")
	next = find_node("NextBlock")
	
	# Set up playspace grid
	generate_cells(grid, 400)
	
	# Set cells to empty color
	clear_cells(grid, CELL_BG1)
	
	pass	

# Generate cells for grid
func generate_cells(node, n):
	
	# Get number of existing cells
	var num_cells = node.get_child_count()
	
	# Fill in cells up to n
	while num_cells < n:
		node.add_child(node.get_child(0).duplicate())
		num_cells += 1
		
	pass

# Clear cells
func clear_cells(node, color):
	
	# Loop through cells and set color
	for cell in node.get_children():
		cell.modulate = color
		
	pass
