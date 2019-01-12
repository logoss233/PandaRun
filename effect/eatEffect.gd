extends Node2D


func _ready():
	$AnimatedSprite.connect("animation_finished",self,"finish")
	$AnimatedSprite.play("default")
func finish():
	queue_free()
