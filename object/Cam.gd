extends Node2D

var player
var startX
var game




var distance=0
func set_distance(value):
	if distance==value:
		return
	distance=value
	game.distance=distance
	

func start(game,player):
	self.game=game
	self.player=player
	
	position=player.position
	startX=position.x
	pass
	
func _physics_process(delta):
	if player.position.x>position.x:
		#更新距离
		position.x=player.position.x
		set_distance(floor((position.x-startX)/10))
	pass
func get_camLeft():
	return $Camera2D.get_camera_screen_center().x-1136/2
	pass
func get_camRight():
	return $Camera2D.get_camera_screen_center().x+1136/2
	pass