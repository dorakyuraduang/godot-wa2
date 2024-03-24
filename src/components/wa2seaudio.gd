extends Wa2Audio
func _ready():
	connect("finished",func ():
		if loop:
			seek(0)
			play()
		else:
			stop()
		)
