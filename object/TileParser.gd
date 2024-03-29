extends Node2D

var tscn_tiles=[]
var tscn_coin=preload("res://object/eatItem/coin.tscn")
var tscn_magnent=preload("res://object/eatItem/Magnent.tscn")
var tscn_shield=preload("res://object/eatItem/Shield.tscn")
var tscn_stab=preload("res://object/damageItem/Stab.tscn")
var tscn_ball1=preload("res://object/damageItem/Ball1.tscn")
var tscn_ball2=preload("res://object/damageItem/Ball2.tscn")

var itemPlace #生成物品放置的位置
var startX #生成物品其实X
#一次解析最多生成一个磁铁和一个盾牌
var hasMagnent=false
var hasShield=false
func _ready():
	randomize()
	for i in range(8):
		var path="res://object/tile/tile"+String(i+1)+".tscn"
		tscn_tiles.append(load(path))

func start(itemPlace):
	self.itemPlace=itemPlace
	pass

#解析地图数据，返回floorRight
func parse(jsonObj,startX):
	hasMagnent=false
	hasShield=false
	self.startX=startX
	
	for layer in jsonObj.layers:
		parseLayer(layer)
		
	var floorRight=startX+jsonObj.width*64
	return floorRight
	
func parseLayer(layer):
	if layer.type=="tilelayer":
		parseTileLayer(layer)
	elif layer.type=="objectgroup":
		parseObjectLayer(layer)
func parseTileLayer(layer):
	var data=layer.data
	var width=layer.width
	for i in data.size():
		#拿出数据
		var d=data[i]
		#0是空的 不处理
		if d==0:
			continue
		var xx=floor(i%int(width))
		var yy=floor(i/int(width))
		var tscn=chooseTscn(d)
		if tscn==null:
			continue
		var tile=tscn.instance()
		itemPlace.add_child(tile)
		tile.position=Vector2(startX+xx*64+32,yy*64+32)


func parseObjectLayer(layer):
	for obj in layer.objects:
		var tscn=chooseTscn(obj.gid)
		if tscn==null:
			continue
		var item=tscn.instance()
		itemPlace.add_child(item)
		var x=startX+obj.x+0.5*obj.width
		var y=obj.y-0.5*obj.height
		item.position=Vector2(x,y)


func chooseTscn(id):
	#根据id来拿出资源
	var tscn
	if id<=8:
		#普通砖块有一定概率变成带叶子的砖块
		if int(id)%2==1 && randf()<0.2:
			id+=1
		tscn=tscn_tiles[id-1]
	elif id==9:
		#金币  有2%的概率变成磁铁，2%的概率变成盾牌
		var r=randf()
		if r<0.005 && !hasMagnent:
			tscn=tscn_magnent
			hasMagnent=true
		elif r<0.01 && !hasShield:
			tscn=tscn_shield
			hasShield=true
		else:
			tscn=tscn_coin
	elif id==11:
		#刺
		tscn=tscn_stab
	elif id==10:
		#球
		if randf()<0.5:
			tscn=tscn_ball1
		else:
			tscn=tscn_ball2
		pass
	return tscn