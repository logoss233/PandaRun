# --------------------------------------------  
# 声音管理 v1.0
# By NPC  18-5-22
# 把Sound设置成自动启动，做成单例模式，
# 用Sound.playMusic(name) 和Sound.playEffect(name)来播放音乐和音效
# name参数是字符串，声音文件的名字，比如“hit.wav”
#自己可以更改MUSIC_PATH,EFFECT_PATH的路径，这是存放声音文件的路径
#可以设置静音，可设置总音量，也可以分别设置音乐和音效的音量
#用mute,musicMute,effectMute来设置静音
#用volume,musicVolume,effectVolume来设置音量，音量是范围是0-1
#用volume_changed信号可以获取UI更新时机
# ---------------------------------------------  

extends Node
const MUSIC_PATH="res://sound/Music" #音乐文件存放路径
const EFFECT_PATH="res://sound/SE" #音效文件存放路径

signal volume_changed #当音量改变或者静音状态改变时发射信号

var mute=false setget mute_set #整体是否静音
func mute_set(value):
	mute=value
	_update_Volume()
	emit_signal("volume_changed")
var volume=1 setget volume_set #整体的音量
func volume_set(value):
	volume=clamp(value,0,1)
	_update_Volume()
	emit_signal("volume_changed")

var musicPlayer #控制音乐播放的播放器
var lastMusic="" #最后一个播放的音乐的名字，如果正在播放，就是当前播放的音乐名字
var musicIsPlaying setget ,musicIsPlaying_get #音乐是否在播放
func musicIsPlaying_get():
	return musicPlayer.playing
var currentMusic="" setget ,currentMusic_get #当前正在播放的音乐的名字，如果没有再播放，就为“”
func currentMusic_get():
	var result=""
	if musicIsPlaying_get():
		result=lastMusic
	return result
var musicMute=false setget musicMute_set #音乐是否静音
func musicMute_set(value):
	musicMute=value
	_update_musicVolume()
	emit_signal("volume_changed")
var musicVolume=1 setget musicVolume_set #音乐的音量
func musicVolume_set(value):
	musicVolume=clamp(value,0,1)
	_update_musicVolume()
	emit_signal("volume_changed")


var effectPlayers=[] #音效播放器,有多个
var effectMute=false setget effectMute_set#音效是否静音
func effectMute_set(value):
	effectMute=value
	_update_effectVolume()
	emit_signal("volume_changed")

var effectVolume=1 setget effectVolume_set#音效的音量
func effectVolume_set(value):
	effectVolume=clamp(value,0,1)
	_update_effectVolume()
	emit_signal("volume_changed")



func _ready():
	musicPlayer=AudioStreamPlayer.new()
	add_child(musicPlayer)
	musicPlayer.connect("finished",self,"_on_music_finished")
	
	
	
	
func stopAll():#停止全部声音的播放
	stopMusic()
	stopEffect()
#播放音乐
func playMusic(name):
	#有音乐在播放时，如果播放相同的音乐，就不做处理
	if musicIsPlaying_get() &&lastMusic==name:
		return
	#保存最后播放的音乐
	lastMusic=name
	#load并播放
	var path
	if MUSIC_PATH=="res://":
		path=MUSIC_PATH+name
	else:
		path=MUSIC_PATH+"/"+name
	musicPlayer.stream=load(path)
	musicPlayer.play()
func stopMusic():
	musicPlayer.stop()
func _on_music_finished():#如果忘了手动设置循环播放，依然可以循环播放音乐
	playMusic(lastMusic)
	
	
#播放音效
func playEffect(name):
	#检查有没有闲置的音效播放器
	var effectPlayer=null
	for p in effectPlayers:
		if !p.playing:
			effectPlayer=p
			break
	if effectPlayer==null:#找到了闲置的播放器
		effectPlayer=_effectPlayerAdd()
	_effectPlayerPlay(effectPlayer,name)
func stopEffect():#停止所有音效
	for p in effectPlayers:
		p.stop()
func _effectPlayerAdd():#添加新的效果播放器
	var effectPlayer=AudioStreamPlayer.new()
	add_child(effectPlayer)
	_update_effectVolumeSingle(effectPlayer)
	effectPlayers.append(effectPlayer)
	return effectPlayer
func _effectPlayerPlay(effectPlayer,effectName):#控制一个效果播放器播放音效
	var path
	if EFFECT_PATH=="res://":
		path=EFFECT_PATH+effectName
	else:
		path=EFFECT_PATH+"/"+effectName
	effectPlayer.stream=load(path)
	effectPlayer.play()


func _update_Volume():
	_update_musicVolume()
	_update_effectVolume()
	
func _update_musicVolume():#根据状态来改变音乐播放器的分贝
	if mute||musicMute:
		musicPlayer.volume_db=-80
	else:
		if volume==0||musicVolume==0:
			musicPlayer.volume_db=-80
		else:
			var v=volume*musicVolume
			musicPlayer.volume_db=10*log(v)/log(10)
func _update_effectVolume():
	for p in effectPlayers:
		_update_effectVolumeSingle(p)
func _update_effectVolumeSingle(effectPlayer):
	if mute||effectMute:
		effectPlayer.volume_db=-80
	else:
		if volume==0 ||effectVolume==0:
			effectPlayer.volume_db=-80
		else:
			var v=volume*effectVolume
			effectPlayer.volume_db=10*log(v)/log(10)
