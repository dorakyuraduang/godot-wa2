extends SubViewportContainer
@onready var sub_viewport=$SubViewport
@onready var texture_viewport=$SubViewport/ColorRect
var bg_draw_frame:=0
var bg_texture:Texture
var bg_image:Image=Image.create(1280,720,false,Image.FORMAT_RGB8)
var cur_image:Image=Image.create(1280,720,false,Image.FORMAT_RGBA8)
var new_image:Image=Image.create(1280,720,false,Image.FORMAT_RGBA8)
var cur_texture:ImageTexture=ImageTexture.create_from_image(cur_image)
var new_texture:ImageTexture=ImageTexture.create_from_image(new_image)
var duration:=0
func set_amp_mode(mode:int):
	texture_viewport.material.set_shader_parameter("amp_mode",mode)
func _ready():
	texture_viewport.material.set_shader_parameter("texture1",cur_texture)
	texture_viewport.material.set_shader_parameter("texture2",new_texture)
func cl(char:int,ef:int,frame:int):
	duration=frame
	Globals.char_info.erase(char)
	await draw_image()
func clear():
	Globals.char_info.clear()
	cur_image.fill(Color(0,0,0,0))
	new_image.fill(Color(0,0,0,0))
	cur_texture.update(cur_image)
	new_texture.update(new_image)
func get_char_pos(pos:int,size:Vector2):
	return Consts.CHAR_POS[pos]-Vector2(((size.x-1280)/2.0),0)
func draw_image():
	#cur_image.save_png("res://a.png")
	new_image.fill(Color(0,0,0,0))
	print(Globals.char_info)
	for i in Globals.char_info:
		var image=Wa2Res.get_char_image(i,Globals.char_info[i].id)
		var pos=get_char_pos(Globals.char_info[i].pos,image.get_size())
		new_image.blend_rect(image,Rect2i(Vector2i.ZERO,image.get_size()),pos)
	texture_viewport.material.set_shader_parameter("time",0.0)
	cur_texture.update(cur_image)
	new_texture.update(new_image)
	var counter:=0
	while (counter<duration and duration>0):
		await get_tree().physics_frame
		counter+=1
		texture_viewport.material.set_shader_parameter("time",float(counter)/duration)
		if Globals.is_skip():
			break
	cur_image=new_image.duplicate()
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
func get_image():
	return sub_viewport.get_texture().get_image()
func get_shader_var(prop:String):
	return texture_viewport.material.get_shader_parameter(prop)
func set_shader_var(prop:String,value):
	texture_viewport.material.set_shader_parameter(prop,value)	
func change_bg(offset:Vector2=Vector2.ZERO,_scale:Vector2=Vector2.ONE):
	var image=load(Globals.cur_bg)
	set_bg2_image(image)
	set_bg2_offset(offset)
	set_bg2_scale(_scale)
	Globals.move_flag=false
	if bg_draw_frame>0:
		for i in bg_draw_frame:
			await get_tree().process_frame
			set_bg2_alpha(i/float(bg_draw_frame))
			if Globals.is_skip():
				break
	set_bg2_alpha(0.0)
	set_bg1_image(image)
	set_bg1_scale(_scale)
	set_bg1_offset(offset)
func bg_move(offset,frame):
	var counter=0
	Globals.move_flag=true
	var start_offset=get_bg1_offset()
	var distance=start_offset-offset
	while (counter<frame):
		await get_tree().physics_frame
		if !Globals.move_flag:
			break
		counter+=1
		set_bg1_offset(start_offset-distance*(float(counter)/frame))
