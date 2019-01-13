extends Node2D



func _ready():
	$Area2D.connect("area_entered",self,"on_body_enterd")
	pass # Replace with function body.

func on_body_enterd(area):
	Global.game.player.hit()
	pass

