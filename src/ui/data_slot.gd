extends Wa2Button
class_name DataSlot
@onready var image=$TextureRect
@onready var no_text=$No
@onready var date_text=$Date
@onready var text_label=$Wa2Text
@onready var no_data=$NoData
@onready var exits_data=$ExistData
var state=0
func set_image(texture:ImageTexture):
	image.texture=texture
func set_no(no:int):
	if no<100:
		no_text.set_text(" %02d"%no)
	else:
		no_text.set_text("%03d"%no)
func set_date(date):
	date_text.set_text("%04d %02d/%02d %02d:%02d"%[date.year,date.month,date.day,date.hour,date.minute])
func set_text(text:String):
	text=text.replace("\n","")
	print(text)
	#print(text.find())
	if len(text)<13:
		text_label.text=text
	else:
		text_label.text=text.substr(0,12)+"…"
func clear():
	no_text.set_text("")
	date_text.set_text("")
	text_label.text=""
	image.texture=null
func set_state(_state:int):
	state=_state
	if state==0:
		no_data.show()
		exits_data.hide()
	else:
		exits_data.show()
		no_data.hide()
