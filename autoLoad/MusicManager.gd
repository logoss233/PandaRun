extends Node

var startMusic=preload("res://sound/Music/Platform Action LOOP START.wav")
var endMusic=preload("res://sound/Music/Platform Action LOOP END.wav")
var loopA=preload("res://sound/Music/Platform Action LOOP A.wav")
var loopB=preload("res://sound/Music/Platform Action LOOP B.wav")
var loopC=preload("res://sound/Music/Platform Action LOOP C.wav")
var loopList=[]


onready var audioPlayer=$AudioStreamPlayer
func _ready():
	loopList=[loopA,loopB,loopC]
	audioPlayer.connect("finished",self,"onMusicFinished")
	pass


func play(music):
	audioPlayer.stream=music
	audioPlayer.play()
	pass
func playRandomLoop():
	var index=rand_range(0,loopList.size())
	var music=loopList[index]
	play(music)
	
func begin():
	play(startMusic)
	pass


func end():
	play(endMusic)
	pass
	
func onMusicFinished():
	if audioPlayer.stream==startMusic:
		playRandomLoop()
	elif audioPlayer.stream==endMusic:
		pass
	else:
		playRandomLoop()
	