extends Node
func get_bg_path(id,type,no)->String:
	return "%sB%04d%01d%01d.tga"%[Consts.BG_IMAGE_PATH,id,no,type]
func get_cg_path(id,no)->String:
	return "%sv%05d%01d.tga"%[Consts.CG_IMAGE_PATH,id,no]
func get_se_stream(id:int):
	if ResourceLoader.exists("%sSE_%04d.WAV"%[Consts.SE_PATH,id]):
		return load("%sSE_%04d.WAV"%[Consts.SE_PATH,id])
	else:
		return load("%sSE_%04d.OGG"%[Consts.SE_PATH,id])
func get_bgm_stream( id:int,loop:=false):
	if ResourceLoader.exists("%sBGM_%03d.OGG"%[Consts.BGM_PATH,id]):
		return load("%sBGM_%03d.OGG"%[Consts.BGM_PATH,id])
	else:	
		if !loop:
			return load("%sBGM_%03d_A.OGG"%[Consts.BGM_PATH,id])
		else:
			return load("%sBGM_%03d_B.OGG"%[Consts.BGM_PATH,id])
func get_voice_stream(file_name:String):
	return load("%s%s"%[Consts.VOICE_PATH,file_name])
func get_char_image(char:int,id:int):
	print("%s%s%06d.tga"%[Consts.CHAR_IMAGE_PATH,Consts.CHAR_NAMES[char],id])
	return load("%s%s%06d.tga"%[Consts.CHAR_IMAGE_PATH,Consts.CHAR_NAMES[char],id]).get_image()
