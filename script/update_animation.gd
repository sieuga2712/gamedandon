extends Node


static func update_animation(velocity:Vector2,)-> String:
	var type_ani='idle'
	var direction_ani='B'
	if velocity.x==0 and velocity.y==0:
		type_ani="idle"
	if velocity.x!=0 or velocity.y!=0:
		type_ani="walk"
	if abs(velocity.x)>=abs(velocity.y):
		if velocity.x>0 :
			direction_ani="R"
		if velocity.x<0:
			direction_ani="L"
	else:
		if velocity.y>0 :
			direction_ani="B"
		if velocity.y<0:
			direction_ani="T"
	return type_ani+"_"+direction_ani
	
