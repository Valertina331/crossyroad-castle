extends CharacterBody2D

class_name player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var device : int

var playerNumber: int
var playerChoice: int


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var bounce_velocity := -300


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if MultiplayerInput.is_action_just_pressed(device,"jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := MultiplayerInput.get_axis(device,"move_left", "move_right")
	
	if direction> 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if direction == 0:
		animated_sprite_2d.play(str(playerChoice)+ "idle")
	else:
		animated_sprite_2d.play(str(playerChoice)+"walking")
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
#bounce when step on enemies
func bounce():
	velocity.y = bounce_velocity
	move_and_slide()
