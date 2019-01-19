extends KinematicBody2D
class_name Player
signal die

var game 
var gravity=1400
var velocity=Vector2()
var runSpeed=500
var jumpSpeed=600

var state=""  # normal slide die
var isRun=false

#实现提前几帧按下按键的效果
var lastPressedAction="" #最后按下的动作
var lastPressedTimer=0
var lastPressedTime=0.15
func setLastPressed(action):
	lastPressedAction=action
	lastPressedTimer=lastPressedTime
	pass


#slide 属性
var slide_timer=0
var slide_time=0.7


#磁铁
var isMagnent=false setget set_isMagnent
func set_isMagnent(value):
	isMagnent=value
	match isMagnent:
		true:
			magnent_timer=magnent_time
			magnentAni.visible=true
		false:
			magnentAni.visible=false
var magnent_timer=0
var magnent_time=8
#盾
var isShield=false setget set_isShield
func set_isShield(value):
	isShield=value
	match isShield:
		true:
			shield_timer=shield_time
			shieldAni.visible=true
		false:
			shieldAni.visible=false
var shield_timer=0
var shield_time=8





func set_state(value):
	match state:
		"normal":
			normalShape.set_deferred("disabled",true)
			#normalShape.disabled=true
			pass
		"slide":
			aniSpr.offset.y=0
			pass
	
	state=value
	match state:
		"normal":
			normalShape.set_deferred("disabled",false)
			#normalShape.disabled=false
			pass
		"slide":
			slide_timer=slide_time
			aniSpr.play("slide")
			aniSpr.offset.y=15
		"die":
			collision_layer=0
			collision_mask=0
			$Area2D.collision_layer=0
			$Area2D.collision_mask=0
			velocity.y=-500
			aniSpr.play("jumpDown")
			rotation_degrees=-45
			#清楚磁铁效果
			if isMagnent:
				set_isMagnent(false)
			#发信号
			emit_signal("die")
			pass
			
#引用
onready var aniSpr=$AnimatedSprite
onready var shieldAni=$shieldAni
onready var magnentAni=$magnentAni
onready var normalShape=$Area2D/normalShape2
onready var slideShape=$Area2D/CollisionShape2D

#初始化
func _ready():
	start()
	
	
func start():
	game=Global.game
	set_state("normal")

func _physics_process(delta):
	#接受按键输入
	if Input.is_action_just_pressed("jump"):
		setLastPressed("jump")
	elif Input.is_action_just_pressed("down"):
		setLastPressed("down")
	
	
	velocity.x=0
	
	#重力加速度
	velocity.y+=gravity*delta
	
	
	match state:
		"normal":
			if is_on_floor() && lastPressedAction=="jump":
				velocity.y=-jumpSpeed
				lastPressedAction=""
			
			if is_on_floor() && lastPressedAction=="down":
				set_state("slide")
				lastPressedAction=""
			pass
		"slide":
			slide_timer-=delta
			if slide_timer<=0:
				set_state("normal")
			if is_on_floor() && lastPressedAction=="jump":
				velocity.y=-jumpSpeed
				set_state("normal")
			pass
		"die":
			velocity.x=-300
			
#	if Input.is_action_pressed("left"):
#		velocity.x=-runSpeed
#	elif Input.is_action_pressed("right"):
#		velocity.x=runSpeed
	if isRun:
		velocity.x=runSpeed
	
	#物理
	velocity=move_and_slide(velocity,Vector2(0,-1))
	#动画
	match state:
		"normal":
			if is_on_floor():
				if velocity.x!=0:
					aniSpr.play("run")
				else:
					aniSpr.play("idle")
			else:
				if velocity.y<0:
					aniSpr.play("jumpUp")
				else:
					aniSpr.play("jumpDown")
		"slide":
			
			pass
	#掉落死亡
	if state!="die":
		if position.y>850:
			set_state("die")
	
	#更新磁铁计时
	if isMagnent:
		magnent_timer-=delta
		if magnent_timer<=0:
			set_isMagnent(false)
	game.magnentLabel.text=String(magnent_timer)
	
	#更新盾牌计时
	if isShield:
		shield_timer-=delta
		if shield_timer<=0:
			set_isShield(false)
	game.shieldLabel.text=String(shield_timer)
	
	#更新最后按下按键
	if lastPressedAction!="":
		lastPressedTimer-=delta
		if lastPressedTimer<=0:
			lastPressedAction=""


#func _input(event):
#	print("input",str(event))
#	if event is InputEventAction:
#		if event.pressed:
#			if event.action=="jump":
#				setLastPressed("jump")
#				pass
#			if event.action=="down":
#				setLastPressed("down")
#				pass
#

func hit():
	print("hit")
	if isShield:
		return
	set_state("die")

