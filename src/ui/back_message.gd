extends VBoxContainer
var voice=""
@onready var name_label=$HBoxContainer/Label
@onready var text_label=$Label
@onready var voice_btn=$HBoxContainer/MarginContainer/TextureButton
func clear():
	name_label.text=""
	text_label.text=""
	voice_btn.hide()
func update(data):
	name_label.text=data.name
	text_label.text=data.text
	voice=data.voice
	if voice:
		voice_btn.show()
	else:
		voice_btn.hide()


func _on_texture_button_button_down():
	Sound.play_voice(voice)
