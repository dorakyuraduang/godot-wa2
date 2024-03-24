extends Node2D
class_name Wa2Image
signal draw_over
var anime_frame:=0
var needed_frame:=0
@export var cur_texture:Texture
@export var effect_texture:Texture
func _physics_process(delta):
	queue_redraw()
	if needed_frame<=0:
		set_physics_process(false)
		cur_texture=effect_texture
		effect_texture=null
		emit_signal("draw_over")
	else:
		needed_frame-=1
