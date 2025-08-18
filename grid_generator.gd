# Maze Hunt - ZaGuh - Pre-Pre-Alpha

extends Node3D

@export var grid_size: int = 11
@export var cell_size: float = 1.0
@export var FloorScene: PackedScene
@export var WallScene: PackedScene

class Cell:
	var x:int
	var z:int
	var visited:bool = false
	var has_top_wall:bool   = true
	var has_bottom_wall:bool = true
	var has_left_wall:bool  = true
	var has_right_wall:bool = true

	func _init(x:int,z:int):
		self.x = x
		self.z = z

var grid := []      # 2D array of Cell
var stack := []     # for backtracking

func _ready()->void:
	# 1. build grid of Cell objects
	for x in range(grid_size):
		grid.append([])
		for z in range(grid_size):
			grid[x].append(Cell.new(x, z))

	# 2. run the recursive backtracker on our grid
	_generate_maze()

	# 3. instantiate floors + walls based on result
	_spawn_level()

# --------------------------
# Maze generation algorithm
# --------------------------
func _generate_maze()->void:
	var current = grid[0][0]
	current.visited = true
	stack.push_back(current)

	while stack.size() > 0:
		current = stack[-1]
		var neighbours = _get_unvisited_neighbours(current)

		if neighbours.size() > 0:
			var next = neighbours[randi() % neighbours.size()]
			# Remove wall between current and next
			_remove_wall(current, next)
			next.visited = true
			stack.push_back(next)
		else:
			stack.pop_back()

func _get_unvisited_neighbours(cell: Cell)->Array:
	var list := []

	# north (z - 1)
	if cell.z > 0 and not grid[cell.x][cell.z - 1].visited:
		list.append(grid[cell.x][cell.z - 1])
	# south (z + 1)
	if cell.z < grid_size - 1 and not grid[cell.x][cell.z + 1].visited:
		list.append(grid[cell.x][cell.z + 1])
	# west (x - 1)
	if cell.x > 0 and not grid[cell.x - 1][cell.z].visited:
		list.append(grid[cell.x - 1][cell.z])
	# east (x + 1)
	if cell.x < grid_size - 1 and not grid[cell.x + 1][cell.z].visited:
		list.append(grid[cell.x + 1][cell.z])

	return list

func _remove_wall(a:Cell, b:Cell)->void:
	# b is above a
	if b.x == a.x and b.z == a.z - 1:
		a.has_top_wall = false
		b.has_bottom_wall = false
	# b is below a
	elif b.x == a.x and b.z == a.z + 1:
		a.has_bottom_wall = false
		b.has_top_wall = false
	# b is to the left of a
	elif b.z == a.z and b.x == a.x - 1:
		a.has_left_wall = false
		b.has_right_wall = false
	# b is to the right of a
	elif b.z == a.z and b.x == a.x + 1:
		a.has_right_wall = false
		b.has_left_wall = false

# --------------------------
# Spawning the actual scenes
# --------------------------
func _spawn_level()->void:
	for x in range(grid_size):
		for z in range(grid_size):
			var c = grid[x][z]
			var pos = Vector3(x * cell_size, 0, z * cell_size)

			# floor
			if FloorScene:
				var f = FloorScene.instantiate()
				f.position = pos
				add_child(f)

			# walls
			if WallScene:
				if c.has_right_wall:
					var w_r = WallScene.instantiate()
					w_r.position = pos + Vector3(cell_size/2, 0, 0)
					w_r.rotation_degrees.y = 90
					add_child(w_r)
				if c.has_bottom_wall:
					var w_b = WallScene.instantiate()
					w_b.position = pos + Vector3(0,0,cell_size/2)
					add_child(w_b)

	# extra top and left outer walls
	for x in range(grid_size):
		var outer_t = WallScene.instantiate()
		outer_t.position = Vector3(x*cell_size,0,-cell_size/2)
		add_child(outer_t)

	for z in range(grid_size):
		var outer_l = WallScene.instantiate()
		outer_l.position = Vector3(-cell_size/2,0,z*cell_size)
		outer_l.rotation_degrees.y = 90
		add_child(outer_l)
