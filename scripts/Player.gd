extends Node2D

@export var tilemap : TileMap

func _ready() -> void:
	$Animation.play('idle_down')

func _process(delta: float) -> void:		
	# Faire avancer le personnage. Jouer la bonne animation.
	$State.process(delta)
	
func _physics_process(delta: float) -> void:
	$State.physics_process(delta)

func play_animation(animation: String) -> void:
	$Animation.play(animation)
	
func get_current_animation() -> String:
	return $Animation.animation
	
func can_move(_offset: Vector2i) -> bool:
	var cur_pos : Vector2i = (global_position - tilemap.global_position) / Constants.TILE_SIZE
	var tile := tilemap.get_cell_tile_data(0, cur_pos+_offset)
	if tile.get_collision_polygons_count(0) == 1:
		return false
	return true
