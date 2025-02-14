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
var valueState = preload("res://script/common/value_common.gd")
var State="idle"
var isWar=false
var enemy_target_position:Node2D
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
	nav_agent.target_position = common.get_random_position_in_area(viewCollisionShappe, position)
	for child in hearts_list.get_children():
		hearts_array.append(child)

func _on_area_2d_area_entered(area: Area2D) -> void:
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
	State=valueState.STATE_DEATH
	velocity = Vector2.ZERO
	move_and_slide()
	colli.disabled = true
	timedeath.start()

func _on_timer_die_timeout() -> void:
	queue_free()

func _on_take_dame_timeout() -> void:
	animation.visible = true
	if State != valueState.STATE_DEATH:
		cantakedmg = true

func _physics_process(delta: float) -> void:
	if State != valueState.STATE_DEATH:
		isWar=get_parent().find_child("enemyList",true,false)!=null
		var distance_to_target = position.distance_to(nav_agent.target_position)
		if isWar==true:
			if enemy_target_position!=null:
				var min_distance=INF
				for child in get_parent().get_node("enemyList").get_children():
					var distance = child.get_position().distance_to(position)
					if distance < min_distance:
						min_distance = distance  # Cập nhật khoảng cách tối thiểu
						enemy_target_position=child
						nav_agent.target_position=child.get_position()
		animation.play(Update_animation.update_animation(State,velocity))
		if distance_to_target > 3:
			State=valueState.STATE_WALK
			var direction = (nav_agent.target_position - position).normalized()
			velocity = direction * SPEED
			move_and_slide()
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			if isWar==false:
				State=valueState.STATE_IDLE
				if timeRamdoRun.is_stopped():
					timeRamdoRun.start()
			else:
				State=valueState.STATE_ATK
				animation.play(Update_animation.update_animation(State,velocity))

func _on_ramdomrun_timeout() -> void:
	nav_agent.target_position = common.get_random_position_in_area(viewCollisionShappe, position)
	var random = randi_range(1, 5)
	timeRamdoRun.wait_time = random
