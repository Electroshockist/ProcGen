class_name Chunk
extends MeshInstance3D

#list of all tiles in chunk
var _tiles := {}

const mat = preload("res://chunk.tres")

#determines how terrain is generated
@onready var terrain_procedure := $"../TerrainProcedure"

#direction enums. Allows for binding of data to a direction
enum DIRECTION {
	NORTH,
	EAST,
	UP,
	WEST,
	SOUTH,
	DOWN
}

#list of all vertices in a unit cube
var _mesh_vertices := PackedVector3Array(
	[
		#west bottom south
		Vector3 (0, 0, 0),
		#east bottom south
		Vector3 (1, 0, 0),
		#east top south
		Vector3 (1, 1, 0),
		#west top south
		Vector3 (0, 1, 0),
		#west top north
		Vector3 (0, 1, 1),
		#east top north
		Vector3 (1, 1, 1),
		#east bottom north
		Vector3 (1, 0, 1),
		#west bottom north
		Vector3 (0, 0, 1)
	]
)

#enum of all vertex indices for each face in a cube 
var _mesh_indices := {
	DIRECTION.NORTH: [ 
		0, 2, 1, #face north
		0, 3, 2
	],
	DIRECTION.SOUTH: [
		5, 4, 7, #face south
		5, 7, 6
	],
	DIRECTION.EAST: [
		1, 2, 5, #face right
		1, 5, 6
	],
	DIRECTION.WEST: [
		0, 7, 4, #face west
		0, 4, 3
	],
	DIRECTION.UP: [
		2, 3, 4, #face top
		2, 4, 5
	],
	DIRECTION.DOWN: [
		0, 6, 7, #face bottom
		0, 1, 6
	]
}

#enum of vector3s for normal directions
var _relative_tile_dirs = {
	DIRECTION.NORTH: Vector3i(0,1,0),
	DIRECTION.SOUTH: Vector3i(0,-1,0),
	DIRECTION.EAST: Vector3i(-1,0,0),
	DIRECTION.WEST: Vector3i(1,0,0),
	DIRECTION.UP: Vector3i(0,1,0),
	DIRECTION.DOWN: Vector3i(0,-1,0)
}

func _ready():
	mesh = ArrayMesh.new()
	material_override = mat
	_gen_chunk()
	_gen_mesh()
		
func add_tile(tile: Tile, pos: Vector3i):
	_tiles[get_relative_pos(pos)] = tile

func get_tile_absolute_coords(pos: Vector3i):	
	return _tiles[get_relative_pos(pos)] if _tiles.has(get_relative_pos(pos)) else null

func get_tile_relative_coords(pos: Vector3i):
	return _tiles[pos] if _tiles.has(pos) else  null
	
#get tile pos relative to chunk pos
func get_relative_pos(tile_pos: Vector3i):
	return tile_pos - (get_chunk_index() * get_parent().chunk_size)

#generate chunk data
func _gen_chunk():
	var c_size: int = get_parent().chunk_size
	
	for x in range(c_size):
		for y in range(c_size):
			for z in range(c_size):
				var relative_tile_pos := Vector3(x,y,z)
				var tile_pos = relative_tile_pos + position
				
				#get the tile at the current position, get null if none
				var tile := (terrain_procedure as TerrainProcedure).get_tile_at(tile_pos.x,tile_pos.y,tile_pos.z)
				
				if(tile != null):
					_tiles[relative_tile_pos] = tile
					tile.name = "Tile %.v" % tile_pos
					tile.position = relative_tile_pos
					add_child(tile)
	
	#if chunk empty, delete chunk
	if _tiles.is_empty():
		queue_free()

#get the chunk index of the current chunk
func get_chunk_index() -> Vector3i:
	var get_i = func(p: int) ->int:
		return p as int / (get_parent() as Terrain).chunk_size
		
	return Vector3i(get_i.call(position.x),get_i.call(position.y),get_i.call(position.z))

func get_tiles():
	return _tiles

#generate chunk mesh
func _gen_mesh():
	
	if(_tiles.size() > 0):
		var surface_array = []
		surface_array.resize(Mesh.ARRAY_MAX)
		
		surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array()
		for tile_pos in _tiles:
			var meshes := _iterate_meshes()
			if not meshes.is_empty():
				surface_array[Mesh.ARRAY_VERTEX].append_array(meshes)
			
		
	#	printerr(name)
		if not surface_array.is_empty():
			mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
