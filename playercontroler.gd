extends CharacterBody2D

@export var walk_speed = 200.0
@export var run_speed = 300.0
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var acceleration = 0.1

@export var jump_force = -400.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5

@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0
@export var wall_jump = 5
@export var jump = 2
@export var gavity = 980
func _physics_process(delta: float) -> void:
	
	var is_dashing = false
	var dash_start_position = 0
	var dash_direction = 0
	var dash_timer = 0
	var is_going_left = false
	var is_going_right = false
	var direction = Input.get_axis("left", "right")
	var _folder = true
	#var is_wall_sliding = false
	var speed
	
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
#		
	
	if Input.is_action_pressed("left"):
		is_going_left = true
		if Input.is_action_just_pressed("left"):
			print("left")
			
	else:
		is_going_left = false
		
	if Input.is_action_pressed("right"):
		is_going_right = true
		if Input.is_action_just_pressed("right"):
			print("right")
	else:
		is_going_right = false
				
	
		
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
			
			
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release
		
	
		
	
	
	
	
	
	
	
			
	#wall jump
	if wall_jump > 0:
		if Input.is_action_just_pressed("jump") and is_on_wall():
			wall_jump -= 1
			print(wall_jump)
			print(is_going_left)
			print(is_going_right)
		#left wall jump
		if Input.is_action_just_pressed("jump") and is_going_left == true and is_on_wall():
			velocity.y = jump_force
			velocity.x += 400
			print("left")
		else:
			if Input.is_action_just_pressed("jump") and is_going_right == true and is_on_wall():
				velocity.y = jump_force
				velocity.x += -400
				print("right")
		#right wall jump
		
			
	if is_on_floor():
			wall_jump = 5
		
		
	if Input.is_action_just_pressed("jump") and wall_jump <= 0:
			wall_jump = 0

	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		
	if Input.is_action_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
			
	if dash_timer > 0:
		dash_timer -= delta
		
	move_and_slide()
