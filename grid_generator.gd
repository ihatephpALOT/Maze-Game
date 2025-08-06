extends Node3D

@export var grid_size: int = 11
@export var cell_size: float = 2.0
@export var FloorScene: PackedScene
@export var WallScene: PackedScene  # Optional

func _ready() -> void:
	generate_grid()

func generate_grid() -> void:
	for x in range(grid_size):
		for z in range(grid_size):
			var tile_position = Vector3(x * cell_size, 0, z * cell_size)

			# Floor tile
			if FloorScene:
				var tile = FloorScene.instantiate()
				tile.position = tile_position
				add_child(tile)

			# Optional: Add walls
			if WallScene:
				# Left wall
				var wall_left = WallScene.instantiate()
				wall_left.position = tile_position + Vector3(-cell_size / 2, 0, 0)
				wall_left.rotation_degrees.y = 90
				add_child(wall_left)

				# Top wall
				var wall_top = WallScene.instantiate()
				wall_top.position = tile_position + Vector3(0, 0, -cell_size / 2)
				add_child(wall_top)

				# Right wall (only at outer edge)
				if x == grid_size - 1:
					var wall_right = WallScene.instantiate()
					wall_right.position = tile_position + Vector3(cell_size / 2, 0, 0)
					wall_right.rotation_degrees.y = 90
					add_child(wall_right)

				# Bottom wall (only at outer edge)
				if z == grid_size - 1:
					var wall_bottom = WallScene.instantiate()
					wall_bottom.position = tile_position + Vector3(0, 0, cell_size / 2)
					add_child(wall_bottom)
