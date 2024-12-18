class_name Terrain
extends Node3D

@export var terrain_procedure: Script

#the object that the terrain will load relative to
@export var loader: Node3D

@export var chunk_size: int

@export var render_distance: int

@export var max_chunk_threads: int

var threads = []

var chunks = {}

#TODO: do thread init

func _ready():
	print(
		"Loading Chunks\n
		Total Chunks:%.0f\n" % (pow(render_distance, 3)))
	print("Total Chunk Volume Tiles: %.0f" % (pow(render_distance * chunk_size, 3)))
	
	_load_chunks()

func _load_chunks():
	#sets the index of chunks. 0,0,0 being the first chunk
	#var loader_chunk_index :Vector3i = (loader.position / chunk_size).floor()
	
	var render_radius = float(render_distance) / 2
	
	#render from a center point outward
	var render_range := range(ceili(-render_radius), ceili(render_radius))
	
	#loop through and generate all coordssible chunks in render range
	for x in render_range:
		for y in render_range:
			for z in render_range:
				var chunk_coords := Vector3i(x, y, z)
				
				var chunk := Chunk.new()
				#var chunk := Chunk.new(chunk_coords + loader_chunk_index)
				
				chunk.position = chunk_coords * chunk_size
				chunk.name = "Chunk %.v" % chunk_coords
				
				chunks[chunk_coords] = chunk
				add_child(chunk)

func get_tile(coords: Vector3i, by_absolute_coords = false) -> Tile:
	return chunks[get_tile_chunk(coords)].get_tile(coords, by_absolute_coords)

func has_tile(coords: Vector3i, by_absolute_coords = false) -> bool:
	return chunks[get_tile_chunk(coords)].has_tile(coords, by_absolute_coords)

# Get the chunk that a tile is in
func get_tile_chunk(tile_coords: Vector3i) -> Vector3i:
	return (tile_coords - tile_coords%chunk_size) / chunk_size