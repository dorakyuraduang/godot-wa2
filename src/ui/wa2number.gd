extends Node2D
class_name Wa2Number
@export var texture:=preload("res://assets/grp/sys_01013.tga")
@export var text:=""
var text_pos={
	"0":Vector2(0,16),
	"1":Vector2(12,16),
	"2":Vector2(24,16),
	"3":Vector2(36,16),
	"4":Vector2(48,16),
	"5":Vector2(60,16),
	"6":Vector2(72,16),
	"7":Vector2(84,16),
	"8":Vector2(96,16),
	"9":Vector2(108,16),	
	":":Vector2(120,16),
	"/":Vector2(180,0)
}
func set_text(str:=""):
	text=str
	queue_redraw() 
func _draw():
	for i in len(text):
		if text_pos.has(text[i]):
			var rect=Rect2(i*Vector2(12,0),Vector2(12,16))
			var src_rect=Rect2(text_pos[text[i]],Vector2(12,16))
			draw_texture_rect_region(texture,rect,src_rect)
		
		
