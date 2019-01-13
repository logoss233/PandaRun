extends StaticBody2D


func get_rightPos():
	return $rightPos.global_position
	
func set_leftPos(pos):
	position=pos-$leftPos.position