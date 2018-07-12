extends KinematicBody2D

const GRAVITY_FORCE = 10 # pixels/second^2
const JUMP_SPEED = 200
const WALK_SPEED = 50
const WALK_DECREMENT = 20
const STOP_SPEED = 10

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

func _physics_process(delta):
	# Create environment forces
	var force = Vector2(0, GRAVITY_FORCE) # pulling down (positive y)
	
	# read user input 
	var jump = Input.is_action_pressed("jump")
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	
	# integrate all acting forces to velocity
	velocity += force * delta
	
	# use velocity for kinematic motion and collide 
	var collision_info = move_and_collide(velocity)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
	
	# determine if player is jumping or falling 
	if is_jumping and velocity.y > 0:
		is_jumping = false
	
	# ensure player does not jump again in the air 
	if is_on_floor() and jump and not is_jumping:
		velocity.y = -JUMP_SPEED # jump up!
		animated_sprite.play("jump")
		is_jumping = true

	if is_on_floor() and not is_jumping:
		if walk_left:
			velocity.x -= WALK_SPEED
		if walk_right:
			velocity.x += WALK_SPEED
		if not (walk_right or walk_left):
			velocity.x += -sign(velocity.x) * WALK_DECREMENT
			if abs(velocity.x) <= STOP_SPEED:
				velocity.x = 0
	
	if velocity.length() == 0:
		animated_sprite.play("idle")
	
	last_print += delta
	if last_print > 10:
		print("player at %s" % position)
		last_print = 0
