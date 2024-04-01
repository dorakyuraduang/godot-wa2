extends SubViewportContainer
@onready var texture_viewport=$SubViewport/ColorRect
var char_info={}
var bg_texture:Texture
var bg_image=Image.create(1280,720,false,Image.FORMAT_RGB8)
var cur_image=Image.create(1280,720,false,Image.FORMAT_RGBA8)
var new_image=Image.create(1280,720,false,Image.FORMAT_RGBA8)
var cur_texture:ImageTexture=ImageTexture.create_from_image(cur_image)
var new_texture:ImageTexture=ImageTexture.create_from_image(new_image)
var duration:=0
func set_amp_mode(mode:int):
	texture_viewport.material.set_shader_parameter("amp_mode",mode)
func _ready():
	texture_viewport.material.set_shader_parameter("texture1",cur_texture)
	texture_viewport.material.set_shader_parameter("texture2",new_texture)
func cl(char:int,ef:int,duration:int):
	Globals.char_info.erase(char)
	draw_image()
func clear():
	Globals.char_info.clear()
	cur_image.fill(Color(0,0,0,0))
	new_image.fill(Color(0,0,0,0))
	cur_texture.update(cur_image)
	new_texture.update(new_image)
func get_char_pos(pos:int,size:Vector2):
	return Consts.CHAR_POS[pos]-Vector2(((size.x-1280)/2.0),0)
func draw_image():
	new_image.fill(Color(0,0,0,0))
	texture_viewport.material.set_shader_parameter("time",0.0)
	for i in Globals.char_info:
		var image=Wa2Res.get_char_image(i,Globals.char_info[i].id)
		var pos=get_char_pos(Globals.char_info[i].pos,image.get_size())
		new_image.blend_rect(image,Rect2i(Vector2i.ZERO,image.get_size()),pos)
	cur_texture.update(cur_image)
	new_texture.update(new_image)
	var counter:=0
	while (counter<duration):
		await get_tree().physics_frame
		counter+=1
		texture_viewport.material.set_shader_parameter("time",float(counter)/duration)
		if Globals.is_skip():
			break
	cur_image=new_image.duplicate()
	new_image.fill(Color(0,0,0,0))
	texture_viewport.material.set_shader_parameter("time",1.0)	
func set_bg1_image(image:Texture):
	texture_viewport.material.set_shader_parameter("bg1_texture",image)
func set_bg1_offset(offset:Vector2):
	texture_viewport.material.set_shader_parameter("bg1_offset",offset)
func set_bg1_scale(scale:Vector2):
	texture_viewport.material.set_shader_parameter("bg1_scale",scale)
func set_bg2_image(image:Texture):
	texture_viewport.material.set_shader_parameter("bg2_texture",image)
func set_bg2_offset(offset:Vector2):
	texture_viewport.material.set_shader_parameter("bg2_offset",offset)
func set_bg2_scale(scale:Vector2):
	texture_viewport.material.set_shader_parameter("bg2_scale",scale)
func set_bg2_alpha(alpha:float):
	texture_viewport.material.set_shader_parameter("bg2_alpha",alpha)
func set_amp_strength(strength:float):
	texture_viewport.material.set_shader_parameter("strength",strength)
func set_amp(amp):
	texture_viewport.material.set_shader_parameter("amp",amp)
func get_bg1_offset():
	return texture_viewport.material.get_shader_parameter("bg1_offset")
func set_chars_priority(flag:bool):
	texture_viewport.material.set_shader_parameter("chars_priority",flag)
