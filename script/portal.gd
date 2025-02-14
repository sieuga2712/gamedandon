extends Node2D

var common = preload("res://script/common/common.gd")
var colli: CollisionShape2D
var enemy_path=preload("res://scenes/enemy1.tscn")

var numberEmemy=6
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colli = $CollisionShape2D
	for i in range(numberEmemy):
		var randomPlace=common.get_random_position_in_area(colli, position)
		create_enemy(randomPlace)
func create_enemy(position: Vector2) -> void:
	var enemy = enemy_path.instantiate()  # Tạo đối tượng kẻ thù từ PackedScene
	enemy.position = position  # Đặt vị trí cho kẻ thù
	get_parent().get_node("enemyList").call_deferred("add_child", enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
