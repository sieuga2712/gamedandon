extends CharacterBody2D


const MAX_SPEED  = 300.0
const ACCELERATION = 1000.0
const DECELERATION = 1000.0

const JUMP_VELOCITY = -400.0
var animation: AnimatedSprite2D
var bullet_path=preload("res://scenes/bullet1.tscn")
var bullet_reload=false;
@onready var timer = Timer.new()
func _ready():
	animation=$AnimatedSprite2D
	animation.play("fly")
	timer.wait_time = 0.1
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
func _on_timer_timeout() -> void:
	bullet_reload=false
func _physics_process(delta: float) -> void:
	
	var mouse_position = get_global_mouse_position()
	var global_position = get_global_transform()
	
	look_at(get_global_mouse_position())
	rotation += deg_to_rad(90)
	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	if direction_x != 0:
		velocity.x = move_toward(velocity.x, direction_x * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	if direction_y != 0:
		velocity.y = move_toward(velocity.y, direction_y * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATION * delta)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire()
	move_and_slide()
	
func fire():
	if bullet_reload==false:
		var bullet=bullet_path.instantiate()
		bullet.dir=rotation
		var random = randi_range(0, 1)
		if random==1:
			bullet.pos=$Node2D.global_position
			bullet.rota=global_rotation
		if random==0:
			bullet.pos=$Node2D2.global_position
			bullet.rota=global_rotation
		bullet_reload=true
		timer.start()
		get_parent().add_child(bullet)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body==$"../TileMap":
		print("wall")
