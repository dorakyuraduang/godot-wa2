@tool
extends Node2D
class_name Wa2Text
@export_enum("cn","jp") var lan:=0
@export_range(0.0,1.0,0.01) var visible_ratio:=1.0:
	set(val):
		visible_ratio=val
		queue_redraw()
@export var text="":
	set(val):
		text=val
		queue_redraw()
func _draw():
	var draw_pos=Vector2.ZERO
	var end=int(visible_ratio*text.length())
	var str=text.substr(0,end)
	for i in str.length():
		var ch=str[i]
		var pos=Consts.font_map.find(ch)
		if ch=="\n":
			draw_pos.x=0
			draw_pos.y+=1
		else:
			if pos>=0:
				var x=pos%80
				var y=pos/80
				var rect=Rect2(draw_pos*Vector2(32,32),Vector2(32,32))
				var src_rect=Rect2(Vector2(x,y)*40+Vector2(4,4),Vector2(32,32))
				print(lan)
				if lan==0:
					draw_texture_rect_region(Consts.cn_font_texture,rect,src_rect)	
					draw_texture_rect_region(Consts.cn_font_shadow_texture,rect,src_rect,Color(0.15,0.15,0.15,1))
				elif lan==1:
					draw_texture_rect_region(Consts.jp_font_shadow_texture,rect,src_rect,Color(0.15,0.15,0.15,1))
					draw_texture_rect_region(Consts.jp_font_texture,rect,src_rect)	
						
			draw_pos.x+=1
