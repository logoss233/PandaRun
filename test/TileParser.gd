extends Node2D


func _ready():
	parse()
	pass 



func parse():
	var file=File.new()
	if !file.file_exists("res://map/1.json"):
		return
	file.open("res://map/1.json",File.READ)
	var txt=file.get_as_text()
	var jsonObj=parse_json(txt)
	
