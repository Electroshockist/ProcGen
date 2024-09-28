class_name TerrainProcedure
extends Node

@export var noise := FastNoiseLite.new()

func _init():
	noise.seed = randi()

func _ready():
	pass

func get_tile_at(x,y,z) -> Tile:
	if (noise.get_noise_3d(x, y, z) > 0):
		
#		print("Pos: %.v \tValue: %f" % [Vector3(x,y,z), noise.get_noise_3d(x, y, z)])
#		print("tile at %.v" % Vector3(x,y,z))
		return Tile.new()
	return null
