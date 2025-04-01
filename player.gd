extends CharacterBody3D

@onready var cam = $Camera3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4.0  # movement speed
var jump_speed = 6.0  # determines jump height
var mouse_sensitivity = 0.002  # turning speed


func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = is_multiplayer_authority()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

func get_input():
	var input = Input.get_vector("left", "right", "forward", "backward")
	velocity.x = input.x * speed
	velocity.z = input.y * speed

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += -gravity * delta
	get_input()
	move_and_slide()
