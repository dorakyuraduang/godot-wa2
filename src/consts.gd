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
	WAIT_SE=8
	
}
const MAX_BACK_INFO_COUNT:=100
const VOICE_WAIT_FRAME=120
const MAX_SE_CHANNELS=4
const CHAR_IMAGE_PATH="res://assets/char/"
const BG_IMAGE_PATH="res://assets/bak/"
const SCRIPT_PATH="res://assets/script/"
const SE_PATH="res://assets/se/"
const BGM_PATH="res://assets/bgm/"
const VOICE_PATH="res://assets/voice/"
const CG_IMAGE_PATH="res://assets/grp/"
enum Page{
	TITLE_MENU,
	GAME
}
const CHAR_POS={
	0:Vector2(-290,0),
	1:Vector2(0,0),
	2:Vector2(290,0),
	3:Vector2(-380,0),
	4:Vector2(380,0)
}
const CHAR_NAMES={
	1:"kaz",
	35:"miy",
	16:"you",
	2:"set",
	10:"tak",
	11:"ioo",
	33:"suz",
	19:"tom",
	14:"mam",
	31:"mat"
}
const CHAPTER=[
	[],
	[],
	[],
	[6001,6002,6003,6004,6005],
	[6101,6102,6103,6104],
]
