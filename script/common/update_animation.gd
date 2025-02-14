extends Node

# Preload file chứa các trạng thái
static var valueState = preload("res://script/common/value_common.gd")

# Cập nhật hoạt ảnh theo trạng thái và vận tốc
static func update_animation(state: String, velocity: Vector2) -> String:
	var type_ani = "idle"
	var direction_ani = "B"
	
	if velocity.x == 0 and velocity.y == 0:
		type_ani = "idle"
		
	if velocity.x != 0 or velocity.y != 0:
		type_ani = "walk"
	
	if abs(velocity.x) >= abs(velocity.y):
		if velocity.x > 0:
			direction_ani = "R"
		if velocity.x < 0:
			direction_ani = "L"
	else:
		if velocity.y > 0:
			direction_ani = "B"
		if velocity.y < 0:
			direction_ani = "T"
	
	return type_ani + "_" + direction_ani

# Lấy loại hoạt ảnh theo trạng thái
static func get_type_ani(state: String) -> String:
	match state:
		valueState.STATE_IDLE:
			return "idle"
		valueState.STATE_WALK:
			return "walk"
		valueState.STATE_ATK:
			return "atk"
		valueState.STATE_CELEB:
			return "walk"
		valueState.STATE_DEATH:
			return "death"
		_:
			return "idle"  # Nếu trạng thái không hợp lệ
