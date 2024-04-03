extends Control
@onready var tip=$Tip
@onready var animation_player=$AnimationPlayer
@onready var data_page=$DataPage
func _ready():
	for i in data_page.slot_list.get_child_count():
		var slot:DataSlot=data_page.slot_list.get_child(i)
		slot.connect("button_down",func ():
			if slot.state==0:
				return
			Globals.load_file(data_page.page*10+i)
			tip.show()
			await get_tree().create_timer(1.5).timeout
			tip.hide()
			close()
		)
func open():
	animation_player.play("open")
	data_page.set_page(0)
func close():
	animation_player.play("close")
func _on_texture_button_button_down():
	close()

