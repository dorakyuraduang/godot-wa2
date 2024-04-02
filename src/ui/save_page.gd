extends Control
@onready var tip=$Tip
@onready var animation_player=$AnimationPlayer
@onready var slot_list=$GridContainer
var page:=0
func _ready():
	for i in slot_list.get_child_count():
		slot_list.get_child(i).connect("button_down",func ():
			Globals.save_file(i)
			tip.show()
			await get_tree().create_timer(2.0).timeout
			tip.hide()
			close()
		)
func open():
	animation_player.play("open")
	
	update_slot()
func close():
	animation_player.play("close")
func _on_texture_button_button_down():
	close()
func update_slot():
	var file_info=Globals.get_file_info(page)
	for i in 10:
		var slot=slot_list.get_child(i)
		slot.set_no(page*10+i+1)
		if file_info.has(i):
			var date=file_info[i].date
			var data=file_info[i].image
			var image=Image.create_from_data(data.width,data.height,data.mipmaps,Image.FORMAT_RGB8,data.data)
			var texture=ImageTexture.create_from_image(image) 
			slot.set_image(texture)
			slot.set_date(date)
