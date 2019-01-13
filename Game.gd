extends Node2D
class_name Game
#分数
var score=0 setget set_score
func set_score(value):
	score=value
	scoreLabel.text=String(score)
#距离
var distance=0 setget set_distance
func set_distance(value):
	distance=value
	distanceLabel.text=String(distance)

#地板最右的位置
var floorRight=Vector2()


var tscn_floor=preload("res://floor/Floor.tscn")

onready var player=$Player
onready var cam=$cam
onready var distanceLabel=$uiLayer/distanceLabel
onready var scoreLabel=$uiLayer/scoreLabel
onready var magnentLabel=$uiLayer/magnentLabel
onready var shieldLabel=$uiLayer/shieldLabel
onready var bg=$BG
onready var floorPlace=$floorPlace
func _ready():
	Global.game=self
	start()
	pass 

func start():
	set_score(0)
	set_distance(0)
	player.start()
	cam.start(self,player)
	bg.start(cam)
	
	#获取第一块地板的位置
	floorRight=$floorPlace/Floor.get_rightPos()
	
	
	pass

func _physics_process(delta):
	if cam.get_camRight()>floorRight.x:
		#生成新的地板
		var fl=tscn_floor.instance()
		var y=rand_range(floorRight.y-160,580)
		var x=rand_range(floorRight.x+100,floorRight.x+300)
		fl.set_leftPos(Vector2(x,y))
		floorPlace.add_child(fl)
		floorRight=fl.get_rightPos()
		
		pass
	
	pass
