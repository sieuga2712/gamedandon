extends CharacterBody2D
var pos:Vector2
var rota:float
var dir:float
var speed=500
var animation: AnimatedSprite2D
@onready var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	animation=get_node("AnimatedSprite2D")
	animation.play("bullet")
	animation.animation_finished.connect(animated_boom)
	global_position=pos
	global_rotation=rota
	timer.wait_time =4 
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
func _on_timer_timeout() -> void:
	animation.play("boom")
	animation.scale=Vector2(0.7, 0.7)
func animated_boom():
	if animation.animation=="boom":
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animation.animation!="boom":
		velocity=Vector2(speed,0).rotated(dir)
	if animation.animation=="boom":
		velocity = Vector2(0, 0)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body!=$"../CharacterBody2D":
		animation.play("boom")
		animation.scale=Vector2(0.7, 0.7)

	
	
