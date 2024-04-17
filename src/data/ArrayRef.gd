extends RefCounted
class_name ArrayRef
var array:Array
var index:int=0
func set_value(value):
	array[index]=value
func add_value(value):
	array[index]+=value
func value():
	return array[index]
