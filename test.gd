@tool
extends Node2D
@onready var bg=$Wa2Bg
func _ready():
	var arr:PackedByteArray=FileAccess.get_file_as_bytes("res://assets/grp/sepia.AMP")
	bg.material.set_shader_parameter("amp",arr)
