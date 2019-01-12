extends Node2D
class_name Game
var score=0 setget set_score

func set_score(value):
	score=value
	scoreLabel.text=String(score)
onready var scoreLabel=$uiLayer/scoreLabel
func _ready():
	start()
	pass # Replace with function body.

func start():
	Global.game=self
	set_score(0)
	pass