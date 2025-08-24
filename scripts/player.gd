extends CharacterBody2D
const SPEED = 500.0
const JUMP_VELOCITY = -900.0
var spawn_point: Vector2

func _ready():
	spawn_point = global_position
	
	var parent = get_parent()
	if parent.has_node("Kill Zone"):
		var kill_zone_area = parent.get_node("Kill Zone")
		if kill_zone_area is Area2D:
			kill_zone_area.body_entered.connect(_on_kill_zone_entered)
			
	if parent.has_node("Finish/EndZone"):
		print("entered endzoned")
		var end_zone = parent.get_node("Finish")
		if end_zone is Area2D:
			end_zone.body_entered.connect(_on_end_zone_entered)

func _physics_process(delta: float) -> void:
	# add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# get input direction
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func set_checkpoint(checkpoint_position: Vector2):
	spawn_point = checkpoint_position

func reset_to_spawn():
	global_position = spawn_point
	velocity = Vector2.ZERO

func _on_kill_zone_entered(body):
	if body == self:
		reset_to_spawn()

func _on_end_zone_entered(body):
	if body == self:
		get_tree().change_scene_to_file("res://scenes/end.tscn")
