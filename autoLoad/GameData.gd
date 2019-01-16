extends Node




var mapLab=[]

func _ready():
	loadMap()
	
	pass
	
func loadMap():
	var dir = Directory.new()
	var path="res://map"
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				#解析单个文件
				
				
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