#func _get_unoccluded_faces(tile_pos: Vector3i) -> PackedVector3Array:	
#	return _tiles[tile_pos].get_vertices()

func _iterate_meshes() ->PackedVector3Array:
	var verts := PackedVector3Array()
	
	#TODO
	var checked_dirs = {}
	
	verts.is_empty()
	
#	var normals := PackedVector3Array()
	for pos in _tiles:
		for dir in range(DIRECTION.size()):
			for index in _mesh_indices[dir]:
				if not _tiles.has(Vector3i(_tiles[pos].position) + _relative_tile_dirs[dir]):
					verts.append(_tiles[pos].position+_mesh_vertices[index])
	#		faces[d] = (get_parent() as Chunk).get_tile_relative_coords(Vector3i(position) + _relative_tile_dirs[d]) != null
#	print("%.v" % position)
#	#for each direction
#	for dir in range(0,DIRECTION.size()):
#		#if tile is on a chunk boundary, draw face anyway
#		#TODO: check adjacent chunks
#		var rel :=_relative_tile_dirs[dir] as Vector3i
#		var next_tile := Vector3i(position) + rel
##		_is_dir_OOB(next_tile, dir) or 
#		if(not get_parent()._tiles.has(next_tile)):
#			print("\t%s" % dir)
#			print(_mesh_indices[dir])
#
#			#append mesh indices
#			for m in _mesh_indices[dir]:
#				for ind in m:
#					var s :=_mesh_vertices[ind] + position
#		#				print("\t\toriginal: %.v\n\t\toffset:\t %.v" % [_mesh_vertices[m], s])
#					faces.append(s)
#
#					var _gizmo = _arrow_gizmo.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
#					_gizmo.name = "arrow %.v" % s
#					_gizmo.position = s
#
#					match dir:
#						DIRECTION.NORTH:
#							_gizmo.rotate_x(deg_to_rad(90))
#							_gizmo.get_child(0, true).set_surface_override_material(0, z_mat)
#							_gizmo.get_child(1, true).set_surface_override_material(0, z_mat)
#
#						DIRECTION.SOUTH:
#							_gizmo.rotate_x(deg_to_rad(-90))
#							_gizmo.get_child(0, true).set_surface_override_material(0, z_mat)
#							_gizmo.get_child(1, true).set_surface_override_material(0, z_mat)
#
#						DIRECTION.EAST:
#							_gizmo.rotate_z(deg_to_rad(90))
#							_gizmo.get_child(0, true).set_surface_override_material(0, x_mat)
#							_gizmo.get_child(1, true).set_surface_override_material(0, x_mat)
#
#						DIRECTION.WEST:
#							_gizmo.rotate_z(deg_to_rad(-90))
#							_gizmo.get_child(0, true).set_surface_override_material(0, x_mat)
#							_gizmo.get_child(1, true).set_surface_override_material(0, x_mat)
#
#						DIRECTION.UP:
#							_gizmo.get_child(0, true).set_surface_override_material(0, y_mat)
#							_gizmo.get_child(1, true).set_surface_override_material(0, y_mat)
#
#						DIRECTION.DOWN:
#							_gizmo.rotate_z(PI)
#							_gizmo.get_child(0, true).set_surface_override_material(0, y_mat)
#							_gizmo.get_child(1, true).set_surface_override_material(0, y_mat)
#
#					add_child(_gizmo)
				
	return verts
	
	#is dir out-of-bounds of chunk
func _is_dir_OOB(next_tile_pos, dir: DIRECTION) -> bool:
	var relative_next_tile_pos = get_parent().get_relative_pos(next_tile_pos)
	
	#get the axis that the direction relates to
	var t_dir = relative_next_tile_pos.x if dir == DIRECTION.EAST or DIRECTION.WEST else (relative_next_tile_pos.y if DIRECTION.UP or DIRECTION.DOWN else relative_next_tile_pos.z)
	#return whether the tile is outside the chunk
	return t_dir < 0 or t_dir > get_parent().chunk_size


func get_inverse_dir(direction: DIRECTION) -> DIRECTION:
	match direction:
		DIRECTION.EAST:
			return DIRECTION.WEST
			
		DIRECTION.WEST:
			return DIRECTION.EAST
			
		DIRECTION.UP:
			return DIRECTION.DOWN
			
		DIRECTION.DOWN:
			return DIRECTION.UP
			
		DIRECTION.NORTH:
			return DIRECTION.SOUTH
			
		_:
			return DIRECTION.NORTH
