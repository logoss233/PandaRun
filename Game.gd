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
var floorRight=0


var tscn_floor=preload("res://floor/Floor.tscn")

onready var player=$Player
onready var cam=$cam
onready var distanceLabel=$uiLayer/distanceLabel
onready var scoreLabel=$uiLayer/scoreLabel
onready var magnentLabel=$uiLayer/magnentLabel
onready var shieldLabel=$uiLayer/shieldLabel
onready var bg=$BG
onready var floorPlace=$floorPlace
onready var tileParser=$TileParser
func _ready():
	randomize()
	Global.game=self
	
	start()
	pass 

func start():
	set_score(0)
	set_distance(0)
	player.start()
	cam.start(self,player)
	bg.start(cam)
	tileParser.start(floorPlace)
	
	
	createFloor(0)
	
	
	pass

func _physics_process(delta):
	if cam.get_camRight()>floorRight-100:
		var lv=floor(distance/5000)+1
		createFloor(lv)

#生成新的地板,根据等级
func createFloor(lv):
	if lv>GameData.mapLab.size()-1:
		lv=GameData.mapLab.size()-1
	var mapList=GameData.mapLab[lv]
	
	var index=floor(rand_range(0,mapList.size()))
	var mapData=mapList[index]
	floorRight=tileParser.parse(mapData,floorRight)
	
	pass