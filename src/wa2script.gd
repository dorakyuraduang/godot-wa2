extends Node
class_name Wa2Script
#0x061b数组
#0x0608==
#0x01 flag数值增加
var bnr_buf:PackedByteArray
var offset:=0
var args=[]
var str_args=[]
var ws_id:=""
func load(id:String,_offset=0):
	offset=0
	ws_id=id
	var path="%s%s.bnr"%[Consts.SCRIPT_PATH,id]
	bnr_buf=FileAccess.get_file_as_bytes(path)
	var txt_str=FileAccess.get_file_as_string("%s%s.txt"%[Consts.SCRIPT_PATH,id])
	str_args=txt_str.split(",")
	start()
	if _offset:
		offset=_offset
func start():
	offset+=4
	var a=read_int()
	var b=read_int()
	Globals.jump_flag=false
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
	var cb:Callable
	while (!parse_end and offset<bnr_buf.size()):
		match Ws.read_int():
			0:
				match read_int():
					2:
						Globals.offsets[0]=read_int()
						Globals.offsets[1]=read_int()
					4:
						if !Globals.jump_flag:
							Ws.offset=Globals.offsets[1]
						parse_end=true
					0x0d:
						if Globals.jump_flag:
							Ws.offset=Globals.offsets[0]
							parse_end=true
					1:
						parse_end=true
						
			1:
				var ref=ArrayRef.new()
				ref.array=Globals.flags
				ref.index=read_int()
				args.append(ref)
			2:
				read_int()
				var ref=ArrayRef.new()
				ref.array=Globals.arr
				args.append(ref)
			6:
				match read_int():
					0:
						if args.size()<2:
							parse_end=true
							return
						var a=args.pop_back()
						var b=args.pop_back()
						if a is ArrayRef:
							a=a.value()
						b.set_value(a)
						parse_end=true
					0x1:
						print(args)
						var a=args.pop_back()
						var b=args.pop_back()
						
						b.add_value(a)
						parse_end=true
					0x8:
						var a=args.pop_back()
						var b=args.pop_back()
						if b is ArrayRef:
							b=b.value()
						if a is ArrayRef:
							a=a.value()
						Globals.jump_flag=bool(a==b)
					0x1b:
						print(args)
						var index=args.pop_back()
						var ref=args.back()
						ref.index=index
					0x1e:
						args=[]
					0x10:
						
						var a=args.pop_back()
						var b=args.back()
						if a is ArrayRef:
							a=a.value()
						if b is ArrayRef:
							b=b.value()
						else:
							args.pop_back()
						b+=a
						args.append(b)
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
				else:
					print("未实装函数："+str(func_idx))
					print(args)
				parse_end=true
	if cb:
		print(args)
		print(cb)
		Globals.cur_command=cb.bindv(args)
