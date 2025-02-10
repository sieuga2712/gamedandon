extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var HP = 500.0
var FullHP = 500.0
var hearts_array: Array[TextureRect]
var animation: AnimatedSprite2D
var cantakedmg = true
var time_takedame:Timer
var timedeath:Timer
var timeRamdoRun:Timer
var isRunning=false
var vectorRamdom:Vector2
const MAX_SPEED  = 30.0
var colli:CollisionShape2D
var direction_ani="B"
var type_ani="idle"

@export var player:Node2D
var nav_agent:NavigationAgent2D
func _ready():
	var hearts_list = $HBoxContainer
	nav_agent=$NavigationAgent2D
	colli=$CollisionShape2D
	animation = get_node("AnimatedSprite2D")
	animation.play(type_ani+"_"+direction_ani)
	time_takedame = $takeDame
	timedeath = $TimerDie
	timeRamdoRun=$ramdomrun
	nav_agent.target_position= get_random_position_in_area()
	for child in hearts_list.get_children():
		hearts_array.append(child)
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		takeDame()
func takeDame() -> void:
	if cantakedmg:
		HP -= 30.0
		if HP > 0:
			_update_display_HP()
			aniTakeDmg()
		else:
			cantakedmg = false
			_update_display_HP()
			call_deferred("death")
func _update_display_HP() -> void:
	for i in range(hearts_array.size()):
		hearts_array[i].visible = i < int(ceil(HP / (FullHP / 6)))

func aniTakeDmg() -> void:
	cantakedmg = false  # Khi bị trúng đòn, không cho nhận sát thương nữa
	animation.visible = false
	time_takedame.start()

func death() -> void:
	animation.play("death")
	velocity = Vector2.ZERO
	move_and_slide()
	colli.disabled=true
	timedeath.start()

func get_random_position_in_area() -> Vector2:
	var collision_shape = $view/CollisionShape2D
	var circle_shape = collision_shape.shape as CircleShape2D
	var radius = circle_shape.radius
	var random_angle = randf_range(0, 2 * PI)
	var random_radius = randf_range(0, radius)
	var random_x = random_radius * cos(random_angle)
	var random_y = random_radius * sin(random_angle)
	return Vector2(random_x+position.x, random_y+position.y)
func _physics_process(delta: float) -> void:
	var global_position = get_global_transform()
	var distance_to_target = position.distance_to(nav_agent.target_position)

	if animation.animation!="death":
		update_animation()
		animation.play(type_ani+"_"+direction_ani)
		if distance_to_target > 3:
			var direction = (nav_agent.target_position - position).normalized()
			velocity = direction * SPEED
			move_and_slide()
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			if timeRamdoRun.is_stopped():
				timeRamdoRun.start()
func _on_ramdomrun_timeout() -> void:
	nav_agent.target_position= get_random_position_in_area()
	var random = randi_range(1, 1)
	timeRamdoRun.wait_time=random
	#nav_agent.target_position= player.position
func _on_timer_die_timeout() -> void:
	queue_free()
func _on_take_dame_timeout() -> void:
	animation.visible = true
	if(animation.animation!="death"):
		cantakedmg = true
func update_animation()-> void:
	if velocity.x==0 and velocity.y==0:
		type_ani="idle"
	if velocity.x!=0 or velocity.y!=0:
		type_ani="walk"
	print("x: "+str(velocity.x))
	print("y: "+str(velocity.y))
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
	print("type_ani: "+type_ani)
	print("direction_ani: "+direction_ani)
	
	
