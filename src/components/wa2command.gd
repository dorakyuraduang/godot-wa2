extends RefCounted
class_name Wa2Command
var args=[]
var fn:Callable
func execute_command():
	fn.callv(args)
	return true
