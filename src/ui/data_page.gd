extends Control
var page:=0
@onready var slot_list=$GridContainer
@onready var page_btn_container=$PageBtnContainer
func set_page(n:int):
	page=n
	page_btn_container.get_child(page).grab_focus()	
	update_slot()
func _ready():
	for i in page_btn_container.get_child_count():
		var btn:TextureButton=page_btn_container.get_child(i)
		btn.connect("button_down",func ():
			set_page(i)
			)
func update_slot():
	var file_info=Globals.get_file_info(page)
	for i in 10:
		var slot:DataSlot=slot_list.get_child(i)
		slot.set_no(page*10+i+1)
		if file_info.has(i):
			slot.set_state(1)
			var text=file_info[i].cur_text
			var date=file_info[i].date
			var data=file_info[i].image
			var image=Image.create_from_data(data.width,data.height,data.mipmaps,Image.FORMAT_RGB8,data.data)
			var texture=ImageTexture.create_from_image(image) 
			slot.set_image(texture)
			slot.set_date(date)
			slot.set_text(text)
		else:
			slot.clear()
			slot.set_state(0)
