extends Control

@export var grid_size: int = 11
@export var cell_size: float = 10.0  # pixel size per cell on minimap
var grid_ref       # set by GridGenerator
var player_ref     # set by GridGenerator

func _ready():
	set_process(true)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if not grid_ref:
		return

	# Draw maze cells + walls
	for ix in range(grid_size):
		for iz in range(grid_size):
			var c = grid_ref[ix][iz]
			var pos = Vector2(ix * cell_size, iz * cell_size)

			# draw cell background
			draw_rect(Rect2(pos, Vector2(cell_size, cell_size)), Color(0.2, 0.2, 0.2))

			# draw walls
			if c.has_top_wall:
				draw_line(pos, pos + Vector2(cell_size, 0), Color.WHITE, 2)
			if c.has_left_wall:
				draw_line(pos, pos + Vector2(0, cell_size), Color.WHITE, 2)
			if c.has_right_wall:
				draw_line(pos + Vector2(cell_size, 0), pos + Vector2(cell_size, cell_size), Color.WHITE, 2)
			if c.has_bottom_wall:
				draw_line(pos + Vector2(0, cell_size), pos + Vector2(cell_size, cell_size), Color.WHITE, 2)

	# Draw player marker
	if player_ref:
		var px = int(round(player_ref.global_position.x))
		var pz = int(round(player_ref.global_position.z))
		var marker_pos = Vector2(px * cell_size + cell_size/2, pz * cell_size + cell_size/2)
		draw_circle(marker_pos, cell_size/3, Color.RED)
