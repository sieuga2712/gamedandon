extends CharacterBody2D

var Update_animation = preload("res://script/common/update_animation.gd")
var common = preload("res://script/common/common.gd")
const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var HP = 500.0
var FullHP = 500.0
var hearts_array: Array[TextureRect]
var animation: AnimatedSprite2D
var cantakedmg = true
var time_takedame: Timer
var timedeath: Timer
var timeRamdoRun: Timer
var colli: CollisionShape2D
var viewCollisionShappe:CollisionShape2D
@export var player: Node2D
var nav_agent: NavigationAgent2D
var trangthai=1
var valueState = preload("res://script/common/value_common.gd")
var State="idle"
func _ready():
	var hearts_list = $HBoxContainer
	nav_agent = $NavigationAgent2D
	colli = $CollisionShape2D
	animation = get_node("AnimatedSprite2D")
	animation.play("idle_B")
	time_takedame = $takeDame
	timedeath = $TimerDie
	timeRamdoRun = $ramdomrun
	viewCollisionShappe=$view/CollisionShape2D
	for child in hearts_list.get_children():
		hearts_array.append(child)
func _on_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		takeDame()

func takeDame() -> void:
	if cantakedmg:
		HP -= 30.0
		_update_display_HP()
		if HP > 0:
			aniTakeDmg()
		else:
			cantakedmg = false
			call_deferred("death")

func _update_display_HP() -> void:
	for i in range(hearts_array.size()):
		hearts_array[i].visible = i < int(ceil(HP / (FullHP / 6)))

func aniTakeDmg() -> void:
	cantakedmg = false  # Không nhận sát thương khi đã bị trúng đòn
	animation.visible = false
	time_takedame.start()

func death() -> void:
	animation.play("death")
	velocity = Vector2.ZERO
	move_and_slide()
	colli.disabled = true
	timedeath.start()

func _on_timer_die_timeout() -> void:
	queue_free()

func _on_take_dame_timeout() -> void:
	animation.visible = true
	if animation.animation != "death":
		cantakedmg = true

func _physics_process(delta: float) -> void:
	if animation.animation == "death":
		return
	var distance_to_target = 0
	if nav_agent and nav_agent.target_position != Vector2.ZERO:
		distance_to_target = position.distance_to(nav_agent.target_position)
	if animation.animation != "death":
		animation.play(Update_animation.update_animation(State,velocity))
		if distance_to_target > 3:
			var direction = (nav_agent.target_position - position).normalized()
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
			if timeRamdoRun.is_stopped():
				timeRamdoRun.start()
		move_and_slide()
		

func _on_ramdomrun_timeout() -> void:
	nav_agent.target_position = common.get_random_position_in_area(viewCollisionShappe, position)
	var random = randi() % 5 + 1
	timeRamdoRun.wait_time = random
func check_enemy()->bool:
	for child in get_parent().get_children():
		if child.name=="enemy1":
			trangthai=2
			return true
	return false
