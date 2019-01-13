extends KinematicBody2D
class_name Player

var game 
var gravity=1100
var velocity=Vector2()
var runSpeed=500
var jumpSpeed=600

var state=""  # normal slide die
#slide 属性
var slide_timer=0
var slide_time=0.7
var slide_cd=0.2
var slide_cd_timer=0

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
var magnent_time=5
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
var shield_time=5





func set_state(value):
	match state:
		"normal":
			normalShape.disabled=true
			pass
		"slide":
			slide_cd_timer=slide_cd
			aniSpr.offset.y=0
			pass
	
	state=value
	match state:
		"normal":
			normalShape.disabled=false
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
			pass
			
#引用
onready var aniSpr=$AnimatedSprite
onready var shieldAni=$shieldAni
onready var magnentAni=$magnentAni
onready var normalShape=$Area2D/normalShape2
onready var slideShape=$Area2D/CollisionShape2D



func _ready():
	start()
	
	
func start():
	game=Global.game
	set_state("normal")

func _physics_process(delta):
	velocity.x=0
	
	#重力加速度
	velocity.y+=gravity*delta
	
	
	match state:
		"normal":
			if is_on_floor() && Input.is_action_just_pressed("jump"):
				velocity.y=-jumpSpeed
			
			slide_cd_timer-=delta
			if slide_cd_timer<=0 && is_on_floor() && Input.is_action_just_pressed("down"):
				set_state("slide")
			pass
		"slide":
			slide_timer-=delta
			if slide_timer<=0:
				set_state("normal")
			if is_on_floor() && Input.is_action_just_pressed("jump"):
				velocity.y=-jumpSpeed
				set_state("normal")
			pass
		"die":
			velocity.x=-300
			
	if Input.is_action_pressed("left"):
		velocity.x=-runSpeed
	elif Input.is_action_pressed("right"):
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


func hit():
	print("hit")
	if isShield:
		return
	set_state("die")
