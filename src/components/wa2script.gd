extends Resource
class_name Wa2Script
var bnr_buf:PackedByteArray
var str_args=[]
var offset:=0
func load(id:int):
	offset=0
	var path="%s%04d.bnr"%[Consts.SCRIPT_PATH,id]
	bnr_buf=FileAccess.get_file_as_bytes(path)
	var txt_str=FileAccess.get_file_as_string("%s%04d.txt"%[Consts.SCRIPT_PATH,id])
	str_args=txt_str.split(",")
	start()
func start():
	offset+=4
	var a=read_int()
	var b=read_int()
	var bx=0
	if b>0:
		var d=0
		while bx<b:
			var c=read_int()
			d=read_int()
			bx+=1
		offset=d
func read_int():
	var u32=bnr_buf.decode_u32(offset)
	offset+=4
	return u32
func read_float():
	var f32=bnr_buf.decode_float(offset)
	offset+=4
	return f32

