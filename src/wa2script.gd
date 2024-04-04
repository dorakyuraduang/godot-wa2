extends Node
class_name Wa2Script
var bnr_buf:PackedByteArray
var offset:=0
var args=[]
var str_args=[]
func load(id:int,_offset=0):
	var path="%s%04d.bnr"%[Consts.SCRIPT_PATH,id]
	bnr_buf=FileAccess.get_file_as_bytes(path)
	var txt_str=FileAccess.get_file_as_string("%s%04d.txt"%[Consts.SCRIPT_PATH,id])
	str_args=txt_str.split(",")
	start()
	offset=_offset
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

func parse_command():
	Globals.cur_command=null
	var parse_end:=false
	var args:Array
	var cb:Callable
	while (!parse_end and offset<bnr_buf.size()):
		match Ws.read_int():
			6:
				match read_int():
					0x1e:
						args=[]
					0x10:
						var a=args.pop_back()
						args[args.size()-1]+=a
					0x17:
						args[args.size()-1]*=-1
			3:
				args.append(str_args[read_int()])
			5:
				match read_int():
					3:
						args.append(read_int())
					4:
						args.append(read_float())
			4:
				var func_idx=read_int()
				if Globals.func_lut.has(func_idx):
					cb=Globals.func_lut[func_idx]
				parse_end=true
	if cb:
		print(args)
		Globals.cur_command=cb.bindv(args)
