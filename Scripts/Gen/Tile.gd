class_name Tile
extends Node3D

const _arrow_gizmo := preload("res://arrow.tscn")
const _sphere_gizmo = preload("res://sphere.tscn")

const x_mat := preload("res://x.tres")
const y_mat := preload("res://y.tres")
const z_mat := preload("res://z.tres")

signal on_modify
