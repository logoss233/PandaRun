extends ItemBase

var eatSound="collect_item_14.wav"
func _ready():
	$Area2D.connect("area_entered",self,"eat")
	
func eat(area):
	#声音
	Sound.playEffect(eatSound)
	#生成特效
	var effect=load("res://effect/eatEffect.tscn").instance()
	get_parent().add_child(effect)
	effect.position=position
	#效果
	Global.game.player.isMagnent=true
	
	queue_free()
	