extends Node2D
class_name Wa2Effect
var image:Texture2D
var duration:int
var effect_type:int
var counter:int
var offset:=Vector2.ZERO
func do_effect():
	queue_redraw()
	counter+=1
	await get_tree().physics_frame
	if counter<duration:
		return true
	else:
		return false	
func _draw():
	match effect_type:
		0:
			var alpha=float(counter)/duration
			var pos=(image.get_size()*((Vector2.ONE-scale)/2)/scale)+offset
			draw_texture(image,pos,Color(1,1,1,alpha))
