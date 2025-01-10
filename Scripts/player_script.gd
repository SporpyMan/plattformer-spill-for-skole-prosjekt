extends CharacterBody2D

# --- MÅ GJØRE --- #
# Ingenting her nå

# --- Fiks Dette --- #
# 

# --- Setter opp variabler --- #
@export var spd : float = 750
@export var jmp_str : float = 900
@export var grav : float = 2000

@export var squash : float = 1.25
@export var stretch : float = 0.85

var jmp_count : int = 2

var current_state

var PlayerFlagPoint : Vector2

var canJump : bool = false
var isJumping : bool  = false 
var isInAir : bool = true
var gravityUp : bool = false
var isBuffering = false

@onready var sprite: Sprite2D = $Sprite

@onready var jump_sound: AudioStreamPlayer = $Sounds/JumpSound
@onready var land_sound: AudioStreamPlayer = $Sounds/LandSound

func _ready() -> void:
	PlayerFlagPoint = position

func _process(delta: float) -> void:
	
	Gravity(delta)
	#ChangeGravity()
	Jump()
	Movement()
	HandleStates()
	DEBUG_Exit()
		
	move_and_slide()
		
	scale.x = lerp(scale.x , 1.0 , .1)
	scale.y = lerp(scale.y , 1.0 , .1)
		
	# --- Print Debug Statements --- #
	#print(isJumping)
	#print(wasAirborne)
	#print(sprite.scale)
	#print(gravityUp)
	#print(jmp_count)
	#print(current_state)
		
		
func Movement():
	var input_dir = Input.get_axis("left" , "right")
		
	if (input_dir):
		velocity.x = input_dir * spd
	else:
		velocity.x = move_toward(velocity.x , 0 , spd * 0.03)
		
		
func Gravity(delta : float):
	if is_on_floor():
		canJump = true
		isJumping = false
		jmp_count = 2
	elif (is_on_wall()):
		jmp_count = 2
		canJump = true
		velocity += get_gravity() * delta
	else: 
		velocity += get_gravity() * delta
		canJump = false
		
		
func Jump():
	if (Input.is_action_just_pressed("jump") && canJump == true || Input.is_action_just_pressed("jump") and jmp_count > 0):
		scale = Vector2(stretch , squash)
		
		if (gravityUp == false):
			velocity.y = -jmp_str
		canJump = false
		isJumping = true
		jmp_count -= 1
		jump_sound.play()
	elif (Input.is_action_just_released("jump")):
		if (canJump == false && isJumping == true && velocity.y < 0):
			velocity.y *= 0.3
			isJumping = false
		
		
func DEBUG_Exit():
	if (Input.is_action_just_pressed("[debug] EXIT")): # '[debug] EXIT' er 'esc' :]
		get_tree().quit()
		
		
func ChangeGravity():
	if (Input.is_action_just_pressed('ChangeGrav') and !is_on_floor()):
		gravityUp = !gravityUp
		up_direction *= -1
		velocity.y *= .5
		
		
enum {
	IDLE,
	WALKING,
	JUMPING,
}
		
		
func HandleStates():
	if (abs(velocity.x) > 0 && is_on_floor()):
		current_state = WALKING
	elif (!is_on_floor()):
		current_state = JUMPING
	else:
		current_state = IDLE
		
		
func _on_ground_check_body_entered(body: Node2D) -> void:
	if (!body.is_in_group('player') && is_on_floor()):
		land_sound.play()
		isInAir = false
		scale = Vector2(squash , stretch)
		
func _on_ground_check_body_exited(_body: Node2D) -> void:
	isInAir = true
		
		
func DIE():
	position = PlayerFlagPoint
	
	
func PLAYER():
	pass
