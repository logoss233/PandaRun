extends Node2D

var soundArray=[
	"collect_coin_03.wav",
	"collect_coin_04.wav",
	"collect_coin_05.wav"
]
var speed=800 #被磁铁吸引的速度
var magnent_distance=800 #吸引范围



func _ready():
	$Area2D.connect("area_entered",self,"eat")
	
func eat(area):
	#随机播放一种声音
	var index=floor(rand_range(0,3))
	var sound=soundArray[index]
	Sound.playEffect(sound)
	#生成特效
	var effect=load("res://effect/eatEffect.tscn").instance()
	get_parent().add_child(effect)
	effect.position=position
	#得分
	Global.game.score+=10
	queue_free()
	
	
func _physics_process(delta):
	var player=Global.game.player as Player
	if player==null:
		return 
	if player.isMagnent:
		var distance=(player.position-position).length()
		if distance<=magnent_distance:
			var dir=(player.position-position).normalized()
			position+=dir*speed*delta
		pass