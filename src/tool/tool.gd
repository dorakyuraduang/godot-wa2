extends Node
func _ready():
	var bak_path="res://assets/bak/"
	var dir=DirAccess.open(bak_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var file_arr=[]
	while file_name != "":
		print(file_name)
		if file_name.ends_with(".tga"):
			var new_str=file_name
			new_str[0]="B"
			dir.rename(file_name,new_str)
		file_name = dir.get_next()
		#var file=FileAccess.open(bak_path+file_name,FileAccess.READ)
