@tool
extends Node
enum ClickState{
	NONE,
	NEW_PAGE,
	CLICK_EOL
}
enum EventMode{
	NULL=0,
	WAIT_TIME=1,
	WAIT_VOICE=2,
	WAIT_CLICK=4,
	WAIT_SE=8,
	WAIT_SELECT=16
	
}
const MAX_BACK_INFO_COUNT:=100
const VOICE_WAIT_FRAME=120
const MAX_SE_CHANNELS=6
const CHAR_IMAGE_PATH="res://assets/char/"
const BG_IMAGE_PATH="res://assets/bak/"
const SCRIPT_PATH="res://assets/script/"
const SE_PATH="res://assets/se/"
const BGM_PATH="res://assets/bgm/"
const VOICE_PATH="res://assets/voice/"
const CG_IMAGE_PATH="res://assets/grp/"
const MV_PATH="res://assets/mv/"
enum Page{
	TITLE_MENU,
	GAME
}
const CHAR_POS={
	0:Vector2(-290,0),
	1:Vector2(0,0),
	2:Vector2(290,0),
	3:Vector2(-380,0),
	4:Vector2(380,0),
	10:Vector2(480,0),
	9:Vector2(160,0),
	8:Vector2(-160,0),
	7:Vector2(-480,0)
}
const CHAR_NAMES={
	1:"kaz",
	5:"mar",
	35:"miy",
	24:"aco",
	25:"mih",
	16:"you",
	20:"Sat",
	21:"hon",
	22:"nak",
	23:"say",
	27:"ueh",
	34:"saw",
	2:"set",
	3:"koh",
	4:"izu",
	10:"tak",
	12:"chi",
	11:"ioo",
	17:"tan",
	18:"shi",
	30:"ham",
	32:"kiz",
	33:"suz",
	19:"tom",
	13:"pap",
	14:"mam",
	15:"oto",
	31:"mat"
}
const CHAPTER=[
	[],
	[],
	[],
	[6001,6002,6003,6004,6005],
	[6101,6102,6103,6104],
]
var font_map=get_font_map()
func get_font_map():
	var file=FileAccess.open("res://assets/fonts/jp.txt",FileAccess.READ)
	var font_map=file.get_as_text()
	font_map=font_map.replace("\n","")
	print(font_map.length())
	file.close()
	return font_map
	
