extends Control
@onready var animation_player=$AnimationPlayer
func _ready():
	pass
func open():
	Globals.cur_bg="res://assets/bak/B000000.tga"
	Globals.viewport.bg_draw_frame=30
	await Globals.viewport.change_bg()
	Globals.cur_bg="res://assets/grp/AQUAPLUS.tga"
	Globals.viewport.bg_draw_frame=30
	await Globals.viewport.change_bg()
	await get_tree().create_timer(2.0).timeout
	Globals.cur_bg="res://assets/bak/B000000.tga"
	Globals.viewport.bg_draw_frame=30
	await Globals.viewport.change_bg()
	
	animation_player.play("open")
	Globals.cur_bg="res://assets/grp/T0000.tga"
	Globals.viewport.bg_draw_frame=30
	await Globals.viewport.change_bg(Vector2(0,0))
	show()
	Globals.viewport.bg_move(Vector2(0,136),150)
