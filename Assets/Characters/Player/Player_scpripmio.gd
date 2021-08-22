extends KinematicBody2D

const SPEED = 128
const FLOOR = Vector2(0, -1)
const GRAVITY = 16
const JUMP_WEIGHT = 280
const BOUNCING_FORCE = 40
const CAST_WALL = 10
onready var motion = Vector2.ZERO
var can_move : bool

func _process(delta):
	motion_ctrl()


func get_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis
	

func motion_ctrl():
	motion.y += GRAVITY
	
	if can_move:
		if get_axis().x == 1:
			$RayCast2D.cast_to.y = CAST_WALL
			$AnimatedSprite.flip_h = false
			
		elif get_axis().x == -1:
			$RayCast2D.cast_to.y = -CAST_WALL
			$AnimatedSprite.flip_h = true 
		
		
		if get_axis().x != 0:
			motion.x = get_axis().x * SPEED
		else :
			motion.x = 0
	
	if is_on_floor():
		can_move = true
		if get_axis().x != 0:
			$AnimatedSprite.play("Run")
			$Particles.emitting = true 
		else:
			$AnimatedSprite.play("Idle")
			$Particles.emitting = false
		
		
		if Input.is_action_just_pressed("ui_accept"):
			$Jump.play()
			motion.y -= JUMP_WEIGHT
	else:
		if motion.y <0:
			$AnimatedSprite.play("Jump")
		else:
			$AnimatedSprite.play("Fall")
		
		print($RayCast2D)
		if $RayCast2D.is_colliding():
			can_move = false
			
			var col = $RayCast2D.get_collider()
		
			
			if col.is_in_group("Wall") and Input.is_action_just_pressed("ui_accept"):
				$Jump.play()
				motion.y -= JUMP_WEIGHT
				
				
				if $AnimatedSprite.flip_h:
					motion.x += BOUNCING_FORCE
					$AnimatedSprite.flip_h = false
				else:
					motion.x -= BOUNCING_FORCE
					$AnimatedSprite.flip_h = true
	motion = move_and_slide(motion, FLOOR)


	





