extends Node3D

@onready var cam = $CharacterBody3D/Camera3D

func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Called when the node enters the scene tree for the first time.
func _ready():
	cam_current = is_multiplayer_authority()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



if event.is_action_pressed("jump") and is_on_floor():
	velocity.y = jump_speed

if 
