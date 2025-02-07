extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var HP = 500.0
var FullHP = 500.0
var hearts_array: Array[TextureRect]
var animation: AnimatedSprite2D
var cantakedmg = true
var time_takedame:Timer
var isRunning=false
var vectorRamdom:Vector2
const MAX_SPEED  = 30.0
func _ready():
	var hearts_list = $HBoxContainer
	animation = get_node("AnimatedSprite2D")
	time_takedame = $takeDame
	time_takedame.wait_time = 0.05
	time_takedame.timeout.connect(_on_takedmg_timeout)
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
			death()

func _on_takedmg_timeout() -> void:
	animation.visible = true
	if(animation.animation!="death"):
		cantakedmg = true  # Đặt lại cantakedmg sau khi hết thời gian chờ

func _update_display_HP() -> void:
	for i in range(hearts_array.size()):
		hearts_array[i].visible = i < int(ceil(HP / (FullHP / 6)))

func aniTakeDmg() -> void:
	cantakedmg = false  # Khi bị trúng đòn, không cho nhận sát thương nữa
	animation.visible = false
	time_takedame.start()

func death() -> void:
	animation.play("death")
	var timedeath = $TimerDie
	timedeath.wait_time = 1
	timedeath.timeout.connect(_on_timedeath)
	timedeath.start()

func _on_timedeath() -> void:
	queue_free()

func get_random_position_in_area() -> Vector2:
	# Lấy CollisionShape2D của Area2D
	var collision_shape = $view/CollisionShape2D
	# Kiểm tra nếu collider là CircleShape2D
	var circle_shape = collision_shape.shape as CircleShape2D
	var radius = circle_shape.radius
	print(radius)
	# Sinh một tọa độ ngẫu nhiên trong phạm vi vòng tròn
	var random_angle = randf_range(0, 2 * PI)
	var random_radius = randf_range(0, radius)

	# Chuyển đổi từ cực sang tọa độ Cartesian (x, y)
	var random_x = random_radius * cos(random_angle)
	var random_y = random_radius * sin(random_angle)

	# Trả về vị trí ngẫu nhiên tính từ tâm của Area2D
	return Vector2(random_x+position.x, random_y+position.y)
func _physics_process(delta: float) -> void:
	var global_position = get_global_transform()
	if(isRunning!=true):
		vectorRamdom = get_random_position_in_area()
		isRunning=true;
	var direction = (vectorRamdom - position).normalized()
	position+=direction*MAX_SPEED*delta
	move_and_slide()
	if position.distance_to(vectorRamdom) < 1:
		print("ok")
		position = vectorRamdom
		isRunning=false
func _on_body_body_exited(body: Node2D) -> void:
	if body.is_in_group("wall"):
		print("wallll")
		vectorRamdom=position
		isRunning=false;
func _on_body_body_entered(body: Node2D) -> void:
	if body.is_in_group("wall"):
		print("wallll")
		vectorRamdom=position
		isRunning=false;
