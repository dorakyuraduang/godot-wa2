extends Control
class_name Wa2Main
func _ready():
	Globals.main=self
	Globals.video=$VideoStreamPlayer
	Globals.viewport=$Wa2Viewport
	Globals.message_box=$Wa2MessageBox
	Globals.backlog=$Pages/BackLog
	Globals.save_page=$Pages/SavePage
	Globals.load_page=$Pages/LoadPage
	Globals.title_menu_page=$Pages/TitleMenu
	Globals.options_container=$Options
	Globals.title_menu_page.open()
	Globals.video.connect("finished",func ():
		Globals.video.hide()
		)
	for i in Globals.options_container.get_child_count():
		Globals.options_container.get_child(i).connect("button_down",func ():
			Globals.select_idx=i
			)
	while (true):
		await get_tree().process_frame
		if Globals.game_state==1:
			if Globals.cur_command:
				print(Globals.cur_command)
				await Globals.cur_command.call()
			Ws.parse_command()
func _physics_process(delta):
	if Input.is_action_pressed("skip"):
		Globals.ctrl_pressed=true
	else:
		Globals.ctrl_pressed=false
func screenshot():
	pass
func _gui_input(event):
	if Globals.is_click(event) and Globals.game_state==1:
		if Globals.text_state==1:
			Globals.click_text_state=1
		elif Globals.text_state==2:
			if !Globals.text_on_flag:
				Globals.message_box.on(1)
			else:
				Globals.click_text_state=2
