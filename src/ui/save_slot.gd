extends TextureButton
@onready var image=$TextureRect
@onready var no_text=$No
@onready var date_text=$Date
func set_image(texture:ImageTexture):
	image.texture=texture
func set_no(no:int):
	if no<100:
		no_text.set_text(" %02d"%no)
	else:
		no_text.set_text("%03d"%no)
func set_date(date):
	date_text.set_text("%04d %02d/%02d %02d:%02d"%[date.year,date.month,date.day,date.hour,date.minute])
