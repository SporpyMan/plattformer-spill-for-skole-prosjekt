extends CharacterBody2D

var enm_speed = 200

@onready var floor_cast: RayCast2D = $FloorCast
@onready var wall_cast: RayCast2D = $WallCast

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if (!floor_cast.is_colliding() || wall_cast.is_colliding() && !wall_cast.get_collider().has_method("PLAYER")):
		FLIP()
		
	velocity.x = enm_speed
		
	move_and_slide()
		
		
func FLIP():
	scale.x *= -1
	enm_speed *= -1


func _on_kill_box_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		body.DIE()
