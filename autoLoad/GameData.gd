extends Node

const mapPath="res://map"

#mapLab结构
#[
#	[map,map,map]   等级0的地图数组
#	[map,map,map]   等级1的地图数组
#]
var mapLab=[] 



func _ready():
	loadMap()
	
	pass

func loadMap():
	var dir = Directory.new()
	var path=mapPath
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				loadMap_singleFile(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
func loadMap_singleFile(file_name):
	#解析单个文件
	var path=mapPath
	var file=File.new()
	file.open(path+"/"+file_name,File.READ)
	var txt=file.get_as_text()
	var jsonObj=parse_json(txt)
	
	var lv=int(file_name.split("-")[0])
	while mapLab.size()-1<lv:
		mapLab.append([])
	
	mapLab[lv].append(jsonObj)
	pass