extends Node3D

@onready var cam = $CharacterBody3D/Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4
var jump
var velocity = 0;

func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = is_multiplayer_authority()

func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
