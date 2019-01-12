extends KinematicBody2D


var gravity=900
var velocity=Vector2()
var runSpeed=500

var state=""  # normal slide 
#slide 属性
var slide_timer=0
var slide_time=0.8


func set_state(value):
	state=value
	match state:
		"normal":
			pass
		"slide":
			slide_timer=slide_time
			aniSpr.play("slide")
			pass
			
#引用
onready var aniSpr=$AnimatedSprite

func _ready():
	start()
	
func start():
	set_state("normal")

func _physics_process(delta):
	velocity.x=0
	
	#重力加速度
	velocity.y+=gravity*delta
	
	
	match state:
		"normal":
			if is_on_floor() && Input.is_action_just_pressed("jump"):
				velocity.y=-500
			if is_on_floor() && Input.is_action_just_pressed("down"):
				set_state("slide")
			pass
		"slide":
			pass
	
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
			slide_timer-=delta
			if slide_timer<=0:
				set_state("normal")
			pass
	
	
	
	pass