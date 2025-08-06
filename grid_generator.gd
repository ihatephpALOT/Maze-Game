extends Node3D

@export var grid_size: int = 11
@export var cell_size: float = 2.0
var FloorScene: PackedScene = preload("res://floor.tscn")
var WallScene: PackedScene = preload("res://wall.tscn")


func _ready() -> void:
	generate_grid()

func generate_grid() -> void:
	for x in range(grid_size):
		for z in range(grid_size):
			var tile_position = Vector3(x * cell_size, 0, z * cell_size)

			# Floor tile
			var tile = FloorScene.instantiate()
			tile.translation = tile_position
			add_child(tile)

			if WallScene:
				# Left wall
				var wall_left = WallScene.instantiate()
				wall_left.translation = tile_position + Vector3(-cell_size / 2, 0, 0)
				wall_left.rotation_degrees.y = 90
				add_child(wall_left)

				# Top wall
				var wall_top = WallScene.instantiate()
				wall_top.translation = tile_position + Vector3(0, 0, -cell_size / 2)
				add_child(wall_top)

				# Right wall
				if x == grid_size - 1:
					var wall_right = WallScene.instantiate()
					wall_right.translation = tile_position + Vector3(cell_size / 2, 0, 0)
					wall_right.rotation_degrees.y = 90
					add_child(wall_right)

				# Bottom wall
				if z == grid_size - 1:
					var wall_bottom = WallScene.instantiate()
					wall_bottom.translation = tile_position + Vector3(0, 0, cell_size / 2)
					add_child(wall_bottom)
