extends ColorRect
class_name Wa2Chars
var char_info={}
var cur_image=Image.create(1280,720,false,Image.FORMAT_RGBA8)
var new_image=Image.create(1280,720,false,Image.FORMAT_RGBA8)
var cur_texture:ImageTexture=ImageTexture.create_from_image(cur_image)
var new_texture:ImageTexture=ImageTexture.create_from_image(new_image)
var duration:=0
class Char:
	var cur_image:Image
	var new_image:Image
	var new_pos:Vector2
	var cur_pos:Vector2
func _ready():
	material.set_shader_parameter("texture1",cur_texture)
	material.set_shader_parameter("texture2",new_texture)
func cl(char:int,ef:int,duration:int):
	char_info[char].new_image=null
	draw_image()
	char_info.erase(char)
func clear():
	char_info.clear()
	cur_image.fill(Color(0,0,0,0))
	new_image.fill(Color(0,0,0,0))
	cur_texture.update(cur_image)
	new_texture.update(new_image)
func get_char_pos(pos:int,size:Vector2):
	return Consts.CHAR_POS[pos]-Vector2(((size.x-1280)/2.0),0)
func set_char(id:int,pos:int,image:Image):
	if !char_info.has(id):
		char_info[id]=Char.new()
	char_info[id].new_image=image
	char_info[id].new_pos=get_char_pos(pos,image.get_size())
func draw_image():
	cur_image.fill(Color(0,0,0,0))
	new_image.fill(Color(0,0,0,0))
	material.set_shader_parameter("time",0.0)
	for i in char_info:
		if char_info[i].cur_image:
			var copy_image=char_info[i].cur_image
			var pos=char_info[i].cur_pos
			cur_image.blend_rect(copy_image,Rect2i(Vector2i.ZERO,copy_image.get_size()),pos)
		if char_info[i].new_image:
			var copy_image=char_info[i].new_image
			var pos=char_info[i].new_pos
			new_image.blend_rect(copy_image,Rect2i(Vector2i.ZERO,copy_image.get_size()),pos)
	cur_texture.update(cur_image)
	new_texture.update(new_image)
	var counter:=0
	while (counter<duration):
		await get_tree().physics_frame
		counter+=1
		material.set_shader_parameter("time",float(counter)/duration)
		if Globals.is_skip():
			break
	for i in char_info:
		if char_info[i].new_image:
			char_info[i].cur_image=char_info[i].new_image
			char_info[i].cur_pos=char_info[i].new_pos
	material.set_shader_parameter("time",1.0)	
#func set_image(c_id:int,t_id:int,t_type:int,pos:int,frame:int=0):
	#anime_frame=frame
	#needed_frame=anime_frame
	#var path="%s%s%06d.tga"%[Consts.CHAR_IMAGE_PATH,Consts.CHAR_NAMES[c_id],t_id+t_type]
	#effect_texture=load(path)
	#set_physics_process(true)
#func _draw():
	#if cur_texture:
		#var color=Color(1,1,1,float(needed_frame)/anime_frame)
		#draw_texture(cur_texture,Vector2.ZERO,Color.WHITE)
	#if effect_texture:
		#var color=Color(1,1,1,float(anime_frame-needed_frame)/anime_frame)
		#draw_texture(effect_texture,Vector2.ZERO,color)
