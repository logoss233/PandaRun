extends Node2D
class_name Game
signal restart

#状态
var state="" setget set_state  #ready 准备阶段   run 运行阶段  end 结束阶段
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
var last_mapData=null #防止重复场景
const levelChangeDistance=1000

onready var player=$Player
onready var cam=$cam
onready var distanceLabel=$uiLayer/distanceLabel
onready var scoreLabel=$uiLayer/scoreLabel
onready var magnentLabel=$uiLayer/magnentLabel
onready var shieldLabel=$uiLayer/shieldLabel
onready var bg=$BG
onready var floorPlace=$floorPlace
onready var tileParser=$TileParser
onready var beginUI=$uiLayer/beginUI
onready var endUI=$uiLayer/endUI
#------------set -----
func set_state(value):
	match state:
		"ready":
			beginUI.visible=false
		"run":
			player.isRun=false
	state=value
	match state:
		"ready":
			beginUI.visible=true
			pass
		"run":
			player.isRun=true
			pass
		"end":
			endUI.visible=true
			pass
#-----------初始化------
func _ready():
	randomize()
	Global.game=self
	
	start()
	pass 

func start():
	set_state("ready")
	set_score(0)
	set_distance(0)
	
	player.connect("die",self,"onDie")
	player.start()
	
	
	cam.start(self,player)
	bg.start(cam)
	tileParser.start(floorPlace)
	
	createFloor(0)
	
	
	pass

#--------------------回调---------------
func _physics_process(delta):
	if state=="ready":
		if Input.is_action_just_pressed("ui_accept"):
			set_state("run")
	elif state=="run":
		if cam.get_camRight()>floorRight-100:
			var level=floor(distance/levelChangeDistance)+1
			var lv=chooseLv(level)
			createFloor(lv)
	elif state=="end":
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("restart")
func onDie():
	set_state("end")
	pass


#------------辅助--------------
#生成新的地板,根据等级
func createFloor(lv):
	print(lv)
	if lv>GameData.mapLab.size()-1:
		lv=GameData.mapLab.size()-1
	var mapList=GameData.mapLab[lv]
	
	
	var index=floor(rand_range(0,mapList.size()))
	var mapData=mapList[index]
	if mapData==last_mapData:
		index=floor(rand_range(0,mapList.size()))
		mapData=mapList[index]
	last_mapData=mapData
	
	
	floorRight=tileParser.parse(mapData,floorRight)
	
	pass
func chooseLv(level):
	var lv=0
	var r=randf()
	if level==1:
		if r<0.7:
			lv=1
		else:
			lv=2
			
	elif level==2:
		if r<0.4:
			lv=1
		elif r<0.8:
			lv=2
		else:
			lv=3
			
	elif level==3:
		if r<0.2:
			lv=1
		elif r<0.6:
			lv=2
		else:
			lv=3
			
	elif level==4:
		if r<0.1:
			lv=1
		elif r<0.5:
			lv=2
		else:
			lv=3

	elif level==5:
		if r<0.4:
			lv=2
		else:
			lv=3
	elif level==6:
		if r<0.3:
			lv=2
		elif r<0.8:
			lv=3
		else:
			lv=4
	elif level==7:
		if r<0.2:
			lv=2
		elif r<0.6:
			lv=3
		else:
			lv=4
	elif level==8:
		if r<0.4:
			lv=3
		else:
			lv=4
	elif level==9:
		if r<0.3:
			lv=3
		else:
			lv=4
	elif level==10:
		if r<0.2:
			lv=3
		else:
			lv=4
	else:
		lv=4
	return lv
