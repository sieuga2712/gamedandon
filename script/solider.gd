extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var HP=5
var hearts_array:Array[TextureRect]
var animation: AnimatedSprite2D
var cantakedmg=true
func _ready():
	var hearts_list=$HBoxContainer
	animation=get_node("AnimatedSprite2D")
	for child in hearts_list.get_children():
		hearts_array.append(child)
		
func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(1)
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet")==true:
		takeDame()
func takeDame()-> void:
	if cantakedmg==true:
		HP-=1
		if HP>0:
			_update_display_HP()
			aniTakeDmg()
		else:
			_update_display_HP()
			death()
func _on_takedmg_timeout() -> void:
	animation.visible=true
	cantakedmg=true
func _update_display_HP()->void:	
	for i in range(hearts_array.size()):
				hearts_array[i].visible=i<HP	
func aniTakeDmg()->void:
	cantakedmg=false
	animation.visible=false
	var timer =$takeDame
	timer.wait_time =0.05
	timer.timeout.connect(_on_takedmg_timeout)
	add_child(timer)
	timer.start()		
func death()->void:
	cantakedmg=false
	animation.play("death")
	var timedeath=$TimerDie
	timedeath.wait_time =1
	timedeath.timeout.connect(_on_timedeateh)
	add_child(timedeath)
	timedeath.start()	
func _on_timedeateh()->void:
	queue_free()	
