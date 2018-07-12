extends KinematicBody2D

# FORCES
const GRAVITY_FORCE = 2200 # pixels/second^2
const WALK_FORCE = 600
const FRICTION_FORCE = 1500

# SPEEDS
const JUMP_SPEED = 1500 # pixels/second
const WALK_MIN_SPEED = 80
const WALK_MAX_SPEED = 200

onready var animated_sprite = $AnimatedSprite

var screen_width
var half_sprite_width

var is_jumping = false
var last_print = 0

# holds velocity across frames 
var velocity = Vector2()

func _ready():
	screen_width = get_viewport_rect().size.x
	half_sprite_width = animated_sprite.frames.get_frame("idle", 0).get_width() / 2

func _process(delta):
	if is_on_floor():
		animated_sprite.play("idle")
	if is_jumping:
		animated_sprite.play("jump")
	
	last_print += delta
	if last_print >= 5:
		print("player at %s, velocity.y: %d" % [position, velocity.y])
		last_print = 0

func handle_user_input(delta):		
	# read user input 
	var jump = Input.is_action_pressed("jump")
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	
	# ensure player cannot jump again when in the air 
	if is_on_floor() and jump and not is_jumping:
		velocity.y = -JUMP_SPEED # jump up!
		is_jumping = true
	
	# determine if player is really jumping (not falling) 
	if is_jumping and velocity.y > 0:
		is_jumping = false
	
		# get acting environment forces
	var forces = Vector2(0, GRAVITY_FORCE) # pulling down (positive y)
	
	var stop = false
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED: 
			forces.x -= WALK_FORCE
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED: 
			forces.x += WALK_FORCE
	else:
		forces.x -= sign(velocity.x) * FRICTION_FORCE
		stop = true
	
	# integrate all acting forces to velocity
	velocity += forces * delta
	
	if stop and velocity.x < 0:
		velocity.x = 0

func _physics_process(delta):		
	#capture user ioput
	handle_user_input(delta)		
		
	# use velocity for kinematic motion and collide 
	velocity = move_and_slide(velocity,  Vector2(0, -1))
