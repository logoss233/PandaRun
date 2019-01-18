extends Node2D


var game
func _ready():
	startGame()
	pass # Replace with function body.

func startGame():
	game=load("res://Game.tscn").instance()
	add_child(game)
	game.connect("restart",self,"restart")

func restart():
	game.queue_free()
	startGame()