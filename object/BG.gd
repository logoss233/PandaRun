extends Node2D


onready var spr1=$Sprite
onready var spr2=$Sprite2
var sprWidth=1300
var cam

func _ready():
	set_physics_process(false)
	pass
func start(cam):
	self.cam=cam
	set_physics_process(true)
	pass
	
func _physics_process(delta):
	if spr1.rect_position.x+sprWidth<cam.get_camLeft():
		spr1.rect_position.x=spr2.rect_position.x+sprWidth
	if spr2.rect_position.x+sprWidth<cam.get_camLeft():
		spr2.rect_position.x=spr1.rect_position.x+sprWidth
	pass
