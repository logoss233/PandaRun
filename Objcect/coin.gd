extends Node2D

var soundArray=[
	"collect_coin_03.wav",
	"collect_coin_04.wav",
	"collect_coin_05.wav"
]

func _ready():
	$Area2D.connect("body_entered",self,"eat")
	
func eat(body):
	#随机播放一种声音
	var index=floor(rand_range(0,3))
	print(index)
	var sound=soundArray[index]
	Sound.playEffect(sound)
	#生成特效
	var effect=load("res://effect/eatEffect.tscn").instance()
	get_parent().add_child(effect)
	effect.position=position
	#得分
	Global.game.score+=10
	queue_free()
	