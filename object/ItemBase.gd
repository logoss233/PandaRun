extends Node2D
class_name ItemBase

func _process(delta):
	var cam=Global.cam
	if cam==null:
		return
	if position.x<cam.get_camLeft()-30:
		queue_free()
	
	
	pass